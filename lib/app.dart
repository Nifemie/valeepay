import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valarpay/core/services/user_activity_service.dart';
import '../core/routing/app_router.dart';
import '../core/themes/app_theme.dart';
import '../core/providers/theme_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Listener(
            onPointerDown: (_) => UserActivityService.resetTimer(context, ref),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => UserActivityService.resetTimer(context, ref),
                child: MaterialApp.router(
                  title: 'ValarPay - Beyond Banking',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  routerConfig: router,
                )));
      },
    );
  }
}
