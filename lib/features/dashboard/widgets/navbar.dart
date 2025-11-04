import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  final List<NavItem> _navItems = const [
    // Made const
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndexFromRoute();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndexFromRoute();
  }

  void _updateSelectedIndexFromRoute() {
    final String location = GoRouterState.of(context).uri.path;
    int newIndex = 0; // Default to Home

    // Map routes to indices with exact matching
    switch (location) {
      case '/':
        newIndex = 0;
        break;
      case '/finance':
        newIndex = 1;
        break;
      case '/invest':
        newIndex = 2;
        break;
      case '/cards':
        newIndex = 3;
        break;
      case '/me':
        newIndex = 4;
        break;
      default:
        // For nested routes, check if they start with any of our main routes
        if (location.startsWith('/finance')) {
          newIndex = 1;
        } else if (location.startsWith('/invest')) {
          newIndex = 2;
        } else if (location.startsWith('/cards')) {
          newIndex = 3;
        } else if (location.startsWith('/me')) {
          newIndex = 4;
        } else {
          newIndex = 0; // Default to Home
        }
        break;
    }

    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      // Navigate using GoRouter with go() instead of push() for tab navigation
      context.go(_navItems[index].route);
      // Update the selected index immediately for better UX
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: const BoxDecoration(),
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
                isSelected
                    ? const Color(0xFFF76301)
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFFF76301)
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
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

  const NavItem({
    // Added const
    required this.icon,
    required this.label,
    required this.route, // Added route
  });
}
