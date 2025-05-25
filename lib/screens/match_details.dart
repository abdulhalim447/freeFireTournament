import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MatchDetailsScreen extends StatefulWidget {
  final String matchId;
  final String matchType;
  final String image;

  const MatchDetailsScreen({
    Key? key,
    required this.matchId,
    required this.matchType,
    required this.image,
  }) : super(key: key);

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  bool _showRoomDetails = false;
  bool _showPrizeDetails = false;

  // Sample data - would be replaced with API data
  late MatchData matchData;

  @override
  void initState() {
    super.initState();
    // Initialize with sample data
    matchData = MatchData(
      id: widget.matchId,
      title: 'Survival Match | [ Vehicle On ]',
      datetime: DateTime(2025, 5, 3, 21, 30),
      image: widget.image,
      winPrize: 405,
      entryType: 'Solo',
      entryFee: 10,
      perKill: 0,
      map: 'Bermuda',
      version: 'MOBILE',
      totalSlots: 48,
      filledSlots: 48,
      startTime: Duration(minutes: 20, seconds: 32),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FreeFire FullMap Matches',
          style: TextStyle(fontSize: isSmallScreen ? 18 : 22),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildMatchCard(isSmallScreen),
              const SizedBox(height: 16),
              // Additional content can be added here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(bool isSmallScreen) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Match header with image and title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        matchData.image,
                        width: 100,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            matchData.title,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat(
                                  'yyyy-MM-dd',
                                ).format(matchData.datetime) +
                                ' at ' +
                                DateFormat(
                                  'hh:mm a',
                                ).format(matchData.datetime),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Match details - first row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailColumn(
                      'WIN PRIZE',
                      '${matchData.winPrize} TK',
                      isSmallScreen,
                    ),
                    _buildDetailColumn(
                      'ENTRY TYPE',
                      matchData.entryType,
                      isSmallScreen,
                    ),
                    _buildDetailColumn(
                      'ENTRY FEE',
                      '${matchData.entryFee} TK',
                      isSmallScreen,
                    ),
                  ],
                ),
              ),

              // Match details - second row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailColumn(
                      'PER KILL',
                      '${matchData.perKill} TK',
                      isSmallScreen,
                    ),
                    _buildDetailColumn('MAP', matchData.map, isSmallScreen),
                    _buildDetailColumn(
                      'VERSION',
                      matchData.version,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),

              // Slots progress bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: matchData.filledSlots / matchData.totalSlots,
                        minHeight: 16,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.green.shade500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Only ${matchData.totalSlots - matchData.filledSlots} spots are left',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${matchData.filledSlots}/${matchData.totalSlots}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Join button
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildButton(
                        'Room Details',
                        FontAwesomeIcons.key,
                        Colors.blue.shade700,
                        () {
                          setState(() {
                            _showRoomDetails = !_showRoomDetails;
                          });
                        },
                        isSmallScreen,
                        isExpanded: _showRoomDetails,
                        downArrow: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: _buildButton(
                        'Total Prize Details',
                        FontAwesomeIcons.trophy,
                        Colors.blue.shade700,
                        () {
                          setState(() {
                            _showPrizeDetails = !_showPrizeDetails;
                          });
                        },
                        isSmallScreen,
                        isExpanded: _showPrizeDetails,
                        downArrow: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle join action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Match Full',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Start time
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'STARTS IN - ${_formatDuration(matchData.startTime)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Room details expandable section
              if (_showRoomDetails)
                _buildExpandableSection('Room Details', [
                  _buildDetailRow('Room ID:', '123456789', isSmallScreen),
                  _buildDetailRow('Password:', '987654', isSmallScreen),
                  _buildDetailRow(
                    'Host:',
                    'Tournament Official',
                    isSmallScreen,
                  ),
                ]),

              // Prize details expandable section
              if (_showPrizeDetails)
                _buildExpandableSection('Prize Distribution', [
                  _buildDetailRow('Rank #1:', '150 TK', isSmallScreen),
                  _buildDetailRow('Rank #2:', '100 TK', isSmallScreen),
                  _buildDetailRow('Rank #3:', '50 TK', isSmallScreen),
                  _buildDetailRow('Per Kill:', '0 TK', isSmallScreen),
                ]),
            ],
          ),

          // ID badge
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                '#${matchData.id}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, bool isSmallScreen) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isSmallScreen, {
    bool isExpanded = false,
    bool downArrow = false,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: isSmallScreen ? 4 : 8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isSmallScreen ? 14 : 16),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (downArrow) ...[
            const SizedBox(width: 4),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: isSmallScreen ? 14 : 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
    String title,
    List<Widget> children, [
    Color backgroundColor = Colors.white,
  ]) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${minutes}m:${seconds}s';
  }
}

class MatchData {
  final String id;
  final String title;
  final DateTime datetime;
  final String image;
  final int winPrize;
  final String entryType;
  final int entryFee;
  final int perKill;
  final String map;
  final String version;
  final int totalSlots;
  final int filledSlots;
  final Duration startTime;

  MatchData({
    required this.id,
    required this.title,
    required this.datetime,
    required this.image,
    required this.winPrize,
    required this.entryType,
    required this.entryFee,
    required this.perKill,
    required this.map,
    required this.version,
    required this.totalSlots,
    required this.filledSlots,
    required this.startTime,
  });
}
