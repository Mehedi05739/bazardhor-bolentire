/// Authenticated user returned by the auth API.
class UserModel {
  const UserModel({required this.id, required this.name, required this.identifier});

  final String id;
  final String name;

  /// Email or phone number the user logged in with.
  final String identifier;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: '${json['id'] ?? ''}',
      name: json['name'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'identifier': identifier,
  };
}
