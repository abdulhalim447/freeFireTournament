import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/screens/profile/withdraw_screen.dart';
import 'package:tournament_app/services/user_preference.dart';

import 'package:tournament_app/models/user_balance_model.dart';
import 'package:tournament_app/providers/profile_provider.dart';
import 'package:tournament_app/screens/profile/edit_profile_screen.dart';
import 'package:tournament_app/screens/profile/refer_screen.dart';
import 'package:tournament_app/screens/profile/top_players_list_screen.dart';
import 'package:tournament_app/screens/profile/wallet_screen.dart';

import 'package:tournament_app/widgets/show_snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfileData();
    });
  }

  Future<void> _fetchProfileData() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final bool success = await profileProvider.getUserProfile();
    if (!success && mounted) {
      showSnackBarMessage(
        context,
        'Failed to load profile data. Please try again.',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _fetchProfileData,
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            final isLoading = profileProvider.isLoading;
            final userData = profileProvider.profileData?.user;

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _buildProfileHeader(context, userData),
                _buildMenuItems(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserData? userData) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7C4DFF), // Deep purple
            Color(0xFF5C1E9E), // Rich purple
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Profile Stack with edit button
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child:
                      userData?.avatar != null
                          ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(userData!.avatar!),
                          )
                          : const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Color(0xFF7C4DFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Username with verified badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userData?.username ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.verified,
                  color: Colors.white.withOpacity(0.9),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats section with glass effect
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(
                    userData?.totalPlayed.toString() ?? '0',
                    'Matches\nPlayed',
                  ),
                  _buildDivider(),
                  _buildCentralStat("BDT ${userData?.balance ?? '0'}"),
                  _buildDivider(),
                  _buildStat(
                    userData?.totalWon.toString() ?? '0',
                    'Matches\nWon',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCentralStat(String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Balance',
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
        ),
      ],
    );
  }

  //all the menu items========================================================

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: Color(0xFF7C4DFF),
        title: 'Wallet',
        subtitle: 'Manage your balance',
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WalletScreen()),
            ),
      ),
      _MenuItem(
        icon: FontAwesomeIcons.arrowUpFromBracket,
        iconColor: Color(0xFF7C4DFF),
        title: 'Withdraw',
        subtitle: 'Cash out your winnings',
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WithdrawScreen()),
            ),
      ),
      _MenuItem(
        icon: Icons.share_outlined,
        iconColor: Color(0xFF7C4DFF),
        title: 'Refer and Earn',
        subtitle: 'Invite friends & earn rewards',
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReferScreen()),
            ),
      ),
      _MenuItem(
        icon: Icons.person_outline_rounded,
        iconColor: Color(0xFF7C4DFF),
        title: 'My Profile',
        subtitle: 'Edit your information',
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            ),
      ),

      _MenuItem(
        icon: Icons.show_chart,
        iconColor: Color(0xFF7C4DFF),
        title: 'Top Players',
        subtitle: 'View leaderboard',
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TopPlayersListScreen(),
              ),
            ),
      ),
      _MenuItem(
        icon: Icons.code,
        iconColor: Color(0xFF7C4DFF),
        title: 'Developer Profile',
        subtitle: 'About the developer',
        onTap: () {},
      ),
      _MenuItem(
        icon: Icons.logout,
        iconColor: Colors.red,
        title: 'Logout',
        subtitle: 'Sign out from your account',
        onTap: () => _showLogoutDialog(context),
      ),
    ];

    return Column(
      children: menuItems.map((item) => _buildMenuItem(context, item)).toList(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text('Do you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await UserPreference.clearUser();
                if (mounted) {
                  // Navigate to login screen and clear all routes
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: item.iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon, color: item.iconColor, size: 24),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: item.onTap,
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
