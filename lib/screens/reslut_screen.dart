import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/result_match_model.dart';
import '../providers/result_provider.dart';
import '../providers/result_matches_provider.dart';
import '../providers/balance_provider.dart';
import '../screens/prizing_result_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedTabIndex = 0;
  bool _isTabControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    // Don't create TabController here - we'll create it when we get data

    // Fetch subcategories (tab titles) and balance when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResultProvider>().getResultTopTitles();
      context.read<BalanceProvider>().fetchBalance();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh balance when returning to this screen
    context.read<BalanceProvider>().fetchBalance();
  }

  // Initialize tab controller once we have the data
  void _initTabController(int length) {
    if (_tabController != null) {
      _tabController!.dispose();
    }

    _tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: _selectedTabIndex < length ? _selectedTabIndex : 0,
    );

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController!.index;
        });
      }
    });

    _isTabControllerInitialized = true;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          'Result',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<BalanceProvider>(
            builder: (context, balanceProvider, _) {
              return Container(
                margin: const EdgeInsets.only(
                  right: 16.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade300, Colors.orange.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'TK ${balanceProvider.balance}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Consumer<ResultProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    provider.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (provider.subCategories.isEmpty) {
                return const Center(child: Text('No results found'));
              }

              // Initialize tab controller if not already done or if count changed
              if (!_isTabControllerInitialized ||
                  _tabController?.length != provider.subCategories.length) {
                _initTabController(provider.subCategories.length);
              }

              // Only the tab titles come from the API
              return Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: provider.subCategories.length,
                  itemBuilder: (context, index) {
                    final isActive = _tabController!.index == index;
                    final subcategory = provider.subCategories[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                          _tabController!.animateTo(index);
                        });

                        // Fetch result matches for the selected subcategory
                        context
                            .read<ResultMatchesProvider>()
                            .fetchResultMatches(subcategory.id);
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
                            subcategory.name,
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
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: Consumer2<ResultProvider, ResultMatchesProvider>(
        builder: (context, resultProvider, matchesProvider, _) {
          if (resultProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (resultProvider.subCategories.isEmpty) {
            return _buildEmptyState();
          }

          // If tab controller not initialized, show loading
          if (_tabController == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Make sure at least one tab is selected
          if (_selectedTabIndex >= resultProvider.subCategories.length) {
            _selectedTabIndex = 0;
          }

          // Get the currently selected subcategory
          final selectedSubcategory =
              resultProvider.subCategories[_selectedTabIndex];

          // If we haven't loaded matches for this subcategory yet, do it now
          if (!matchesProvider.hasMatchesForSubcategory(
            selectedSubcategory.id,
          )) {
            // Start fetching if not already loading
            if (!matchesProvider.isLoading) {
              Future.microtask(
                () =>
                    matchesProvider.fetchResultMatches(selectedSubcategory.id),
              );
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }

          // Get the matches for this subcategory
          final matches = matchesProvider.getMatchesForSubcategory(
            selectedSubcategory.id,
          );

          return PageView.builder(
            controller: PageController(initialPage: _selectedTabIndex),
            onPageChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
                _tabController!.animateTo(index);
              });

              // Fetch matches for the newly selected subcategory
              final newSubcategory = resultProvider.subCategories[index];
              if (!matchesProvider.hasMatchesForSubcategory(
                newSubcategory.id,
              )) {
                matchesProvider.fetchResultMatches(newSubcategory.id);
              }
            },
            itemCount: resultProvider.subCategories.length,
            itemBuilder: (context, index) {
              final subcategory = resultProvider.subCategories[index];
              final subcategoryMatches = matchesProvider
                  .getMatchesForSubcategory(subcategory.id);

              // Show empty state if no matches for this subcategory
              if (subcategoryMatches.isEmpty) {
                return _buildEmptyState();
              }

              // Show the list of matches
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: subcategoryMatches.length,
                itemBuilder: (context, matchIndex) {
                  return _buildSimpleMatchCard(
                    subcategoryMatches[matchIndex],
                    onTap: () {
                      // Handle match tap - will navigate to details screen later
                      _onMatchTap(subcategoryMatches[matchIndex]);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _onMatchTap(ResultMatch match) {
    // Navigate to PrizingResultScreen with match details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PrizingResultScreen(
              matchId: match.id,
              matchTitle: match.matchTitle,
              matchDate: _formatDateTime(match),
              winPrize: match.totalPrize?.toString() ?? '0',
              perKill: match.perKill?.toString() ?? '0',
              entryFee: match.entryFee?.toString() ?? '0',
            ),
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

  // Simplified match card showing only required fields
  Widget _buildSimpleMatchCard(
    ResultMatch match, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Title
                  Text(
                    match.matchTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Match details in a row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Prize
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Prize',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '${match.totalPrize} TK',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                      // Entry Type
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Type',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            match.entryType.isNotEmpty
                                ? match.entryType.first.toUpperCase()
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Version
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Version',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            match.version.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Match ID badge
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Text(
                  '#${match.id}',
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
      ),
    );
  }

  // Keep the original detailed match card for reference
  Widget _buildMatchCard(ResultMatch match) {
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
                        'assets/images/freefire.png',
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
                            match.matchTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDateTime(match),
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
                            '${match.totalPrize} TK',
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            'ENTRY TYPE',
                            match.entryType.isNotEmpty
                                ? match.entryType.first.toUpperCase()
                                : 'N/A',
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            'ENTRY FEE',
                            '${match.entryFee} TK',
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
                            match.perKill != null
                                ? '${match.perKill} TK'
                                : 'N/A',
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem('MAP', match.matchMap),
                        ),
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
                '#${match.id}',
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

  String _formatDateTime(ResultMatch match) {
    try {
      final DateTime dateTime = match.getMatchDateTime();
      return '${DateFormat('yyyy-MM-dd').format(dateTime)} at ${DateFormat('hh:mm a').format(dateTime)}';
    } catch (e) {
      return '${match.matchStartDate} at ${match.matchStartTime}';
    }
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
