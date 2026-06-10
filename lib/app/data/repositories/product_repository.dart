import '../models/product_model.dart';
import '../providers/api_client.dart';

/// Provides products for the home screen and per-bazaar screens, and persists
/// price updates. Mock-backed for now.
class ProductRepository {
  ProductRepository({required this.apiClient});

  final ApiClient apiClient;

  static const List<ProductModel> _catalog = [
    ProductModel(id: 'p1', name: 'Tomato', unit: 'kg', price: 60, bazaarId: 'b1'),
    ProductModel(id: 'p2', name: 'Potato', unit: 'kg', price: 35, bazaarId: 'b1'),
    ProductModel(id: 'p3', name: 'Onion', unit: 'kg', price: 90, bazaarId: 'b1'),
    ProductModel(id: 'p4', name: 'Egg', unit: 'dozen', price: 145, bazaarId: 'b2'),
    ProductModel(id: 'p5', name: 'Rice (Miniket)', unit: 'kg', price: 72, bazaarId: 'b2'),
    ProductModel(id: 'p6', name: 'Green Chili', unit: 'kg', price: 120, bazaarId: 'b3'),
    ProductModel(id: 'p7', name: 'Carrot', unit: 'kg', price: 80, bazaarId: 'b3'),
    ProductModel(id: 'p8', name: 'Banana', unit: 'dozen', price: 55, bazaarId: 'b4'),
    ProductModel(id: 'p9', name: 'Cucumber', unit: 'kg', price: 45, bazaarId: 'b4'),
    ProductModel(id: 'p10', name: 'Lemon', unit: 'piece', price: 8, bazaarId: 'b1'),
  ];

  /// Featured products for the home screen.
  Future<List<ProductModel>> fetchProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return _catalog;
  }

  /// Products belonging to a single bazaar.
  Future<List<ProductModel>> fetchProductsByBazaar(String bazaarId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    // Replace with: apiClient.get('bazaars/$bazaarId/products');
    return _catalog.where((p) => p.bazaarId == bazaarId).toList();
  }

  /// Persists a new price and returns the updated product.
  Future<ProductModel> updatePrice({
    required ProductModel product,
    required double newPrice,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    // Replace with: apiClient.put('products/${product.id}',
    //     body: {'price': newPrice});
    return product.copyWith(price: newPrice);
  }
}
