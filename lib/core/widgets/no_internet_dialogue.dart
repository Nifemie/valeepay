import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// Shows a colorful "No Internet" alert dialog.
/// - [onRetry] is called when the user taps Retry.
/// - [onOpenSettings] is called when the user taps Open Settings (optional).
/// Returns true if retry was tapped, false if settings tapped, null if dismissed.
Future<bool?> showNoInternetDialog(
  BuildContext context, {
  VoidCallback? onRetry,
  VoidCallback? onOpenSettings,
  String title = 'No Internet Connection',
  String message =
      'Your device is offline. Check your connection and try again.',
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<bool?>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'No Internet',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (ctx, anim, secAnim) {
      return const SizedBox.shrink(); // content built in transitionBuilder
    },
    transitionBuilder: (ctx, animation, secondaryAnimation, child) {
      final curved = Curves.easeOut.transform(animation.value);
      return Transform.translate(
        offset: Offset(0, (1 - curved) * 20),
        child: Opacity(
          opacity: animation.value,
          child: _NoInternetDialogBody(
            onRetry: onRetry,
            onOpenSettings: onOpenSettings,
            title: title,
            message: message,
            barrierDismissible: barrierDismissible,
          ),
        ),
      );
    },
  );
}

class _NoInternetDialogBody extends StatefulWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;
  final String title;
  final String message;
  final bool barrierDismissible;

  const _NoInternetDialogBody({
    Key? key,
    this.onRetry,
    this.onOpenSettings,
    required this.title,
    required this.message,
    required this.barrierDismissible,
  }) : super(key: key);

  @override
  State<_NoInternetDialogBody> createState() => _NoInternetDialogBodyState();
}

class _NoInternetDialogBodyState extends State<_NoInternetDialogBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.95,
      upperBound: 1.06,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _openSettings() async {
    // Default behavior: open platform settings if possible
    // On Android you might use 'android_intent' package. This is a gentle default:
    try {
      if (Platform.isAndroid) {
        // quick attempt to open settings via system channel (may not work for all)
        await openAppSettings();
      } else if (Platform.isIOS) {
        // iOS requires packages / deep linking to open Settings
      }
    } catch (_) {}
    widget.onOpenSettings?.call();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final dialogWidth = media.size.width * 0.86;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth,
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.indigo.shade700, Colors.deepPurple.shade700]
                    : [Colors.pink.shade300, Colors.orange.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top decorative pill
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 14),

                // Pulsing icon
                ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.0).animate(_pulseController),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = _pulseController.value;
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.wifi_off,
                          size: 44,
                          color: isDark ? Colors.deepPurple : Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Title
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Message card with glassy effect
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.12), width: 0.8),
                  ),
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 13.5,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          widget.onRetry?.call();
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Retry'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white70),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          await _openSettings();
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Open Settings'),
                      ),
                    ),
                  ],
                ),

                // Optional dismiss hint
                if (widget.barrierDismissible) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Tap outside to dismiss',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
