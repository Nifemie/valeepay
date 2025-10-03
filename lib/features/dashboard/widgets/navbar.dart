import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  final List<NavItem> _navItems = const [ // Made const
    NavItem(
      icon: 'assets/images/nav_icons/home.svg',
      label: 'Home',
      route: '/', // Added route
    ),
    NavItem(
      icon: 'assets/images/nav_icons/bank.svg',
      label: 'Finance',
      route: '/finance', // Placeholder route
    ),
    NavItem(
      icon: 'assets/images/nav_icons/briefcase.svg',
      label: 'Invest',
      route: '/invest', // Placeholder route
    ),
    NavItem(
      icon: 'assets/images/nav_icons/card-pos.svg',
      label: 'Cards',
      route: '/cards', // Placeholder route
    ),
    NavItem(
      icon: 'assets/images/nav_icons/profile-circle.svg',
      label: 'Me',
      route: '/me', // Added route
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndexFromRoute();
  }

  void _updateSelectedIndexFromRoute() {
    final String location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    int newIndex = 0; // Default to Home
    int bestMatchLength = -1;

    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].route) && _navItems[i].route.length > bestMatchLength) {
        bestMatchLength = _navItems[i].route.length;
        newIndex = i;
      }
    }

    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  void _onItemTapped(int index) {
    // Navigate using GoRouter
    context.push(_navItems[index].route);
    // The _selectedIndex will be updated by didChangeDependencies when the route changes
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _navItems.length,
              (index) => _buildNavItem(index),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              item.icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFFF76301) : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFF76301) : Colors.grey,
                fontFamily: 'SF Pro',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 16 / 12,
                letterSpacing: 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final String icon;
  final String label;
  final String route; // Added route property

  const NavItem({ // Added const
    required this.icon,
    required this.label,
    required this.route, // Added route
  });
}