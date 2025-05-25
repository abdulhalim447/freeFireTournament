import 'package:flutter/material.dart';

class TopPlayersListScreen extends StatelessWidget {
  const TopPlayersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Sample data - Replace with API data later
    final topPlayers = [
      TopPlayer(rank: 1, name: 'rifat01', amount: 22100),
      TopPlayer(rank: 2, name: 'mdsayemmmm', amount: 20905),
      TopPlayer(rank: 3, name: 'anisahmed', amount: 19935),
      TopPlayer(rank: 4, name: 'Ayan', amount: 19568),
      TopPlayer(rank: 5, name: 'joyfc', amount: 18025),
      TopPlayer(rank: 6, name: 'asraful007', amount: 17357),
      TopPlayer(rank: 7, name: 'siyamvai', amount: 15660),
      TopPlayer(rank: 8, name: 'vjgxxxb', amount: 15230),
      TopPlayer(rank: 9, name: 'mdshuvo', amount: 14043),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'TOP PLAYERS',
          style: TextStyle(
            fontSize: 22 * textScaleFactor,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.02,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.15,
                  child: Text(
                    'SI No.',
                    style: TextStyle(
                      fontSize: 16 * textScaleFactor,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16 * textScaleFactor,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Amount',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16 * textScaleFactor,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of players
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              itemCount: topPlayers.length,
              separatorBuilder:
                  (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.shade200,
                  ),
              itemBuilder: (context, index) {
                final player = topPlayers[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  child: Row(
                    children: [
                      // Rank with medal
                      SizedBox(
                        width: size.width * 0.15,
                        child: _buildRankWidget(player.rank, textScaleFactor),
                      ),
                      // Player name
                      Expanded(
                        flex: 2,
                        child: Text(
                          player.name,
                          style: TextStyle(
                            fontSize: 16 * textScaleFactor,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Amount
                      Expanded(
                        child: Text(
                          '${player.amount} TK',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16 * textScaleFactor,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankWidget(int rank, double textScaleFactor) {
    if (rank <= 3) {
      return Row(
        children: [
          _getMedalIcon(rank),
          SizedBox(width: 4),
          Text(
            '$rank',
            style: TextStyle(
              fontSize: 16 * textScaleFactor,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      );
    }
    return Text(
      '$rank',
      style: TextStyle(
        fontSize: 16 * textScaleFactor,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _getMedalIcon(int rank) {
    IconData iconData;
    Color iconColor;

    switch (rank) {
      case 1:
        iconData = Icons.emoji_events;
        iconColor = Colors.amber; // Gold
        break;
      case 2:
        iconData = Icons.emoji_events;
        iconColor = Colors.grey[400]!; // Silver
        break;
      case 3:
        iconData = Icons.emoji_events;
        iconColor = Colors.brown[300]!; // Bronze
        break;
      default:
        return const SizedBox();
    }

    return Icon(iconData, color: iconColor, size: 24);
  }
}

class TopPlayer {
  final int rank;
  final String name;
  final int amount;

  TopPlayer({required this.rank, required this.name, required this.amount});
}
