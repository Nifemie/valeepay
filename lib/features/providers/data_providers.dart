import 'package:flutter/material.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/features/repositories/data_repository.dart';
import 'package:valarpay/features/notifiers/data_notifier.dart';

class DataProviders {
  static final ApiClient _apiClient = ApiClient();
  static final DataRepository _repository = DataRepository(_apiClient);
  static final DataNotifier _notifier = DataNotifier(_repository);

  static DataNotifier get notifier => _notifier;
  static DataRepository get repository => _repository;
  static ApiClient get apiClient => _apiClient;
}

// Provider widget for easy access in the widget tree
class DataProvider extends InheritedWidget {
  final DataNotifier notifier;

  const DataProvider({
    super.key,
    required this.notifier,
    required super.child,
  });

  static DataProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider>();
  }

  @override
  bool updateShouldNotify(DataProvider oldWidget) {
    return notifier != oldWidget.notifier;
  }
}

// Extension for easy access
extension DataContext on BuildContext {
  DataNotifier get dataNotifier {
    final provider = DataProvider.of(this);
    assert(provider != null, 'DataProvider not found in widget tree');
    return provider!.notifier;
  }
}
