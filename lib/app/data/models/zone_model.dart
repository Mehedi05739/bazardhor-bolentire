/// Delivery/coverage zone resolved from the user's coordinates via
/// `/api/config/get-zone`.
class ZoneModel {
  const ZoneModel({
    required this.id,
    required this.name,
    this.description,
    this.isActive = false,
  });

  final String id;
  final String name;
  final String? description;
  final bool isActive;

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: '${json['id'] ?? ''}',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'is_active': isActive,
  };
}
