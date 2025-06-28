import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:tournament_app/models/subcategory_matches_model.dart';
import 'package:tournament_app/models/mathces.dart';
import 'package:tournament_app/providers/subcategory_matches_provider.dart';
import 'package:tournament_app/utils/app_colors.dart';
import 'package:tournament_app/screens/matches/match_related/join_screen.dart';

class SubcategoryMatchesScreen extends StatefulWidget {
  final int subcategoryId;
  final String title;
  final String image;

  const SubcategoryMatchesScreen({
    Key? key,
    required this.subcategoryId,
    required this.title,
    required this.image,
  }) : super(key: key);

  @override
  State<SubcategoryMatchesScreen> createState() =>
      _SubcategoryMatchesScreenState();
}

class _SubcategoryMatchesScreenState extends State<SubcategoryMatchesScreen> {
  // Map to store timers for each match
  final Map<int, Timer> _timers = {};

  // Map to store remaining time in seconds for each match
  final Map<int, int> _remainingTimes = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubcategoryMatchesProvider>().fetchSubcategoryMatches(
        widget.subcategoryId,
      );
    });
  }

  @override
  void dispose() {
    // Cancel all timers when screen is disposed
    _timers.forEach((_, timer) => timer.cancel());
    _timers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryPurple.withOpacity(0.2),
                Colors.blue.withOpacity(0.2),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.purple.shade300, Colors.blue.shade300],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<SubcategoryMatchesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPurple),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red[300], size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load matches',
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchSubcategoryMatches(widget.subcategoryId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_esports, color: Colors.grey[400], size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'No matches available',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check back later for new matches',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh:
                () => provider.fetchSubcategoryMatches(widget.subcategoryId),
            color: AppColors.primaryPurple,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: provider.matches.length,
              itemBuilder: (context, index) {
                final match = provider.matches[index];
                _startTimer(match);
                return _buildMatchCard(match);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchCard(SubcategoryMatch match) {
    // Get remaining time from map or calculate it
    final remainingTime =
        _remainingTimes[match.id] ?? match.getRemainingTimeInSeconds();
    // Check if user has joined this match using isJoined field from API
    final bool hasJoined = match.isJoined == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logo, title and time
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo/Image from subcategory
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    widget.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.sports_esports,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                  ),
                ),
                const SizedBox(width: 12),

                // Title, date/time and ID badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and ID badge row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryPurple.withOpacity(0.1),
                                    Colors.blue.withOpacity(0.1),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ShaderMask(
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
                                  match.matchTitle,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),

                          // ID badge
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#${match.id}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Date and time
                      Text(
                        _formatMatchDateTime(match),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.pink.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Match details grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                // First row: Win Prize, Entry Type, Entry Fee
                Row(
                  children: [
                    _buildDetailBox(
                      'WIN PRIZE',
                      '${match.totalPrize} TK',
                      flex: 1,
                    ),
                    _buildDetailBox(
                      'ENTRY TYPE',
                      match.entryType.isNotEmpty
                          ? match.entryType.first.toUpperCase()
                          : 'N/A',
                      flex: 1,
                    ),
                    _buildDetailBox(
                      'ENTRY FEE',
                      '${match.entryFee} TK',
                      flex: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Second row: Per Kill, Map, Version
                Row(
                  children: [
                    _buildDetailBox(
                      'PER KILL',
                      '0.00 TK',
                      flex: 1,
                    ), // Assuming 10 TK per kill
                    _buildDetailBox('MAP', match.matchMap, flex: 1),
                    _buildDetailBox(
                      'VERSION',
                      match.version.toUpperCase(),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Progress bar and Join button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Progress bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value:
                              match.totalSlots > 0
                                  ? match.joined / match.totalSlots
                                  : 0,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Slots info
                      Text(
                        'Only ${match.totalSlots - match.joined} spots are left',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${match.joined}/${match.totalSlots}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Join button
                ElevatedButton(
                  onPressed:
                      hasJoined
                          ? null
                          : () {
                            // Create Matches object from SubcategoryMatch
                            final matchData = Matches(
                              id: match.id.toString(),
                              matchTitle: match.matchTitle,
                              matchStartDate: match.matchStartDate,
                              matchStartTime: match.matchStartTime,
                              totalPrize: match.totalPrize,
                              entryFee: match.entryFee,
                              entryType: match.entryType,
                              fullSlot: match.totalSlots,
                              joined: match.joined,
                              version: match.version,
                              map: match.matchMap,
                              roomDetails: match.roomDetails,
                            );

                            // Navigate to join screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => JoinScreen(match: matchData),
                              ),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        hasJoined ? Colors.grey : AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    hasJoined ? 'JOINED' : 'Join Now',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Room Details and Prize Details buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Room Details button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Show room details dialog
                      if (match.roomDetails != null &&
                          match.roomDetails!.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Room Details'),
                                content: Text(match.roomDetails!),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Room details not available yet'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.vpn_key, size: 16),
                    label: const Text('Room Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade800,
                      side: BorderSide(color: Colors.blue.shade800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Prize Details button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Show prize details dialog
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Prize Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Prize: ${match.totalPrize} TK',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Prize Distribution:'),
                                  const SizedBox(height: 4),
                                  Text(
                                    '• Winner: ${(match.totalPrize * 0.7).toInt()} TK',
                                  ),
                                  Text(
                                    '• Runner-up: ${(match.totalPrize * 0.3).toInt()} TK',
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                      );
                    },
                    icon: const Icon(Icons.emoji_events, size: 16),
                    label: const Text('Total Prize Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade800,
                      side: BorderSide(color: Colors.blue.shade800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Timer Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF18713C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'STARTS IN - ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  _formatRemainingTime(remainingTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build detail boxes
  Widget _buildDetailBox(String label, String value, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatMatchDateTime(SubcategoryMatch match) {
    try {
      final DateTime matchDate = DateTime.parse(match.matchStartDate);
      final formattedDate = DateFormat('MMM dd, yyyy').format(matchDate);

      final timeParts = match.matchStartTime.split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert 24-hour format to 12-hour
      hour = hour > 12 ? hour - 12 : hour;
      hour = hour == 0 ? 12 : hour;

      return '$formattedDate at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return 'Date not available';
    }
  }

  String _formatRemainingTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startTimer(SubcategoryMatch match) {
    // Cancel existing timer if any
    _timers[match.id]?.cancel();

    // Set initial remaining time
    if (_remainingTimes[match.id] == null) {
      _remainingTimes[match.id] = match.getRemainingTimeInSeconds();
    }

    // Create new timer
    _timers[match.id] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_remainingTimes[match.id]! > 0) {
          _remainingTimes[match.id] = _remainingTimes[match.id]! - 1;
        } else {
          timer.cancel();
        }
      });
    });
  }
}
