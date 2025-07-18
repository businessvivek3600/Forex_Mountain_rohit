class FundHistoryEntry {
  final String requestId;
  final String date;
  final String paymentType;
  final String fundAmount;
  final String status;
  final String? proofFileUrl;

  FundHistoryEntry({
    required this.requestId,
    required this.date,
    required this.paymentType,
    required this.fundAmount,
    required this.status,
    this.proofFileUrl,
  });
}
