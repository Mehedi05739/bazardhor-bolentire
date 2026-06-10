/// A bazaar (market) shown on the home screen and opened on its own screen.
class BazaarModel {
  const BazaarModel({
    required this.id,
    required this.name,
    required this.location,
    required this.productCount,
    this.rating = 0,
  });

  final String id;
  final String name;
  final String location;
  final int productCount;
  final double rating;

  factory BazaarModel.fromJson(Map<String, dynamic> json) {
    return BazaarModel(
      id: '${json['id'] ?? ''}',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'product_count': productCount,
    'rating': rating,
  };
}
