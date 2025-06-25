import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/providers/balance_provider.dart';

class BalanceDisplay extends StatelessWidget {
  final TextStyle? textStyle;
  final bool showCurrency;
  final String currencySymbol;
  final bool showLoader;
  final Widget? prefix;
  final Widget? suffix;

  const BalanceDisplay({
    Key? key,
    this.textStyle,
    this.showCurrency = true,
    this.currencySymbol = 'BDT',
    this.showLoader = true,
    this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BalanceProvider>(
      builder: (context, balanceProvider, child) {
        if (balanceProvider.isLoading && showLoader) {
          return SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefix != null) prefix!,
            if (prefix != null) SizedBox(width: 4),
            Text(
              showCurrency
                  ? '$currencySymbol ${balanceProvider.balance}'
                  : balanceProvider.balance,
              style:
                  textStyle ??
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (suffix != null) SizedBox(width: 4),
            if (suffix != null) suffix!,
          ],
        );
      },
    );
  }
}

// Helper function to refresh balance from anywhere
Future<bool> refreshBalance(BuildContext context) async {
  final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
  return await balanceProvider.fetchBalance();
}
