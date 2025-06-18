!pip install flask flask-cors openai diffusers transformers accelerate safetensors opencv-python requests pyngrok controlnet_aux fastapi uvicorn nest-asyncio pydantic

# 📌 import
import torch, gc, base64, requests, os, time
from io import BytesIO
from PIL import Image
from flask import Flask, request, jsonify
from flask_cors import CORS
from threading import Thread
from concurrent.futures import ThreadPoolExecutor
import asyncio
from pyngrok import ngrok, conf
from openai import OpenAI
from diffusers import (
    StableDiffusionPipeline,
    StableDiffusionControlNetPipeline,
    ControlNetModel
)
from controlnet_aux.open_pose import OpenposeDetector
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

# 📌 환경 설정
def initialize_tokens(hf_token: str, openai_key: str, ngrok_token: str):
    global HF_TOKEN, OPENAI_API_KEY, client, pipe_style, pipe_final
    
    # 토큰 설정
    HF_TOKEN = hf_token
    OPENAI_API_KEY = openai_key
    
    # OpenAI 클라이언트 초기화
    client = OpenAI(api_key=OPENAI_API_KEY)
    
    # ngrok 토큰 설정
    conf.get_default().auth_token = ngrok_token
    
    # 디바이스 설정
    device = "cuda" if torch.cuda.is_available() else "cpu"
    torch_dtype = torch.float16 if torch.cuda.is_available() else torch.float32
    
    # 모델 초기화
    pipe_style = StableDiffusionPipeline.from_pretrained(
        "nitrosocke/Ghibli-Diffusion", token=HF_TOKEN, torch_dtype=torch_dtype
    ).to(device)
    pipe_style.safety_checker = None
    
    detector = OpenposeDetector.from_pretrained("lllyasviel/ControlNet")
    
    controlnet = ControlNetModel.from_pretrained(
        "lllyasviel/sd-controlnet-openpose", token=HF_TOKEN, torch_dtype=torch_dtype
    )
    pipe_final = StableDiffusionControlNetPipeline.from_pretrained(
        "runwayml/stable-diffusion-v1-5", controlnet=controlnet, token=HF_TOKEN, torch_dtype=torch_dtype
    ).to(device)
    pipe_final.safety_checker = None

# ✨ Flask app
app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB로 제한 증가
CORS(app)

# FastAPI 앱 설정
app = FastAPI(title="Ghibli Image Generator API")

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic 모델
class GenerateRequest(BaseModel):
    user_id: str
    diary: str
    gender: str
    node_server_url: str

# ✨ 프롬프트 생성 함수
def get_prompts_from_chatgpt(user_diary: str, gender: str):
    system_prompt = (
        "You are an AI assistant that creates AI art prompts in Ghibli style from a diary entry.\n\n"
        "Your task is to read the diary and extract the most emotionally or visually important moment as a single scene.\n"
        "Then, generate two prompts:\n\n"
        "1. pose_prompt:\n"
        "- Describe the character's full-body pose, composition, placement, and interactions with important elements in the scene (e.g., a cat, a window, a book).\n"
        "- Use keywords like pastel tone, monotone background, natural posture, and always include 'Ghibli style'.\n"
        "- Format should be a list of keywords or short phrases separated by commas (not a complete sentence).\n"
        "- The total token count must not exceed 75 tokens.\n"
        "- This prompt is used for pose estimation.\n\n"
        "2. full_prompt:\n"
        "- Start with a short pose description (e.g., dancing pose).\n"
        "- Then add keywords or short phrases (comma-separated) describing the following:\n"
        "  - clothing style (e.g., casual dress, school uniform)\n"
        "  - background environment (e.g., grassy field, cozy room, forest path)\n"
        "  - facial expression (e.g., gentle smile, curious look)\n"
        "  - eye details (e.g., sparkling eyes, soft gaze)\n"
        "  - interaction with other elements (e.g., reaching toward cat)\n"
        "  - atmosphere (e.g., peaceful, nostalgic, dreamy)\n"
        "  - artistic style and texture (e.g., watercolor painting, skin glow, sunlight filtering)\n"
        "- Always include 'Ghibli style'.\n"
        "- Format should also be a comma-separated list of keywords or short phrases (not a complete sentence).\n"
        "- The total token count must not exceed 75 tokens.\n\n"
        "Both prompts must be in fluent English and formatted as follows:\n"
        "pose_prompt: ...\n"
        "full_prompt: ...\n"
    )

    res = client.chat.completions.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": f"Here is the diary:\n{user_diary}\nGender: {gender}"}
        ],
        temperature=0.8
    )
    content = res.choices[0].message.content
    lines = content.split("\n")
    pose_prompt = next((l.split(":", 1)[1].strip() for l in lines if l.lower().startswith("pose_prompt")), "")
    full_prompt = next((l.split(":", 1)[1].strip() for l in lines if l.lower().startswith("full_prompt")), "")
    return pose_prompt, full_prompt

