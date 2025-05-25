import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    final double horizontalPadding = 0;
    final double verticalPadding = 0;

    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(context, isSmallScreen),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _buildHelpSection(context, isSmallScreen),
            ),
            SizedBox(height: 60), // For bottom navigation bar space
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL CASH BALANCE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'BDT 0',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to transaction history
                      },
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                'View Transaction',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'History',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildWalletBalance(
                  icon: Icons.emoji_events,
                  iconColor: Colors.amber,
                  title: 'WINNING CASH BALANCE',
                  amount: 'BDT 0',
                  infoAction: () {},
                  actionButton: _buildActionButton(
                    context,
                    'WITHDRAW',
                    Icons.monetization_on_outlined,
                    Colors.green,
                    () {},
                  ),
                  isSmallScreen: isSmallScreen,
                ),
                const SizedBox(height: 20),
                _buildWalletBalance(
                  icon: FontAwesomeIcons.landmark,
                  iconColor: Colors.green.shade700,
                  title: 'DEPOSIT CASH',
                  amount: 'BDT 0',
                  infoAction: () {},
                  actionButton: _buildActionButton(
                    context,
                    'ADD MORE',
                    Icons.add,
                    Colors.blue,
                    () {},
                  ),
                  isSmallScreen: isSmallScreen,
                ),
                const SizedBox(height: 20),
                _buildWalletBalance(
                  icon: Icons.card_giftcard,
                  iconColor: Colors.purple,
                  title: 'REFER AND EARN',
                  amount: 'BDT 0',
                  infoAction: () {},
                  actionButton: _buildActionButton(
                    context,
                    'REFER & EARN',
                    Icons.share,
                    Colors.purple,
                    () {},
                  ),
                  isSmallScreen: isSmallScreen,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletBalance({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String amount,
    required VoidCallback infoAction,
    required Widget actionButton,
    required bool isSmallScreen,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: infoAction,
                child: Icon(
                  Icons.info_outline,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        actionButton,
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size(40, 36),
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHelpItem(
          context: context,
          englishTitle: 'HOW TO ADD MONEY?',
          bengaliTitle: 'কিভাবে টাকা অ্যাড করবেন',
          isSmallScreen: isSmallScreen,
        ),
        const SizedBox(height: 16),
        _buildHelpItem(
          context: context,
          englishTitle: 'HOW TO COLLECT ROOM ID?',
          bengaliTitle: 'কিভাবে রুম আইডি পাবেন',
          isSmallScreen: isSmallScreen,
        ),
        const SizedBox(height: 16),
        _buildHelpItem(
          context: context,
          englishTitle: 'HOW TO JOIN IN A MATCH?',
          bengaliTitle: 'কিভাবে ম্যাচে জয়েন করবেন',
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildHelpItem({
    required BuildContext context,
    required String englishTitle,
    required String bengaliTitle,
    required bool isSmallScreen,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 1.5),
                ),
                child: const Center(
                  child: Icon(Icons.play_arrow, color: Colors.red, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      englishTitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      bengaliTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow, color: Colors.red, size: 16),
                const SizedBox(width: 2),
                Text(
                  'ভিডিওটি\nদেখুন',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
