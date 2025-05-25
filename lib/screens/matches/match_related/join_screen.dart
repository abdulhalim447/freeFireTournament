// lib/screens/matches/match_related/join_screen.dart

import 'package:flutter/material.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/screens/matches/match_related/confirm_join.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Match'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildMatchInfo(),
            SizedBox(height: 20),
            Spacer(),
            _buildJoinButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.match.matchTitle ?? 'No Title',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Date & Time: ${widget.match.matchStartDate ?? 'N/A'}, ${widget.match.matchStartTime ?? 'N/A'}",
            ),
            SizedBox(height: 8),
            Text("Win Prize: ${widget.match.totalPrize ?? 0}TK"),
            SizedBox(height: 8),
            Text("Entry Fee: ${widget.match.entryFee ?? 0}TK"),
            SizedBox(height: 16),
            Text(
              "*অবশ্যই এখানে আপনার গেমের এর নামটি দিয়ে জয়েন করবেন।",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedEntryType = 'solo';
                        _showPlayerFields = true;
                      });
                    },
                    child: Text('Solo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                  ),
                  if (widget.match.entryType?.toLowerCase() == 'duo')
                    SizedBox(width: 10),
                  if (widget.match.entryType?.toLowerCase() == 'duo')
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedEntryType = 'duo';
                          _showPlayerFields = true;
                        });
                      },
                      child: Text('Duo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_showPlayerFields) ...[
              SizedBox(height: 16),
              TextFormField(
                controller: _player1Controller,
                decoration: InputDecoration(
                  labelText: 'Player 1 ID',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your game ID',
                ),
              ),
              if (_selectedEntryType == 'duo') ...[
                SizedBox(height: 10),
                TextFormField(
                  controller: _player2Controller,
                  decoration: InputDecoration(
                    labelText: 'Player 2 ID',
                    border: OutlineInputBorder(),
                    hintText: 'Enter teammate\'s game ID',
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            _showPlayerFields && _validateFields()
                ? () {
                  _handleJoinMatch();
                }
                : null,
        child: Text('Join Now!'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
      ),
    );
  }

  bool _validateFields() {
    if (_player1Controller.text.isEmpty) return false;
    if (_selectedEntryType == 'duo' && _player2Controller.text.isEmpty) {
      return false;
    }
    return true;
  }

  void _handleJoinMatch() {
    // Navigate to ConfirmJoinScreen with the required data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ConfirmJoinScreen(
              match: widget.match,
              player1Id: _player1Controller.text,
              player2Id:
                  _selectedEntryType == 'duo' ? _player2Controller.text : null,
              entryType: _selectedEntryType ?? 'solo',
            ),
      ),
    );
  }
}
