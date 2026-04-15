import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/api_service.dart';

final characterProvider =
    AsyncNotifierProvider<CharacterNotifier, Map<String, dynamic>?>(
  CharacterNotifier.new,
);

class CharacterNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  @override
  Future<Map<String, dynamic>?> build() async {
    final data = await ApiService.get('/api/character');
    return Map<String, dynamic>.from(data as Map);
  }
}
