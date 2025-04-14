import 'package:currency/src/core/models/model.dart';
import 'package:currency/src/core/utils/app_string.dart';
import 'package:currency/src/core/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
class ApiService {
  final Dio _dio;
  static const String _baseUrl = Constants.apiurl;
  final String _apiKey;

  ApiService({required String apiKey})
      : _apiKey = apiKey,
        _dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Accept': 'application/json'},
        )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        (error.message ?? 'Unknown network error');
        return handler.next(error);
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  Future<ExchangeRateModel> getExchangeRates({
    required DateTime startDate,
    required DateTime endDate,
    required String fromCurrency,
    required String targetCurrency,
  }) async {
    try {
      _validateInputs(startDate, endDate, fromCurrency, targetCurrency);

      final response = await _dio.get<Map<String, dynamic>>(
        '/timeframe',
        queryParameters: {
          'start_date': _formatDate(startDate),
          'end_date': _formatDate(endDate),
          'source': fromCurrency.toUpperCase(),
          'currencies': targetCurrency.toUpperCase(),
          'access_key': _apiKey,
        },
      );

      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      return ExchangeRateModel.fromJson(response.data!);
    } on DioException catch (e) {
      ('Network error: ${e.message}');
      rethrow;
    } on ArgumentError catch (e) {
      (e.message);
      rethrow;
    } catch (e) {
      ('An unexpected error occurred');
      rethrow;
    }
  }

  void _validateInputs(
    DateTime startDate,
    DateTime endDate,
    String fromCurrency,
    String targetCurrency,
  ) {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError(AppString.startdatebeforend);
    }

    if (fromCurrency.isEmpty || targetCurrency.isEmpty) {
      throw ArgumentError(AppString.currancysantempty);
    }

    if (fromCurrency.length != 3 || targetCurrency.length != 3) {
      throw ArgumentError('Currency codes must be 3 characters long');
    }
  }

 

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void dispose() {
    _dio.close();
  }
}