import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TournamentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const TournamentDetailsScreen({Key? key, required this.tournament})
    : super(key: key);

  @override
  State<TournamentDetailsScreen> createState() =>
      _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
  bool _isRegistered = false;
  List<Map<String, dynamic>> _participants = [];

  @override
  void initState() {
    super.initState();
    // Simulate loading participants - in a real app this would come from a backend
    _loadParticipants();
  }

  void _loadParticipants() {
    // Simulate participant data - would be fetched from API in real app
    _participants = List.generate(
      12,
      (index) => {
        'id': 'user_${index + 1}',
        'name': 'Player ${index + 1}',
        'avatar': null, // Would be an actual image in a real app
        'registeredAt': DateTime.now().subtract(Duration(hours: index)),
      },
    );
    setState(() {});
  }

  void _toggleRegistration() {
    setState(() {
      _isRegistered = !_isRegistered;
      if (_isRegistered) {
        // Add current user to participants
        _participants.insert(0, {
          'id': 'current_user',
          'name': 'You',
          'avatar': null,
          'registeredAt': DateTime.now(),
        });
      } else {
        // Remove current user from participants
        _participants.removeWhere((p) => p['id'] == 'current_user');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Tournament Details',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {
              // Share tournament details functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sharing tournament details...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTournamentBanner(isSmallScreen),
            _buildTournamentInfo(isSmallScreen),
            _buildRegistrationSection(isSmallScreen),
            _buildParticipantsSection(isSmallScreen),
            SizedBox(height: 80), // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _buildTournamentBanner(bool isSmallScreen) {
    return Container(
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          // Tournament banner image
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.indigo.shade800,
              image: DecorationImage(
                image: AssetImage('assets/images/freefire.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Tournament info overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'UPCOMING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 10 : 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      widget.tournament['title'] ?? 'Free Fire Tournament',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Prize Pool',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                    ),
                    Text(
                      'BDT ${widget.tournament['prizePool'] ?? '1000'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentInfo(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tournament Details',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: FontAwesomeIcons.calendarAlt,
            iconColor: Colors.blue,
            title: 'Date & Time',
            value: DateFormat('MMM dd, yyyy - hh:mm a').format(
              widget.tournament['dateTime'] ??
                  DateTime.now().add(Duration(days: 2)),
            ),
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.mapMarkerAlt,
            iconColor: Colors.red,
            title: 'Map',
            value: widget.tournament['map'] ?? 'Bermuda',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.users,
            iconColor: Colors.green,
            title: 'Mode',
            value: widget.tournament['mode'] ?? 'Squad',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.moneyBill,
            iconColor: Colors.amber,
            title: 'Entry Fee',
            value: 'BDT ${widget.tournament['entryFee'] ?? '50'} per person',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.trophy,
            iconColor: Colors.purple,
            title: 'First Prize',
            value: 'BDT ${widget.tournament['firstPrize'] ?? '500'}',
          ),
          SizedBox(height: 16),
          Text(
            'Description',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.tournament['description'] ??
                'Join our exciting Free Fire tournament and compete against the best players to win amazing prizes! The tournament will be streamed live on our social media channels. Make sure to register before the deadline.',
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Rules',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          _buildRuleItem(
            'Players must be present 15 minutes before the match starts',
          ),
          _buildRuleItem(
            'Any form of teaming with other squads is strictly prohibited',
          ),
          _buildRuleItem('Matches will be played in TPP mode only'),
          _buildRuleItem(
            'Hackers will be permanently banned from all future tournaments',
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: Colors.indigo),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              rule,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isRegistered ? Colors.green : Colors.indigo,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isRegistered ? 'REGISTERED' : 'REGISTRATION OPEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Slots',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    '${_participants.length}/30',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _toggleRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRegistered ? Colors.red : Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isRegistered ? 'CANCEL REGISTRATION' : 'REGISTER NOW',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Participants',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _participants.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No participants yet. Be the first to register!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              )
              : Column(
                children:
                    _participants
                        .take(8) // Show only first 8 participants
                        .map(
                          (participant) =>
                              _buildParticipantItem(participant, isSmallScreen),
                        )
                        .toList(),
              ),
          if (_participants.length > 8)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // View all participants action
                  },
                  child: Text(
                    'View all ${_participants.length} participants',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantItem(
    Map<String, dynamic> participant,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.person, color: Colors.grey),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      participant['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            participant['id'] == 'current_user'
                                ? Colors.indigo
                                : Colors.black87,
                      ),
                    ),
                    if (participant['id'] == 'current_user')
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          '(You)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.indigo,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Registered ${_formatRegistrationTime(participant['registeredAt'])}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRegistrationTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return DateFormat('MMM dd, hh:mm a').format(dateTime);
    }
  }
}
