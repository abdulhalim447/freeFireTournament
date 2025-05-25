import 'package:flutter/material.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';

class ReservationScreen extends StatelessWidget {
  final Matches match;
  final String player1Id;
  final String? player2Id;

  const ReservationScreen({
    Key? key,
    required this.match,
    required this.player1Id,
    this.player2Id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildReservationDetails(),
              const SizedBox(height: 20),
              _buildPlayerInfo(),
              const SizedBox(height: 20),
              _buildDisclaimer(),
              const Spacer(),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 40),
          const SizedBox(height: 10),
          const Text(
            "Thank You for Reservation",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationDetails() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.matchTitle ?? 'No Title',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${match.matchStartDate} at ${match.matchStartTime}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text("Total Win Prize: ${match.totalPrize}TK"),
            Text("Paid: 0TK"),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Player 1: $player1Id", style: const TextStyle(fontSize: 16)),
        if (player2Id != null)
          Text("Player 2: $player2Id", style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Text(
      "Disclaimer: You have to follow all the rules and regulations otherwise you'll be banned.",
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            // Implement join group action
            showSnackBarMessage(
              context,
              "Join group action triggered",
              type: SnackBarType.info,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Click here to join Group"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text("Done"),
        ),
      ],
    );
  }
}
