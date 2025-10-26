import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valarpay/core/themes/color_utils.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({super.key});

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen>
    with SingleTickerProviderStateMixin {
  int selectedRating = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // TODO: Replace with actual Google Play Store URL
  final String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.valarpay.app';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openPlayStore() async {
    final uri = Uri.parse(playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        AppMessenger.show(context,
            message: 'Could not open Play Store', type: MessageType.error);
       
      }
    }
  }

  void _onStarTap(int rating) {
    setState(() {
      selectedRating = rating;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Open Play Store after a short delay for animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && rating > 0) {
        _openPlayStore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Rate ValarPay'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ResponsiveUtils.spacing32),

              // App Icon/Logo
              Container(
                width: 100.w,
                height: 100.h,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appTheme.primaryColor.withOpacity(0.8),
                      appTheme.primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.star, size: 50.sp, color: Colors.white);
                  },
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing32),

              // Title
              Text(
                'Enjoying ValarPay?',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: ResponsiveUtils.spacing12),

              // Subtitle
              Text(
                'Your feedback helps us improve and serve you better',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize16,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: ResponsiveUtils.spacing48),

              // Rating prompt
              Text(
                'Tap to rate us',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing24),

              // Star Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final rating = index + 1;
                  final isSelected = rating <= selectedRating;

                  return GestureDetector(
                    onTap: () => _onStarTap(rating),
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              isSelected && rating == selectedRating
                                  ? _scaleAnimation.value
                                  : 1.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Icon(
                              isSelected ? Icons.star : Icons.star_border,
                              size: 48.sp,
                              color:
                                  isSelected
                                      ? const Color(0xFFFFA500)
                                      : isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),

              SizedBox(height: ResponsiveUtils.spacing24),

              // Selected rating text
              if (selectedRating > 0)
                AnimatedOpacity(
                  opacity: selectedRating > 0 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Text(
                        _getRatingText(selectedRating),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize20,
                          fontWeight: FontWeight.w600,
                          color: appTheme.primaryColor,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing8),
                      Text(
                        'Taking you to Play Store...',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize14,
                          color:
                              isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: ResponsiveUtils.spacing48),

              // Info card
              Container(
                padding: ResponsiveUtils.paddingAll16,
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? appTheme.primaryColor.withOpacity(0.1)
                          : appTheme.primaryColor.withOpacity(0.05),
                  borderRadius: ResponsiveUtils.borderRadius12,
                  border: Border.all(
                    color: appTheme.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: appTheme.primaryColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: ResponsiveUtils.spacing12),
                    Expanded(
                      child: Text(
                        'Your rating will be submitted on Google Play Store',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize14,
                          color:
                              isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing24),

              // Manual button as alternative
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openPlayStore,
                  icon: Icon(Icons.open_in_new, size: 20.sp),
                  label: Text(
                    'Open Play Store Manually',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: appTheme.primaryColor,
                    side: BorderSide(color: appTheme.primaryColor, width: 2),
                    padding: ResponsiveUtils.paddingVertical16,
                    shape: RoundedRectangleBorder(
                      borderRadius: ResponsiveUtils.borderRadius12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return '😔 We\'re sorry';
      case 2:
        return '😕 Could be better';
      case 3:
        return '😊 Good';
      case 4:
        return '😃 Great!';
      case 5:
        return '🤩 Awesome!';
      default:
        return '';
    }
  }
}
