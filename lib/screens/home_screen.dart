import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marquee/marquee.dart';

import 'package:tournament_app/screens/matches/br_match.dart';
import 'package:tournament_app/screens/matches/clash_squads.dart';
import 'package:tournament_app/screens/matches/cs2vs2.dart';
import 'package:tournament_app/screens/matches/free_match.dart';
import 'package:tournament_app/screens/matches/lone_wolf.dart';
import 'package:tournament_app/screens/matches/ludo_screen.dart';

import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/models/get_all_match_model.dart';
import 'package:tournament_app/utils/urls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSlideIndex = 0;
  bool _isLoading = true;
  Map<String, int> matchCounts = {};
  final ScrollController _scrollController = ScrollController();

  // Slider images would come from API later
  final List<String> _sliderImages = [
    'assets/images/freefire.png',
    'assets/images/clash_squad.png',
    'assets/images/lone_wolf.png',
    'assets/images/cs2vs2.png',
    'assets/images/ludo.png',
    'assets/images/free_match.png',
  ];

  @override
  void initState() {
    super.initState();
    _fetchMatchCounts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchMatchCounts() async {
    setState(() {
      _isLoading = true;
    });

    final categories = {
      'BR MATCH': URLs.BRMatchUrl,
      'CLASH SQUAD': URLs.ClashSquadUrl,
      'LONE WOLF': URLs.LoneWolfUrl,
      'CS 2 VS 2': URLs.CS2vs2Url,
      'LUDO': URLs.LudoUrl,
      'FREE MATCH': URLs.FreeMatchUrl,
    };

    for (var entry in categories.entries) {
      final response = await NetworkCaller.getRequest(entry.value);
      if (response.isSuccess) {
        final matchesData = GetAllMatches.fromJson(response.responsData);
        matchCounts[entry.key] = matchesData.matches?.length ?? 0;
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
  

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchMatchCounts,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 200.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageSlider(),
                ),
              ),

              // Marquee Text
              SliverToBoxAdapter(child: _buildMarqueeText()),

              // Section Title - FREE FIRE
              SliverToBoxAdapter(child: _buildSectionTitle('FREE FIRE', theme)),

              // Game Tournaments Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver:
                    _isLoading
                        ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                        : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: size.width > 600 ? 3 : 2,
                                childAspectRatio: 0.85,
                                mainAxisSpacing: 16.0,
                                crossAxisSpacing: 16.0,
                              ),
                          delegate: SliverChildListDelegate([
                            _buildTournamentCard(
                              context,
                              'BR MATCH',
                              matchCounts['BR MATCH'] ?? 0,
                              'assets/images/freefire.png',
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => BRMatchScreen(
                                            matchType: 'BR MATCH',
                                            image: 'assets/images/freefire.png',
                                          ),
                                    ),
                                  ),
                            ),
                            _buildTournamentCard(
                              context,
                              'Clash Squad',
                              matchCounts['CLASH SQUAD'] ?? 0,
                              'assets/images/clash_squad.png',
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ClashSquadsScreen(
                                            matchType: 'Clash Squad',
                                            image:
                                                'assets/images/clash_squad.png',
                                          ),
                                    ),
                                  ),
                            ),
                            _buildTournamentCard(
                              context,
                              'LONE WOLF',
                              matchCounts['LONE WOLF'] ?? 0,
                              'assets/images/lone_wolf.png',
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => LoneWolfScreen(
                                            matchType: 'LONE WOLF',
                                            image:
                                                'assets/images/lone_wolf.png',
                                          ),
                                    ),
                                  ),
                            ),
                            _buildTournamentCard(
                              context,
                              'CS 2 VS 2',
                              matchCounts['CS 2 VS 2'] ?? 0,
                              'assets/images/cs2vs2.png',
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CS2vs2Screen(
                                            matchType: 'CS 2 VS 2',
                                            image: 'assets/images/cs2vs2.png',
                                          ),
                                    ),
                                  ),
                            ),
                          ]),
                        ),
              ),

              // Section Title - LUDO AND FREE MATCH
              SliverToBoxAdapter(
                child: _buildSectionTitle('LUDO AND FREE MATCH', theme),
              ),

              // Ludo and Free Match Grid
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width > 600 ? 3 : 2,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildTournamentCard(
                      context,
                      'Ludo',
                      matchCounts['LUDO'] ?? 0,
                      'assets/images/ludo.png',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => LudoScreen(
                                    matchType: 'Ludo',
                                    image: 'assets/images/ludo.png',
                                  ),
                            ),
                          ),
                    ),
                    _buildTournamentCard(
                      context,
                      'Free Match',
                      matchCounts['FREE MATCH'] ?? 0,
                      'assets/images/free_match.png',
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => FreeMatchScreen(
                                    matchType: 'Free Match',
                                    image: 'assets/images/free_match.png',
                                  ),
                            ),
                          ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Stack(
      children: [
        CarouselSlider(
          items:
              _sliderImages.map((imagePath) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                );
              }).toList(),
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentSlideIndex = index;
              });
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                _sliderImages.asMap().entries.map((entry) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(
                        _currentSlideIndex == entry.key ? 0.9 : 0.4,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMarqueeText() {
    return Container(
      height: 40.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Marquee(
            text: 'যে কোনো প্রয়োজনে টেলিগ্রাম  গ্রুপে যোগাযোগ করুন। ধন্যবাদ',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 50.0,
            velocity: 50.0,
            pauseAfterRound: const Duration(seconds: 1),
            startPadding: 10.0,
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onBackground,
        ),
      ),
    );
  }

  Widget _buildTournamentCard(
    BuildContext context,
    String title,
    int matchCount,
    String imagePath, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(imagePath, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '$matchCount matches',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
