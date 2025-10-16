import 'package:flutter/foundation.dart';
import 'package:valarpay/features/models/network_provider.dart';
import 'package:valarpay/features/models/data_models.dart';
import 'package:valarpay/features/repositories/data_repository.dart';

enum DataState {
  initial,
  loading,
  success,
  error,
}

class DataNotifier extends ChangeNotifier {
  final DataRepository _repository;

  DataNotifier(this._repository);

  DataState _state = DataState.initial;
  String _errorMessage = '';
  List<NetworkProvider> _dataProviders = [];
  List<DataPlanInfo> _availablePlans = [];
  DataPlan? _currentVariation;
  DataPurchaseResponse? _lastTransaction;
  String? _currentNetwork;

  // Getters
  DataState get state => _state;
  String get errorMessage => _errorMessage;
  List<NetworkProvider> get dataProviders => _dataProviders;
  List<DataPlanInfo> get availablePlans => _availablePlans;
  DataPlan? get currentVariation => _currentVariation;
  DataPurchaseResponse? get lastTransaction => _lastTransaction;
  String? get currentNetwork => _currentNetwork;

  bool get isLoading => _state == DataState.loading;
  bool get hasError => _state == DataState.error;

  void _setState(DataState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(DataState.error);
  }

  /// Fetch data network providers
  Future<void> fetchDataProviders() async {
    _setState(DataState.loading);
    try {
      final response = await _repository.getDataNetworkProviders();
      _dataProviders = response.providers;
      _setState(DataState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Get data plan for a phone number
  Future<void> getDataPlan({
    required String phone,
    required String currency,
  }) async {
    _setState(DataState.loading);
    try {
      final response = await _repository.getDataPlan(
        phone: phone,
        currency: currency,
      );
      _availablePlans = response.plans;
      _currentNetwork = response.network;
      _setState(DataState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Get data variation by operator ID
  Future<void> getDataVariation({
    required int operatorId,
  }) async {
    _setState(DataState.loading);
    try {
      final response = await _repository.getDataVariation(
        operatorId: operatorId,
      );
      _currentVariation = response.data;
      _setState(DataState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Purchase data
  Future<bool> purchaseData({
    required String walletPin,
    required double amount,
    required int operatorId,
    required String phone,
    required String currency,
    bool? addBeneficiary,
  }) async {
    _setState(DataState.loading);
    try {
      final request = DataPurchaseRequest(
        walletPin: walletPin,
        amount: amount,
        operatorId: operatorId,
        phone: phone,
        currency: currency,
        addBeneficiary: addBeneficiary,
      );

      final response = await _repository.payData(request);
      _lastTransaction = response;
      _setState(DataState.success);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Clear error state
  void clearError() {
    _errorMessage = '';
    if (_state == DataState.error) {
      _setState(DataState.initial);
    }
  }

  /// Reset state
  void reset() {
    _state = DataState.initial;
    _errorMessage = '';
    _availablePlans = [];
    _currentVariation = null;
    _lastTransaction = null;
    _currentNetwork = null;
    notifyListeners();
  }

  /// Get network provider by operator ID
  NetworkProvider? getProviderByOperatorId(int operatorId) {
    try {
      return _dataProviders.firstWhere(
        (provider) => provider.operatorId == operatorId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get network provider by network name
  NetworkProvider? getProviderByNetwork(String network) {
    try {
      return _dataProviders.firstWhere(
        (provider) => provider.network.toLowerCase() == network.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get data plan info by operator ID
  DataPlanInfo? getPlanByOperatorId(int operatorId) {
    try {
      return _availablePlans.firstWhere(
        (plan) => plan.operatorId == operatorId,
      );
    } catch (e) {
      return null;
    }
  }
}
