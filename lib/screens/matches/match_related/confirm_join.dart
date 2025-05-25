import 'package:flutter/material.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/models/user_balance_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';

class ConfirmJoinScreen extends StatefulWidget {
  final Matches match;
  final String player1Id;
  final String? player2Id;
  final String entryType;

  const ConfirmJoinScreen({
    Key? key,
    required this.match,
    required this.player1Id,
    this.player2Id,
    required this.entryType,
  }) : super(key: key);

  @override
  State<ConfirmJoinScreen> createState() => _ConfirmJoinScreenState();
}

class _ConfirmJoinScreenState extends State<ConfirmJoinScreen> {
  double? userBalance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserBalance();
  }

  Future<void> _fetchUserBalance() async {
    try {
      final user = await UserPreference.getUser();
      final response = await NetworkCaller.postRequest(
        URLs.getUserBalanceUrl,
        body: {
          "user_id": user?.id, // Assuming User model has an 'id' field
        },
      );

      if (response.isSuccess) {
        final balanceData = UserBalanceModel.fromJson(response.responsData);
        setState(() {
          userBalance = balanceData.balance;
          isLoading = false;
        });
      } else {
        showSnackBarMessage(
          context,
          'Failed to fetch balance',
          type: SnackBarType.error,
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      showSnackBarMessage(
        context,
        'Error: ${e.toString()}',
        type: SnackBarType.error,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  bool get _hasEnoughBalance {
    if (userBalance == null || widget.match.entryFee == null) return false;
    return userBalance! >= widget.match.entryFee!;
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
              Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    'Balance Details',
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
                'Current Balance',
                isLoading
                    ? 'Loading...'
                    : '${userBalance?.toStringAsFixed(2) ?? '0.00'} TK',
                Icons.money,
              ),
              _buildDetailRow(
                'Entry Fee',
                '${widget.match.entryFee ?? 0} TK',
                Icons.payment,
              ),
              if (!isLoading) ...[
                Divider(color: Colors.purple.withOpacity(0.3)),
                _buildDetailRow(
                  'Remaining Balance',
                  '${((userBalance ?? 0) - (widget.match.entryFee ?? 0)).toStringAsFixed(2)} TK',
                  Icons.calculate,
                  valueColor: _hasEnoughBalance ? Colors.green : Colors.red,
                ),
              ],
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
              if (widget.entryType.toLowerCase() == 'duo' &&
                  widget.player2Id != null)
                _buildDetailRow('Player 2 ID', widget.player2Id!, Icons.person),
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
                onPressed: () => _handleConfirmJoin(context),
                icon: Icon(Icons.check_circle),
                label: Text('Confirm Join'),
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

  void _handleConfirmJoin(BuildContext context) async {
    if (!_hasEnoughBalance) {
      showSnackBarMessage(
        context,
        'Insufficient balance to join the match',
        type: SnackBarType.error,
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Prepare the data for API call
      final joinData = {
        'match_id': widget.match.id,
        'player1_id': widget.player1Id,
        'player2_id': widget.player2Id,
        'entry_type': widget.entryType,
      };

      // TODO: Implement your API call here
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      print('Confirming join with data: $joinData');

      // Close loading indicator
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Successfully joined the match!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to the matches screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // Close loading indicator
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Failed to join match: ${e.toString()}'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
