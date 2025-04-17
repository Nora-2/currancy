import 'package:currency/src/core/utils/app_assets.dart';
import 'package:currency/src/core/utils/app_colors.dart';
import 'package:currency/src/core/utils/app_string.dart';
import 'package:currency/src/core/utils/constants.dart';
import 'package:currency/src/features/currency/presentation/cubit/currency_exchange_cubit.dart';
import 'package:currency/src/features/currency/presentation/widgets/exchange_rate_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CurrencyExchangeView extends StatefulWidget {
  const CurrencyExchangeView({super.key});

  @override
  State<CurrencyExchangeView> createState() => _CurrencyExchangeViewState();
}

class _CurrencyExchangeViewState extends State<CurrencyExchangeView> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 14));
  DateTime _endDate = DateTime.now();
  String _fromCurrency = AppString.usd;
  String _targetCurrency = AppString.egp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               const SizedBox(height: 20),
              buildFilterSection(),
              const SizedBox(height: 20),
              buildResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterSection() {
    return Card(
      elevation: 4,
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              AppString.select,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            buildDateRangePicker(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: buildCurrencyDropdown(AppString.from, true)),
                const SizedBox(width: 16),
                Expanded(child: buildCurrencyDropdown(AppString.target, false)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
               
              ),
              onPressed: fetchRates,
              child: const Text(AppString.search,style: TextStyle(color: AppColors.black,fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCurrencyDropdown(String label, bool isFromCurrency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label${AppString.currency}'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          dropdownColor: AppColors.white,
          
          iconEnabledColor: AppColors.primaryColor,
          value: isFromCurrency ? _fromCurrency : _targetCurrency,
          items: Constants.currencies.map((currency) {
            return DropdownMenuItem(
              
              value: currency,
              child: Text(currency),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (isFromCurrency) {
                _fromCurrency = value!;
              } else {
                _targetCurrency = value!;
              }
            });
          },
          decoration:  InputDecoration(
            border: OutlineInputBorder(),
            
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            focusColor: AppColors.white,
            
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.black),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        ),
      ],
    );
  }

  Widget buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppString.dateRange),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _showDatePicker(true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  child:  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(DateFormat('yyyy-MM-dd').format(_startDate)),
      Icon(Icons.calendar_today, 
           size: 20, 
           color: AppColors.primaryColor),
    ],),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(AppString.to),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _showDatePicker(false),
                child: InputDecorator(
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  child:  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(DateFormat('yyyy-MM-dd').format(_endDate)),
      Icon(Icons.calendar_today, 
           size: 20, 
           color: AppColors.primaryColor),
    ],),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDatePicker(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }


  Widget buildResultsSection() {
  return BlocBuilder<CurrencyExchangeCubit, CurrencyExchangeState>(
    builder: (context, state) {
      if (state is CurrencyExchangeInitial) {
        return Column(
          children: [
            SizedBox(height: 30,),
            Image.asset(AppImages.cover, fit: BoxFit.cover),
          ],
        );
      } else if (state is CurrencyExchangeLoading) {
        return  Center(child: LottieBuilder.asset(AppImages.loading),);
      } else if (state is CurrencyExchangeError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImages.error, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Text(state.message),
            ],
          ),
        );
      } else if (state is CurrencyExchangeLoaded) {
        final cubit = context.read<CurrencyExchangeCubit>();
        return Column(
          mainAxisSize: MainAxisSize.min, // Important fix
          children: [
            ExchangeRatesTable(
              state: state,
              onNextPage: cubit.nextPage,
              onPreviousPage: cubit.previousPage,
            ),
            const SizedBox(height: 16),
            _buildPaginationControls(context, state, cubit),
          ],
        );
      }
      return const SizedBox.shrink();
    },
  );
}

Widget _buildPaginationControls(
  BuildContext context,
  CurrencyExchangeLoaded state,
  CurrencyExchangeCubit cubit,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${AppString.page} ${state.currentPage} ${AppString.of} ${state.totalPages}',style: TextStyle(color: AppColors.black),),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left,color: AppColors.black,),
              onPressed: state.currentPage > 1 ? cubit.previousPage : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right,color: AppColors.black),
              onPressed: state.hasMorePages ? cubit.nextPage : null,
            ),
          ],
        ),
      ],
    ),
  );
}
  void fetchRates() {
    if (_startDate.isAfter(_endDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppString.startdatebeforend)),
      );
      return;
    }

    context.read<CurrencyExchangeCubit>().fetchExchangeRates(
          startDate: _startDate,
          endDate: _endDate,
          fromCurrency: _fromCurrency,
          targetCurrency: _targetCurrency,
        );
  }
}
