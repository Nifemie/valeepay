import 'package:flutter/material.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/features/dashboard/view/cards/get_physical_card.dart';
import 'package:valarpay/features/dashboard/view/comming_soon.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  bool isPhysicalCardSelected = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "ValarPay Cards",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.grey.shade800
                          : Theme.of(context).cardColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    _buildCardToggle("Physical Card", true),
                    _buildCardToggle("Virtual Card", false),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Card image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/card_image.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),

              // 1️⃣ Free Application and Usage
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.card_giftcard,
                      color: Color(0xFF00C853),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Free Application and Usage",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Free application, Zero maintenance",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2️⃣ Earn
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F5FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.attach_money,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Accepted At Millions of Locations Nationwide ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Flexible spending with 10% annual interest",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3️⃣ Security
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      color: Color(0xFF00C853),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Manage Your Card Effortlessly in ValarPay App ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Fully securely & licensed",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GetPhysicalCardScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Get Card Now",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // toggle builder
  Expanded _buildCardToggle(String label, bool isPhysical) {
    final bool isActive = isPhysicalCardSelected == isPhysical;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isPhysical) {
            // Navigate to coming soon screen for virtual card
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => const ComingSoonScreen(serviceName: "Virtual Card"),
              ),
            );
          } else {
            setState(() => isPhysicalCardSelected = isPhysical);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color:
                isActive
                    ? appTheme.primaryColor.withValues(alpha: 0.3)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color:
                            isActive
                                ? (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white12
                                    : Colors.black12)
                                : Colors.transparent,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ]
                    : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
