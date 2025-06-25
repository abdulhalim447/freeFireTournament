import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/models/home_data_response.dart';
import 'package:tournament_app/providers/home_provider.dart';
import 'package:tournament_app/screens/matches/match_related/tournament_details_screen.dart';

class TodayMatchWidget extends StatefulWidget {
  const TodayMatchWidget({Key? key}) : super(key: key);

  @override
  State<TodayMatchWidget> createState() => _TodayMatchWidgetState();
}

class _TodayMatchWidgetState extends State<TodayMatchWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final todayMatches = homeProvider.todayMatches;
        final isLoading = homeProvider.isTodayMatchesLoading;
        final error = homeProvider.todayMatchesError;

        // If there are no matches, return an empty container
        if (!isLoading && todayMatches.isEmpty && error == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              const Text(
                'Today Match',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Loading, Error, or Match Cards
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(color: Color(0xFF54A9EB)),
                  ),
                )
              else if (error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF312E56),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        'Error loading matches: $error',
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ),
                )
              else if (todayMatches.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF312E56),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        'No matches scheduled for today',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children:
                      todayMatches
                          .map((match) => _buildMatchCard(context, match))
                          .toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMatchCard(BuildContext context, TodayMatch match) {
    return GestureDetector(
      onTap: () {
        // Navigate to tournament details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => TournamentDetailsScreen(
                  tournament: {
                    'matchId': match.id,
                    'title': match.matchTitle,
                    'registration': match.registration,
                    'dateTime': DateTime.parse(
                      '${match.matchStartDate} ${match.matchStartTime}',
                    ),
                    'prizePool': match.totalPrize,
                    'perKill': 10, // Assuming default value
                    'entryFee': match.entryFee,
                    'mode':
                        match.entryType.isNotEmpty
                            ? match.entryType.first
                            : 'N/A',
                    'totalSlots': match.totalSlod,
                    'joinedCount': match.joined,
                    'map': match.matchMap,
                    'roomDetails': match.roomDetails,
                    'totalPrizeDetails': 'Prize: ${match.totalPrize} TK',
                    'description': match.details,
                    'isJoined': false, // Assuming not joined by default
                  },
                ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF312E56),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Match Title and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    match.matchTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5F31E2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    match.matchStartTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Match Details
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Date:', match.matchStartDate),
                ),
                Expanded(
                  child: _buildDetailItem('Time:', match.matchStartTime),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Version and Map
            _buildDetailItem('Match Map:', '${match.matchMap}'),

            const SizedBox(height: 8),

            // Version and Prize
            _buildDetailItem('Version:', '${match.version}'),

            const SizedBox(height: 8),

            // Prize and Entry Fee
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Prize:', '${match.totalPrize}'),
                ),
                Expanded(
                  child: _buildDetailItem('Entry Fee:', '${match.entryFee}'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Slots info
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Total Slots:', '${match.totalSlod}'),
                ),
                Expanded(child: _buildDetailItem('Joined:', '${match.joined}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.white),
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
