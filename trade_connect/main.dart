import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/trade_connect_model.dart';
import 'screens/market_news_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TradeConnectModel(),
      child: const TradeConnectApp(),
    ),
  );
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
      home: const MainNavigationScreen(),
    );
  }
}

// The selected bottom-navigation tab is UI state, not shared project data.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    MarketsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Markets',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TradeConnectModel>();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TradeConnect',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Market community feed',
            icon: const Icon(Icons.article_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MarketNewsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back, Trader'),
            const SizedBox(height: 5),
            const Text(
              'Connect. Trade. Learn.',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Market Watch',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model.markets.length,
                itemBuilder: (context, index) {
                  final market = model.markets[index];
                  return _marketCard(context, market);
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Trader Activity',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('${model.tradeCount} trades',
                    style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: model.activity.isEmpty
                  ? const Center(child: Text('No activity yet.'))
                  : ListView.builder(
                      itemCount: model.activity.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                              child: Icon(Icons.person)),
                          title: Text(model.activity[index]),
                          subtitle: const Text('TradeConnect activity'),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _marketCard(BuildContext context, Market market) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.read<TradeConnectModel>().selectMarket(market.symbol);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MarketDetailScreen()),
        );
      },
      child: Container(
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
            Text(market.symbol,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(market.change, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Tap for details', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TradeConnectModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markets',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Market community feed',
            icon: const Icon(Icons.article_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const MarketNewsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (model.watchedMarkets.isNotEmpty) ...[
            Text('Watchlist (${model.watchedMarkets.length})',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: model.watchedMarkets
                  .map((market) => Chip(label: Text(market.symbol)))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          ...model.markets.map(
            (market) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                    child: Icon(Icons.show_chart)),
                title: Text(market.symbol,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Market information'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(market.change,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      tooltip: market.isWatched
                          ? 'Remove from watchlist'
                          : 'Add to watchlist',
                      icon: Icon(market.isWatched
                          ? Icons.star
                          : Icons.star_border),
                      onPressed: () => context
                          .read<TradeConnectModel>()
                          .toggleWatched(market.symbol),
                    ),
                  ],
                ),
                onTap: () {
                  context
                      .read<TradeConnectModel>()
                      .selectMarket(market.symbol);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MarketDetailScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarketDetailScreen extends StatelessWidget {
  const MarketDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TradeConnectModel>();
    final market = model.selectedMarket;
    final marketTrades =
        model.trades.where((trade) => trade.symbol == market.symbol).toList();

    return Scaffold(
      appBar: AppBar(title: Text(market.symbol)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(market.symbol,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Today: ${market.change}',
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 15),
                    const Text(
                        'Market information is read directly from the shared Provider model.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Your trades for this market',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (marketTrades.isEmpty)
              const Text('No trades for this market yet.')
            else
              ...marketTrades.map(
                (trade) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle),
                    title: Text('${trade.direction} order'),
                    subtitle: Text(
                        '${trade.quantity} ${trade.symbol} • ${trade.createdAt.toLocal()}'),
                  ),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TradeScreen()),
                  );
                },
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Create Trade'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  String _direction = 'Long';
  final TextEditingController _quantityController =
      TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _submitTrade() {
    final quantity = double.tryParse(_quantityController.text.trim());

    if (quantity == null || !quantity.isFinite || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid quantity greater than 0.'),
        ),
      );
      return;
    }

    final model = context.read<TradeConnectModel>();
    final symbol = model.selectedMarketSymbol;

    // The model stores the trade and notifies Home, Markets, and Profile.
    model.addTrade(
      symbol: symbol,
      direction: _direction,
      quantity: quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '$_direction order created for ${quantity.toStringAsFixed(2)} $symbol.'),
      ),
    );

    Navigator.pop(context); // Navigation only; no data is passed back.
  }

  @override
  Widget build(BuildContext context) {
    final market = context.watch<TradeConnectModel>().selectedMarket;

    return Scaffold(
      appBar: AppBar(title: Text('Trade ${market.symbol}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(market.symbol,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Current change: ${market.change}'),
            const SizedBox(height: 25),
            const Text('Trade Direction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'Long',
                    label: Text('Long'),
                    icon: Icon(Icons.trending_up)),
                ButtonSegment(
                    value: 'Short',
                    label: Text('Short'),
                    icon: Icon(Icons.trending_down)),
              ],
              selected: {_direction},
              onSelectionChanged: (selection) {
                setState(() => _direction = selection.first);
              },
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _quantityController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submitTrade,
                child: const Text('Submit Trade'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TradeConnectModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text('Trader',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Portfolio'),
              subtitle: Text('${model.tradeCount} completed trades'),
            ),
          ),
          const SizedBox(height: 12),
          Text('Trade History (${model.trades.length})',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (model.trades.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('No trades yet. Create a trade from the Markets tab.'),
              ),
            )
          else
            ...model.trades.map(
              (trade) => Card(
                child: ListTile(
                  leading: Icon(
                    trade.direction == 'Long'
                        ? Icons.trending_up
                        : Icons.trending_down,
                  ),
                  title: Text('${trade.direction} ${trade.symbol}'),
                  subtitle: Text(
                      '${trade.quantity} units • ${trade.createdAt.toLocal()}'),
                ),
              ),
            ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              subtitle: Text('Manage app preferences'),
            ),
          ),
        ],
      ),
    );
  }
}
