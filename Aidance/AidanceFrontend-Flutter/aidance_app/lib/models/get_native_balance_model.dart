class GetNativeBalanceModel {
  String? balance;
  String? symbol;

  GetNativeBalanceModel({this.symbol, this.balance});

  GetNativeBalanceModel.fromJson(Map<String, dynamic> json) {
    balance = json['Balance'];
    symbol = json['Symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Balance'] = this.balance;
    data['Symbol'] = this.symbol;
    return data;
  }
}
