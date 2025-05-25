import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferScreen extends StatelessWidget {
  const ReferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refer & Earn',
          style: TextStyle(
            fontSize: 20 * textScaleFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            children: [
              // Referral Icon and Header
              Container(
                width: size.width * 0.25,
                height: size.width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.people_alt_rounded,
                  size: size.width * 0.15,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'REFER MORE TO EARN MORE!',
                style: TextStyle(
                  fontSize: 24 * textScaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'Share your referral code with friends and earn rewards when they join!',
                style: TextStyle(
                  fontSize: 16 * textScaleFactor,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.04),

              // Referral Code Section
              Container(
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'YOUR REFER CODE',
                      style: TextStyle(
                        fontSize: 18 * textScaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.08,
                        vertical: size.height * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'baccu',
                            style: TextStyle(
                              fontSize: 24 * textScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          IconButton(
                            icon: Icon(Icons.copy, color: Colors.white),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: 'baccu'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Referral code copied!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // How it works section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'How it works',
                      style: TextStyle(
                        fontSize: 20 * textScaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buildStepItem(
                      context,
                      icon: Icons.person_add,
                      title: 'Invite Friends',
                      description: 'Share your referral code with friends',
                      size: size,
                      textScaleFactor: textScaleFactor,
                    ),
                    _buildStepItem(
                      context,
                      icon: Icons.login,
                      title: 'Friends Register',
                      description: 'They register using your referral code',
                      size: size,
                      textScaleFactor: textScaleFactor,
                    ),
                    _buildStepItem(
                      context,
                      icon: Icons.currency_exchange,
                      title: 'Earn Rewards',
                      description:
                          'Get rewarded when they make their first deposit',
                      size: size,
                      textScaleFactor: textScaleFactor,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),

              // Share button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'REFER NOW',
                    style: TextStyle(
                      fontSize: 18 * textScaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Size size,
    required double textScaleFactor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: size.width * 0.06, color: Colors.blue),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16 * textScaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14 * textScaleFactor,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          SizedBox(height: size.height * 0.02),
          Divider(),
          SizedBox(height: size.height * 0.02),
        ],
      ],
    );
  }
}
