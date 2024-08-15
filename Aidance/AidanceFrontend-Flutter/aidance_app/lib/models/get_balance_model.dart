class GetBalanceModel {
  String? address;
  String? balance;

  GetBalanceModel({this.address, this.balance});

  GetBalanceModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['balance'] = this.balance;
    return data;
  }
}
