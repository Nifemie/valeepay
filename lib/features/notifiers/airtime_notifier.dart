import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/network_provider.dart';
import 'package:valarpay/features/models/airtime_models.dart';
import 'package:valarpay/features/repositories/airtime_repository.dart';
import 'package:valarpay/features/notifiers/auth_notifier.dart';

/// Repository provider
final airtimeRepositoryProvider = Provider<AirtimeRepository>((ref) {
  return AirtimeRepository(ref.read(apiClientProvider));
});

/// Providers
class AirtimeProvidersNotifier
    extends StateNotifier<DataState<NetworkProvider>> {
  final AirtimeRepository _repository;

  AirtimeProvidersNotifier(this._repository)
      : super(DataState<NetworkProvider>.initial());

  Future<void> fetchProviders() async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.getAirtimeNetworkProviders();
      state = state.copyWith(
          isInitialLoading: false,
          data: res.providers,
          isDataAvailable: true,
          message: res.message);
    } catch (e, stack) {
      log('[AirtimeProvidersNotifier fetchProviders] $e\n$stack');
      state = state.copyWith(
          isInitialLoading: false,
          isDataAvailable: false,
          message: 'Failed to load providers: ${e.toString()}');
    }
  }

  void reset() => state = DataState<NetworkProvider>.initial();
}

class AirtimePlanNotifier extends StateNotifier<DataState<AirtimePlan>> {
  final AirtimeRepository _repository;

  AirtimePlanNotifier(this._repository)
      : super(DataState<AirtimePlan>.initial());

  Future<void> getPlan(
      {required String phone, required String currency}) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res =
          await _repository.getAirtimePlan(phone: phone, currency: currency);
      state = state.copyWith(
          isInitialLoading: false,
          data: [res.plan],
          isDataAvailable: true,
          message: res.message);
    } catch (e, stack) {
      log('[AirtimePlanNotifier getPlan] $e\n$stack');
      state = state.copyWith(
          isInitialLoading: false,
          isDataAvailable: false,
          message: 'Failed to load plan: ${e.toString()}');
    }
  }

  Future<void> getVariation({required int operatorId}) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.getAirtimeVariation(operatorId: operatorId);
      state = state.copyWith(
          isInitialLoading: false,
          data: [res.plan],
          isDataAvailable: true,
          message: res.message);
    } catch (e, stack) {
      log('[AirtimePlanNotifier getVariation] $e\n$stack');
      state = state.copyWith(
          isInitialLoading: false,
          isDataAvailable: false,
          message: 'Failed to load variation: ${e.toString()}');
    }
  }

  void reset() => state = DataState<AirtimePlan>.initial();
}

class AirtimePurchaseNotifier
    extends StateNotifier<DataState<AirtimePurchaseResponse>> {
  final AirtimeRepository _repository;

  AirtimePurchaseNotifier(this._repository)
      : super(DataState<AirtimePurchaseResponse>.initial());

  Future<void> purchase(AirtimePurchaseRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.payAirtime(request);
      state = state.copyWith(
          isInitialLoading: false,
          data: [res],
          isDataAvailable: true,
          message: res.message);
    } catch (e, stack) {
      log('[AirtimePurchaseNotifier purchase] $e\n$stack');
      state = state.copyWith(
          isInitialLoading: false,
          isDataAvailable: false,
          message: 'Purchase failed: ${e.toString()}');
    }
  }

  void reset() => state = DataState<AirtimePurchaseResponse>.initial();
}

// Riverpod providers
final airtimeProvidersNotifierProvider =
    StateNotifierProvider<AirtimeProvidersNotifier, DataState<NetworkProvider>>(
  (ref) => AirtimeProvidersNotifier(ref.read(airtimeRepositoryProvider)),
);

final airtimePlanNotifierProvider =
    StateNotifierProvider<AirtimePlanNotifier, DataState<AirtimePlan>>(
  (ref) => AirtimePlanNotifier(ref.read(airtimeRepositoryProvider)),
);

final airtimePurchaseNotifierProvider = StateNotifierProvider<
    AirtimePurchaseNotifier, DataState<AirtimePurchaseResponse>>(
  (ref) => AirtimePurchaseNotifier(ref.read(airtimeRepositoryProvider)),
);