# ✨ 이미지 생성 함수
def generate_image(pose_prompt: str, full_prompt: str):
    pose_img = pipe_style(prompt=pose_prompt, num_inference_steps=20).images[0]
    pose_map = detector(pose_img).convert("L").convert("RGB")
    result_img = pipe_final(prompt=full_prompt, image=pose_map, num_inference_steps=30).images[0]

    torch.cuda.empty_cache()
    gc.collect()

    return result_img

# ✨ 이미지 -> base64
def image_to_base64(img: Image.Image) -> str:
    buffer = BytesIO()
    img.save(buffer, format="PNG")
    return base64.b64encode(buffer.getvalue()).decode("utf-8")

@app.post("/generate")
async def generate(request: GenerateRequest):
    try:
        print("🔥 [SERVER] /generate 요청 들어옴!")
        print(f"👤 user_id: {request.user_id}")
        print(f"📝 gender: {request.gender}")
        print(f"📔 diary 내용 (앞부분): {request.diary[:100]}...")
        print(f"🌐 Node.js 서버 URL: {request.node_server_url}")

        # ChatGPT 프롬프트 생성
        pose_prompt, full_prompt = get_prompts_from_chatgpt(request.diary, request.gender)
        print("✨ pose_prompt:", pose_prompt)
        print("✨ full_prompt:", full_prompt)

        # 이미지 생성
        result_img = generate_image(pose_prompt, full_prompt)
        print("🖼️ 이미지 생성 완료!")

        # 이미지를 바이트로 변환
        img_byte_arr = BytesIO()
        result_img.save(img_byte_arr, format='PNG')
        img_bytes = img_byte_arr.getvalue()
        print("🖼️ 이미지 바이트 변환 완료!")

        try:
            # Node.js 서버로 이미지 전송
            response = requests.post(
                request.node_server_url,
                data=img_bytes,
                headers={
                    'Content-Type': 'image/png'
                }
            )

            if response.status_code == 200:
                return {
                    "success": True,
                    "message": "이미지 생성 및 전송 성공"
                }
            else:
                print(f"❌ Node.js 서버 응답 오류: {response.status_code}")
                print(f"❌ 응답 내용: {response.text}")
                return {
                    "success": False,
                    "message": "Node.js 서버 응답 오류",
                    "error": response.text
                }

        except requests.exceptions.RequestException as e:
            print(f"❌ Node.js 서버 요청 실패: {str(e)}")
            return {
                "success": False,
                "message": "Node.js 서버 연결 실패",
                "error": str(e)
            }

    except Exception as e:
        print(f"❌ 에러 발생: {str(e)}")
        return {
            "success": False,
            "message": "이미지 생성 중 오류가 발생했습니다",
            "error": str(e)
        }

if __name__ == "__main__":
    import nest_asyncio
    import uvicorn
    from pyngrok import ngrok, conf

    # Colab의 이벤트 루프 문제 해결
    nest_asyncio.apply()

    # 토큰 초기화 (외부에서 받아온 토큰들)
    initialize_tokens(
        hf_token="your_huggingface_token",
        openai_key="your_openai_key",
        ngrok_token="your_ngrok_token"
    )

    # ngrok 연결
    public_url = ngrok.connect(8005)
    print("🚀 ngrok URL:", public_url)

    # 서버 실행 (타임아웃 설정 추가)
    uvicorn.run(app, host="0.0.0.0", port=8005, timeout_keep_alive=120)