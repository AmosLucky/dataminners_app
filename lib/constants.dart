import 'dart:async';
import 'dart:convert';

import 'package:dataminners/models/menu_model.dart';
import 'package:dataminners/models/post_model.dart';
import 'package:dataminners/models/settings_model.dart';
import 'package:dataminners/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

String balance = "";
//old app id = ca-app-pub-7712827866171461~3179160742
//old banner-id  ca-app-pub-7712827866171461/1490335243
//old inerstitai add ca-app-pub-7712827866171461/5238008569

////////new ads detais////////

//new app id ca-app-pub-2409697587470650~7149358596
//new banner - id ca-app-pub-2409697587470650/2205806068
//new interstitial add ca-app-pub-2409697587470650/9701152701

var lightGrey = const Color(0xffe1e1e1);
const primaryColor = Color(0xFF6F35A5);
var _interstitialAd;
var _isInterstitialAdReady = false;
var appUrl = " https://play.google.com/store/apps/details?id=dataminners.com";
var appName = "DataMinners";
var appVersion = 7;

// var primaryColor = Colors.blue[900];
const kPrimaryLightColor = Color(0xFFF1E6FF);
const whiteColor = Color(0xFFFFFFFF);
var redColor = Colors.red;
var blackColor = Colors.black;
var rootDomain = "https://www.dataminners.com/dataminners/";
UserModel userModel = new UserModel(
    id: "o",
    username: "",
    suspended: "",
    phoneNumber: "",
    email: "",
    balance: "",
    isVerified: "",
    accessToken: "");
SettingsModel settingsModel = new SettingsModel(
    link_ads_count: "",
    link_ads_url: "",
    showAdds: "",
    start_ads_count: "",
    loginMb: "",
    commentMb: "",
    stableVersion: "",
    clicksBeforeAds: "",
    registerMb: "",
    referMb: "",
    availableData: "",
    postb4adds: "",
    historyb4adds: "");
MenuModel? menuModel;
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
var menu;

class ShowPreloader {
  //bool isShow = true;
  // ShowPreloader({required this.show});
  Widget showPreLoader(bool isShow) {
    return Container(
      child: isShow ? Image.asset("assets/images/item1.png") : Container(),
    );
  }

  // stopPreloader() {
  //   // setState(() {
  //   isShow = false;
  //   //   });
  // }
}

void setEasyLoading(var EasyLoading) {
  EasyLoading
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..displayDuration = const Duration(seconds: 20)
    ..backgroundColor = primaryColor
    ..loadingStyle = EasyLoadingStyle.light;
}

showMessage(
  BuildContext context,
  title,
  msg,
  int type,
) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Container(
      //height: 34,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            type == 1
                ? "assets/images/success1.png"
                : "assets/images/error.png",
            width: 100,
            height: 100,
          ),
          Text(msg)
        ],
      ),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

cancelPreLoader() {
  Timer(Duration(seconds: 3), () {
    EasyLoading.dismiss();
  });
}

LCS(url) async {
  //print(userModel.accessToken);
  var request = await http.get(Uri.parse(url));
  if (request.statusCode == 200) {
    print(request.body);
    var response = jsonDecode(request.body);
    if (response['status']) {
      Fluttertoast.showToast(msg: "Success");
    } else {
      Fluttertoast.showToast(msg: "Error");
    }
  } else {
    Fluttertoast.showToast(msg: "Error");
  }
}

sharePosts(content) async {
  Share.share(content);
  // final FlutterShareMe flutterShareMe = FlutterShareMe();
  // var response = await flutterShareMe.shareToSystem(msg: msg);
}

refreshData(BuildContext context) async {
  ///EasyLoading.show();
  var request = await http.post(Uri.parse(rootDomain + "user.php"), body: {
    "action": "refresh",
    "username": userModel.username,
  });
  if (request.statusCode == 200) {
    EasyLoading.dismiss();
    var response = jsonDecode(request.body);
    print(response);
    if (response['status']) {
      userModel = UserModel.fromJson(response['bio']);
      userModel.balance = response['bio']['balance'];

      showToast("You are up to date");
    } else {
      EasyLoading.dismiss();
      Navigator.pushNamed(context, "/Login");
    }
  }
}

showToast(String msg) {
  Fluttertoast.showToast(
    backgroundColor: primaryColor,
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
  );
}

showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Sending Message"),
  ));
}

void showInstatAd() {
  InterstitialAd.load(
    adUnitId: 'ca-app-pub-2409697587470650/9701152701',
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        _interstitialAd = ad;

        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            // Navigator.pop(context);
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

ShareContent(String content) {
  Share.share(content);
}
