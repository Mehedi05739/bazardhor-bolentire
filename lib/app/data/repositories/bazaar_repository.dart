import '../models/bazaar_model.dart';
import '../providers/api_client.dart';

/// Provides bazaars for the home screen. Mock-backed for now.
class BazaarRepository {
  BazaarRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<List<BazaarModel>> fetchBazaars() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    // Replace with: final data = await apiClient.get('bazaars');
    return const [
      BazaarModel(
        id: 'b1',
        name: 'Karwan Bazar',
        location: 'Tejgaon, Dhaka',
        productCount: 128,
        rating: 4.6,
      ),
      BazaarModel(
        id: 'b2',
        name: 'New Market',
        location: 'Azimpur, Dhaka',
        productCount: 96,
        rating: 4.3,
      ),
      BazaarModel(
        id: 'b3',
        name: 'Mohammadpur Krishi Market',
        location: 'Mohammadpur, Dhaka',
        productCount: 74,
        rating: 4.5,
      ),
      BazaarModel(
        id: 'b4',
        name: 'Hatirpool Bazar',
        location: 'Hatirpool, Dhaka',
        productCount: 51,
        rating: 4.1,
      ),
    ];
  }
}
