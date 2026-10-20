import 'package:dio/dio.dart';

import 'package:med_drop/core/error/exceptions.dart';
import 'package:med_drop/core/network/dio_client.dart';
import 'package:med_drop/features/catalog/data/models/medicine_model.dart';

// ── Contract ──────────────────────────────────────────────────────────────────

/// Defines all remote-fetch operations for the medicine catalog.
abstract interface class MedicineRemoteDataSource {
  /// Fetches the full medicine catalog from the remote API.
  ///
  /// Throws [ServerException] on any network or server error.
  Future<List<MedicineModel>> getMedicines();

  /// Searches the remote API for medicines matching [query].
  ///
  /// Throws [ServerException] on any network or server error.
  Future<List<MedicineModel>> searchMedicines(String query);
}

// ── Mock dataset ──────────────────────────────────────────────────────────────

/// Realistic pharmaceutical mock data used when the remote endpoint is
/// unavailable. Provides offline-first testability without a live server.
const List<Map<String, dynamic>> _mockMedicines = [
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000001',
    'brand_name': 'Panadol',
    'salt_name': 'Paracetamol',
    'dosage_form': 'Tablet',
    'strength': '500 mg',
    'unit_price': 45.0,
    'stock_count': 200,
    'requires_prescription': false,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000002',
    'brand_name': 'Augmentin',
    'salt_name': 'Amoxicillin / Clavulanate',
    'dosage_form': 'Tablet',
    'strength': '625 mg',
    'unit_price': 320.0,
    'stock_count': 80,
    'requires_prescription': true,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000003',
    'brand_name': 'Brufen',
    'salt_name': 'Ibuprofen',
    'dosage_form': 'Tablet',
    'strength': '400 mg',
    'unit_price': 60.0,
    'stock_count': 150,
    'requires_prescription': false,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000004',
    'brand_name': 'Disprin',
    'salt_name': 'Aspirin',
    'dosage_form': 'Dispersible Tablet',
    'strength': '75 mg',
    'unit_price': 30.0,
    'stock_count': 300,
    'requires_prescription': false,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000005',
    'brand_name': 'Flagyl',
    'salt_name': 'Metronidazole',
    'dosage_form': 'Tablet',
    'strength': '400 mg',
    'unit_price': 55.0,
    'stock_count': 120,
    'requires_prescription': true,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000006',
    'brand_name': 'Amoxil',
    'salt_name': 'Amoxicillin',
    'dosage_form': 'Capsule',
    'strength': '500 mg',
    'unit_price': 95.0,
    'stock_count': 90,
    'requires_prescription': true,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000007',
    'brand_name': 'Ventolin',
    'salt_name': 'Salbutamol',
    'dosage_form': 'Inhaler',
    'strength': '100 mcg/dose',
    'unit_price': 280.0,
    'stock_count': 40,
    'requires_prescription': true,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000008',
    'brand_name': 'Nexium',
    'salt_name': 'Esomeprazole',
    'dosage_form': 'Capsule',
    'strength': '20 mg',
    'unit_price': 210.0,
    'stock_count': 60,
    'requires_prescription': false,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000009',
    'brand_name': 'Glucophage',
    'salt_name': 'Metformin',
    'dosage_form': 'Tablet',
    'strength': '500 mg',
    'unit_price': 40.0,
    'stock_count': 180,
    'requires_prescription': true,
    'image_url': null,
  },
  {
    'id': 'aaf1e2d3-0001-4b5c-9e6f-000000000010',
    'brand_name': 'Calpol',
    'salt_name': 'Paracetamol',
    'dosage_form': 'Syrup',
    'strength': '120 mg/5 mL',
    'unit_price': 75.0,
    'stock_count': 0,
    'requires_prescription': false,
    'image_url': null,
  },
];

// ── Implementation ────────────────────────────────────────────────────────────

/// Fetches medicine catalog data from the Supabase REST API via [DioClient].
///
/// Falls back to the [_mockMedicines] dataset when the remote call fails so
/// that the app remains usable during development and offline testing.
class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  final DioClient _dioClient;

  /// Endpoint paths relative to [AppConstants.baseUrl].
  static const String _medicinesPath = '/rest/v1/medicines';

  const MedicineRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<MedicineModel>> getMedicines() async {
    try {
      final response = await _dioClient.dio.get<List<dynamic>>(
        _medicinesPath,
        queryParameters: {'select': '*', 'order': 'brand_name.asc'},
      );
      final data = _requireList(response);
      return data
          .map((json) => MedicineModel.fromJson(json as Map<String, dynamic>))
          .toList(growable: false);
    } on DioException {
      // Remote unavailable — return mock dataset for offline-first testability.
      return _mockMedicines
          .map(MedicineModel.fromJson)
          .toList(growable: false);
    } catch (e) {
      throw ServerException(message: 'Unexpected error fetching medicines: $e');
    }
  }

  @override
  Future<List<MedicineModel>> searchMedicines(String query) async {
    try {
      final encoded = Uri.encodeComponent(query);
      final response = await _dioClient.dio.get<List<dynamic>>(
        _medicinesPath,
        queryParameters: {
          'select': '*',
          'or': '(brand_name.ilike.*$encoded*,salt_name.ilike.*$encoded*)',
          'order': 'brand_name.asc',
        },
      );
      final data = _requireList(response);
      return data
          .map((json) => MedicineModel.fromJson(json as Map<String, dynamic>))
          .toList(growable: false);
    } on DioException {
      // Remote unavailable — filter mock dataset locally.
      final lower = query.toLowerCase();
      return _mockMedicines
          .where(
            (m) =>
                (m['brand_name'] as String).toLowerCase().contains(lower) ||
                (m['salt_name'] as String).toLowerCase().contains(lower),
          )
          .map(MedicineModel.fromJson)
          .toList(growable: false);
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error searching medicines: $e',
      );
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<dynamic> _requireList(Response<List<dynamic>> response) {
    final data = response.data;
    if (data == null) {
      throw ServerException(
        message: 'Empty response body from server.',
        statusCode: response.statusCode,
      );
    }
    return data;
  }
}
