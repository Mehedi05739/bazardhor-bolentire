import '../models/user_model.dart';
import '../providers/api_client.dart';
import '../services/storage_service.dart';

/// Handles authentication against `/api/auth/login` and owns the session
/// lifecycle (persisting and clearing the token + user via [StorageService]).
class AuthRepository {
  AuthRepository({required this.apiClient, required this.storage});

  final ApiClient apiClient;
  final StorageService storage;

  /// Logs in with the given credentials. On success the access token and user
  /// are persisted, and the parsed [UserModel] is returned.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final dynamic body = await apiClient.post(
      '/api/auth/login',
      body: {'email': email, 'password': password},
    );

    final data = body is Map ? body['data'] as Map<String, dynamic>? : null;
    final token = data?['access_token'] as String?;
    final userJson = data?['user'] as Map<String, dynamic>?;

    if (token == null || token.isEmpty || userJson == null) {
      throw ApiException(
        statusCode: 500,
        message: 'Unexpected response from server.',
      );
    }

    final user = UserModel.fromJson(userJson);
    await storage.saveSession(token: token, user: user);
    return user;
  }

  /// Clears the stored session.
  Future<void> logout() => storage.clear();
}
