import 'package:flutter/foundation.dart';
import 'package:valarpay/features/models/network_provider.dart';
import 'package:valarpay/features/models/airtime_models.dart';
import 'package:valarpay/features/repositories/airtime_repository.dart';

enum AirtimeState {
  initial,
  loading,
  success,
  error,
}

class AirtimeNotifier extends ChangeNotifier {
  final AirtimeRepository _repository;

  AirtimeNotifier(this._repository);

  AirtimeState _state = AirtimeState.initial;
  String _errorMessage = '';
  List<NetworkProvider> _airtimeProviders = [];
  List<NetworkProvider> _dataProviders = [];
  AirtimePlan? _currentPlan;
  AirtimePlan? _currentVariation;
  InternationalFxRate? _currentFxRate;
  AirtimePurchaseResponse? _lastTransaction;

  // Getters
  AirtimeState get state => _state;
  String get errorMessage => _errorMessage;
  List<NetworkProvider> get airtimeProviders => _airtimeProviders;
  List<NetworkProvider> get dataProviders => _dataProviders;
  AirtimePlan? get currentPlan => _currentPlan;
  AirtimePlan? get currentVariation => _currentVariation;
  InternationalFxRate? get currentFxRate => _currentFxRate;
  AirtimePurchaseResponse? get lastTransaction => _lastTransaction;

  bool get isLoading => _state == AirtimeState.loading;
  bool get hasError => _state == AirtimeState.error;

  void _setState(AirtimeState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(AirtimeState.error);
  }

  /// Fetch airtime network providers
  Future<void> fetchAirtimeProviders() async {
    _setState(AirtimeState.loading);
    try {
      final response = await _repository.getAirtimeNetworkProviders();
      _airtimeProviders = response.providers;
      _setState(AirtimeState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Get airtime plan for a phone number
  Future<void> getAirtimePlan({
    required String phone,
    required String currency,
  }) async {
    _setState(AirtimeState.loading);
    try {
      final response = await _repository.getAirtimePlan(
        phone: phone,
        currency: currency,
      );
      _currentPlan = response.plan;
      _setState(AirtimeState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Get airtime variation by operator ID
  Future<void> getAirtimeVariation({
    required int operatorId,
  }) async {
    _setState(AirtimeState.loading);
    try {
      final response = await _repository.getAirtimeVariation(
        operatorId: operatorId,
      );
      _currentVariation = response.plan;
      _setState(AirtimeState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Purchase airtime
  Future<bool> purchaseAirtime({
    required String walletPin,
    required double amount,
    required int operatorId,
    required String phone,
    required String currency,
    bool? addBeneficiary,
  }) async {
    _setState(AirtimeState.loading);
    try {
      final request = AirtimePurchaseRequest(
        walletPin: walletPin,
        amount: amount,
        operatorId: operatorId,
        phone: phone,
        currency: currency,
        addBeneficiary: addBeneficiary,
      );

      final response = await _repository.payAirtime(request);
      _lastTransaction = response;
      _setState(AirtimeState.success);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Get international FX rate
  Future<void> getInternationalFxRate({
    required double amount,
    required int operatorId,
  }) async {
    _setState(AirtimeState.loading);
    try {
      final response = await _repository.getInternationalFxRate(
        amount: amount,
        operatorId: operatorId,
      );
      _currentFxRate = response.data;
      _setState(AirtimeState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Get international airtime plan
  Future<void> getInternationalPlan({
    required String phone,
  }) async {
    _setState(AirtimeState.loading);
    try {
      final response = await _repository.getInternationalPlan(phone: phone);
      _currentPlan = response.plan;
      _setState(AirtimeState.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Purchase international airtime
  Future<bool> purchaseInternationalAirtime({
    required String walletPin,
    required double amount,
    required int operatorId,
    required String phone,
    required String currency,
    bool? addBeneficiary,
  }) async {
    _setState(AirtimeState.loading);
    try {
      final request = AirtimePurchaseRequest(
        walletPin: walletPin,
        amount: amount,
        operatorId: operatorId,
        phone: phone,
        currency: currency,
        addBeneficiary: addBeneficiary,
      );

      final response = await _repository.payInternationalAirtime(request);
      _lastTransaction = response;
      _setState(AirtimeState.success);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Clear error state
  void clearError() {
    _errorMessage = '';
    if (_state == AirtimeState.error) {
      _setState(AirtimeState.initial);
    }
  }

  /// Reset state
  void reset() {
    _state = AirtimeState.initial;
    _errorMessage = '';
    _currentPlan = null;
    _currentVariation = null;
    _currentFxRate = null;
    _lastTransaction = null;
    notifyListeners();
  }

  /// Get network provider by operator ID
  NetworkProvider? getProviderByOperatorId(int operatorId) {
    try {
      return _airtimeProviders.firstWhere(
        (provider) => provider.operatorId == operatorId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get network provider by network name
  NetworkProvider? getProviderByNetwork(String network) {
    try {
      return _airtimeProviders.firstWhere(
        (provider) => provider.network.toLowerCase() == network.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
