import 'package:flutter/material.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/screens/main_bottom_nav.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReservationScreen extends StatefulWidget {
  final Matches match;
  final String player1Id;
  final String? player2Id;
  final String? player3Id;
  final String? player4Id;

  const ReservationScreen({
    Key? key,
    required this.match,
    required this.player1Id,
    this.player2Id,
    this.player3Id,
    this.player4Id,
  }) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildReservationDetails(),
                const SizedBox(height: 24),
                _buildPlayerInfo(),
                const SizedBox(height: 24),
                _buildRoomDetails(),
                const SizedBox(height: 24),
                _buildDisclaimer(),
                const SizedBox(height: 32),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade400,
                size: 64,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            textAlign: TextAlign.center,
            "Reservation Successful!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your spot has been secured",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Match Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple[700],
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: FontAwesomeIcons.gamepad,
                title: widget.match.matchTitle ?? 'No Title',
                isTitle: true,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: FontAwesomeIcons.calendarAlt,
                title:
                    "${widget.match.matchStartDate} at ${widget.match.matchStartTime}",
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: FontAwesomeIcons.trophy,
                title: "Win Prize",
                value: "${widget.match.totalPrize}TK",
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: FontAwesomeIcons.coins,
                title: "Entry Fee",
                value: "${widget.match.entryFee}TK",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    String? value,
    bool isTitle = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple.shade100.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.purple[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              isTitle
                  ? Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      if (value != null)
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                    ],
                  ),
        ),
      ],
    );
  }

  Widget _buildPlayerInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Player Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.purple[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildPlayerRow("Player 1", widget.player1Id),
            if (widget.player2Id != null) ...[
              const SizedBox(height: 12),
              _buildPlayerRow("Player 2", widget.player2Id!),
            ],
            if (widget.player3Id != null) ...[
              const SizedBox(height: 12),
              _buildPlayerRow("Player 3", widget.player3Id!),
            ],
            if (widget.player4Id != null) ...[
              const SizedBox(height: 12),
              _buildPlayerRow("Player 4", widget.player4Id!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRow(String label, String id) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          radius: 20,
          child: Icon(Icons.person, color: Colors.purple[700]),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              id,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.doorOpen,
                  size: 20,
                  color: Colors.purple[700],
                ),
                const SizedBox(width: 8),
                Text(
                  "Room Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.match.roomDetails ??
                  "Room details will be shared before the match starts",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Please follow all rules and regulations. Violation may result in permanent ban.",
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              showSnackBarMessage(
                context,
                "Joining group...",
                type: SnackBarType.info,
              );
            },
            icon: Icon(FontAwesomeIcons.userGroup),
            label: Text("Join Group"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavScreen()),
                ),
            icon: Icon(Icons.check_circle_outline),
            label: Text("Done"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
