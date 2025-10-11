import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/themes/color_utils.dart';

class LoginSettingsScreen extends StatefulWidget {
  const LoginSettingsScreen({super.key});

  @override
  State<LoginSettingsScreen> createState() => _LoginSettingsScreenState();
}

class _LoginSettingsScreenState extends State<LoginSettingsScreen> {
  bool fingerprintEnabled = true;
  bool faceIdEnabled = false;
  bool logInWithFaceId = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Login Settings'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              // Password Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Change Password',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Forgot Password',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        context.push('/auto-logout-settings');
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Auto Logout Settings',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Biometrics Section

              Text(
                'Biometrics',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Log in with fingerprint',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Switch(
                          value: faceIdEnabled,
                          onChanged: (value) {
                            setState(() {
                              faceIdEnabled = value;
                            });
                          },
                          activeTrackColor: appTheme.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Log in with Face ID',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Switch(
                          value: logInWithFaceId,
                          onChanged: (value) {
                            setState(() {
                              logInWithFaceId = value;
                            });
                          },
                          activeTrackColor: appTheme.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
