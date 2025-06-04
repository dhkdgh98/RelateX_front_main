import 'package:flutter/foundation.dart';
import 'package:relate_x_front_main/features/home/api/home_api.dart';

class RecordOptionsProvider with ChangeNotifier {
  Map<String, List<String>> _options = {
    'friends': [],
    'locations': [],
    'emotions': [],
    'categories': [],
    'recordTypes': [],
  };

  Map<String, List<String>> get options => _options;

  Future<void> loadOptions(String userId) async {
    try {
      _options = await HomeApi.getRecordOptions(userId);
      notifyListeners();
    } catch (e) {
      print('Error loading options: $e');
      rethrow;
    }
  }

  Future<void> updateOptions(String userId, Map<String, List<String>> newOptions) async {
    try {
      _options = await HomeApi.updateRecordOptions(userId, newOptions);
      notifyListeners();
    } catch (e) {
      print('Error updating options: $e');
      rethrow;
    }
  }

  Future<void> addOption(String userId, String category, String value) async {
    try {
      final updatedOptions = await HomeApi.addOption(userId, category, value);
      _options[category] = updatedOptions;
      notifyListeners();
    } catch (e) {
      print('Error adding option: $e');
      rethrow;
    }
  }
} 