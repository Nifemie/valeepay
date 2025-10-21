import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/features/repositories/data_repository.dart';

/// NOTE: this file previously exposed a ChangeNotifier-based `DataNotifier`.
/// The project has been migrated to Riverpod providers. Keep a minimal
/// compatibility accessor for ApiClient and DataRepository here to avoid
/// breakage in places that import this module. New code should use the
/// Riverpod providers in `lib/features/notifiers/data_notifier.dart`.

class DataProviders {
  static final ApiClient _apiClient = ApiClient();
  static final DataRepository _repository = DataRepository(_apiClient);

  static DataRepository get repository => _repository;
  static ApiClient get apiClient => _apiClient;
}
