class NGOCampaignModel {
  List<String> cover_photo;
  List<Map<String, String>>? additional_docs;
  String title;
  String description;
  String story;
  String name_of_recipient;
  String total_donation_required;
  String donation_expiration_date;
  String total_no_of_beneficiaries;
  String fund_usage_plan;
  String ngoName;
  String email;
  String registrationID;
  String status;
  String? tokenUri;
  String? tokenId;
  String total_donations_received;

  NGOCampaignModel(
      {required this.cover_photo,
      required this.additional_docs,
      required this.title,
      required this.description,
      required this.story,
      required this.name_of_recipient,
      required this.total_donation_required,
      required this.donation_expiration_date,
      required this.fund_usage_plan,
      required this.ngoName,
      required this.email,
      required this.registrationID,
      required this.status,
      required this.total_no_of_beneficiaries,
      this.tokenId,
      this.tokenUri,
      required this.total_donations_received});

  factory NGOCampaignModel.fromJson(Map<String, dynamic> json) {
    return NGOCampaignModel(
      cover_photo: List<String>.from(json['cover_photo']),
      additional_docs: json['additional_docs'] != null
          ? List<Map<String, String>>.from(json['additional_docs']
              .map((doc) => Map<String, String>.from(doc)))
          : null,
      title: json['title'],
      description: json['description'],
      story: json['story'],
      name_of_recipient: json['name_of_recipient'],
      total_donation_required: json['total_donation_required'],
      donation_expiration_date: json['donation_expiration_date'],
      fund_usage_plan: json['fund_usage_plan'],
      ngoName: json['ngoName'],
      email: json['email'],
      registrationID: json['registrationID'],
      status: json['status'],
      total_no_of_beneficiaries: json['total_no_of_beneficiaries'],
      tokenUri: json['tokenUri'],
      tokenId: json['tokenId'],
      total_donations_received: json['total_donations_received'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cover_photo': cover_photo,
      'additional_docs': additional_docs,
      'title': title,
      'description': description,
      'story': story,
      'name_of_recipient': name_of_recipient,
      'total_donation_required': total_donation_required,
      'donation_expiration_date': donation_expiration_date,
      'fund_usage_plan': fund_usage_plan,
      'ngoName': ngoName,
      'email': email,
      'registrationID': registrationID,
      'status': status,
      'total_no_of_beneficiaries': total_no_of_beneficiaries,
      'tokenUri': tokenUri,
      'tokenId': tokenId,
      'total_donations_received': total_donations_received
    };
  }
}
