class GetAddressModel {
  String? address;

  GetAddressModel({this.address});

  GetAddressModel.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address'] = this.address;
    return data;
  }
}
