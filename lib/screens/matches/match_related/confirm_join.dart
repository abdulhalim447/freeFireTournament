import 'package:flutter/material.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/models/user_balance_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';
import 'package:tournament_app/screens/matches/match_related/greeting_screen.dart';

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
  bool isLoading = false;

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
                    'Balance: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  Spacer(),
                  Text(
                    isLoading
                        ? 'Loading...'
                        : '${userBalance?.toStringAsFixed(2) ?? '0.00'} TK',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
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

  Future<void> _handleConfirmJoin(BuildContext context) async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }

    if (!_hasEnoughBalance) {
      showSnackBarMessage(
        context,
        'Insufficient balance to join the match. Required: ${widget.match.entryFee} TK, Your Balance: ${userBalance?.toStringAsFixed(2)} TK',
        type: SnackBarType.error,
      );
      return;
    }

    try {
      // Show loading indica
      // Get user ID
      final userId = await UserPreference.getUserId();
      if (userId == null) {
        // Close loading indicator
      
        showSnackBarMessage(
          context,
          'User not found. Please login again.',
          type: SnackBarType.error,
        );
        return;
      }

      // Prepare the data for API call
      final joinData = {
        'match_id': widget.match.id,
        'user_id': userId,
        'match_title': widget.match.matchTitle,
        'player1_id': widget.player1Id,
        if (widget.player2Id != null) 'player2_id': widget.player2Id,
        'entry_fee': widget.match.entryFee?.toString(),
        'entry_type': widget.entryType.toLowerCase(),
        'categories': widget.match.categories,
        'match_start_time': widget.match.matchStartTime,
        'match_start_date': widget.match.matchStartDate,
      };

      // Make API call to join match
      final response = await NetworkCaller.postRequest(
        URLs.joinedMatchUrl,
        body: joinData,
      );
      isLoading = false;
      if (mounted) {
        setState(() {});
      }

      if (!mounted) return;

      

      if (response.isSuccess) {
        // Decrease user balance
        final decreaseBalanceResponse = await NetworkCaller.postRequest(
          URLs.decrementBalanceUrl,
          body: {"user_id": userId, "amount": widget.match.entryFee},
        );

        if (!decreaseBalanceResponse.isSuccess) {
          showSnackBarMessage(
            context,
            'Failed to update balance: ${decreaseBalanceResponse.errorMessage}',
            type: SnackBarType.error,
          );
          return;
        }

        showSnackBarMessage(
          context,
          'Successfully joined the match!',
          type: SnackBarType.success,
        );

        // Navigate to the reservation screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ReservationScreen(
                  match: widget.match,
                  player1Id: widget.player1Id,
                  player2Id: widget.player2Id,
                ),
          ),
        );
      } else {
        isLoading = false;
        if (mounted) {
          setState(() {});
        }

        // Enhanced error message handling
        String errorMsg = response.errorMessage ?? 'Failed to join match';
        if (response.responsData != null &&
            response.responsData['message'] != null) {
          errorMsg = response.responsData['message'].toString();
        }

        showSnackBarMessage(context, errorMsg, type: SnackBarType.error);
      }
    } catch (e) {
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
      if (!mounted) return;

      // Ensure loading indicator is closed in case of error
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      showSnackBarMessage(
        context,
        'Error: ${e.toString()}',
        type: SnackBarType.error,
      );
    }
  }
}
