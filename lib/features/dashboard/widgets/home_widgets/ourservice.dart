import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OurServicesWidget extends StatelessWidget {
  const OurServicesWidget({Key? key}) : super(key: key);

  static const List<ServiceItem> services = [
    ServiceItem(
      icon: 'assets/images/service_icon/airtime.svg',
      label: 'Airtime',
    ),
    ServiceItem(icon: 'assets/images/service_icon/Data.svg', label: 'Data'),
    ServiceItem(
      icon: 'assets/images/service_icon/betting.svg',
      label: 'Betting',
    ),
    ServiceItem(
      icon: 'assets/images/service_icon/light.svg',
      label: 'Electricity',
    ),
    ServiceItem(
      icon: 'assets/images/service_icon/cable.svg',
      label: 'Cable Tv',
    ),
    ServiceItem(
      icon: 'assets/images/service_icon/arrow-swap-horizontal.svg',
      label: 'Swap Currency',
    ),
    ServiceItem(
      icon: 'assets/images/service_icon/internet.svg',
      label: 'Internet',
    ),
    ServiceItem(icon: 'assets/images/service_icon/gift.svg', label: 'Giftcard'),
    ServiceItem(
      icon: 'assets/images/service_icon/int.svg',
      label: 'Intl. Airtime',
    ),
    ServiceItem(
      icon: 'assets/images/service_icon/Education.svg',
      label: 'Education',
    ),
    ServiceItem(
      icon: 'assets/images/service_icon/shoping.svg',
      label: 'Shopping',
    ),
    ServiceItem(
      icon: 'assets/images/service_icon/Insurance.svg',
      label: 'Insurance',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            'Our Services',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'SF Pro',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 22 / 18,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100, // adaptive
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceItem(context, services[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(BuildContext context, ServiceItem service) {
    return Container(
      height: 100,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push('/coming-soon'); // navigate to coming soon
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF76301),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: SvgPicture.asset(
                  service.icon,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'SF Pro',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 14 / 10,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceItem {
  final String icon;
  final String label;

  const ServiceItem({required this.icon, required this.label});
}