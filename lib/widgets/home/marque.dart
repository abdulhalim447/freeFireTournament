import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/providers/marquee_text_provider.dart';

/// একটি পুনঃব্যবহারযোগ্য Marquee উইজেট যা অ্যাপের যেকোনো জায়গায় ব্যবহার করা যাবে।
///
/// এই উইজেটটি একটি `text` প্যারামিটার অবশ্যই গ্রহণ করে।
/// এছাড়াও কিছু অপশনাল প্যারামিটার যেমন `backgroundColor`, `textColor`, `fontSize`
/// এবং `height` পরিবর্তন করার সুযোগ দেয়।

class ReusableMarqueeWidget extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double height;

  const ReusableMarqueeWidget({
    super.key,
    this.backgroundColor = const Color(
      0xFF0D47A1,
    ), // ডিফল্ট ব্যাকগ্রাউন্ড রঙ ( koyekti nil )
    this.textColor = Colors.white, // ডিফল্ট টেক্সটের রঙ
    this.fontSize = 18.0, // ডিফল্ট ফন্ট সাইজ
    this.height = 40.0, // ডিফল্ট উচ্চতা
  });

  @override
  State<ReusableMarqueeWidget> createState() => _ReusableMarqueeWidgetState();
}

class _ReusableMarqueeWidgetState extends State<ReusableMarqueeWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('=== MarqueeWidget: Loading marquee text ===');
      context.read<MarqueeTextProvider>().fetchMarqueeText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarqueeTextProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Container(
            height: widget.height,
            color: widget.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        if (provider.error != null) {
          return Container(
            height: widget.height,
            color: widget.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Text(
                'Error loading announcements',
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.fontSize,
                ),
              ),
            ),
          );
        }

        return Container(
          height: widget.height,
          color: widget.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Marquee(
            text: provider.marqueeText,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
            ),
            velocity: 80.0, // স্ক্রলের গতি
            blankSpace: 30.0, // টেক্সটের শেষে ফাঁকা স্থান
            pauseAfterRound: const Duration(
              seconds: 1,
            ), // প্রতি রাউন্ডের পর বিরতি
            crossAxisAlignment:
                CrossAxisAlignment.center, // টেক্সটকে উল্লম্বভাবে মাঝখানে রাখে
          ),
        );
      },
    );
  }
}
