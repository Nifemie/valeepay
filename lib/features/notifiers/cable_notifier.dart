import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/cable_models.dart';
import 'package:valarpay/features/repositories/cable_repository.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class CablePlansNotifier extends StateNotifier<DataState<CablePlanInfo>> {
  final CableRepository _repository;

  CablePlansNotifier(this._repository)
      : super(DataState<CablePlanInfo>.initial());

  Future<void> getPlans({required String currency}) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.getCablePlans(currency: currency);
      state = state.copyWith(
        isInitialLoading: false,
        data: res.data,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[CablePlansNotifier getPlans Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to load plans: ${e.toString()}',
      );
    }
  }

  void reset() => state = DataState<CablePlanInfo>.initial();
}

class CableVariationNotifier
    extends StateNotifier<DataState<CableVariationInfo>> {
  final CableRepository _repository;

  CableVariationNotifier(this._repository)
      : super(DataState<CableVariationInfo>.initial());

  Future<void> getVariations({required String billerCode}) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.getCableVariation(billerCode: billerCode);
      state = state.copyWith(
        isInitialLoading: false,
        data: res.data,
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[CableVariationNotifier getVariations Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to load variations: ${e.toString()}',
      );
    }
  }

  void reset() => state = DataState<CableVariationInfo>.initial();
}

class CablePaymentNotifier
    extends StateNotifier<DataState<CablePaymentResponse>> {
  final CableRepository _repository;

  CablePaymentNotifier(this._repository)
      : super(DataState<CablePaymentResponse>.initial());

  Future<void> verifyNumber(VerifyCableRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      await _repository.verifyCableNumber(request);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Number verified',
      );
    } catch (e, stack) {
      log('[CablePaymentNotifier verifyNumber Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  Future<void> payCable(CablePayRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.payCable(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[CablePaymentNotifier payCable Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Payment failed: ${e.toString()}',
      );
    }
  }

  void reset() => state = DataState<CablePaymentResponse>.initial();
}

// Providers
final cableRepositoryProvider =
    Provider((ref) => CableRepository(ref.read(apiClientProvider)));

final cablePlansNotifierProvider =
    StateNotifierProvider<CablePlansNotifier, DataState<CablePlanInfo>>(
  (ref) => CablePlansNotifier(ref.read(cableRepositoryProvider)),
);

final cableVariationNotifierProvider = StateNotifierProvider<
    CableVariationNotifier, DataState<CableVariationInfo>>(
  (ref) => CableVariationNotifier(ref.read(cableRepositoryProvider)),
);

final cablePaymentNotifierProvider = StateNotifierProvider<CablePaymentNotifier,
    DataState<CablePaymentResponse>>(
  (ref) => CablePaymentNotifier(ref.read(cableRepositoryProvider)),
);
