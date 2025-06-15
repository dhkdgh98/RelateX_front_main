import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../../../../constants/api_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/controller/auth_provider.dart';

class GhibliModule {
  static const String moduleId = 'ghibli';
  static const String moduleName = '지브리 모듈';
  static const String moduleDescription = '지브리 스타일로 기록을 변환합니다';

  static Future<String?> generateImage(String content, WidgetRef ref) async {
    final userId = ref.read(authProvider).userId;
    if (userId == null) {
      debugPrint('❌ 유저 ID 없음. 로그인 필요!');
      return null;
    }

    final url = '${ApiConfig.baseUrl}/ghibli/generate';
    final body = {
      'userId': userId,
      'content': content,
    };

    debugPrint(
      '🔄 지브리 이미지 생성 요청\n'
      'URL: $url\n'
      'Body: ${jsonEncode(body)}',
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint(
        '📡 지브리 이미지 생성 응답\n'
        'Status: ${response.statusCode}\n'
        'Body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageData = data['data']['imageData'];
        
        debugPrint(
          '✅ 지브리 이미지 생성 성공\n'
          'Image Data: ${imageData.substring(0, 50)}...',
        );
        
        return imageData;
      } else {
        debugPrint(
          '❌ 지브리 이미지 생성 실패\n'
          'Status: ${response.statusCode}\n'
          'Error: ${response.body}',
        );
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint(
        '💥 지브리 이미지 생성 중 오류 발생\n'
        'Error: $e\n'
        'Stack Trace: $stackTrace',
      );
      return null;
    }
  }

  static Widget buildModuleSettings({
    required String? generatedImageUrl,
    required bool isGeneratingImage,
    required Function() onGenerateImage,
    required Function() onConfirm,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '지브리 스타일 설정',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '기록을 지브리 스타일의 이미지로 변환합니다.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        if (generatedImageUrl != null) ...[
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: MemoryImage(
                  base64Decode(generatedImageUrl.split(',')[1]),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: isGeneratingImage ? null : onGenerateImage,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 생성하기'),
              ),
              ElevatedButton.icon(
                onPressed: onConfirm,
                icon: const Icon(Icons.check),
                label: const Text('확인'),
              ),
            ],
          ),
        ] else
          ElevatedButton.icon(
            onPressed: isGeneratingImage ? null : onGenerateImage,
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('이미지 생성하기'),
          ),
      ],
    );
  }

  static Widget buildModuleTile({
    required List<String> selectedModules,
    required Function(String?) onModuleSelected,
    required String? generatedImageUrl,
  }) {
    final isSelected = selectedModules.contains(moduleId);
    
    return ListTile(
      leading: Image.asset(
        'assets/images/ghibli_module.png',
        width: 40,
        height: 40,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.movie, size: 40);
        },
      ),
      title: Text(moduleName),
      subtitle: Text(moduleDescription),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (generatedImageUrl != null)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
          const SizedBox(width: 8),
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              onModuleSelected(moduleId);
            },
          ),
        ],
      ),
      onTap: () => onModuleSelected(moduleId),
    );
  }
} 