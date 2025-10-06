import 'package:flutter/material.dart';
import '/features/dashboard/widgets/navbar.dart';

class DashboardWrapper extends StatelessWidget {
  final Widget child;

  const DashboardWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: child,
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
