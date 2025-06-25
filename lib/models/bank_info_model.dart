class BankInfoModel {
  final List<BankInfo> data;

  BankInfoModel({required this.data});

  factory BankInfoModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> bankList = json['data'] ?? [];
    List<BankInfo> banks =
        bankList.map((bank) => BankInfo.fromJson(bank)).toList();
    return BankInfoModel(data: banks);
  }
}

class BankInfo {
  final int id;
  final String bankName;
  final String accountNumber;
  final String createdAt;
  final String updatedAt;

  BankInfo({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      id: json['id'] ?? 0,
      bankName: json['bank_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
