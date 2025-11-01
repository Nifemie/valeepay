import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/electricity.dart';
import 'package:valarpay/features/repositories/electricity_repository.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

class ElectricityNotifier extends StateNotifier<DataState<ElectricityPlan>> {
  final ElectricityRepository _repository;

  ElectricityNotifier(this._repository)
      : super(DataState<ElectricityPlan>.initial());

  Future<void> getElectricityPlans({required String currency}) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final response =
          await _repository.getElectricityPlans(currency: currency);
      state = state.copyWith(
        isInitialLoading: false,
        data: response.data,
        isDataAvailable: true,
        message: response.message,
      );
    } catch (e, stack) {
      log('[ElectricityNotifier getElectricityPlans Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to get electricity plans: ${e.toString()}',
      );
    }
  }

  void reset() => state = DataState<ElectricityPlan>.initial();
}

class ElectricityBillInfoNotifier
    extends StateNotifier<DataState<ElectricityBillInfo>> {
  final ElectricityRepository _repository;

  ElectricityBillInfoNotifier(this._repository)
      : super(DataState<ElectricityBillInfo>.initial());

  Future<void> getBillInfo({required String billerCode}) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final response = await _repository.getBillInfo(billerCode: billerCode);
      state = state.copyWith(
        isInitialLoading: false,
        data: response.data,
        isDataAvailable: true,
        message: response.message,
      );
    } catch (e, stack) {
      log('[ElectricityBillInfoNotifier getBillInfo Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Failed to get bill information: ${e.toString()}',
      );
    }
  }

  void reset() => state = DataState<ElectricityBillInfo>.initial();
}

class ElectricityPaymentNotifier
    extends StateNotifier<DataState<ElectricityPaymentResponse>> {
  final ElectricityRepository _repository;

  ElectricityPaymentNotifier(this._repository)
      : super(DataState<ElectricityPaymentResponse>.initial());

  Future<void> verifyMeterNumber(VerifyMeterNumberRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      await _repository.verifyMeterNumber(request);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Meter number verified successfully',
      );
    } catch (e, stack) {
      log('[ElectricityPaymentNotifier verifyMeterNumber Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  Future<void> payElectricity(ElectricityPaymentRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final response = await _repository.payElectricity(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [response],
        isDataAvailable: true,
        message: response.message,
      );
    } catch (e, stack) {
      log('[ElectricityPaymentNotifier payElectricity Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: 'Payment failed: ${e.toString()}',
      );
    }
  }

  void reset() => state = DataState<ElectricityPaymentResponse>.initial();
}

// Providers
final electricityRepositoryProvider = Provider(
  (ref) => ElectricityRepository(ref.read(apiClientProvider)),
);

final electricityNotifierProvider =
    StateNotifierProvider<ElectricityNotifier, DataState<ElectricityPlan>>(
  (ref) => ElectricityNotifier(ref.read(electricityRepositoryProvider)),
);

final electricityBillInfoNotifierProvider = StateNotifierProvider<
    ElectricityBillInfoNotifier, DataState<ElectricityBillInfo>>(
  (ref) => ElectricityBillInfoNotifier(ref.read(electricityRepositoryProvider)),
);

final electricityPaymentNotifierProvider = StateNotifierProvider<
    ElectricityPaymentNotifier, DataState<ElectricityPaymentResponse>>(
  (ref) => ElectricityPaymentNotifier(ref.read(electricityRepositoryProvider)),
);
