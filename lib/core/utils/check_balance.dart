import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/app_messenger.dart';

bool checkBalanceLeft(BuildContext context, String balance, String totalAmount) {
    final doubleBalance = double.tryParse(balance.replaceAll(',', '')) ?? 0.0;
    final doubleTotal = double.tryParse(totalAmount.replaceAll(',', '')) ?? 0.0;

    if (doubleBalance < doubleTotal) {
      AppMessenger.show(
        context,
        message: 'Insufficient account balance, kindly top up and continue',
        type: MessageType.error,
      );
      return false;
    }

    return true;
  }