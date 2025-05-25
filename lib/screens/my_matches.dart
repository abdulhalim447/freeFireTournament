import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({Key? key}) : super(key: key);

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
  // Sample data that will be replaced with API data later
  final List<MatchInfo> _matches = [
    MatchInfo(
      id: '#8293',
      title: 'FREE MATCH | ID & Pass Give In Telegram',
      timestamp: DateTime(2025, 4, 30, 22, 32, 50),
      wonAmount: 0,
      matchType: 'FREE MATCH',
    ),
    MatchInfo(
      id: '#7584',
      title: 'BR MATCH | Room ID & Pass 8:30 PM',
      timestamp: DateTime(2025, 4, 29, 20, 15, 22),
      wonAmount: 250,
      matchType: 'BR MATCH',
    ),
    MatchInfo(
      id: '#6391',
      title: 'Clash Squad | Join Now',
      timestamp: DateTime(2025, 4, 28, 19, 45, 00),
      wonAmount: 500,
      matchType: 'CS MATCH',
    ),
    MatchInfo(
      id: '#5172',
      title: 'LUDO TOURNAMENT | Special Prize',
      timestamp: DateTime(2025, 4, 27, 14, 30, 15),
      wonAmount: 1200,
      matchType: 'LUDO',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'MY MATCHES',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            Text(
              'TK 0',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body:
          _matches.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  return _buildMatchCard(_matches[index], index + 1);
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_esports, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No matches found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join a tournament to see your matches here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(MatchInfo match, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side with number
                Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text(
                    index.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:
                              match.matchType == 'FREE MATCH'
                                  ? Colors.green.shade700
                                  : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat(
                          'yyyy-MM-dd hh:mm:ss a',
                        ).format(match.timestamp),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Won Amount: ${match.wonAmount} TK',
                        style: const TextStyle(
                          fontSize: 16,
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
          // Right side with ID (Positioned at top-right)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Text(
                match.id,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MatchInfo {
  final String id;
  final String title;
  final DateTime timestamp;
  final int wonAmount;
  final String matchType;

  MatchInfo({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.wonAmount,
    required this.matchType,
  });
}
