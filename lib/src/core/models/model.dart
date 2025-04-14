class ExchangeRateModel {
  final bool success;
  final String? terms;
  final String? privacy;
  final bool? timeframe;
  final String? source;
  final Map<String, Map<String, double>> quotes;
  final Map<String, dynamic>? error;

  ExchangeRateModel({
    required this.success,
    this.terms,
    this.privacy,
    this.timeframe,
    this.source,
    required this.quotes,
    this.error,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    if (json['success'] == false) {
      return ExchangeRateModel(
        success: false,
        quotes: {},
        error: json['error'] as Map<String, dynamic>?,
      );
    }

    // Improved quotes parsing with more type safety
    final quotesMap = <String, Map<String, double>>{};
    final rawQuotes = json['quotes'] as Map<String, dynamic>?;

    if (rawQuotes != null) {
      for (final entry in rawQuotes.entries) {
        final date = entry.key;
        final currencies = entry.value as Map<String, dynamic>;
        final currencyMap = <String, double>{};

        for (final currencyEntry in currencies.entries) {
          final currencyCode = currencyEntry.key;
          final rate = currencyEntry.value;
          currencyMap[currencyCode] = rate is int ? rate.toDouble() : rate as double;
        }
        quotesMap[date] = currencyMap;
      }
    }

    return ExchangeRateModel(
      success: json['success'] as bool? ?? false,
      terms: json['terms'] as String?,
      privacy: json['privacy'] as String?,
      timeframe: json['timeframe'] as bool?,
      source: json['source'] as String?,
      quotes: quotesMap,
    );
  }
}