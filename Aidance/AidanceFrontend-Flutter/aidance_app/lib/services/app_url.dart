class AppUrl {
  // this is our base url
  static String baseURL = 'https://aidance-backend.vercel.app/api/';

  // static String baseURL = 'http://localhost:3000/api/';
  // 'https://k4xqpj8h-3091.asse.devtunnels.ms/api/v1/';

  static String getBalance = baseURL + 'balanceOf';
  static String getnativeBalance = baseURL + 'getaccountBalance';
  static String getAddress = baseURL + 'getaddress';
  static String transferTokens = baseURL + 'transfertokens';
  static String registerNgo = baseURL + 'ngo/registerNgo';
  static String confirmNgoRegistration = baseURL + 'ngo/confirmNgoRegistration';
  static String getFavorVotes = baseURL + 'ngo/ngoInFavorVotes';
  static String getAgainstVotes = baseURL + 'ngo/ngoAgainstVotes';
  static String voteForNGO = baseURL + 'ngo/voteForNGO';
  static String voteAgainstNGO = baseURL + 'ngo/voteAgainstNGO';
  static String getNgoData = baseURL + 'ngo/getNgoData';
  static String isNgoVoted = baseURL + 'ngo/ngoVoted';

  //Campaign Apis
  static String createCampaign = baseURL + 'campaign/createCampaign';
  static String campaignEndTime = baseURL + 'campaign/campaignEndTime';
  static String maxCampaignDonation = baseURL + 'campaign/maxCampaignDonation';
  static String campaignTotalBeneficiary =
      baseURL + 'campaign/campaignTotalBeneficiary';
  static String campaignAgainstVotes =
      baseURL + 'campaign/campaignAgainstVotes';
  static String campaignFavorVotes = baseURL + 'campaign/campaignFavorVotes';
  static String campaignRecievedDonation =
      baseURL + 'campaign/campaignRecievedDonation';
  static String voteForCampaign = baseURL + 'campaign/voteForCampaign';
  static String voteAgainstCampaign = baseURL + 'campaign/voteAgainstCampaign';
  static String isVotingPeriodEnd = baseURL + 'campaign/isVotingPeriodEnd';
  static String confirmCampaign = baseURL + 'campaign/confirmCampaign';
  static String getCampaignData = baseURL + 'campaign/getCampaignData';
  static String isCampaignVoted = baseURL + 'campaign/campaignVoted';

  //Donation
  static String donateAmount = baseURL + 'Donation/donateAmount';
  static String claimFunds = baseURL + 'Donation/claimFunds';
  static String createVoucher = baseURL + 'Donation/createVoucher';
  static String donatoToCampaign = baseURL + 'Donation/donateAmount';

  // static String getaccountBalance = baseURL + 'getaccountBalance';

  // static String isVotingPeriodEnd = baseURL + 'ngo/campaign/isVotingPeriodEnd';
}
