import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/utils/app_messenger.dart';
import 'package:valarpay/core/utils/check_balance.dart';
import 'package:valarpay/core/utils/currency_formatter.dart';
import 'package:valarpay/core/widgets/all_time_reusable_button.dart';
import 'package:valarpay/core/widgets/biometric_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/current_rate_widget.dart';
import 'package:valarpay/core/widgets/receipt_share_screen.dart';
import 'package:valarpay/core/widgets/reusable_transaction_pin_modal.dart';
import 'package:valarpay/core/widgets/shareable_transaction_receipt.dart';
import 'package:valarpay/core/widgets/transaction_details_screen.dart';
import 'package:valarpay/core/widgets/transaction_receipt_widget.dart';
import 'package:valarpay/features/dashboard/view/services/giftcard/upload_images_screen.dart';
import 'package:valarpay/features/models/giftcard.dart';
import 'package:valarpay/features/notifiers/giftcard_notifier.dart';
import '/core/themes/color_utils.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_brand_modal.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_country_modal.dart';
import '/features/dashboard/widgets/services_widgets/giftcard_widgets/gift_card_amount_modal.dart';
import '/features/dashboard/view/services/giftcard/saved_beneficiary_screen.dart';
import 'package:valarpay/core/widgets/kyc_not_set_widget.dart';
import 'package:valarpay/features/providers/user_provider.dart';

class GiftCardScreen extends ConsumerStatefulWidget {
  const GiftCardScreen({super.key});

