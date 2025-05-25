import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marquee/marquee.dart';
import 'package:tournament_app/screens/match_details.dart';
import 'package:tournament_app/screens/matches/br_match.dart';
import 'package:tournament_app/screens/my_matches.dart';
import 'package:tournament_app/screens/tournament_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSlideIndex = 0;

  // Slider images would come from API later
  final List<String> _sliderImages = ['assets/images/freefire.png'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slider/Carousel
              _buildImageSlider(),

              // Marquee text
              _buildMarqueeText(),

              // Free Fire section
              _buildSectionTitle('FREE FIRE'),
              _buildGameTournaments(),

              // Ludo and Free Match section
              _buildSectionTitle('LUDO AND FREE MATCH'),
              _buildLudoAndFreeMatchSection(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Column(
      children: [
        CarouselSlider(
          items:
              _sliderImages.map((imagePath) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
        Row(
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
                    color: Colors.orange.withOpacity(
                      _currentSlideIndex == entry.key ? 0.9 : 0.4,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildMarqueeText() {
    return Container(
      height: 50.0,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.white,
      child: Marquee(
        text: 'না প্রয়োজনে টেলিগ্রাম জয়েন করুন এবং এভাডিন',
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      margin: const EdgeInsets.only(top: 2.0, bottom: 10.0),
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildGameTournaments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.85,
        children: [
          _buildTournamentCard(
            'BR MATCH',
            '4 matches found',
            'assets/images/freefire.png',
            onTap: () {
              // Navigate to TournamentDetailsScreen for BR MATCH
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BRMatchScreen(
                        matchType: 'BR MATCH',
                        image: 'assets/images/freefire.png',
                      ),
                ),
              );
            },
          ),
          _buildTournamentCard(
            'Clash Squad',
            '8 matches found',
            'assets/images/clash_squad.png',
            onTap: () {
              // Navigate to TournamentDetailsScreen for Clash Squad
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TournamentDetailsScreen(
                        tournament: {
                          'title': 'Clash Squad',
                          'prizePool': '1500',
                          'entryFee': '75',
                          'firstPrize': '750',
                          'dateTime': DateTime.now().add(Duration(days: 1)),
                          'map': 'Bermuda',
                          'mode': 'CS 4v4',
                          'image': 'assets/images/clash_squad.png',
                        },
                      ),
                ),
              );
            },
          ),
          _buildTournamentCard(
            'LONE WOLF',
            '9 matches found',
            'assets/images/lone_wolf.png',
            onTap: () {
              // Navigate to MatchDetailsScreen for LONE WOLF
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MatchDetailsScreen(
                        matchId: 'LW001',
                        matchType: 'LONE WOLF',
                        image: 'assets/images/lone_wolf.png',
                      ),
                ),
              );
            },
          ),
          _buildTournamentCard(
            'CS 2 VS 2',
            '7 matches found',
            'assets/images/cs2vs2.png',
            onTap: () {
              // Navigate to MatchDetailsScreen for CS 2 VS 2
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MatchDetailsScreen(
                        matchId: 'CS001',
                        matchType: 'CS 2 VS 2',
                        image: 'assets/images/cs2vs2.png',
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLudoAndFreeMatchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.85,
        children: [
          _buildTournamentCard(
            'Ludo',
            'No Matches Found',
            'assets/images/ludo.png',
            textColor: Colors.grey,
          ),
          _buildTournamentCard(
            'Free Match',
            '22 matches found',
            'assets/images/free_match.png',
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard(
    String title,
    String subtitle,
    String imagePath, {
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: textColor ?? Colors.grey[600],
                          fontSize: 8.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
