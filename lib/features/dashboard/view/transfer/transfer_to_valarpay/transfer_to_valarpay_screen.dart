import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:valarpay/core/utils/color_utils.dart';
import 'package:valarpay/core/widgets/custom_toast.dart';

class TransferToValarPayScreen extends StatefulWidget {
  const TransferToValarPayScreen({super.key});

  @override
  State<TransferToValarPayScreen> createState() =>
      _TransferToValarPayScreenState();
}

class _TransferToValarPayScreenState extends State<TransferToValarPayScreen> {
  final TextEditingController _accountController = TextEditingController();
  bool isEmpty = true;

  Future<void> pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _accountController.text = clipboardData.text!;
      });
      CustomToast.showAppToast(
          context: context, message: 'ValarPay pasted from clipboard');
    } else {
      CustomToast.showAppToast(context: context, message: 'Clipboard is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Transfer to ValarPay Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, color: Colors.blue, size: 18.sp),
                    SizedBox(width: 6),
                    Text(
                      'Quick, Free, No-delays',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Recipient Account Number',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _accountController,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      isEmpty = true;
                    });
                  } else {
                    setState(() {
                      isEmpty = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter ValarPay account name/number',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  suffixIcon: isEmpty
                      ? IconButton(
                          onPressed: () {
                            pasteFromClipboard();
                          },
                          icon: Icon(
                            Icons.content_paste,
                            color: Colors.grey[500],
                          ))
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Selected Recipient
              Row(
                children: [
                  Icon(Icons.check_circle, color: appTheme.primaryColor),
                  SizedBox(width: 8.w),
                  Text(
                    'Emmy John Smith',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push("/transfer-amount");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),

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
          ),
        ),
      ),
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
