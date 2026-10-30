import 'package:flutter/foundation.dart';

/// A market record shared by every screen through Provider.
@immutable
class Market {
  final String symbol;
  final String change;
  final bool isWatched;

  const Market({
    required this.symbol,
    required this.change,
    this.isWatched = false,
  });

  Market copyWith({String? change, bool? isWatched}) {
    return Market(
      symbol: symbol,
      change: change ?? this.change,
      isWatched: isWatched ?? this.isWatched,
    );
  }
}

/// A completed trade stored in the shared model.
@immutable
class Trade {
  final String symbol;
  final String direction;
  final double quantity;
  final DateTime createdAt;

  const Trade({
    required this.symbol,
    required this.direction,
    required this.quantity,
    required this.createdAt,
  });
}

/// The single source of truth for TradeConnect's shared application data.
class TradeConnectModel extends ChangeNotifier {
  final List<Market> _markets = [
    const Market(symbol: 'NASDAQ', change: '+1.24%'),
    const Market(symbol: 'AAPL', change: '+0.82%'),
    const Market(symbol: 'NVDA', change: '+2.15%'),
    const Market(symbol: 'TSLA', change: '-0.43%'),
    const Market(symbol: 'MSFT', change: '+1.10%'),
    const Market(symbol: 'AMZN', change: '+0.67%'),
  ];

  final List<Trade> _trades = [];

  final List<String> _activity = [
    'Alex entered a long position on NVDA',
    'Jordan closed a trade on AAPL',
    'Chris opened a short position on TSLA',
    'Taylor entered a long position on MSFT',
    'Morgan shared a new NASDAQ setup',
  ];

  String _selectedMarketSymbol = 'NASDAQ';

  List<Market> get markets => List.unmodifiable(_markets);
  List<Trade> get trades => List.unmodifiable(_trades);
  List<String> get activity => List.unmodifiable(_activity);
  String get selectedMarketSymbol => _selectedMarketSymbol;
  int get tradeCount => _trades.length;

  Market get selectedMarket {
    return _markets.firstWhere(
      (market) => market.symbol == _selectedMarketSymbol,
      orElse: () => _markets.first,
    );
  }

  List<Market> get watchedMarkets =>
      _markets.where((market) => market.isWatched).toList();

  void selectMarket(String symbol) {
    if (!_markets.any((market) => market.symbol == symbol)) return;
    _selectedMarketSymbol = symbol;
    notifyListeners();
  }

  /// Changes a shared market value so the update is visible on Home and Markets.
  void updateMarketChange(String symbol, String newChange) {
    final index = _markets.indexWhere((market) => market.symbol == symbol);
    if (index == -1) return;
    _markets[index] = _markets[index].copyWith(change: newChange);
    notifyListeners();
  }

  void toggleWatched(String symbol) {
    final index = _markets.indexWhere((market) => market.symbol == symbol);
    if (index == -1) return;
    final market = _markets[index];
    _markets[index] = market.copyWith(isWatched: !market.isWatched);
    notifyListeners();
  }

  void addTrade({
    required String symbol,
    required String direction,
    required double quantity,
  }) {
    final trade = Trade(
      symbol: symbol,
      direction: direction,
      quantity: quantity,
      createdAt: DateTime.now(),
    );
    _trades.insert(0, trade);
    _activity.insert(
      0,
      'You opened a $direction position on $symbol (${quantity.toStringAsFixed(2)} units)',
    );
    notifyListeners();
  }
}
