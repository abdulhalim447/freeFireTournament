import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tournament_app/screens/profile/edit_profile_screen.dart';
import 'package:tournament_app/screens/profile/refer_screen.dart';
import 'package:tournament_app/screens/profile/top_players_list_screen.dart';
import 'package:tournament_app/screens/profile/wallet_screen.dart';
import 'package:tournament_app/screens/profile/withdraw_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [_buildProfileHeader(), _buildMenuItems(context)]),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF54A9EB), Color(0xFF2E6DA4)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Profile image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                child: ClipOval(
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Username
            const Text(
              'baccu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Stats section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat('0', 'Match \nPlayed'),
                  _buildCentralStat('BDT 0'),
                  _buildStat('0', 'Won'),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
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
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: Color(0xFF58A0E4),
        title: 'Wallet',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WalletScreen()),
          );
        },
      ),
      _MenuItem(
        icon: FontAwesomeIcons.arrowUpFromBracket,
        iconColor: Color(0xFF58A0E4),
        title: 'Withdraw',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WithdrawScreen()),
          );
        },
      ),
      _MenuItem(
        icon: Icons.share_outlined,
        iconColor: Color(0xFF58A0E4),
        title: 'Refer and Earn',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReferScreen()),
          );
        },
      ),
      _MenuItem(
        icon: Icons.person_outline_rounded,
        iconColor: Color(0xFF58A0E4),
        title: 'My Profile',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          );
        },
      ),
      _MenuItem(
        icon: Icons.show_chart,
        iconColor: Color(0xFF58A0E4),
        title: 'Top Players',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TopPlayersListScreen(),
            ),
          );
        },
      ),
      _MenuItem(
        icon: Icons.code,
        iconColor: Color(0xFF58A0E4),
        title: 'Developer Profile',
        onTap: () {},
      ),
    ];

    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildMenuItem(context, menuItems[index]),
              if (index < menuItems.length - 1)
                Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return Container(
      color: Color(0xFFEEEEEE),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        leading: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(item.icon, color: item.iconColor, size: 30),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
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
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });
}
