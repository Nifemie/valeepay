import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/services/session_service.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/utils/device_utils.dart';
import 'package:valarpay/features/notifiers/auth_notifier.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/auth/widgets/need_help_modal.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class PasscodeLoginScreen extends ConsumerStatefulWidget {
  const PasscodeLoginScreen({super.key});

  @override
  ConsumerState<PasscodeLoginScreen> createState() =>
      _PasscodeLoginScreenState();
}

class _PasscodeLoginScreenState extends ConsumerState<PasscodeLoginScreen> {
  String _passcode = '';
  final int _passcodeLength = 6;
  bool _isProcessing = false;

  void _onNumberPressed(String number) async {
    if (_passcode.length < _passcodeLength) {
      setState(() => _passcode += number);

      if (_passcode.length == _passcodeLength) {
        FocusScope.of(context).unfocus();
        setState(() => _isProcessing = true);

        final ip = await DeviceUtils.getIpAddress();
        final deviceName = await DeviceUtils.getDeviceName();
        final os = await DeviceUtils.getDeviceOS();

        final savedUsername = await SessionService.getUsername() ?? '';
        if (savedUsername != '') {
          final request = PasscodeLoginRequest(
            username: savedUsername,
            passcode: _passcode,
            ipAddress: ip,
            deviceName: deviceName,
            operatingSystem: os,
          );

          final notifier = ref.read(authNotifierProvider.notifier);
          await notifier.loginWithPasscode(request);
          final state = ref.read(authNotifierProvider);

          if (state.isDataAvailable && mounted) {
            final loginResponse = state.data?.first;

            // Save session with access token
            await SessionService.saveSession(loginResponse!);

            // Update user provider
            ref.read(userProvider.notifier).setUser(loginResponse.user);

            AppMessenger.show(
              context,
              message: 'Welcome ${loginResponse.user.fullname}',
              type: MessageType.success,
            );
            context.pushReplacement('/');
          } else {
            AppMessenger.show(
              context,
              message: state.message ?? 'Invalid passcode',
              type: MessageType.error,
            );
            setState(() => _passcode = '');
          }
        } else {
          AppMessenger.show(
            context,
            message: 'Please login with your password first.',
            type: MessageType.warning,
          );
          context.pushReplacement('/signin');
        }
        setState(() => _isProcessing = false);
      }
    }
  }

  void _onDeletePressed() {
    if (_passcode.isNotEmpty) {
      setState(() => _passcode = _passcode.substring(0, _passcode.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.push('/signin'),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () => NeedHelpModal.show(context),
            child: const Text(
              'Need Help?',
              style: TextStyle(
                color: appTheme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Enter Passcode',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your 6-digit passcode to login',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Passcode dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_passcodeLength, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: index < _passcode.length
                        ? appTheme.primaryColor
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            const Spacer(),

            if (_isProcessing || authState.isInitialLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),

            if (!_isProcessing && !authState.isInitialLoading)
              _buildNumberPad(),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.push('/forgot-password'),
              child: const Text(
                'Forgot Passcode?',
                style: TextStyle(
                  color: appTheme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    final numbers = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'del',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          final item = numbers[index];
          if (item.isEmpty) return const SizedBox.shrink();
          if (item == 'del') return _buildDeleteButton();
          return _buildNumberButton(item);
        },
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _onDeletePressed,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.backspace_outlined, size: 24),
        ),
      ),
    );
  }
}
