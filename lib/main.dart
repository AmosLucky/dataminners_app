import 'dart:async';
import 'dart:convert';

import 'package:dataminners/functions/show_update.dart';
import 'package:dataminners/models/menu_model.dart';
import 'package:dataminners/models/settings_model.dart';
import 'package:dataminners/pages/forget_password.dart';
import 'package:dataminners/pages/redeem.dart';
import 'package:dataminners/pages/webview_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'models/user_model.dart';
import 'pages/dashboard.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..displayDuration = const Duration(seconds: 60)
      ..backgroundColor = primaryColor
      ..loadingStyle = EasyLoadingStyle.light;
    return MaterialApp(
      routes: {
        '/Login': (ctx) => Login(),
        '/SplashScreen': (ctx) => SplashScreen(),
        '/Register': (ctx) => Register(),
        '/Dashboard': (ctx) => Dashboard(),
        '/Redeem': (ctx) => Redeem(),
        '/Welcome': (ctx) => WelcomePage(),
        '/ForgetPassword': (ctx) => ForgetPassword(),
      },
      title: 'DataMinners',
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primaryColor: Colors.purpleAccent,
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ShowPreloader preloader = new ShowPreloader();
  //final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);
  fetchDataInitialData() async {
    SharedPreferences _sharedPreferences = await prefs;
    String? username = _sharedPreferences.getString("username");
    String? password = _sharedPreferences.getString("password");
    if (password == null || username == null) {
      goToWelcome();
    } else {
      login(username.toString(), password.toString());
    }
  }

  void login(String username, password) async {
    SharedPreferences _sharedPreferences = await prefs;
    Uri uri = Uri.parse(rootDomain +
        "user.php?action=login&username=" +
        username +
        "&password=" +
        password);
    print(uri);
    var resquest = await http.get(uri);
    print(resquest.statusCode);
    if (resquest.statusCode == 200) {
      var response = jsonDecode(resquest.body);
      if (response['status']) {
        _sharedPreferences.setString("username", username);
        _sharedPreferences.setString("password", password);
        print(response);
        var userDetails = response['bio'];
        var settingsDetails = response['settings'];
        var stableVersion = settingsDetails['stableVersion'];

        if (int.parse(stableVersion) > appVersion) {
          showAlertDialogUPdate(context, "New Update",
              "Your app is out of date, please update it to enjoy a better service");
          return;
        }

        menu = response['menu'];
        userModel = UserModel.fromJson(userDetails);
        settingsModel = SettingsModel.fromjson(settingsDetails);
        // Navigator.pushNamed(context, "/Welcome");
        Navigator.pushNamed(context, "/Dashboard");
      } else {
        goToWelcome();
      }
    } else {
      goToWelcome();
    }
  }

  goToWelcome() {
    // Timer(Duration(seconds: 2), () {
    //   Navigator.pushNamed(context, "/Welcome");
    // });
  }

  @override
  void initState() {
    fetchDataInitialData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              "assets/images/logo1.png",
              width: 100,
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext) => WebPage(
                        menuModel: new MenuModel(
                            url: "https://dataminners.com",
                            title: "Dataminners.com"))));
          },
          child: Text(
            "dataminners.com",
            style: TextStyle(color: primaryColor),
          ),
        )
      ],
    )));
  }
}
