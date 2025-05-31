# import sys
# import os
# import openai

# # API 키 경로 설정
# sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'API_keys')))
# from config import API_KEY

# # OpenAI API 키 설정
# openai.api_key = API_KEY

# print("🤖 친구 GPT-4o야! 뭐든 편하게 말해줘~")

# # 최근 사용자 발화 저장
# last_user_input = None

# while True:
#     try:
#         user_input = input("🗣️ 나: ")

#         if user_input.lower() == '종료':
#             print("🛑 끄아앙~ 또 보쟈~!")
#             break

#         base_prompt = (
#         "너는 상담박사이자 경청하는 친구야. "
#         "절대 조언하지마. "
#         "대신 스스로 문제를 해결할 수 있도록 개방형이나 폐쇄형 질문위주로 하고 공감이나 위로도 적절한 타이밍에 해줘. "
#         "답변은 귀엽고 친근하게, 300자 이내로 답변해줘. "
#          )

#         system_message = (
#             base_prompt + f"사용자가 방금 '{last_user_input}' 라고 말했어. 지금 그 대화를 자연스럽게 이어가."
#             if last_user_input else
#             base_prompt
#         )



#         # GPT 호출
#         response = openai.ChatCompletion.create(
#             model="gpt-4o",
#             messages=[
#                 {"role": "system", "content": system_message},
#                 {"role": "user", "content": user_input}
#             ],
#             temperature=0.9
#         )

#         reply = response['choices'][0]['message']['content']
#         print(f"\n🤖 GPT-4o: {reply.strip()}\n")

#         last_user_input = user_input

#     except Exception as e:
#         print(f"⚠️ 오류 발생: {e}")

import sys
import os
import openai

# API 키 경로 설정
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', 'API_keys')))
from config import API_KEY

# OpenAI API 키 설정
openai.api_key = API_KEY

print("🤖 친구 GPT-4o야! 뭐든 편하게 말해줘~")

# 대화 기록 저장 리스트 (user, assistant 번갈아 저장)
chat_history = []

while True:
    try:
        user_input = input("🗣️ 나: ")
        if user_input.lower() == '종료':
            print("🛑 끄아앙~ 또 보쟈~!")
            break

        # 사용자 발화 저장
        chat_history.append({"role": "user", "content": user_input})

        # 베이스 프롬프트 (매번 system 메시지로 넣기)
        base_prompt = (
            "너는 상담박사이자 경청하는 친구야. 사용자가 자신의 일이나 감정을 말하면 다음 기준에 따라 반응해줘. "
            
            "1. 고민이나 힘든 일 → 진심 어린 공감과 따뜻한 반응. "
            "2. 생각이 정리되지 않을 때 → 30자 이내의 간단한 질문으로 유도. "
            "3. 감정 표현이 적을 때 → 지금 감정을 직접 묻거나 감정 이름을 제시. "
            "4. 자책하거나 지쳐 있을 때 → 노력과 회복력에 대한 구체적 칭찬. "
            "5. 해결책을 요구할 때 → 직접 말하지 말고 제안형 표현으로 선택 유도. "
            
            "모든 말은 귀엽고 친근하게, 300자 이내로 작성해줘."
        )

        
        # 최근 5턴(10 메시지)만 유지 (user+assistant)
        recent_history = chat_history[-10:]

        # 메시지 배열 구성 (system + 최근 대화)
        messages = [{"role": "system", "content": base_prompt}] + recent_history

        # GPT 호출
        response = openai.ChatCompletion.create(
            model="gpt-4o",
            messages=messages,
            temperature=0.9
        )

        reply = response['choices'][0]['message']['content'].strip()
        print(f"\n🤖 GPT-4o: {reply}\n")

        # GPT 답변 저장
        chat_history.append({"role": "assistant", "content": reply})

    except Exception as e:
        print(f"⚠️ 오류 발생: {e}")
