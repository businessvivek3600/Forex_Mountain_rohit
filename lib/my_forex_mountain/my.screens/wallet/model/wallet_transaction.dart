

class WalletTransaction {
  final String date;
  final String description;
  final String amountIn;
  final String amountOut;
  final String balance;

  WalletTransaction({
    required this.date,
    required this.description,
    required this.amountIn,
    required this.amountOut,
    required this.balance,
  });
}
