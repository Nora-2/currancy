import 'package:currency/src/core/utils/app_colors.dart';
import 'package:currency/src/core/utils/app_string.dart';
import 'package:currency/src/features/currency/presentation/cubit/currency_exchange_cubit.dart';
import 'package:flutter/material.dart';
class ExchangeRatesTable extends StatelessWidget {
  final CurrencyExchangeLoaded state;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  const ExchangeRatesTable({
    required this.state,
    required this.onNextPage,
    required this.onPreviousPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Important fix
      children: [
        _buildTableHeader(context),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, // Set a max height
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: state.paginatedRates.length,
            itemBuilder: (context, index) => _buildTableRow(state.paginatedRates[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        border: const Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:18,right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Text(AppString.date ,textAlign: TextAlign.left , style: const TextStyle(color: AppColors.black))),
            Expanded(flex: 1, child: Text(AppString.from, style: const TextStyle(color: AppColors.black))),
            Expanded(flex: 1, child: Text(AppString.to, style: const TextStyle(color: AppColors.black))),
            Expanded(flex: 1, child: Text(AppString.price, textAlign: TextAlign.right,style: const TextStyle(color: AppColors.black,))),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(ExchangeRate rate) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(rate.formattedDate)),
          Expanded(flex: 1, child: Text(rate.fromCurrency)),
          Expanded(flex: 1, child: Text(rate.targetCurrency)),
          Expanded(
            flex: 1,
            child: Text(
              rate.rate.toStringAsFixed(4),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}