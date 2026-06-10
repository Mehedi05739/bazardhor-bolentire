import '../models/user_model.dart';
import '../providers/api_client.dart';

/// Handles authentication. Currently backed by mock data with simulated
/// latency; swap the body of [login] for `apiClient.post(...)` when the
/// backend is ready.
class AuthRepository {
  AuthRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    // Demo validation. Replace with a real API call:
    // final data = await apiClient.post('auth/login',
    //     body: {'identifier': identifier, 'password': password});
    // return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    if (password.length < 6) {
      throw ApiException(
        statusCode: 401,
        message: 'Invalid credentials. Please try again.',
      );
    }

    return UserModel(
      id: '1',
      name: 'Bazardhor User',
      identifier: identifier,
    );
  }
}
