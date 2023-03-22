import 'dart:convert';

class MyWallet {
  double amount;
  double appNet;
  
  MyWallet({
    required this.amount,
    required this.appNet,
  });

  MyWallet copyWith({
    double? amount,
    double? appNet,
  }) {
    return MyWallet(
      amount: amount ?? this.amount,
      appNet: appNet ?? this.appNet,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'amount': amount});
    result.addAll({'appNet': appNet});
  
    return result;
  }

  factory MyWallet.fromMap(Map<String, dynamic> map) {
    return MyWallet(
      amount: map['amount']?.toDouble() ?? 0.0,
      appNet: map['appNet']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyWallet.fromJson(String source) => MyWallet.fromMap(json.decode(source));

  @override
  String toString() => 'MyWallet(amount: $amount, appNet: $appNet)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MyWallet &&
      other.amount == amount &&
      other.appNet == appNet;
  }

  @override
  int get hashCode => amount.hashCode ^ appNet.hashCode;
}
