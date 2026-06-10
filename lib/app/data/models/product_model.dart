/// A product. `price` is mutable through the update-price flow, so the model
/// is immutable and we expose [copyWith] to produce updated instances.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    this.bazaarId,
  });

  final String id;
  final String name;

  /// Selling unit, e.g. "kg", "dozen", "piece".
  final String unit;
  final double price;

  /// Owning bazaar, when the product belongs to one.
  final String? bazaarId;

  ProductModel copyWith({double? price}) {
    return ProductModel(
      id: id,
      name: name,
      unit: unit,
      price: price ?? this.price,
      bazaarId: bazaarId,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: '${json['id'] ?? ''}',
      name: json['name'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      bazaarId: json['bazaar_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'unit': unit,
    'price': price,
    'bazaar_id': bazaarId,
  };
}
