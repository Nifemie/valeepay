import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/utils/responsive_utils.dart';

class ComingSoonScreen extends StatelessWidget {
  final String? serviceName;

  const ComingSoonScreen({Key? key, this.serviceName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = serviceName ?? "Service";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16.sp),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration / SVG icon
              Container(
                padding: ResponsiveUtils.paddingAll24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/images/coming_soon.svg", // <-- add your svg illustration
                  width: 120.w,
                  height: 120.h,
                ),
              ),
              SizedBox(height: 32.h),

              // Title
              Text(
                "$title Coming Soon 🚀",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),

              // Subtitle
              Text(
                "We’re working hard to bring this feature to you. "
                "Stay tuned for updates!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32.h),

              // Button back to home
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: ResponsiveUtils.borderRadius12,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 14.h,
                  ),
                ),
                onPressed: () => context.push("/"),
                icon: const Icon(Icons.home, color: Colors.white),
                label: Text(
                  "Back to Home",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}