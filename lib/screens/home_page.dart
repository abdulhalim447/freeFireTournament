import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/widgets/home/image_slider_widget.dart';
import 'package:tournament_app/widgets/home/marque.dart';
import 'package:tournament_app/widgets/home/match_category_widget.dart';
import 'package:tournament_app/widgets/home/today_match_widget.dart';
import 'package:tournament_app/widgets/home/upcoming_matches_widget.dart';
import 'package:tournament_app/providers/home_provider.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Initialize data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('=== Starting to load home data ===');
      final homeProvider = context.read<HomeProvider>();
      homeProvider.loadHomeData();

      // Ensure today matches and category matches are loaded
      homeProvider.fetchTodayMatches();
      homeProvider.fetchCategoryMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161829),
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            // Debug print for provider state
            debugPrint('=== Home Provider State ===');
            debugPrint('Is Loading: ${provider.isLoading}');
            debugPrint('Error: ${provider.error}');

            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF54A9EB)),
              );
            }

            if (provider.error != null) {
              debugPrint('=== Error in Home Page ===');
              debugPrint('Error message: ${provider.error}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading data',
                      style: TextStyle(color: Colors.red[100], fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('=== Retrying to load home data ===');
                        provider.loadHomeData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await provider.refreshData();
                await provider.fetchTodayMatches();
                await provider.fetchCategoryMatches();
              },
              color: const Color(0xFF54A9EB),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1) Image Slider - Now loads its own data
                    const ImageSliderWidget(),

                    const SizedBox(height: 20),

                    // 2) Marquee Text Widget - Now loads its own data
                    const ReusableMarqueeWidget(
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16,
                      height: 40,
                    ),

                    // 3) Match Category
                    const MatchCategoryWidget(),

                    const SizedBox(height: 24),

                    // 4) Today Match
                    const TodayMatchWidget(),

                    const SizedBox(height: 10),

                    // 5) Upcoming Matches (Category Matches)
                    const UpcomingMatchesWidget(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
