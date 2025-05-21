
import openai

# ✅ OpenAI API 키 설정
# client = openai.OpenAI(
#     api_key=
# )

print("🤖 텍스트 챗봇에 오신 걸 환영해요! 질문을 입력해주세요.")

while True:
    try:
        # 사용자로부터 텍스트 입력 받기
        user_input = input("🗣️ 당신: ")

        if user_input.lower() == '종료':
            print("🛑 종료합니다.")
            break

        # 🤖 GPT 응답 생성
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "너는 친절하고 지적인 한국어 음성 비서야."},
                {"role": "user", "content": user_input}
            ]
        )

        reply = response.choices[0].message.content
        print(f"🤖 GPT: {reply}\n")

    except Exception as e:
        print(f"⚠️ 오류 발생: {e}")
