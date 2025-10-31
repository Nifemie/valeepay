import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KycReviewProgressScreen extends StatelessWidget {
  const KycReviewProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Review Progress',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              
              // House icon image
              Image.asset(
                'assets/images/kyc_house.png',
                width: 120.w,
                height: 120.h,
              ),
              SizedBox(height: 32.h),
              
              // Title
              Text(
                'Verification in Progress',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111827),
                ),
              ),
              SizedBox(height: 12.h),
              
              // Subtitle
              Text(
                'Our team is reviewing your details. You\'ll be notified once the verification is complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF9CA3AF),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 48.h),
              
              // Progress Steps
              _buildProgressStep(
                icon: Icons.check_circle,
                iconColor: const Color(0xFF10B981),
                title: 'Request Submitted Successfully',
                subtitle: 'Oct 6 7:09pm',
                isCompleted: true,
              ),
              SizedBox(height: 24.h),
              
              _buildProgressStep(
                icon: Icons.circle,
                iconColor: const Color(0xFFF76301),
                title: 'Upgrade Under Review',
                subtitle: 'Your account upgrade to Tier 3 is currently under review. Our team is verifying your details to ensure accuracy and compliance',
                isCompleted: false,
                isActive: true,
              ),
              SizedBox(height: 24.h),
              
              _buildProgressStep(
                icon: Icons.circle_outlined,
                iconColor: const Color(0xFFD1D5DB),
                title: 'Upgrade Successful',
                subtitle: 'You\'ll be notified once it\'s approved',
                isCompleted: false,
                isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isCompleted,
    bool isActive = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Icon(
          icon,
          color: iconColor,
          size: 24.sp,
        ),
        SizedBox(width: 12.w),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive || isCompleted
                      ? const Color(0xFF111827)
                      : const Color(0xFF9CA3AF),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF9CA3AF),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
