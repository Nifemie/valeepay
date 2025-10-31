import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/features/notifiers/user_notifier.dart';

final ninProvider = StateProvider<String>((ref) => '');

class NINPage extends ConsumerStatefulWidget {
  const NINPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NINPage> createState() => _NINPageState();
}

class _NINPageState extends ConsumerState<NINPage> {
  late TextEditingController _ninController;

  @override
  void initState() {
    super.initState();
    _ninController = TextEditingController(
      text: ref.read(ninProvider),
    );
  }

  @override
  void dispose() {
    _ninController.dispose();
    super.dispose();
  }

  Future<void> _verifyNin(String nin) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call API to verify NIN (without selfie)
      final response = await ref.read(userNotifierProvider.notifier).verifyNinOnly(nin);

      if (mounted) {
        Navigator.pop(context); // Close loading

        if (response?.isSuccess ?? false) {
          // Show success modal
          _showSuccessModal();
        } else {
          throw Exception(response?.message ?? 'NIN verification failed');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () {
                    Navigator.pop(context); // Close modal
                    Navigator.pop(context); // Go back to previous screen
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Upgrade Successfully',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              
              // Subtitle
              const Text(
                'Your account upgrade to Tier 2 is now complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // Done button
              SizedBox(
                width: double.infinity,
                child: FullWidthButton(
                  text: 'Done',
                  isEnabled: true,
                  onPressed: () {
                    Navigator.pop(context); // Close modal
                    Navigator.pop(context); // Go back to previous screen
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nin = ref.watch(ninProvider);
    final isFormValid = nin.length == 11;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Title
              const Text(
                'Your NIN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Enter your NIN to upgrade to Tier 2',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'SF Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              const SizedBox(height: 32),

              // NIN Input Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your NIN',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.06,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _ninController,
                      onChanged: (value) {
                        ref.read(ninProvider.notifier).state = value;
                      },
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      style: const TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your NIN',
                        hintStyle: TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontFamily: 'SF Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        counterText: '', // Hide counter
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Info Section
              Column(
                children: [
                  const Text(
                    'Why we need your NIN?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We need your NIN to verify your identity and upgrade your account to Tier 2. This allows you to enjoy higher transaction limits and more features.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontFamily: 'SF Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your NIN is securely encrypted and never shared with third parties.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF76301),
                      fontFamily: 'SF Pro',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Continue Button
              FullWidthButton(
                text: 'Continue',
                isEnabled: isFormValid,
                onPressed: () => _verifyNin(nin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
