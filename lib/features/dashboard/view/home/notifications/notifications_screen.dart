import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/home_widgets/notification_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/notification-settings');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).primaryColor,
          dividerColor: Colors.transparent,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Transactions'),
            Tab(text: 'Services'),
            Tab(text: 'Updates'),
            Tab(text: 'Messages'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NotificationTabView(
            tab: 'Transaction',
            notifications: _getTransactionNotifications(),
            emptyMessage:
                'No new transactions yet. Start making payments to see your transaction notifications here.',
          ),
          NotificationTabView(
            tab: 'Other',
            notifications: _getServiceNotifications(),
            emptyMessage:
                'No service notifications yet. Service updates and service notifications will appear here.',
          ),
          NotificationTabView(
            tab: 'Other',
            notifications: _getUpdateNotifications(),
            emptyMessage:
                'No updates yet. Stay tuned for the latest news and updates.',
          ),
          NotificationTabView(
            tab: 'Other',
            notifications: _getMessageNotifications(),
            emptyMessage: 'No new messages from ValarPay right now.',
          ),
        ],
      ),
    );
  }

  List<NotificationItem> _getTransactionNotifications() {
    return [];
  }

  List<NotificationItem> _getServiceNotifications() {
    return [
      NotificationItem(
        icon: 'assets/images/payment_wid/bell.svg',
        title: 'We\'re transfer to John Doe successful',
        subtitle:
            'Your transfer of ₦10,000 to John Doe has been processed successfully.',
        time: '1 day ago',
        isRead: false,
      ),
      NotificationItem(
        icon: 'assets/images/payment_wid/bell.svg',
        title: 'We\'re transfer to John Doe failed',
        subtitle:
            'Your transfer of ₦10,000 to John Doe has failed due to insufficient balance.',
        time: '2 days ago',
        isRead: true,
      ),
      NotificationItem(
        icon: 'assets/images/payment_wid/bell.svg',
        title: 'We\'re transfer to Alex James pending',
        subtitle: 'Your transfer of ₦5,000 to Alex James is being processed.',
        time: '3 days ago',
        isRead: true,
      ),
    ];
  }

  List<NotificationItem> _getUpdateNotifications() {
    return [];
  }

  List<NotificationItem> _getMessageNotifications() {
    return [
      NotificationItem(
        icon: 'assets/images/payment_wid/bell.svg',
        title: 'You\'re now set to earn some cashback!',
        subtitle:
            'Every time you pay for essentials like cable TV or even government services through ValarPay, you\'ll automatically enjoy instant cashback rewards. It\'s our way of making your daily payments smarter and more rewarding.',
        time: '1 week ago',
        isRead: false,
      ),
    ];
  }
}
