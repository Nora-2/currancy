part of 'currency_exchange_cubit.dart';

abstract class CurrencyExchangeState extends Equatable {
  const CurrencyExchangeState();

  @override
  List<Object> get props => [];
}

class CurrencyExchangeInitial extends CurrencyExchangeState {}

class CurrencyExchangeLoading extends CurrencyExchangeState {}

class CurrencyExchangeLoaded extends CurrencyExchangeState {
  final List<ExchangeRate> allExchangeRates;
  final int currentPage;
  final int itemsPerPage;

  const CurrencyExchangeLoaded({
    required this.allExchangeRates,
    this.currentPage = 1,
    this.itemsPerPage = 10,
  });

  int get totalPages => (allExchangeRates.length / itemsPerPage).ceil();
  bool get hasMorePages => currentPage < totalPages;

  List<ExchangeRate> get paginatedRates {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return allExchangeRates.sublist(
      startIndex.clamp(0, allExchangeRates.length),
      endIndex.clamp(0, allExchangeRates.length),
    );
  }

  CurrencyExchangeLoaded copyWith({
    List<ExchangeRate>? allExchangeRates,
    int? currentPage,
    int? itemsPerPage,
  }) {
    return CurrencyExchangeLoaded(
      allExchangeRates: allExchangeRates ?? this.allExchangeRates,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }

  @override
  List<Object> get props => [allExchangeRates, currentPage, itemsPerPage];
}

class CurrencyExchangeError extends CurrencyExchangeState {
  final String message;

  const CurrencyExchangeError({required this.message});

  @override
  List<Object> get props => [message];
}

class ExchangeRate extends Equatable {
  final DateTime date;
  final String fromCurrency;
  final String targetCurrency;
  final double rate;

  const ExchangeRate({
    required this.date,
    required this.fromCurrency,
    required this.targetCurrency,
    required this.rate,
  });

  String get formattedDate =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  List<Object> get props => [date, fromCurrency, targetCurrency, rate];
}