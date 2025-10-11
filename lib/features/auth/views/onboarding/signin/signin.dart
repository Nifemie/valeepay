import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/services/session_service.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/device_utils.dart';
import 'package:valarpay/features/models/login.dart';
import 'package:valarpay/features/notifiers/auth_notifier.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../../features/auth/widgets/need_help_modal.dart';
import '../../../../../../core/utils/color_utils.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _hasIncorrectPassword = false;

  onPressed() async {
    if (_formKey.currentState!.validate()) {
      final ip = await DeviceUtils.getIpAddress();
      final deviceName = await DeviceUtils.getDeviceName();
      final deviceOs = await DeviceUtils.getDeviceOS();

      final notifier = ref.read(authNotifierProvider.notifier);

      final request = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        ipAddress: ip,
        deviceName: deviceName,
        operatingSystem: deviceOs,
      );

      FocusScope.of(context).unfocus();

      await notifier.login(request);

      final state = ref.read(authNotifierProvider);
      if (state.isDataAvailable) {
        final user = state.data?.first;
        await SessionService.saveSession(
          LoginResponse(
            message: state.message ?? '',
            user: user!,
            statusCode: 200,
          ),
        );
        context.push('/'); // navigate to home
      } else {
        AppMessenger.show(
          context,
          message: state.message ?? 'Login failed',
          type: MessageType.error,
        );

        setState(() => _hasIncorrectPassword = true);
      }
    }
  }

  initialize() async {
    String? savedUsername = await SessionService.getUsername();
    if (savedUsername != null) {
      _emailController.text = savedUsername;
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/loginbg.jpg', // replace with your image
              fit: BoxFit.cover,
            ),
          ),

          // Black gradient overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: PlatformResponsive.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppBar replacement
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => context.push('/intro'),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () => NeedHelpModal.show(context),
                            child: const Text(
                              'Need Help?',
                              style: TextStyle(
                                color: appTheme.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 40.rw,
                            height: 50.rh,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: PlatformResponsive.circular(8),
                            ),
                            child: ClipRRect(
                              // Use ClipRRect to apply border radius to the image
                              borderRadius: PlatformResponsive.circular(8),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover, // Cover the container area
                                width: 40.rw,
                                height: 40.rh,
                              ),
                            ),
                          ),
                          PlatformResponsive.sizedBoxW(6),
                          Text(
                            'Valarpay',
                            style: TextStyle(
                              fontSize: 24.rsp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),

                      // Welcome text
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Enter details to Login into your account',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Email
                      _buildTextField(
                        controller: _emailController,
                        label: 'Username',
                        hint: 'example@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        isDark: true,
                      ),
                      SizedBox(height: 5.h),

                      // Password
                      _buildPasswordField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '*********',
                        obscureText: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        hasError: _hasIncorrectPassword,
                        isDark: true,
                      ),

                      if (_hasIncorrectPassword) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 8.w),
                            const Text(
                              'Incorrect password',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                context.push('/forgot-password');
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: appTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 40.h),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              !authState.isInitialLoading ? onPressed : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appTheme.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: authState.isInitialLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Login Options
                      _buildLoginOption(
                        icon: Icons.fingerprint,
                        label: 'Login with Thumbprint',
                        onTap: () => context.push('/biometric-login'),
                      ),
                      SizedBox(height: 12.h),
                      _buildLoginOption(
                        icon: Icons.lock_outline,
                        label: 'Login with Passcode',
                        onTap: () => context.push('/passcode-login'),
                      ),
                      SizedBox(height: 32.h),

                      // Don't have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account yet? ",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/signup'),
                            child: Text(
                              'Open account',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: appTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- reusable widgets ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isDark = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : appTheme.darkColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: appTheme.primaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    bool hasError = false,
    bool isDark = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : appTheme.darkColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : appTheme.primaryColor,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'This field is required';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: appTheme.primaryColor, size: 22),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: appTheme.primaryColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          side: const BorderSide(color: appTheme.primaryColor, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
