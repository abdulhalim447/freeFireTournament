// lib/screens/matches/match_related/join_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/providers/balance_provider.dart';
import 'package:tournament_app/screens/matches/match_related/confirm_join.dart';
import 'package:tournament_app/utils/app_colors.dart';

class JoinScreen extends StatefulWidget {
  final Matches match;

  const JoinScreen({Key? key, required this.match}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  bool _showPlayerFields = false;
  String? _selectedEntryType;
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  final _player3Controller = TextEditingController();
  final _player4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If there's only one entry type available, pre-select it
    if (widget.match.entryType != null && widget.match.entryType!.isNotEmpty) {
      _selectedEntryType = widget.match.entryType!.first.toLowerCase();
    }

    // Fetch balance when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BalanceProvider>().fetchBalance();
    });
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    _player3Controller.dispose();
    _player4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B22), // Dark background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B22),
        title: const Text(
          'Join Match',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance Section
                      Consumer<BalanceProvider>(
                        builder: (context, balanceProvider, child) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Your Balance:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${balanceProvider.balance} TK',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Match Title
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryPurple.withOpacity(0.1),
                              Colors.blue.withOpacity(0.1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback:
                                  (bounds) => LinearGradient(
                                    colors: [
                                      AppColors.primaryPurple,
                                      Colors.blue,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(bounds),
                              child: Text(
                                widget.match.matchTitle ?? 'No Title',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors
                                          .white, // This will be overridden by the gradient
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryPurple,
                                    Colors.blue,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Match #${widget.match.id ?? ''}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Match Details
                      _buildDetailRow(
                        'Date & Time',
                        _formatDateTime(
                          widget.match.matchStartDate,
                          widget.match.matchStartTime,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Win Prize',
                        '${widget.match.totalPrize ?? 0} TK',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Entry Fee',
                        '${widget.match.entryFee ?? 0} TK',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Entry Type',
                        widget.match.entryType
                                ?.map((e) => e.toUpperCase())
                                .join(', ') ??
                            'N/A',
                      ),
                      const SizedBox(height: 20),

                      // Warning Text
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "*অবশ্যই এখানে আপনার গেমের এর নামটি দিয়ে জয়েন করবেন।",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Entry Type Buttons
                      Center(child: _buildEntryTypeButtons()),
                      if (_showPlayerFields) ...[
                        const SizedBox(height: 24),
                        _buildPlayerFields(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildJoinButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$label: ',
                style: const TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }

  String _formatDateTime(String? date, String? time) {
    if (date == null || time == null) return 'N/A';

    // Convert 24-hour format to 12-hour format
    try {
      final timeParts = time.split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      hour = hour > 12 ? hour - 12 : hour;
      hour = hour == 0 ? 12 : hour;

      return '$date at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return '$date $time';
    }
  }

  Widget _buildEntryTypeButtons() {
    final entryTypes = widget.match.entryType;

    if (entryTypes == null || entryTypes.isEmpty) {
      return const Text(
        'No entry type specified',
        style: TextStyle(color: Colors.red),
      );
    }

    return Column(
      children: [
        const Text(
          'Select Entry Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children:
              entryTypes.map((type) {
                final lowerType = type.toLowerCase();
                IconData icon;
                String displayText;

                switch (lowerType) {
                  case 'solo':
                    icon = Icons.person;
                    displayText = 'SOLO';
                    break;
                  case 'due':
                    icon = Icons.people;
                    displayText = 'DUO';
                    break;
                  case 'squared':
                    icon = Icons.groups;
                    displayText = 'SQUAD';
                    break;
                  default:
                    icon = Icons.person;
                    displayText = type.toUpperCase();
                }

                return _buildEntryTypeButton(
                  type: displayText,
                  icon: icon,
                  isSelected: _selectedEntryType == lowerType,
                  onTap: () => _onEntryTypeSelected(lowerType),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildEntryTypeButton({
    required String type,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color:
                  isSelected ? AppColors.primaryPurple : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEntryTypeSelected(String type) {
    setState(() {
      _selectedEntryType = type;
      _showPlayerFields = true;

      // Clear controllers that aren't needed for the selected type
      if (type == 'solo') {
        _player2Controller.clear();
        _player3Controller.clear();
        _player4Controller.clear();
      } else if (type == 'due') {
        _player3Controller.clear();
        _player4Controller.clear();
      }
    });
  }

  Widget _buildPlayerFields() {
    if (!_showPlayerFields) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Player Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildPlayerField(
          controller: _player1Controller,
          label: 'Player 1 ID',
          hint: 'Enter your game ID',
        ),
        if (_selectedEntryType == 'due') ...[
          const SizedBox(height: 12),
          _buildPlayerField(
            controller: _player2Controller,
            label: 'Player 2 ID',
            hint: 'Enter teammate\'s game ID',
          ),
        ] else if (_selectedEntryType == 'squared') ...[
          const SizedBox(height: 12),
          _buildPlayerField(
            controller: _player2Controller,
            label: 'Player 2 ID',
            hint: 'Enter teammate\'s game ID',
          ),
          const SizedBox(height: 12),
          _buildPlayerField(
            controller: _player3Controller,
            label: 'Player 3 ID',
            hint: 'Enter teammate\'s game ID',
          ),
          const SizedBox(height: 12),
          _buildPlayerField(
            controller: _player4Controller,
            label: 'Player 4 ID',
            hint: 'Enter teammate\'s game ID',
          ),
        ],
      ],
    );
  }

  Widget _buildPlayerField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        labelStyle: const TextStyle(color: Color(0xFF666666)),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryPurple),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: const TextStyle(color: Color(0xFF333333), fontSize: 15),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed:
            _showPlayerFields && _validateFields() ? _handleJoinMatch : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        child: Text(
          'Join Now!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                _showPlayerFields && _validateFields()
                    ? Colors.white
                    : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    if (_player1Controller.text.isEmpty) return false;

    if (_selectedEntryType == 'due' && _player2Controller.text.isEmpty) {
      return false;
    }

    if (_selectedEntryType == 'squared') {
      if (_player2Controller.text.isEmpty ||
          _player3Controller.text.isEmpty ||
          _player4Controller.text.isEmpty) {
        return false;
      }
    }

    return true;
  }

  void _handleJoinMatch() {
    // Collect player IDs based on entry type
    List<String> playerIds = [_player1Controller.text];

    if (_selectedEntryType == 'due') {
      playerIds.add(_player2Controller.text);
    } else if (_selectedEntryType == 'squared') {
      playerIds.add(_player2Controller.text);
      playerIds.add(_player3Controller.text);
      playerIds.add(_player4Controller.text);
    }

    // Navigate to ConfirmJoinScreen with the required data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ConfirmJoinScreen(
              match: widget.match,
              player1Id: _player1Controller.text,
              player2Id:
                  _selectedEntryType == 'due' || _selectedEntryType == 'squared'
                      ? _player2Controller.text
                      : null,
              player3Id:
                  _selectedEntryType == 'squared'
                      ? _player3Controller.text
                      : null,
              player4Id:
                  _selectedEntryType == 'squared'
                      ? _player4Controller.text
                      : null,
              entryType: _selectedEntryType ?? 'solo',
            ),
      ),
    );
  }
}
