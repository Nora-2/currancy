import 'package:bloc/bloc.dart';
import 'package:currency/src/core/services/apiservice.dart';
import 'package:equatable/equatable.dart';

part 'currency_exchange_state.dart';

class CurrencyExchangeCubit extends Cubit<CurrencyExchangeState> {
  final ApiService apiService;
  static const int itemsPerPage = 10;

  CurrencyExchangeCubit({required this.apiService})
      : super(CurrencyExchangeInitial());

  Future<void> fetchExchangeRates({
    required DateTime startDate,
    required DateTime endDate,
    required String fromCurrency,
    required String targetCurrency,
    bool isLoadMore = false,
  }) async {
    try {
      if (!isLoadMore) {
        emit(CurrencyExchangeLoading());
      }

      if (fromCurrency.isEmpty || targetCurrency.isEmpty) {
        throw ArgumentError('Currency codes cannot be empty');
      }

      final normalizedFromCurrency = fromCurrency.toUpperCase();
      final normalizedTargetCurrency = targetCurrency.toUpperCase();

      final model = await apiService.getExchangeRates(
        startDate: startDate,
        endDate: endDate,
        fromCurrency: normalizedFromCurrency,
        targetCurrency: normalizedTargetCurrency,
      );

      final exchangeRates = _processQuotes(
        model.quotes,
        normalizedFromCurrency,
        normalizedTargetCurrency,
      );

      if (!isLoadMore) {
        emit(CurrencyExchangeLoaded(
          allExchangeRates: exchangeRates,
          currentPage: 1,
        ));
      } else if (state is CurrencyExchangeLoaded) {
        final currentState = state as CurrencyExchangeLoaded;
        emit(currentState.copyWith(
          allExchangeRates: [...currentState.allExchangeRates, ...exchangeRates],
        ));
      }
    } catch (e) {
      emit(CurrencyExchangeError(
        message: e is ArgumentError 
            ? e.message 
            : 'Failed to fetch exchange rates. Please try again.',
      ));
    }
  }

  List<ExchangeRate> getCurrentPageRecords() {
    if (state is! CurrencyExchangeLoaded) return [];
    
    final currentState = state as CurrencyExchangeLoaded;
    final startIndex = (currentState.currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= currentState.allExchangeRates.length) {
      return [];
    }

    if (endIndex > currentState.allExchangeRates.length) {
      return currentState.allExchangeRates.sublist(startIndex);
    }

    return currentState.allExchangeRates.sublist(startIndex, endIndex);
  }

  void nextPage() {
    if (state is! CurrencyExchangeLoaded) return;

    final currentState = state as CurrencyExchangeLoaded;
    if (currentState.currentPage < currentState.totalPages) {
      emit(currentState.copyWith(currentPage: currentState.currentPage + 1));
    }
  }

  void previousPage() {
    if (state is! CurrencyExchangeLoaded) return;

    final currentState = state as CurrencyExchangeLoaded;
    if (currentState.currentPage > 1) {
      emit(currentState.copyWith(currentPage: currentState.currentPage - 1));
    }
  }

  List<ExchangeRate> _processQuotes(
    Map<String, Map<String, double>> quotes,
    String fromCurrency,
    String targetCurrency,
  ) {
    final currencyPair = '$fromCurrency$targetCurrency';
    
    return quotes.entries
        .map((entry) => ExchangeRate(
              date: DateTime.parse(entry.key),
              fromCurrency: fromCurrency,
              targetCurrency: targetCurrency,
              rate: entry.value[currencyPair] ?? 0.0,
            ))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}