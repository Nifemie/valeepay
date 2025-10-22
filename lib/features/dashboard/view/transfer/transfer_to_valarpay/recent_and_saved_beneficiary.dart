import 'package:flutter/material.dart';
import 'package:valarpay/core/themes/color_utils.dart';

class InternalRecentAndSavedBeneficiary extends StatefulWidget {
  const InternalRecentAndSavedBeneficiary({super.key});

  @override
  State<InternalRecentAndSavedBeneficiary> createState() => _InternalRecentAndSavedBeneficiaryState();
}

class _InternalRecentAndSavedBeneficiaryState extends State<InternalRecentAndSavedBeneficiary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         // Tabs
              DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: appTheme.primaryColor,
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: appTheme.primaryColor,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        tabs: const [
                          Tab(text: 'Recent'),
                          Tab(text: 'Saved Beneficiary'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildRecipientList(context),
                            _buildRecipientList(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
      ],
    );
  }

  Widget _buildRecipientList(BuildContext context) {
    final recipients = [
      {'name': 'John Smith', 'type': 'ValarPay'},
      {'name': 'John Smith', 'type': 'ValarPay'},
      {'name': 'John Smith', 'type': 'ValarPay'},
    ];

    return ListView.builder(
      itemCount: recipients.length,
      padding: EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        final user = recipients[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.greenAccent,
            child: const Icon(Icons.person, color: Colors.black87),
          ),
          title: Text(
            user['name']!,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            user['type']!,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          trailing: Icon(
            index == 1 ? Icons.bookmark : Icons.add,
            color: index == 1 ? Colors.orangeAccent : Colors.grey[500],
          ),
        );
      },
    );
  }
}