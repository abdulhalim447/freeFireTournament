import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tournament_app/screens/matches/match_related/join_screen.dart';

class TournamentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const TournamentDetailsScreen({Key? key, required this.tournament})
    : super(key: key);

  @override
  State<TournamentDetailsScreen> createState() =>
      _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
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
          'Match Details',
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTournamentBanner(isSmallScreen),
            _buildMatchInfo(isSmallScreen),
            _buildMatchRules(isSmallScreen),
            _buildRegistrationSection(isSmallScreen),
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
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            widget.tournament['registration']?.toLowerCase() ==
                                    'open'
                                ? Colors.green
                                : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.tournament['registration']?.toUpperCase() ??
                            'CLOSED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 10 : 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      widget.tournament['title'] ?? 'Match Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Allow text to wrap to the next line if it's too long
                      overflow: TextOverflow.ellipsis, // Optional: add ellipsis if text overflows
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
                      'BDT ${widget.tournament['prizePool'] ?? '0'}',
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

  Widget _buildMatchInfo(bool isSmallScreen) {
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
            'Match Information',
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
            value:
                widget.tournament['dateTime'] != null
                    ? DateFormat(
                      'MMM dd, yyyy - hh:mm a',
                    ).format(widget.tournament['dateTime'])
                    : 'TBA',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.mapMarkerAlt,
            iconColor: Colors.red,
            title: 'Map',
            value: widget.tournament['map'] ?? 'TBA',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.users,
            iconColor: Colors.green,
            title: 'Mode',
            value: widget.tournament['mode'] ?? 'TBA',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.moneyBill,
            iconColor: Colors.amber,
            title: 'Entry Fee',
            value: 'BDT ${widget.tournament['entryFee'] ?? '0'}',
          ),
          _buildInfoRow(
            icon: FontAwesomeIcons.trophy,
            iconColor: Colors.purple,
            title: 'Per Kill',
            value: 'BDT ${widget.tournament['perKill'] ?? '0'}',
          ),
          if (widget.tournament['totalPrizeDetails'] != null) ...[
            SizedBox(height: 16),
            Text(
              'Prize Distribution',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.tournament['totalPrizeDetails'],
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchRules(bool isSmallScreen) {
    if (widget.tournament['description'] == null) return SizedBox.shrink();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Match Rules',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text(
            widget.tournament['description'],
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                'Registration Status',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      widget.tournament['isJoined'] == true
                          ? Colors.green
                          : widget.tournament['registration']?.toLowerCase() ==
                              'open'
                          ? Colors.blue
                          : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.tournament['isJoined'] == true
                      ? 'JOINED'
                      : widget.tournament['registration']?.toUpperCase() ??
                          'CLOSED',
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
                    'Available Slots',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    '${widget.tournament['joinedCount'] ?? 0}/${widget.tournament['totalSlots'] ?? 0}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (!widget.tournament['isJoined'] &&
                  widget.tournament['registration']?.toLowerCase() == 'open')
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => JoinScreen(match: _convertToMatch()),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'JOIN NOW',
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

  // Helper method to convert tournament data back to Match object
  dynamic _convertToMatch() {
    return {
      'id': widget.tournament['matchId'],
      'match_title': widget.tournament['title'],
      'registration': widget.tournament['registration'],
      'match_start_time': widget.tournament['dateTime']?.toString(),
      'total_prize': widget.tournament['prizePool'],
      'per_kill': widget.tournament['perKill'],
      'entry_fee': widget.tournament['entryFee'],
      'entry_type': widget.tournament['mode'],
      'full_slot': widget.tournament['totalSlots'],
      'joined_count': widget.tournament['joinedCount'],
      'map': widget.tournament['map'],
      'room_details': widget.tournament['roomDetails'],
      'total_prize_details': widget.tournament['totalPrizeDetails'],
      'detailes': widget.tournament['description'],
    };
  }
}
