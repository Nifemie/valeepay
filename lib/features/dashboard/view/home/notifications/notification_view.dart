import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:valarpay/app.dart'; // unused

class NotificationViewScreen extends StatelessWidget {
  final String title;
  final String content;
  const NotificationViewScreen(
      {required this.content, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      content,
                      style: TextStyle(
                          fontSize: 10.sp, fontWeight: FontWeight.w200),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
