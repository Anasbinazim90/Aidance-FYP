class GetCampaignDataModel {
  int? campaignId;
  bool? campaignAcceptedOrNot;
  bool? timeEnded;
  String? maxCampaignDonationTotal;
  String? totalBeneficiary;
  String? maxReceivedDonationTotal;
  String? totalInFavorVoteCampaign;
  String? endTime;
  String? totalAgainstVoteCampaign;

  GetCampaignDataModel({
    this.campaignId,
    this.campaignAcceptedOrNot,
    this.timeEnded,
    this.maxCampaignDonationTotal,
    this.totalBeneficiary,
    this.maxReceivedDonationTotal,
    this.totalInFavorVoteCampaign,
    this.endTime,
    this.totalAgainstVoteCampaign,
  });

  // Factory constructor to create a Campaign object from a map
  GetCampaignDataModel.fromJson(Map<String, dynamic> json) {
    campaignId = json['campaignId'];
    campaignAcceptedOrNot = json['CampaignAcceptedOrNot'];
    timeEnded = json['TimeEnded'];
    maxCampaignDonationTotal = json['MaxCampaignDonation_Total'];
    totalBeneficiary = json['Total_Beneficiary'];
    maxReceivedDonationTotal = json['MaxRecievedDonation_Total'];
    totalInFavorVoteCampaign = json['TotalInFavorVoteCampaign'];
    endTime = json['endTime'];
    totalAgainstVoteCampaign = json['TotalAgainstVoteCampaign'];
  }

  // Method to convert a Campaign object to a map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['campaignId'] = this.campaignId;
    data['CampaignAcceptedOrNot'] = this.campaignAcceptedOrNot;
    data['TimeEnded'] = this.timeEnded;
    data['MaxCampaignDonation_Total'] = this.maxCampaignDonationTotal;
    data['Total_Beneficiary'] = this.totalBeneficiary;
    data['MaxRecievedDonation_Total'] = this.maxReceivedDonationTotal;
    data['TotalInFavorVoteCampaign'] = this.totalInFavorVoteCampaign;
    data['endTime'] = this.endTime;
    data['TotalAgainstVoteCampaign'] = this.totalAgainstVoteCampaign;
    return data;
  }
}