  @override
  ConsumerState<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends ConsumerState<GiftCardScreen> {
  bool isBuySelected = true;
  GiftCardProduct? selectedProduct;
  String selectedBrand = 'Select Brand';
  String selectedCountry = 'Select Country';
  String selectedAmount = 'Select Amount';
  double? selectedAmountValue;
  int quantity = 1;
  String codeOptional = '';
  String currentRate = '0';
  List<GiftCardProduct> availableProducts = [];
  List<GiftCardCategory> categories = [];
  bool isLoadingRate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    ref.read(giftCardCategoriesNotifierProvider.notifier).getCategories();
    ref.read(giftCardNotifierProvider.notifier).getProducts(currency: 'NGN');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isBvnVerified = user?.isBvnVerified ?? false;

    // Debug logging
    print('🎁 [GiftCard] User: ${user?.fullname}');
    print('🎁 [GiftCard] BVN Verified: $isBvnVerified');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final giftCardState = ref.watch(giftCardNotifierProvider);
    final categoriesState = ref.watch(giftCardCategoriesNotifierProvider);

    // Update available products when state changes
    if (giftCardState.isDataAvailable && giftCardState.data != null) {
      availableProducts = giftCardState.data!;
    }

    // Update categories when state changes
    if (categoriesState.isDataAvailable && categoriesState.data != null) {
      categories = categoriesState.data!;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Giftcards',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: isBvnVerified
            ? [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedBeneficiaryScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Saved Beneficiary',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: !isBvnVerified
          ? const KycNotSetWidget(
              title: 'KYC Not Completed',
              subtitle:
                  'Complete your KYC verification to buy or sell giftcards',
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Buy/Sell Toggle
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color:
                            isDark ? const Color(0xFF2B2725) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isBuySelected = true),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isBuySelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  'Buy Giftcard',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isBuySelected
                                        ? Colors.black
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => isBuySelected = false),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !isBuySelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  'Sell Giftcard',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !isBuySelected
                                        ? Colors.black
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Select Giftcard Brand
                    _buildSectionTitle('Select Giftcard Brand'),
                    const SizedBox(height: 8),
                    _buildDropdownField(
                      value: giftCardState.isInitialLoading
                          ? 'Loading...'
                          : selectedBrand,
                      imagePath: selectedProduct?.logoUrls.isNotEmpty == true
                          ? selectedProduct!.logoUrls.first
                          : 'assets/images/blank.png',
                      onTap: giftCardState.isInitialLoading
                          ? null
                          : () => _showGiftCardBrandModal(),
                      isLoading: giftCardState.isInitialLoading,
                    ),

                    const SizedBox(height: 20),

                    // Select Country
                    _buildSectionTitle('Select Country'),
                    const SizedBox(height: 8),
                    _buildDropdownField(
                      value: selectedCountry,
                      imagePath: selectedProduct?.country.flagUrl ??
                          'assets/images/blank.png',
                      onTap: selectedProduct != null
                          ? () => _showCountryModal()
                          : null,
                      isLoading: false,
                    ),

                    const SizedBox(height: 20),

                    // Amount
                    _buildSectionTitle('Amount'),
                    const SizedBox(height: 8),
                    _buildDropdownField(
                      value: isLoadingRate ? 'Loading rate...' : selectedAmount,
                      imagePath: 'assets/images/moneysymbol.png',
                      onTap: selectedProduct != null && !isLoadingRate
                          ? () => _showAmountModal()
                          : null,
                      isLoading: isLoadingRate,
                    ),

                    const SizedBox(height: 20),

                    // Enter Code (Optional)
                    _buildSectionTitle('Enter Code (Optional)'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => codeOptional = value),
                        decoration: InputDecoration(
                          hintText: '1234',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Price in Naira
                    CurrentRateWidget(
                        price: currentRate, text: 'Price in Naira'),

                    const SizedBox(height: 45),

                    // Continue Button
                    FullWidthButton(
                      text: 'Continue',
                      onPressed: _canProceed() ? _handleContinue : () {},
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String imagePath,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (imagePath.startsWith('http'))
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.network(
                  imagePath,
                  height: 14,
                  width: 14,
                  errorBuilder: (context, error, stackTrace) => ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child:
                          Image.asset('assets/images/POUNDS.png', height: 14)),
                ),
              )
            else
              ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.asset(imagePath, height: 14)),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: onTap == null ? Colors.grey : null,
                ),
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down,
                color: onTap == null ? Colors.grey[400] : Colors.grey[600],
              ),
          ],
        ),
      ),
    );
  }

  void _showGiftCardBrandModal() {
    if (availableProducts.isEmpty) {
      AppMessenger.show(context,
          message: 'No gift card products available at the moment.',
          type: MessageType.info);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GiftCardBrandModal(
        selectedBrand: selectedBrand,
        products: availableProducts,
        onBrandSelected: (product) {
          setState(() {
            selectedProduct = product;
            selectedBrand = product.brand.brandName;
            selectedCountry = product.country.name;
            selectedAmount = 'Select Amount';
            selectedAmountValue = null;
            currentRate = '0';
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCountryModal() {
    if (selectedProduct == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GiftCardCountryModal(
        selectedCountry: selectedCountry,
        product: selectedProduct!,
        onCountrySelected: (country) {
          setState(() {
            selectedCountry = country;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAmountModal() {
    if (selectedProduct == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GiftCardAmountModal(
        selectedAmount: selectedAmount,
        product: selectedProduct!,
        onAmountSelected: (amount, value) {
          selectedAmount = amount;
          selectedAmountValue = value;
          _updateRate(value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _updateRate(double amount) async {
    if (selectedProduct == null) return;

    setState(() {
      isLoadingRate = true;
    });

    try {
      final fxRate =
          await ref.read(giftCardNotifierProvider.notifier).getFxRate(
                currency: selectedProduct!.recipientCurrencyCode,
                amount: amount,
              );

      if (fxRate != null && mounted) {
        setState(() {
          currentRate = fxRate.data.senderAmount.toStringAsFixed(2);
          isLoadingRate = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          currentRate = '0';
          isLoadingRate = false;
        });
      }
    }
  }

  bool _canProceed() {
    if (isBuySelected) {
      return selectedProduct != null &&
          selectedAmountValue != null &&
          currentRate != '0' &&
          !isLoadingRate;
    } else {
      return selectedProduct != null &&
          selectedAmountValue != null &&
          currentRate != '0' &&
          !isLoadingRate;
    }
  }

  void _handleContinue() {
    if (isBuySelected) {
      _handleBuyGiftCard();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UploadImagesScreen()),
      );
    }
  }

  void _handleBuyGiftCard() {
    if (selectedProduct == null || selectedAmountValue == null) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rate = currentRate.replaceAll(',', '');
    final rateValue = double.tryParse(rate) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReuseableTransactionDetailsScreen(
          hasBottom: false,
          topTitleText: 'Transaction',
          topTransactionsDetailsList: [
            buildDetailRow('Card Type', selectedBrand, isDark),
            buildDetailRow('Country', selectedCountry, isDark),
            buildDetailRow('Card Amount', selectedAmount, isDark),
            buildDetailRow(
              'Rate',
              '${currencyFormatter((rateValue / selectedAmountValue!).toStringAsFixed(2))}/${selectedProduct!.recipientCurrencyCode}',
              isDark,
            ),
            buildDetailRow('Expected Amount in Naira',
                currencyFormatter(currentRate), isDark),
          ],
          onButtonPressed: () => _processPayment(rateValue),
        ),
      ),
    );
  }

  Future<void> _processPayment(double amount) async {
    final user = ref.read(userProvider);
    final hasEnoughBalance = checkBalanceLeft(context,
        user?.wallets.first.balance.toString() ?? '0', amount.toString());
    if (!hasEnoughBalance) return;
    final pin = await BiometricTransactionPinModal.show(context);
    if (pin == null || pin.length != 4 || !mounted) return;

    if (mounted) Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final paymentRequest = GiftCardPaymentRequest(
      productId: selectedProduct!.productId,
      currency: 'NGN',
      walletPin: pin,
      amount: amount,
      unitPrice: selectedAmountValue!,
      quantity: quantity,
    );

    try {
      await ref
          .read(giftCardNotifierProvider.notifier)
          .payForGiftCard(paymentRequest);

      Navigator.pop(context);

      final state = ref.read(giftCardNotifierProvider);
       final isSuccessMessage = state.message != null &&
                state.message!.toLowerCase().contains('success');

      if ((state.isDataAvailable &&
                    state.data != null &&
                    state.data!.isNotEmpty && mounted) ||
                isSuccessMessage && mounted) {
        final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionReceiptWidget(
              amount: currentRate,
              topDetails: [
                TransactionDetail(label: 'Card Type', value: selectedBrand),
                TransactionDetail(
                  label: 'Country',
                  value: selectedCountry,
                ),
                TransactionDetail(label: 'Card Amount', value: selectedAmount),
                TransactionDetail(
                  label: 'Rate',
                  value:
                      '${currencyFormatter((amount / selectedAmountValue!).toStringAsFixed(2))}/${selectedProduct!.recipientCurrencyCode}',
                ),
                TransactionDetail(label: 'Amount Paid', value: currencyFormatter(currentRate)),
              ],
              bottomDetails: [
                TransactionDetail(
                  label: 'Transaction ID',
                  value: transactionId,
                  showCopyIcon: true,
                ),
                TransactionDetail(
                  label: 'Payment Source',
                  value: 'ValarPay Account',
                ),
                TransactionDetail(
                  label: 'Date & Time',
                  value:
                      '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                ),
              ],
              onShareReceipt:  _onShareBuyTransactionReceiptPressed,
            ),
          ),
        );
      } else {
        AppMessenger.show(context,
            message: state.message ?? 'Purchase failed. Please try again.',
            type: MessageType.error);
      }
    } catch (e) {
      if (mounted) {
        AppMessenger.show(context,
            message: 'Purchase failed: ${e.toString()}',
            type: MessageType.error);
      }
    }
  }

_onShareBuyTransactionReceiptPressed() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ReceiptShareScreen(
                    date:
                        '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year} | ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
                    transactionDetailList: [
                      ShareableTransactionReceiptDetail(
                          label: 'Amount',
                          value:  currencyFormatter(currentRate)),
                      ShareableTransactionReceiptDetail(
                          label: 'Currency', value: 'NGN'),
                      ShareableTransactionReceiptDetail(
                          label: 'Transaction Type',
                          value: 'Buy Giftcard'),
                      ShareableTransactionReceiptDetail(
                          label: 'Card Type',
                          value: selectedProduct != null
                              ? selectedProduct!.productName
                              : ''),
                       ShareableTransactionReceiptDetail(
                          label: 'Country',
                          value: selectedCountry),
                        ShareableTransactionReceiptDetail(
                          label: 'Card',
                          value: 'Card number'),
                      
                      ShareableTransactionReceiptDetail(
                          label: 'Transaction ID',
                          value: 'TXN${DateTime.now().millisecondsSinceEpoch}'),
                      ShareableTransactionReceiptDetail(
                          label: 'Status',
                          value: 'Successful',
                          isSuccessful: true)
                    ],
                  )));
    }

}

String getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}
