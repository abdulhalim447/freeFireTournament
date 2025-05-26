import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tournament_app/models/get_all_match_model.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/screens/matches/match_related/join_screen.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';
import 'dart:async';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/screens/matches/match_related/tournament_details_screen.dart';

class CS2vs2Screen extends StatefulWidget {
  final String matchType;
  final String image;

    const CS2vs2Screen({Key? key, required this.matchType, required this.image})
    : super(key: key);

  @override
  State<CS2vs2Screen> createState() => _CS2vs2ScreenState();
}

class _CS2vs2ScreenState extends State<CS2vs2Screen> {
  bool _isLoading = true;
  String? currentUserId;

  List<Matches> allMatches = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndMatchData();
  }

  Future<void> _fetchUserIdAndMatchData() async {
    // First get the user ID
    currentUserId = await UserPreference.getUserId();
    // Then fetch match data
    _fetchMatchData();
  }

  Future<void> _fetchMatchData() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    final response = await NetworkCaller.getRequest(URLs.CS2vs2Url);

    if (response.isSuccess) {
      final matchesData = GetAllMatches.fromJson(response.responsData);

      setState(() {
        _isLoading = false;
        if (matchesData.matches != null && matchesData.matches!.isNotEmpty) {
          allMatches = matchesData.matches!;
        } else {
          errorMessage = 'No matches found';
        }
      });
    } else {
      setState(() {
        _isLoading = false;
        errorMessage = response.errorMessage ?? 'Failed to load match data';
      });
      showSnackBarMessage(context, errorMessage!, type: SnackBarType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FreeFire FullMap Matches',
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage!,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchMatchData,
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              )
              : allMatches.isEmpty
              ? Center(child: Text('No matches available'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allMatches.length,
                itemBuilder: (context, index) {
                  return _buildMatchCard(allMatches[index], isSmallScreen);
                },
              ),
    );
  }

  Widget _buildMatchCard(Matches match, bool isSmallScreen) {
    // Parse the date and time
    DateTime? matchDateTime;
    try {
      final dateStr = match.matchStartDate ?? '';
      final timeStr = match.matchStartTime ?? '';

      if (dateStr.isNotEmpty && timeStr.isNotEmpty) {
        // API returns time in HH:MM format
        matchDateTime = DateFormat(
          'yyyy-MM-dd HH:mm',
        ).parse('$dateStr $timeStr');
      }
    } catch (e) {
      print('Error parsing date/time: $e');
    }

    // Calculate time until match starts
    Duration timeUntilStart = Duration.zero;
    if (matchDateTime != null) {
      final now = DateTime.now();
      if (matchDateTime.isAfter(now)) {
        timeUntilStart = matchDateTime.difference(now);
      }
    }

    // Check if user has already joined this match
    bool userHasJoined = false;
    if (currentUserId != null && match.joinedUserIds != null) {
      userHasJoined = match.joinedUserIds!.contains(int.parse(currentUserId!));
    }

    // Slots calculation - use joinedCount instead of joined
    final int totalSlots = match.fullSlot ?? 0;
    final int filledSlots =
        match.joinedCount ??
        match.joined ??
        0; // Fallback to joined for backward compatibility

    return InkWell(
      onTap: () {
        // Convert match data to tournament format
        final tournamentData = {
          'title': match.matchTitle,
          'prizePool': match.totalPrize,
          'dateTime': matchDateTime,
          'map': match.map,
          'mode': match.entryType,
          'entryFee': match.entryFee,
          'firstPrize': match.totalPrize,
          'description': match.detailes, // Add match details/rules here
          'totalPrizeDetails': match.totalPrizeDetails,
          'roomDetails': match.roomDetails,
          'joinedCount': filledSlots,
          'totalSlots': totalSlots,
          'isJoined': userHasJoined,
          'registration': match.registration,
          'perKill': match.perKill,
          'matchId': match.id,
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    TournamentDetailsScreen(tournament: tournamentData),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
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
                          widget.image,
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
                              match.matchTitle ?? 'No Title',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${match.matchStartDate ?? 'N/A'} at ${match.matchStartTime ?? 'N/A'}',
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
                        '${match.totalPrize ?? 0} TK',
                        isSmallScreen,
                      ),
                      _buildDetailColumn(
                        'ENTRY TYPE',
                        match.entryType ?? 'N/A',
                        isSmallScreen,
                      ),
                      _buildDetailColumn(
                        'ENTRY FEE',
                        '${match.entryFee ?? 0} TK',
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
                        '${match.perKill ?? 0} TK',
                        isSmallScreen,
                      ),
                      _buildDetailColumn(
                        'MAP',
                        match.map ?? 'N/A',
                        isSmallScreen,
                      ),
                      _buildDetailColumn(
                        'VERSION',
                        match.version ?? 'N/A',
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
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value:
                                    totalSlots > 0
                                        ? filledSlots / totalSlots
                                        : 0,
                                minHeight: 16,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green.shade500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed:
                                  userHasJoined
                                      ? null
                                      : match.registration?.toLowerCase() ==
                                          'open'
                                      ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    JoinScreen(match: match),
                                          ),
                                        );
                                      }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    userHasJoined
                                        ? Colors.green
                                        : match.registration?.toLowerCase() ==
                                            'open'
                                        ? Colors.blue.shade700
                                        : Colors.grey,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                userHasJoined
                                    ? 'Joined'
                                    : match.registration?.toLowerCase() ==
                                        'open'
                                    ? 'Join'
                                    : 'Match Full',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Only ${totalSlots - filledSlots} spots are left',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '$filledSlots/$totalSlots',
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

                // Buttons row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildButton(
                          'Room Details',
                          FontAwesomeIcons.key,
                          Colors.blue.shade700,
                          () {
                            _showRoomDetailsBottomSheet(
                              context,
                              match,
                              isSmallScreen,
                            );
                          },
                          isSmallScreen,
                          downArrow: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: _buildButton(
                          'Prize Details',
                          FontAwesomeIcons.trophy,
                          Colors.blue.shade700,
                          () {
                            _showPrizeDetailsBottomSheet(
                              context,
                              match,
                              isSmallScreen,
                            );
                          },
                          isSmallScreen,
                          downArrow: true,
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
                      matchDateTime != null &&
                              matchDateTime.isAfter(DateTime.now())
                          ? CountdownTimer(
                            targetTime: matchDateTime,
                            isSmallScreen: isSmallScreen,
                          )
                          : Text(
                            'MATCH BEGINS SOON',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),

            // ID badge
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  '#${match.id ?? "N/A"}',
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
      ),
    );
  }

  void _showRoomDetailsBottomSheet(
    BuildContext context,
    Matches match,
    bool isSmallScreen,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (match.roomDetails != null && match.roomDetails!.isNotEmpty)
                _buildDetailRow('', match.roomDetails!, isSmallScreen)
              else ...[
                _buildDetailRow(
                  'Room ID:',
                  'Will be shown before match',
                  isSmallScreen,
                ),
                _buildDetailRow(
                  'Password:',
                  'Will be shown before match',
                  isSmallScreen,
                ),
                _buildDetailRow('Host:', 'Tournament Official', isSmallScreen),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrizeDetailsBottomSheet(
    BuildContext context,
    Matches match,
    bool isSmallScreen,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prize Distribution',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (match.totalPrizeDetails != null &&
                  match.totalPrizeDetails!.isNotEmpty)
                _buildDetailRow('', match.totalPrizeDetails!, isSmallScreen)
              else if (match.totalPrizeDetails == null)
                _buildDetailRow(
                  'Prize Details:',
                  'No prize details available',
                  isSmallScreen,
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
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
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;
  final bool isSmallScreen;

  const CountdownTimer({
    Key? key,
    required this.targetTime,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _timeLeft;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeLeft();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    if (widget.targetTime.isAfter(now)) {
      setState(() {
        _timeLeft = widget.targetTime.difference(now);
      });
    } else {
      setState(() {
        _timeLeft = Duration.zero;
      });
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'STARTS IN - ${_formatDuration(_timeLeft)}',
      style: TextStyle(
        color: Colors.white,
        fontSize: widget.isSmallScreen ? 16 : 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '${hours}h:${minutes}m:${seconds}s';
    } else {
      return '${minutes}m:${seconds}s';
    }
  }
}
