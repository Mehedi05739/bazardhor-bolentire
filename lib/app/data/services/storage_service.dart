import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/zone_model.dart';

/// Persists the session (access token + user) in `SharedPreferences`.
///
/// Registered as a permanent [GetxService] and initialized in `main()` before
/// `runApp`, so the token is available synchronously to the [ApiClient] and to
/// the startup routing decision.
class StorageService extends GetxService {
  static const _kToken = 'access_token';
  static const _kUser = 'auth_user';
  static const _kZoneId = 'zone_id';
  static const _kZone = 'zone';

  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  String? get token => _prefs.getString(_kToken);

  bool get isLoggedIn => (token ?? '').isNotEmpty;

  UserModel? get user {
    final raw = _prefs.getString(_kUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession({required String token, required UserModel user}) async {
    await _prefs.setString(_kToken, token);
    await _prefs.setString(_kUser, jsonEncode(user.toJson()));
  }

  String? get zoneId => _prefs.getString(_kZoneId);

  ZoneModel? get zone {
    final raw = _prefs.getString(_kZone);
    if (raw == null || raw.isEmpty) return null;
    try {
      return ZoneModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveZone(ZoneModel zone) async {
    await _prefs.setString(_kZoneId, zone.id);
    await _prefs.setString(_kZone, jsonEncode(zone.toJson()));
  }

  Future<void> clear() async {
    await _prefs.remove(_kToken);
    await _prefs.remove(_kUser);
    await _prefs.remove(_kZoneId);
    await _prefs.remove(_kZone);
  }
}
