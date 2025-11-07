import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/logger.dart';

// Education service model
class EducationService {
  final String name;

  EducationService({required this.name});
}

final educationServicesProvider = StateProvider<List<EducationService>>(
  (ref) => [
    EducationService(name: 'JAMB'),
    EducationService(name: 'WAEC'),
    EducationService(name: 'NECO'),
    EducationService(name: 'NABTEB'),
  ],
);

final searchQueryProvider = StateProvider<String>((ref) => '');

class EducationPaymentPage extends ConsumerWidget {
  const EducationPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(educationServicesProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Filter services based on search
    final filteredServices =
        searchQuery.isEmpty
            ? services
            : services
                .where(
                  (service) => service.name.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                )
                .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Education Payment',
          style: TextStyle(
            color: Color(0xFF111827),
            fontFamily: 'SF Pro',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.035,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to saved beneficiary
                  AppLogger.log('Saved Beneficiary tapped');
                },
                child: const Text(
                  'Saved Beneficiary',
                  style: TextStyle(
                    color: Color(0xFFF76301),
                    fontFamily: 'SF Pro',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.06,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                width: 335,
                height: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 18,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          ref.read(searchQueryProvider.notifier).state = value;
                        },
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontFamily: 'SF Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Searching',
                          hintStyle: TextStyle(
                            color: Color(0xFFD1D5DB),
                            fontFamily: 'SF Pro',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Education Services List
              ...filteredServices.map((service) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildServiceItem(context, service),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, EducationService service) {
    return GestureDetector(
      onTap: () {
        // Navigate to payment details
        AppLogger.log('${service.name} tapped');
      },
      child: Container(
        width: 335,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEE3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              service.name,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.43,
                letterSpacing: 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
