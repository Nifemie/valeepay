import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:dio/dio.dart';
import 'package:valarpay/core/network/api_client.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  String currentPin = '';
  String newPin = '';
  String confirmPin = '';
  int step = 1; // 1: current pin, 2: new pin, 3: confirm pin
  final int pinLength = 4;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              _getTitle(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getSubtitle(),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Passcode dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pinLength, (index) {
                final filled = index < _getCurrentPin().length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color:
                        filled ? appTheme.primaryColor : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            const Spacer(),

            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),

            if (!_isProcessing) _buildNumberPad(),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/forgot-password'),
              child: Text(
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

  String _getTitle() {
    switch (step) {
      case 1:
        return 'Enter Current PIN';
      case 2:
        return 'Enter New PIN';
      case 3:
        return 'Confirm New PIN';
      default:
        return 'Change PIN';
    }
  }

  String _getSubtitle() {
    switch (step) {
      case 1:
        return 'Please enter your current transaction PIN';
      case 2:
        return 'Please enter your new transaction PIN';
      case 3:
        return 'Please confirm your new transaction PIN';
      default:
        return '';
    }
  }

  String _getCurrentPin() {
    switch (step) {
      case 1:
        return currentPin;
      case 2:
        return newPin;
      case 3:
        return confirmPin;
      default:
        return '';
    }
  }

  void _addDigit(String digit) {
    String currentPinValue = _getCurrentPin();
    if (currentPinValue.length < pinLength) {
      setState(() {
        switch (step) {
          case 1:
            currentPin += digit;
            break;
          case 2:
            newPin += digit;
            break;
          case 3:
            confirmPin += digit;
            break;
        }
      });

      if (_getCurrentPin().length == pinLength) {
        _handlePinComplete();
      }
    }
  }

  void _deleteDigit() {
    String currentPinValue = _getCurrentPin();
    if (currentPinValue.isNotEmpty) {
      setState(() {
        switch (step) {
          case 1:
            currentPin = currentPin.substring(0, currentPin.length - 1);
            break;
          case 2:
            newPin = newPin.substring(0, newPin.length - 1);
            break;
          case 3:
            confirmPin = confirmPin.substring(0, confirmPin.length - 1);
            break;
        }
      });
    }
  }

  void _handlePinComplete() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        switch (step) {
          case 1:
            // Verify current PIN (simulate verification)
            setState(() {
              step = 2;
            });
            break;
          case 2:
            setState(() {
              step = 3;
            });
            break;
          case 3:
            if (newPin == confirmPin) {
              // call backend to change pin
              _submitChangePin();
            } else {
              AppMessenger.show(
                context,
                message: 'Pins do not match',
                type: MessageType.error,
              );
              // reset new pin steps
              setState(() {
                newPin = '';
                confirmPin = '';
                step = 2;
              });
            }
            break;
        }
      }
    });
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

  // void _onNumberPressed(String number) async {
  //   if (_passcode.length < _passcodeLength) {
  //     setState(() => _passcode += number);

  //     if (_passcode.length == _passcodeLength) {
  //       FocusScope.of(context).unfocus();
  //       setState(() => _isProcessing = true);

  //       final ip = await DeviceUtils.getIpAddress();
  //       final deviceName = await DeviceUtils.getDeviceName();
  //       final os = await DeviceUtils.getDeviceOS();

  //       final savedUsername = await SessionService.getUsername() ?? '';
  //       if (savedUsername != '') {
  //         final request = PasscodeLoginRequest(
  //           username: savedUsername,
  //           passcode: _passcode,
  //           ipAddress: ip,
  //           deviceName: deviceName,
  //           operatingSystem: os,
  //         );

  //         final notifier = ref.read(authNotifierProvider.notifier);
  //         await notifier.loginWithPasscode(request);
  //         final state = ref.read(authNotifierProvider);

  //         if (state.isDataAvailable && mounted) {
  //           final loginResponse = state.data?.first;

  //           // Save session with access token
  //           await SessionService.saveSession(loginResponse!);

  //           // 🔥 FIX: Fetch fresh user data with wallet from /me endpoint
  //           AppLogger.log('🔥 [PasscodeLogin] About to call refreshUserProfile...');
  //           final freshUser =
  //               await ref
  //                   .read(userNotifierProvider.notifier)
  //                   .refreshUserProfile();
  //           AppLogger.log(
  //             '🔥 [PasscodeLogin] refreshUserProfile returned: ${freshUser != null}',
  //           );
  //           if (freshUser != null) {
  //             AppLogger.log(
  //               '🔥 [PasscodeLogin] Fresh user has ${freshUser.wallets.length} wallets',
  //             );
  //           }

  //           if (freshUser != null) {
  //             // Update user provider with fresh data including wallet
  //             ref.read(userProvider.notifier).setUser(freshUser);

  //             // Update cached session with complete user data
  //             await SessionService.saveSession(
  //               LoginResponse(
  //                 message: loginResponse.message,
  //                 statusCode: loginResponse.statusCode,
  //                 user: freshUser,
  //                 accessToken: loginResponse.accessToken,
  //               ),
  //             );
  //           } else {
  //             // Fallback to login response user if refresh fails
  //             ref.read(userProvider.notifier).setUser(loginResponse.user);
  //           }

  //           AppMessenger.show(
  //             context,
  //             message: 'Welcome ${loginResponse.user.fullname}',
  //             type: MessageType.success,
  //           );

  //           // Navigate after the current frame to avoid duplicate key issues
  //           WidgetsBinding.instance.addPostFrameCallback((_) {
  //             if (mounted) {
  //               context.go('/');
  //             }
  //           });
  //         } else {
  //           AppMessenger.show(
  //             context,
  //             message: state.message ?? 'Invalid passcode',
  //             type: MessageType.error,
  //           );
  //           setState(() => _passcode = '');
  //         }
  //       } else {
  //         AppMessenger.show(
  //           context,
  //           message: 'Please login with your password first.',
  //           type: MessageType.warning,
  //         );
  //         context.go('/signin');
  //       }
  //       setState(() => _isProcessing = false);
  //     }
  //   }
  // }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _addDigit(number),
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
      onTap: _deleteDigit,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: const Center(child: Icon(Icons.backspace_outlined, size: 24)),
      ),
    );
  }

  Future<void> _submitChangePin() async {
    // final ApiClient will attach Authorization header from SessionService
    setState(() => _isProcessing = true);
    try {
      final client = ApiClient();
      final resp = await client.put(
        '/api/v1/user/change-pin',
        data: {'oldPin': currentPin, 'newPin': newPin},
      );

      if (resp.statusCode == 200) {
        AppMessenger.show(
          context,
          message: 'PIN changed successfully',
          type: MessageType.success,
        );
        // pop back after a short delay to show message
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) Navigator.of(context).pop();
        });
      } else {
        AppMessenger.show(
          context,
          message: resp.statusMessage ?? 'Failed to change PIN',
          type: MessageType.error,
        );
        // reset to new pin step so user can try again
        setState(() {
          newPin = '';
          confirmPin = '';
          step = 2;
        });
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?.toString() ?? e.message ?? 'An error occurred';
      AppMessenger.show(context, message: message, type: MessageType.error);
      setState(() {
        newPin = '';
        confirmPin = '';
        step = 2;
      });
    } catch (e) {
      AppMessenger.show(
        context,
        message: e.toString(),
        type: MessageType.error,
      );
      setState(() {
        newPin = '';
        confirmPin = '';
        step = 2;
      });
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
