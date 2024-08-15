class GetCampaignModel {
  String? ngoRegistrationNo;
  String? address;
  String? votingHours;
  int? totalBeneficiary;
  String? tokenUri;
  String? maxDonation;

  GetCampaignModel({
    this.ngoRegistrationNo,
    this.address,
    this.votingHours,
    this.totalBeneficiary,
    this.tokenUri,
    this.maxDonation,
  });

  GetCampaignModel.fromJson(Map<String, dynamic> json) {
    ngoRegistrationNo = json['ngoRegistrationNo'];
    address = json['address'];
    votingHours = json['votingHours'];
    totalBeneficiary = json['totalBeneficiary'];
    tokenUri = json['tokenUri'];
    maxDonation = json['maxDonation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ngoRegistrationNo'] = this.ngoRegistrationNo;
    data['address'] = this.address;
    data['votingHours'] = this.votingHours;
    data['totalBeneficiary'] = this.totalBeneficiary;
    data['tokenUri'] = this.tokenUri;
    data['maxDonation'] = this.maxDonation;
    return data;
  }
}
