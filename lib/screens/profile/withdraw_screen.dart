import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/models/user_balance_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/providers/balance_provider.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/utils/app_colors.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  // Use a dark navy color to match the screenshot
  final Color darkNavy = Color(0xFF161829);
  final Color primaryPurple = Color(0xFF5F31E2);

  int _selectedPaymentMethod = 0; // 0: bKash, 1: Nagad, 2: Rocket
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch balance when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BalanceProvider>(context, listen: false).fetchBalance();
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: darkNavy,
      appBar: AppBar(
        backgroundColor: darkNavy,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Withdraw',
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
      ),
      body: RefreshIndicator(
        color: primaryPurple,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await Provider.of<BalanceProvider>(
            context,
            listen: false,
          ).fetchBalance();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvailableAmountCard(isSmallScreen),
                const SizedBox(height: 20),
                _buildPaymentMethodsRow(isSmallScreen),
                const SizedBox(height: 20),
                _buildMobileInputField(isSmallScreen),
                const SizedBox(height: 16),
                _buildAmountInputField(isSmallScreen),
                const SizedBox(height: 8),
                _buildMinimumWithdrawalText(isSmallScreen),
                const SizedBox(height: 24),
                _buildWithdrawButton(isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableAmountCard(bool isSmallScreen) {
    return Consumer<BalanceProvider>(
      builder: (context, balanceProvider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                'Available Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    color: Color(0xFF5F31E2),
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  balanceProvider.isLoading
                      ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF5F31E2),
                        ),
                      )
                      : Text(
                        'BDT ${balanceProvider.balance}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodsRow(bool isSmallScreen) {
    return Row(
      children: [
        Expanded(
          child: _buildPaymentMethodCard(
            index: 0,
            name: 'bKash',
            color: Colors.pink,
            isSmallScreen: isSmallScreen,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPaymentMethodCard(
            index: 1,
            name: 'Nagad',
            color: Colors.orange,
            isSmallScreen: isSmallScreen,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPaymentMethodCard(
            index: 2,
            name: 'Rocket',
            color: Colors.purple,
            isSmallScreen: isSmallScreen,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required int index,
    required String name,
    required Color color,
    required bool isSmallScreen,
  }) {
    final bool isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSelected
                ? Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Color(0xFF5F31E2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 15),
                )
                : SizedBox(height: 19), // To maintain consistent heights
            const SizedBox(height: 8),
            Icon(
              name == 'bKash'
                  ? Icons.account_balance_wallet
                  : name == 'Nagad'
                  ? Icons.account_balance_wallet
                  : Icons.account_balance_wallet,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileInputField(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: _mobileController,
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Mobile Number',
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.phone_android, color: Color(0xFF5F31E2)),
        ),
        cursorColor: Color(0xFF5F31E2),
        inputFormatters: [
          LengthLimitingTextInputFormatter(11),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget _buildAmountInputField(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Amount to Withdraw',
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Text(
              '৳',
              style: TextStyle(fontSize: 22, color: Color(0xFF5F31E2)),
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ),
        cursorColor: Color(0xFF5F31E2),
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget _buildMinimumWithdrawalText(bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        '* Minimum Withdrawal amount is ৳100',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildWithdrawButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _processWithdrawal,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF5F31E2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
          disabledBackgroundColor: Color(0xFF5F31E2).withOpacity(0.6),
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
                  'Withdraw',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
      ),
    );
  }

  void _processWithdrawal() async {
    final String mobileNumber = _mobileController.text.trim();
    final String amountText = _amountController.text.trim();
    final int amount = int.tryParse(amountText) ?? 0;

    // Get balance from provider
    final balanceProvider = Provider.of<BalanceProvider>(
      context,
      listen: false,
    );
    final double userBalance = double.tryParse(balanceProvider.balance) ?? 0;

    if (mobileNumber.isEmpty) {
      showSnackBarMessage(
        context,
        'Please enter a mobile number',
        type: SnackBarType.error,
      );
      return;
    }
    if (mobileNumber.length != 11) {
      showSnackBarMessage(
        context,
        'Mobile number must be 11 digits',
        type: SnackBarType.error,
      );
      return;
    }
    if (amountText.isEmpty) {
      showSnackBarMessage(
        context,
        'Please enter an amount to withdraw',
        type: SnackBarType.error,
      );
      return;
    }
    if (amount < 100) {
      showSnackBarMessage(
        context,
        'Minimum withdrawal amount is ৳100',
        type: SnackBarType.error,
      );
      return;
    }
    if (amount > userBalance) {
      showSnackBarMessage(
        context,
        'Insufficient balance.',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Updated API parameter names to match the screenshot
    String paymentMethod =
        _selectedPaymentMethod == 0
            ? 'bkash'
            : _selectedPaymentMethod == 1
            ? 'nagad'
            : 'roket';

    final response = await NetworkCaller.postRequest(
      URLs.withdrawUrl,
      body: {
        "amount": amount,
        "payment_method": paymentMethod,
        "recived_account": mobileNumber,
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.isSuccess) {
      showSnackBarMessage(
        context,
        'Withdrawal request created successfully',
        type: SnackBarType.success,
      );
      _amountController.clear();
      _mobileController.clear();
      // Refresh balance after withdrawal
      balanceProvider.fetchBalance();
    } else {
      showSnackBarMessage(
        context,
        response.errorMessage ?? 'Failed to create withdrawal request',
        type: SnackBarType.error,
      );
    }
  }
}
