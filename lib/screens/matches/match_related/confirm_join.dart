import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/providers/balance_provider.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart'
    show showSnackBarMessage, SnackBarType;
import 'package:tournament_app/screens/matches/match_related/greeting_screen.dart';

class ConfirmJoinScreen extends StatefulWidget {
  final Matches match;
  final String player1Id;
  final String? player2Id;
  final String? player3Id;
  final String? player4Id;
  final String entryType;

  const ConfirmJoinScreen({
    Key? key,
    required this.match,
    required this.player1Id,
    this.player2Id,
    this.player3Id,
    this.player4Id,
    required this.entryType,
  }) : super(key: key);

  @override
  State<ConfirmJoinScreen> createState() => _ConfirmJoinScreenState();
}

class _ConfirmJoinScreenState extends State<ConfirmJoinScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch balance when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BalanceProvider>().fetchBalance();
    });
  }

  bool get _hasEnoughBalance {
    final balance =
        double.tryParse(context.read<BalanceProvider>().balance) ?? 0.0;
    return balance >= (widget.match.entryFee ?? 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Confirmation'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeaderSection(),
                SizedBox(height: 20),
                _buildBalanceCard(),
                SizedBox(height: 20),
                _buildMatchDetailsCard(),
                SizedBox(height: 20),
                _buildPlayerDetailsCard(),
                SizedBox(height: 30),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            widget.match.matchTitle ?? 'No Title',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
              height: 1.3,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.entryType.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<BalanceProvider>(
                builder: (context, balanceProvider, child) {
                  final balance =
                      double.tryParse(balanceProvider.balance) ?? 0.0;
                  final entryFee = widget.match.entryFee ?? 0.0;
                  final hasEnoughBalance = balance >= entryFee;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color:
                                hasEnoughBalance ? Colors.purple : Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Balance: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  hasEnoughBalance ? Colors.purple : Colors.red,
                            ),
                          ),
                          Spacer(),
                          Text(
                            balanceProvider.isLoading
                                ? 'Loading...'
                                : '${balanceProvider.balance} TK',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  hasEnoughBalance ? Colors.purple : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      if (!hasEnoughBalance) ...[
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red, size: 16),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Insufficient balance. Required: ${widget.match.entryFee} TK',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    'Match Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.purple.withOpacity(0.3)),
              _buildDetailRow(
                'Date & Time',
                '${widget.match.matchStartDate ?? 'N/A'}\n${widget.match.matchStartTime ?? 'N/A'}',
                Icons.calendar_today,
              ),
              _buildDetailRow(
                'Entry Fee',
                '${widget.match.entryFee ?? 0} TK',
                Icons.money,
              ),
              _buildDetailRow(
                'Win Prize',
                '${widget.match.totalPrize ?? 0} TK',
                Icons.card_giftcard,
              ),
              _buildDetailRow(
                'Per Kill',
                '${widget.match.perKill ?? 0} TK',
                Icons.sports_esports,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.people, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    'Player Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.purple.withOpacity(0.3)),
              _buildDetailRow('Player 1 ID', widget.player1Id, Icons.person),
              if (widget.player2Id != null)
                _buildDetailRow('Player 2 ID', widget.player2Id!, Icons.person),
              if (widget.player3Id != null)
                _buildDetailRow('Player 3 ID', widget.player3Id!, Icons.person),
              if (widget.player4Id != null)
                _buildDetailRow('Player 4 ID', widget.player4Id!, Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Text(
          'Please review your match registration details',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.edit),
                label: Text('Edit Player'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _handleJoinMatch(),
                icon:
                    isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Icon(Icons.check_circle),
                label: isLoading ? Text('Loading...') : Text('Confirm Join'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToGreetingScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => ReservationScreen(
              match: widget.match,
              player1Id: widget.player1Id,
              player2Id: widget.player2Id,
              player3Id: widget.player3Id,
              player4Id: widget.player4Id,
            ),
      ),
    );
  }

  Future<void> _handleJoinMatch() async {
    if (!_hasEnoughBalance) {
      showSnackBarMessage(
        context,
        'Insufficient balance to join the match',
        type: SnackBarType.error,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Prepare players list
      List<Map<String, String>> players = [
        {"player_name": widget.player1Id, "player_id": widget.player1Id},
      ];

      if (widget.player2Id != null) {
        players.add({
          "player_name": widget.player2Id!,
          "player_id": widget.player2Id!,
        });
      }
      if (widget.player3Id != null) {
        players.add({
          "player_name": widget.player3Id!,
          "player_id": widget.player3Id!,
        });
      }
      if (widget.player4Id != null) {
        players.add({
          "player_name": widget.player4Id!,
          "player_id": widget.player4Id!,
        });
      }

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "match_info_id": widget.match.id,
        "team_name": widget.player1Id, // Using player1Id as team name
        "team_logo": "", // Empty as it's optional
        "join_type":
            widget.entryType.toLowerCase(), // Convert to lowercase for API
        "players": players,
      };

      // Make API call
      final response = await NetworkCaller.postRequest(
        URLs.joinMatchUrl,
        body: requestBody,
      );

      if (response.isSuccess) {
        // Update balance after successful join
        await context.read<BalanceProvider>().fetchBalance();

        // Show success message
        if (mounted) {
          showSnackBarMessage(
            context,
            'Successfully joined the match',
            type: SnackBarType.success,
          );
          _navigateToGreetingScreen();
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            response.errorMessage ?? 'Failed to join match',
            type: SnackBarType.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBarMessage(
          context,
          'An error occurred: $e',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
