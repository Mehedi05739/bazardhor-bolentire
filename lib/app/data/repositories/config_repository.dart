import '../models/zone_model.dart';
import '../providers/api_client.dart';
import '../services/storage_service.dart';

/// App configuration endpoints. Resolves the user's zone from coordinates and
/// persists its id so it can be attached to subsequent requests.
class ConfigRepository {
  ConfigRepository({required this.apiClient, required this.storage});

  final ApiClient apiClient;
  final StorageService storage;

  /// Calls `/api/config/get-zone?lat=&lng=`, persists the zone id, and returns
  /// the resolved [ZoneModel].
  Future<ZoneModel> getZone({
    required double lat,
    required double lng,
  }) async {
    final dynamic body = await apiClient.get(
      '/api/config/get-zone',
      query: {'lat': lat, 'lng': lng},
    );

    final data = body is Map ? body['data'] as Map<String, dynamic>? : null;
    if (data == null || data['id'] == null) {
      throw ApiException(
        statusCode: 500,
        message: 'Could not resolve your zone.',
      );
    }

    final zone = ZoneModel.fromJson(data);
    await storage.saveZone(zone);
    return zone;
  }
}
