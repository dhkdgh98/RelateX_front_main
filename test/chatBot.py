# ↓ 가상환경 활성화 코드
# .\venv\Scripts\Activate.ps1 

import sys
import os
import openai

# 현재 파일 기준으로 프로젝트 바깥의 API_keys 폴더를 sys.path에 추가
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'API_keys')))

# config.py에서 API 키 임포트
from config import API_KEY

# OpenAI API 키 설정
openai.api_key = API_KEY

print("🤖 GPT-4o 챗봇에 오신 걸 환영해~!")

while True:
    try:
        user_input = input("🗣️ 당신: ")

        if user_input.lower() == '종료':
            print("🛑 종료해쪄~ 또 봐용~!")
            break

        # OpenAI GPT-4o 호출
        response = openai.ChatCompletion.create(
            model="gpt-4o",
            messages=[
                {"role": "system", "content": "너는 친절하고 지적인 한국어 음성 비서야."},
                {"role": "user", "content": user_input}
            ]
        )

        reply = response['choices'][0]['message']['content']
        print(f"🤖 GPT-4o: {reply}\n")

    except Exception as e:
        print(f"⚠️ 오류 발생: {e}")
