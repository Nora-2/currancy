// lib/features/currency_exchange/presentation/pages/currency_exchange_page.dart
import 'package:currency/src/core/services/apiservice.dart';
import 'package:currency/src/core/utils/constants.dart';
import 'package:currency/src/features/currency/presentation/cubit/currency_exchange_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/currency_exchange_view.dart';

class CurrencyExchangePage extends StatelessWidget {
  const CurrencyExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrencyExchangeCubit(apiService: ApiService(apiKey: Constants.apikey)),
      child: const CurrencyExchangeView(),
    );
  }
}

