import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/providers/balance_provider.dart';
import 'package:tournament_app/providers/help_videos_provider.dart';
import 'package:tournament_app/screens/profile/deposit_screen.dart';
import 'package:tournament_app/screens/profile/refer_screen.dart';
import 'package:tournament_app/screens/profile/withdraw_screen.dart';
import 'package:tournament_app/utils/url_launcher_utils.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch balance and help videos when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BalanceProvider>(context, listen: false).fetchBalance();
      Provider.of<HelpVideosProvider>(context, listen: false).fetchHelpVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<BalanceProvider>(
            context,
            listen: false,
          ).fetchBalance();
          await Provider.of<HelpVideosProvider>(
            context,
            listen: false,
          ).fetchHelpVideos();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(context),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Help Center',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildHelpSection(context),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B5CF6), // Violet-500
            Color(0xFF7C3AED), // Violet-600
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8B5CF6).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Balance Section
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BDT ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Consumer<BalanceProvider>(
                              builder: (context, balanceProvider, child) {
                                if (balanceProvider.isLoading) {
                                  return SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                return Text(
                                  balanceProvider.balance,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Balance Items
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.all(3),
            child: Column(
              children: [
                _buildWalletItem(
                  context,
                  icon: Icons.emoji_events,
                  title: 'Winning Balance',
                  amount: 'BDT 0',
                  actionLabel: 'Withdraw',
                  actionIcon: Icons.monetization_on_outlined,
                  showDivider: true,
                ),
                _buildWalletItem(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'Deposit Balance',
                  amount: 'BDT 0',
                  actionLabel: 'Add Money',
                  actionIcon: Icons.add,
                  showDivider: true,
                ),
                _buildWalletItem(
                  context,
                  icon: Icons.card_giftcard,
                  title: 'Referral Balance',
                  amount: 'BDT 0',
                  actionLabel: 'Share',
                  actionIcon: Icons.share,
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String amount,
    required String actionLabel,
    required IconData actionIcon,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Handle tap on the entire wallet item
            if (title == 'Winning Balance') {
              // Navigate to withdraw screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WithdrawScreen()),
              );
            } else if (title == 'Deposit Balance') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DepositScreen()),
              );
            } else if (title == 'Referral Balance') {
              // Navigate to referral screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReferScreen()),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Color(0xFF8B5CF6), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle action button tap
                    if (actionLabel == 'Withdraw') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WithdrawScreen(),
                        ),
                      );
                    } else if (actionLabel == 'Add Money') {
                      // Navigate to add money screen (You'll need to create this screen)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DepositScreen()),
                      );
                    } else if (actionLabel == 'Share') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReferScreen()),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF8B5CF6).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(actionIcon, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          actionLabel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1)),
      ],
    );
  }

  Widget _buildHelpSection(BuildContext context) {
    final helpVideosProvider = Provider.of<HelpVideosProvider>(context);

    if (helpVideosProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        _buildHelpItem(
          context: context,
          icon: Icons.add_circle_outline,
          englishTitle: 'HOW TO ADD MONEY?',
          bengaliTitle: 'কিভাবে টাকা অ্যাড করবেন',
          videoUrl: helpVideosProvider.addMoneyVideo,
        ),
        const SizedBox(height: 16),
        _buildHelpItem(
          context: context,
          icon: Icons.meeting_room_outlined,
          englishTitle: 'HOW TO COLLECT ROOM ID?',
          bengaliTitle: 'কিভাবে রুম আইডি পাবেন',
          videoUrl: helpVideosProvider.roomIdVideo,
        ),
        const SizedBox(height: 16),
        _buildHelpItem(
          context: context,
          icon: Icons.sports_esports_outlined,
          englishTitle: 'HOW TO JOIN IN A MATCH?',
          bengaliTitle: 'কিভাবে ম্যাচে জয়েন করবেন',
          videoUrl: helpVideosProvider.joinMatchVideo,
        ),
      ],
    );
  }

  Widget _buildHelpItem({
    required BuildContext context,
    required IconData icon,
    required String englishTitle,
    required String bengaliTitle,
    required String videoUrl,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.secondaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          debugPrint('Video URL being launched: $videoUrl');
          UrlLauncherUtils.launchVideoUrl(context, videoUrl);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: colorScheme.onSecondaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      englishTitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      bengaliTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_fill_rounded,
                color: colorScheme.secondary,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
