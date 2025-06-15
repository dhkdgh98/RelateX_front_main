from flask import Flask, request, send_file, jsonify
from diffusers import StableDiffusionPipeline, StableDiffusionControlNetPipeline, ControlNetModel, StableDiffusionInpaintPipeline
from controlnet_aux import OpenposeDetector
import torch
import os
import requests
from PIL import Image
from io import BytesIO
import threading
from pyngrok import ngrok

# Flask 앱 설정
app = Flask(__name__)
device = "cuda" if torch.cuda.is_available() else "cpu"
torch_dtype = torch.float32

HF_TOKEN = os.getenv("HUGGINGFACE_HUB_TOKEN")

print("모델 로드 시작...")

# 1. 포즈 제어용 ControlNet 모델 및 파이프라인 (OpenPose)
controlnet_pose = ControlNetModel.from_pretrained(
    "lllyasviel/sd-controlnet-openpose",
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_pose = StableDiffusionControlNetPipeline.from_pretrained(
    "nitrosocke/Ghibli-Diffusion",
    controlnet=controlnet_pose,
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_pose.safety_checker = None
pipe_pose.to(device)

# 2. 구도 제어용 ControlNet 모델 및 파이프라인 (Depth)
controlnet_depth = ControlNetModel.from_pretrained(
    "lllyasviel/sd-controlnet-depth",
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_depth = StableDiffusionControlNetPipeline.from_pretrained(
    "nitrosocke/Ghibli-Diffusion",
    controlnet=controlnet_depth,
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_depth.safety_checker = None
pipe_depth.to(device)

# 3. 캐릭터 스타일용 파이프라인 (기본 지브리 스타일)
pipe_style = StableDiffusionPipeline.from_pretrained(
    "nitrosocke/Ghibli-Diffusion",
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_style.safety_checker = None
pipe_style.to(device)

# 4. 배경 생성용 파이프라인
pipe_bg = StableDiffusionPipeline.from_pretrained(
    "nitrosocke/Ghibli-Diffusion",
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_bg.safety_checker = None
pipe_bg.to(device)

# 5. 얼굴 디테일 보정용 Inpainting 파이프라인
pipe_inpaint = StableDiffusionInpaintPipeline.from_pretrained(
    "nitrosocke/Ghibli-Diffusion",
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_inpaint.safety_checker = None
pipe_inpaint.to(device)

# 6. 오브젝트 추가용 ControlNet 모델 및 파이프라인 (Canny)
controlnet_canny = ControlNetModel.from_pretrained(
    "lllyasviel/sd-controlnet-canny",
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_canny = StableDiffusionControlNetPipeline.from_pretrained(
    "nitrosocke/Ghibli-Diffusion",
    controlnet=controlnet_canny,
    use_auth_token=HF_TOKEN,
    torch_dtype=torch_dtype
)
pipe_canny.safety_checker = None
pipe_canny.to(device)

print("모델 로드 완료!")

def save_image(image, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    image.save(path)
    print(f"이미지 저장: {path}")

@app.route('/generate-scene', methods=['POST'])
def generate_scene():
    try:
        # 1. 포즈 이미지 URL 받기
        pose_image_url = request.json.get('pose_image_url', '')
        if not pose_image_url:
            return jsonify({'error': 'pose_image_url required'}), 400

        # URL에서 이미지 다운로드
        response = requests.get(pose_image_url)
        pose_image = Image.open(BytesIO(response.content)).convert("RGB")
        
        # OpenPose로 포즈 추출
        pose_detector = OpenposeDetector.from_pretrained('lllyasviel/ControlNet')
        pose_map = pose_detector(pose_image)
        
        # 2. 포즈 기반 이미지 생성
        result = pipe_pose(
            prompt="a character in Ghibli style",
            image=pose_map,
            num_inference_steps=30
        )
        current_image = result.images[0]

        # 3. 구도 제어 적용
        depth_prompt = request.json.get('depth_prompt', '')
        if depth_prompt:
            result = pipe_depth(
                prompt=depth_prompt,
                image=current_image,
                num_inference_steps=30
            )
            current_image = result.images[0]

        # 4. 스타일 적용
        style_prompt = request.json.get('style_prompt', '')
        if style_prompt:
            result = pipe_style(
                prompt=style_prompt,
                image=current_image,
                num_inference_steps=30
            )
            current_image = result.images[0]

        # 5. 배경 생성
        bg_prompt = request.json.get('bg_prompt', '')
        if bg_prompt:
            result = pipe_bg(
                prompt=bg_prompt,
                image=current_image,
                num_inference_steps=30
            )
            current_image = result.images[0]

        # 6. 얼굴 디테일 보정
        face_mask = request.files.get('face_mask')
        detail_prompt = request.json.get('detail_prompt', '')
        if face_mask and detail_prompt:
            mask_image = Image.open(face_mask).convert("L")
            result = pipe_inpaint(
                prompt=detail_prompt,
                image=current_image,
                mask_image=mask_image,
                num_inference_steps=30
            )
            current_image = result.images[0]

        # 7. 오브젝트 추가
        object_prompt = request.json.get('object_prompt', '')
        if object_prompt:
            result = pipe_canny(
                prompt=object_prompt,
                image=current_image,
                num_inference_steps=30
            )
            current_image = result.images[0]

        # 최종 이미지 저장
        path = "static/images/final_scene.png"
        save_image(current_image, path)
        return send_file(path, mimetype='image/png')

    except Exception as e:
        return jsonify({'error': str(e)}), 500

def prompt_scene_input():
    print("\n🎬 AI 웹툰 씬 생성 파이프라인")
    
    # 1. 포즈 이미지 URL 입력
    pose_image_url = input("🖼️ 포즈 이미지 URL을 입력하세요: ")
    if not pose_image_url:
        print("❗ 포즈 이미지 URL은 필수입니다.")
        return

    # 2. 구도 프롬프트 입력
    depth_prompt = input("🎥 구도 프롬프트를 입력하세요 (선택사항): ")

    # 3. 스타일 프롬프트 입력
    style_prompt = input("🎨 스타일 프롬프트를 입력하세요 (선택사항): ")

    # 4. 배경 프롬프트 입력
    bg_prompt = input("🖼️ 배경 프롬프트를 입력하세요 (선택사항): ")

    # 5. 얼굴 마스크 및 디테일 프롬프트 입력
    face_mask_path = input("😷 얼굴 마스크 이미지 경로를 입력하세요 (선택사항): ")
    detail_prompt = input("👤 디테일 프롬프트를 입력하세요 (선택사항): ")

    # 6. 오브젝트 프롬프트 입력
    object_prompt = input("🎁 오브젝트 프롬프트를 입력하세요 (선택사항): ")

    try:
        # API 요청 데이터 준비
        data = {
            "pose_image_url": pose_image_url,
            "depth_prompt": depth_prompt,
            "style_prompt": style_prompt,
            "bg_prompt": bg_prompt,
            "detail_prompt": detail_prompt,
            "object_prompt": object_prompt
        }

        # 파일이 있는 경우에만 추가
        files = {}
        if face_mask_path:
            files['face_mask'] = open(face_mask_path, 'rb')

        # API 호출
        response = requests.post('http://127.0.0.1:5000/generate-scene', 
                               json=data, 
                               files=files if files else None)

        if response.status_code == 200:
            print("✅ 씬 생성 완료!")
            with open("static/images/final_scene.png", "wb") as f:
                f.write(response.content)
            print("🎉 최종 이미지가 static/images/final_scene.png 에 저장되었습니다!")
        else:
            print(f"❌ 오류 발생: {response.text}")

    except Exception as e:
        print(f"❌ 요청 중 오류 발생: {str(e)}")
    finally:
        # 열린 파일 닫기
        if 'files' in locals() and files:
            for file in files.values():
                file.close()

def run_cli():
    while True:
        print("\n1. 씬 생성 시작")
        print("0. 종료")
        
        choice = input("\n원하는 작업 번호를 입력하세요: ")
        if choice == "1":
            prompt_scene_input()
        elif choice == "0":
            print("👋 종료합니다.")
            break
        else:
            print("❗ 유효한 번호를 입력하세요 (0-1).")

def run_flask():
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=False)

if __name__ == '__main__':
    # ngrok 설정
    from pyngrok import conf
    conf.get_default().auth_token = "2w7VRYBj2DCgHZqi8pCXh0DyFrr_3SfpgoXUWGkDyeejAw2RY"
    
    # ngrok을 통해 Flask 서버를 외부에서 접근 가능하게 설정
    public_url = ngrok.connect(5000)
    print("Flask 서버가 실행되었습니다. 접근 URL:", public_url)

    # Flask 서버를 별도 스레드에서 실행
    flask_thread = threading.Thread(target=run_flask)
    flask_thread.start()

    # CLI 실행
    run_cli() 