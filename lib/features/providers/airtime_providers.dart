import 'package:flutter/material.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/features/repositories/airtime_repository.dart';
import 'package:valarpay/features/notifiers/airtime_notifier.dart';

class AirtimeProviders {
  static final ApiClient _apiClient = ApiClient();
  static final AirtimeRepository _repository = AirtimeRepository(_apiClient);
  static final AirtimeNotifier _notifier = AirtimeNotifier(_repository);

  static AirtimeNotifier get notifier => _notifier;
  static AirtimeRepository get repository => _repository;
  static ApiClient get apiClient => _apiClient;
}

// Provider widget for easy access in the widget tree
class AirtimeProvider extends InheritedWidget {
  final AirtimeNotifier notifier;

  const AirtimeProvider({
    super.key,
    required this.notifier,
    required super.child,
  });

  static AirtimeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AirtimeProvider>();
  }

  @override
  bool updateShouldNotify(AirtimeProvider oldWidget) {
    return notifier != oldWidget.notifier;
  }
}

// Extension for easy access
extension AirtimeContext on BuildContext {
  AirtimeNotifier get airtimeNotifier {
    final provider = AirtimeProvider.of(this);
    assert(provider != null, 'AirtimeProvider not found in widget tree');
    return provider!.notifier;
  }
}
