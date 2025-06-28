import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/models/bank_info_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/providers/balance_provider.dart';
import 'package:tournament_app/providers/bank_info_provider.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPaymentMethod = 0; // 0: bKash, 1: Rocket, 2: Nagad

  // Colors for different payment methods
  final Color bkashColor = Color(0xFFE2136E);
  final Color rocketColor = Color(0xFF8C3AAE);
  final Color nagadColor = Color(0xFFFF6A00);
  final Color darkNavy = Color(0xFF161829);
  final Color primaryPurple = Color(0xFF5F31E2);

  // Controllers
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch balance and bank info
      Provider.of<BalanceProvider>(context, listen: false).fetchBalance();
      Provider.of<BankInfoProvider>(context, listen: false).fetchBankInfo();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  String _getAccountNumber() {
    final bankInfoProvider = Provider.of<BankInfoProvider>(
      context,
      listen: false,
    );
    String bankName =
        _selectedPaymentMethod == 0
            ? 'Bkash'
            : _selectedPaymentMethod == 1
            ? 'Rocket'
            : 'Nagad';

    return bankInfoProvider.getAccountNumber(bankName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkNavy,
      appBar: AppBar(
        backgroundColor: darkNavy,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Deposit',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryPurple,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [Tab(text: 'Manual Payment'), Tab(text: 'Auto Payment')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildManualPaymentTab(), _buildAutoPaymentTab()],
      ),
    );
  }

  Widget _buildManualPaymentTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentMethodSelector(),
            const SizedBox(height: 24),
            _buildPaymentInstructions(),
            const SizedBox(height: 24),
            _buildVerifyButton(),
          ],
        ),
      ),
    );
  }

  // auto payment  is coming soon
  Widget _buildAutoPaymentTab() {
    // Placeholder for auto payment tab
    return Center(
      child: Text(
        'Something went wrong. Please try again later.',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildPaymentMethodCard(
            index: 0,
            name: 'bKash',
            logo: 'assets/images/bkash_logo.png',
            color: bkashColor,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPaymentMethodCard(
            index: 1,
            name: 'Rocket',
            logo: 'assets/images/rocket_logo.png',
            color: rocketColor,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPaymentMethodCard(
            index: 2,
            name: 'Nagad',
            logo: 'assets/images/nagad_logo.png',
            color: nagadColor,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required int index,
    required String name,
    required String logo,
    required Color color,
    required Color backgroundColor,
  }) {
    final bool isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _getSelectedColor() : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              name == 'bKash'
                  ? Icons.account_balance_wallet
                  : name == 'Rocket'
                  ? Icons.payments
                  : Icons.payment,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 6),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getSelectedColor(),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInstructions() {
    final Color containerColor = _getSelectedColor();
    final String dialCode =
        _selectedPaymentMethod == 0
            ? '*247#'
            : _selectedPaymentMethod == 1
            ? '*322#'
            : '*167#';
    final String paymentMethod =
        _selectedPaymentMethod == 0
            ? 'BKASH'
            : _selectedPaymentMethod == 1
            ? 'Rocket'
            : 'NAGAD';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'পেমেন্ট ইনফরমেশন',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          _buildAccountNumberField(),
          SizedBox(height: 16),
          _buildAmountField(),
          SizedBox(height: 16),
          _buildInstructionStep(
            '• $dialCode ডায়াল করে আপনার $paymentMethod মোবাইল মেনুতে যান অথবা $paymentMethod অ্যাপে যান ।',
            Colors.white,
          ),
          _buildInstructionStep('• Send Money - এ ক্লিক করুন ।', Colors.yellow),
          _buildInstructionStep(
            '• প্রাপক নম্বর হিসাবে নিচের এই নম্বরটি লিখুন',
            Colors.white,
          ),
          Consumer<BankInfoProvider>(
            builder: (context, bankInfoProvider, child) {
              if (bankInfoProvider.isLoading) {
                return Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                );
              }

              if (bankInfoProvider.hasError) {
                return Text(
                  'Error loading payment information',
                  style: TextStyle(color: Colors.red[300]),
                );
              }

              String bankName =
                  _selectedPaymentMethod == 0
                      ? 'Bkash'
                      : _selectedPaymentMethod == 1
                      ? 'Rocket'
                      : 'Nagad';

              String accountNumber = bankInfoProvider.getAccountNumber(
                bankName,
              );

              return accountNumber.isNotEmpty
                  ? Row(
                    children: [
                      Text(
                        accountNumber,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _copyToClipboard(accountNumber),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.copy, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Copy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                  : Text(
                    'Account number not available',
                    style: TextStyle(fontSize: 16, color: Colors.red[300]),
                  );
            },
          ),
          _buildInstructionStep(
            '• নিশ্চিত করতে এখন আপনার $paymentMethod মোবাইল মেনু পিন লিখুন।',
            Colors.white,
          ),
          _buildInstructionStep(
            '• পেমেন্ট সম্পন্ন হলে উপরের বক্সে আপনার পেমেন্ট নাম্বার এবং এমাউন্ট দিয়ে VERIFY বাটনে ক্লিক করুন।',
            Colors.white,
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      showSnackBarMessage(
        context,
        'Copied to clipboard: $text',
        type: SnackBarType.success,
        duration: Duration(seconds: 2),
      );
    });
  }

  Widget _buildInstructionStep(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _accountNumberController,
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'আপনার পেমেন্ট নাম্বার',
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          filled: false,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.phone_android, color: primaryPurple),
        ),
        cursorColor: primaryPurple,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Amount',
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          filled: false,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Text(
              '৳',
              style: TextStyle(fontSize: 22, color: primaryPurple),
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ),
        cursorColor: primaryPurple,
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _processDeposit,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getSelectedColor(),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Text(
                  'VERIFY',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
      ),
    );
  }

  Color _getSelectedColor() {
    switch (_selectedPaymentMethod) {
      case 0:
        return bkashColor;
      case 1:
        return rocketColor;
      case 2:
        return nagadColor;
      default:
        return primaryPurple;
    }
  }

  void _processDeposit() async {
    final String accountNumber = _accountNumberController.text.trim();
    final String amountText = _amountController.text.trim();
    final int amount = int.tryParse(amountText) ?? 0;

    // Validate inputs
    if (accountNumber.isEmpty) {
      showSnackBarMessage(
        context,
        'পেমেন্ট নাম্বার দিন',
        type: SnackBarType.error,
      );
      return;
    }

    if (accountNumber.length != 11) {
      showSnackBarMessage(
        context,
        'সঠিক পেমেন্ট নাম্বার দিন',
        type: SnackBarType.error,
      );
      return;
    }

    if (amountText.isEmpty) {
      showSnackBarMessage(
        context,
        'Please enter an amount',
        type: SnackBarType.error,
      );
      return;
    }

    if (amount <= 0) {
      showSnackBarMessage(
        context,
        'Please enter a valid amount',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Determine payment method
    String paymentMethod =
        _selectedPaymentMethod == 0
            ? 'bkash'
            : _selectedPaymentMethod == 1
            ? 'rocket'
            : 'nagad';

    // Make the actual API call with updated URL and body structure
    final response = await NetworkCaller.postRequest(
      URLs.manualDepositUrl,
      body: {
        "payment_method": paymentMethod,
        "account_number": accountNumber,
        "amount": amount,
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.isSuccess) {
      showSnackBarMessage(
        context,
        'Deposit request submitted successfully. Pending verification.',
        type: SnackBarType.success,
      );

      _amountController.clear();
      _accountNumberController.clear();

      // Refresh balance
      Provider.of<BalanceProvider>(context, listen: false).fetchBalance();
    } else {
      showSnackBarMessage(
        context,
        response.errorMessage ?? 'Failed to submit deposit request',
        type: SnackBarType.error,
      );
    }
  }
}
