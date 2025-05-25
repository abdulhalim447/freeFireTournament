import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  int _selectedPaymentMethod = 0; // 0: bKash, 1: Nagad, 2: Rocket

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
      backgroundColor: Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Withdraw',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvailableAmountCard(isSmallScreen),
              const SizedBox(height: 20),
              _buildPaymentMethodsRow(isSmallScreen),
              const SizedBox(height: 24),
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
    );
  }

  Widget _buildAvailableAmountCard(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Available Amount',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/taka_icon.png',
                width: 24,
                height: 24,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Icon(Icons.money, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 4),
              Text(
                'BDT 0',
                style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsRow(bool isSmallScreen) {
    return Row(
      children: [
        Expanded(
          child: _buildPaymentMethodCard(
            index: 0,
            name: 'bKash',
            logoPath: 'assets/images/bkash_logo.png',
            isSmallScreen: isSmallScreen,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPaymentMethodCard(
            index: 1,
            name: 'Nagad',
            logoPath: 'assets/images/nagad_logo.png',
            isSmallScreen: isSmallScreen,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPaymentMethodCard(
            index: 2,
            name: 'Rocket',
            logoPath: 'assets/images/rocket_logo.png',
            isSmallScreen: isSmallScreen,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required int index,
    required String name,
    required String logoPath,
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
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 14),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    logoPath,
                    height: 30,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(
                          Icons.account_balance_wallet,
                          color:
                              index == 0
                                  ? Colors.pink
                                  : index == 1
                                  ? Colors.orange
                                  : Colors.purple,
                          size: 30,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileInputField(bool isSmallScreen) {
    return TextFormField(
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      style: TextStyle(
        fontSize: isSmallScreen ? 16 : 18,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: 'Mobile Number',
        hintStyle: TextStyle(
          fontSize: isSmallScreen ? 16 : 18,
          color: Colors.grey.shade500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple),
        ),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(11),
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _buildAmountInputField(bool isSmallScreen) {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: isSmallScreen ? 16 : 18,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: 'Amount to Withdraw',
        hintStyle: TextStyle(
          fontSize: isSmallScreen ? 16 : 18,
          color: Colors.grey.shade500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Text(
            '৳',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              color: Colors.black87,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _buildMinimumWithdrawalText(bool isSmallScreen) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '* Minimum Withdrawal amount is ৳100',
        style: TextStyle(
          fontSize: isSmallScreen ? 12 : 14,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildWithdrawButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle withdrawal process
          _processWithdrawal();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          'Withdraw',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _processWithdrawal() {
    // Get the values
    final String mobileNumber = _mobileController.text.trim();
    final String amountText = _amountController.text.trim();

    // Validate inputs
    if (mobileNumber.isEmpty) {
      _showErrorSnackBar('Please enter a mobile number');
      return;
    }

    if (mobileNumber.length != 11) {
      _showErrorSnackBar('Mobile number must be 11 digits');
      return;
    }

    if (amountText.isEmpty) {
      _showErrorSnackBar('Please enter an amount to withdraw');
      return;
    }

    final int amount = int.tryParse(amountText) ?? 0;
    if (amount < 100) {
      _showErrorSnackBar('Minimum withdrawal amount is ৳100');
      return;
    }

    // Show success message (in a real app, you would call an API)
    _showSuccessSnackBar('Withdrawal request submitted successfully');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
