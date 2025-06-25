import 'package:flutter/material.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';

class LiveSupport extends StatelessWidget {
  const LiveSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'E-Sports IT live support',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF2962FF),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Tawk(
          directChatLink:
              'https://tawk.to/chat/685b6e3dee661a190cce8014/1iuiid8f0',
          visitor: TawkVisitor(name: 'E-Sports', email: 'sagor89089000@gmail.com'),
          onLoad: () {
            print('Hello Tawk!');
          },
          onLinkTap: (String url) {
            print(url);
          },
          placeholder: const Center(child: Text('Loading...')),
        ),
      ),
    );
  }
}
