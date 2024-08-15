class GetNgoDataModel {
  bool? ifngoExist;
  bool? ngoAccepted;
  String? totalAgainstVote;
  String? totalInFavorVote;

  GetNgoDataModel(
      {this.ifngoExist,
      this.ngoAccepted,
      this.totalAgainstVote,
      this.totalInFavorVote});

  GetNgoDataModel.fromJson(Map<String, dynamic> json) {
    ifngoExist = json['ifngoExist'];
    ngoAccepted = json['ngoAccepted'];
    totalAgainstVote = json['TotalAgainstVote'];
    totalInFavorVote = json['TotalInFavorVote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ifngoExist'] = this.ifngoExist;
    data['ngoAccepted'] = this.ngoAccepted;
    data['TotalAgainstVote'] = this.totalAgainstVote;
    data['TotalInFavorVote'] = this.totalInFavorVote;
    return data;
  }
}
