class SettingsModel {
  //int itemsBeforeAd = 5;
  String showAdds;
  String loginMb;
  String commentMb;
  String stableVersion;
  String clicksBeforeAds;
  String registerMb;
  String availableData;
  String referMb;
  String historyb4adds;
  String postb4adds;
  String start_ads_count;
  String link_ads_url = "https://google.comR";
  String link_ads_count;

  SettingsModel(
      {required this.link_ads_url,
      required this.link_ads_count,
      required this.start_ads_count,
      required this.showAdds,
      required this.loginMb,
      required this.commentMb,
      required this.stableVersion,
      required this.clicksBeforeAds,
      required this.registerMb,
      required this.referMb,
      required this.availableData,
      required this.historyb4adds,
      required this.postb4adds});

  factory SettingsModel.fromjson(Map<String, dynamic> json) {
    return SettingsModel(
        link_ads_count: json['link_ads_count'],
        link_ads_url: json['link_ads_url'],
        start_ads_count: json['start_ads_count'],
        postb4adds: json['postb4adds'],
        historyb4adds: json['historyb4adds'],
        showAdds: json['showAdds'],
        loginMb: json['loginMb'],
        commentMb: json['commentMb'],
        stableVersion: json['stableVersion'],
        clicksBeforeAds: json['clicksBeforeAds'],
        registerMb: json['registerMb'],
        referMb: json['referMb'],
        availableData: json['availableData']);
  }
}
