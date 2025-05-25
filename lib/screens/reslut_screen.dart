import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample data that will be replaced with API data
  final List<GameMatch> _matches = [
    GameMatch(
      id: '#11189',
      title: 'Survival Match | [ Vehicle On ]',
      datetime: DateTime(2025, 5, 2, 20, 30),
      image: 'assets/images/freefire.png',
      winPrize: 405,
      entryType: 'Solo',
      entryFee: 10,
      perKill: 0,
      map: 'Bermuda',
      version: 'MOBILE',
    ),
    GameMatch(
      id: '#11188',
      title: 'Survival Match | [ Vehicle On ]',
      datetime: DateTime(2025, 5, 2, 20, 0),
      image: 'assets/images/freefire.png',
      winPrize: 405,
      entryType: 'Solo',
      entryFee: 10,
      perKill: 0,
      map: 'Bermuda',
      version: 'MOBILE',
    ),
    GameMatch(
      id: '#11187',
      title: 'BR Match | Room ID & Pass 9:30 PM',
      datetime: DateTime(2025, 5, 2, 21, 30),
      image: 'assets/images/freefire.png',
      winPrize: 500,
      entryType: 'Duo',
      entryFee: 20,
      perKill: 5,
      map: 'Kalahari',
      version: 'MOBILE',
    ),
    GameMatch(
      id: '#11186',
      title: 'CS Match | Squad Tournament',
      datetime: DateTime(2025, 5, 2, 22, 0),
      image: 'assets/images/clash_squad.png',
      winPrize: 800,
      entryType: 'Squad',
      entryFee: 30,
      perKill: 10,
      map: 'Bermuda',
      version: 'MOBILE',
    ),
  ];

  // Tab titles from home screen
  final List<String> _tabTitles = [
    'FF FULLMAP',
    'FF Clash Squad',
    'Lone Wolf',
    'CS 2 VS 2',
    'Ludo',
    'Free Match',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Center(
          child: Text(
            'Result',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'TK 0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: List.generate(_tabTitles.length, (index) {
                final isActive = _tabController.index == index;
                return GestureDetector(
                  onTap: () {
                    _tabController.animateTo(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22.0,
                      vertical: 8.0,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color:
                          isActive
                              ? Colors.amber.shade500
                              : Colors.lightBlue.shade100,
                    ),
                    child: Center(
                      child: Text(
                        _tabTitles[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: _tabController.index),
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
        itemCount: _tabTitles.length,
        itemBuilder: (context, index) {
          // In a real app, you would filter the matches based on tab index
          final matches = _matches;

          return matches.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: matches.length,
                itemBuilder: (context, matchIndex) {
                  return _buildMatchCard(matches[matchIndex]);
                },
              );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete tournaments to see results here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(GameMatch match) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Match header with image and title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      top: 12.0,
                      right: 12.0,
                      bottom: 6.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        match.image,
                        width: 90,
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
                            match.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('yyyy-MM-dd').format(match.datetime) +
                                ' at ' +
                                DateFormat('hh:mm a').format(match.datetime),
                            style: TextStyle(
                              fontSize: 16,
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

              const Divider(height: 20, thickness: 0.5),

              // Match details
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: Column(
                  children: [
                    // First row - WIN PRIZE, ENTRY TYPE, ENTRY FEE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            'WIN PRIZE',
                            '${match.winPrize} TK',
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            'ENTRY TYPE',
                            match.entryType,
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            'ENTRY FEE',
                            match.entryFee.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Second row - PER KILL, MAP, VERSION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            'PER KILL',
                            match.perKill.toString(),
                          ),
                        ),
                        Expanded(child: _buildDetailItem('MAP', match.map)),
                        Expanded(
                          child: _buildDetailItem('VERSION', match.version),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Match ID badge
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.orange,
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

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class GameMatch {
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

  GameMatch({
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
  });
}
