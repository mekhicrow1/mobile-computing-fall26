import 'package:flutter/material.dart';

void main() {
  runApp(const TradeConnectApp());
}

class TradeConnectApp extends StatelessWidget {
  const TradeConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TradeConnect',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF065A82),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TradeConnect',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              'Welcome back, Trader',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Connect. Trade. Learn.',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // HORIZONTAL SCROLLING SECTION
            const Text(
              'Market Watch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _marketCard('NASDAQ', '+1.24%'),
                  _marketCard('AAPL', '+0.82%'),
                  _marketCard('NVDA', '+2.15%'),
                  _marketCard('TSLA', '-0.43%'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // VERTICAL LIST
            const Text(
              'Trader Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  final traders = [
                    'Alex entered a long position on NVDA',
                    'Jordan closed a trade on AAPL',
                    'Chris opened a short position on TSLA',
                    'Taylor entered a long position on MSFT',
                    'Morgan shared a new NASDAQ setup',
                  ];

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        traders[index],
                      ),
                      subtitle: const Text(
                        'Just now • NASDAQ',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _marketCard(String symbol, String change) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blueGrey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            symbol,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
