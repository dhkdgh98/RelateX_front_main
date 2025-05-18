import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  String? _gender; // 남성 / 여성 선택용
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


 // ✅ 실제 경로에 맞게 수정

void _submit() async {
  if (_formKey.currentState!.validate()) {
    final success = await AuthController.signUp(
      name: _nameController.text,
      gender: _gender ?? '',
      birth: _birthController.text,
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입 완료!")),
      );

      // ✅ 0.5초 지연 후 로그인 화면으로 이동
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()), // LoginScreen import 필요
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입 실패 😢")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 이름
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 성별
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: '성별'),
                items: const [
                  DropdownMenuItem(value: '남성', child: Text('남성')),
                  DropdownMenuItem(value: '여성', child: Text('여성')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return '성별을 선택해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
  controller: _birthController,
  decoration: const InputDecoration(labelText: '생년월일 (YYYY-MM-DD)'),
  readOnly: true, // 직접 입력 못하게
  onTap: () async {
    FocusScope.of(context).requestFocus(FocusNode()); // 키보드 닫기

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: '생년월일 선택',
      locale: const Locale('ko', 'KR'), // 한글 달력
    );

    if (picked != null) {
      setState(() {
        _birthController.text = "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return '생년월일을 선택해주세요';
    }
    return null;
  },
),

              const SizedBox(height: 16),

              // 이메일
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return '올바른 이메일을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 아이디
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: '아이디'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 비밀번호
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return '비밀번호는 6자 이상이어야 합니다';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 비밀번호 확인
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 제출 버튼
              ElevatedButton(
                onPressed: _submit,
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
