import 'package:dataminners/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets.dart';
import 'package:startapp/startapp.dart';

var _interstitialAd;
var _isInterstitialAdReady = false;

int add_count = 0;
void adCounter() {
  print("hhhh");
  if (add_count > int.parse(settingsModel.clicksBeforeAds)) {
    add_count = 0;

    loadInterstitialAd();

    ///showMessage(context, "Ads", "Ads", 1);
    //print("add cont");
  } else {
    add_count++;
    //print(add_count);
  }
}

int start_add_count = 0;
void startAdsCounter() async {
  // print(
  //     "KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
  if (start_add_count > int.parse(settingsModel.start_ads_count) &&
      settingsModel.showAdds == "1") {
    start_add_count = 0;

    await StartApp.showInterstitialAd();

    ///showMessage(context, "Ads", "Ads", 1);
    //print("add cont");
  } else {
    start_add_count++;
    //print(add_count);

  }
}

void loadInterstitialAd() {
  InterstitialAd.load(
    adUnitId: 'ca-app-pub-7712827866171461/5238008569',
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        _interstitialAd = ad;

        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            //Navigator.pop(context);
          },
        );

        _isInterstitialAdReady = true;
      },
      onAdFailedToLoad: (err) {
        print('Failed to load an interstitial ad: ${err.message}');
        _isInterstitialAdReady = false;
      },
    ),
  );
  _interstitialAd?.show();
}
