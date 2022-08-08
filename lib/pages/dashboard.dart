import 'dart:async';
import 'dart:convert';

import 'package:dataminners/constants.dart';
import 'package:dataminners/functions/click_function.dart';
import 'package:dataminners/models/menu_model.dart';
import 'package:dataminners/models/settings_model.dart';
import 'package:dataminners/models/user_model.dart';
import 'package:dataminners/pages/activity.dart';
import 'package:dataminners/pages/redeem.dart';
import 'package:dataminners/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:launch_review/launch_review.dart';
//import 'package:social_share/social_share.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../widgets.dart';
import 'transactions.dart';
import '../models/user_model.dart';
import 'webview_page.dart';

class Dashboard extends StatefulWidget {
  // UserModel userModel;
  final int currentIndex;
  Dashboard({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var currentIndex = 0;
  var numTasks = 0;

  PageController _controller = PageController(
    initialPage: 0,
  );

  int exit = 0;
  //String balance = userModel.balance;
  bool isLodingBalance = true;
  Future<void> getData() async {
    var request = await http.post(Uri.parse(rootDomain + "user.php"), body: {
      "action": "refresh",
      "username": userModel.username,
    });
    if (request.statusCode == 200) {
      var response = jsonDecode(request.body);
      isLodingBalance = false;
      userModel = UserModel.fromJson(response['bio']);
      settingsModel = SettingsModel.fromjson(response['settings']);
      balance = response['bio']['balance'];
      setState(() {});
    }
  }

  Future<void> getTasks() async {
    var request = await http.get(
        Uri.parse(rootDomain + "tasks.php?username=" + userModel.username));
    if (request.statusCode == 200) {
      var response = jsonDecode(request.body);
      // isLodingBalance = false;
      numTasks = int.parse(response['task']);
      //print("ddddddddddddddddddddkkkkkkkkkkkkkkkkk" + numTasks.toString());
      setState(() {});
    } else {
      //print("ddddddddddddddddddddkkkkkkkkkkkkkkkkk000");
    }
  }

  Future<void> showNotification() async {
    //print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    var request =
        await http.post(Uri.parse(rootDomain + "notifications.php"), body: {
      "action": "quickNotification",
      "username": userModel.username,
    });
    //print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    if (request.statusCode == 200) {
      /// quickNotification(context, "", "");
      //print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      var response = jsonDecode(request.body);
      print(response);
      if (response['status']) {
        Timer(Duration(seconds: 2), () {
          quickNotification(context, response['title'], response['msg']);
        });
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    getData();
    refreshData(context);
    adCounter();
    showNotification();
    getTasks();
    setState(() {});
    exit = 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool returnBackPress() {
    // loadInterstitialAd();
    startAdsCounter();
    if (exit < 1) {
      exit++;

      Fluttertoast.showToast(msg: "Double tap  to exit");
      Timer(Duration(seconds: 2), () {
        exit = 0;
        setState(() {});
      });

      setState(() {});
      return false;
    } else {
      SystemNavigator.pop();
      exit = 0;
      return false;
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //getData();
    return WillPopScope(
        onWillPop: () async {
          showInerstitialAdds();

          // print("back pressed");
          return returnBackPress();
        },
        child: Scaffold(
            drawer: myDrawer(),
            appBar: AppBar(
                foregroundColor: primaryColor,
                actions: [
                  InkWell(
                    onTap: () {
                      adCounter();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext) => WebPage(
                                  menuModel: MenuModel(
                                      id: "1",
                                      url: rootDomain +
                                          "task?username=" +
                                          userModel.username,
                                      title: "Task Notification",
                                      icon: ""))));
                    },
                    child: Container(
                      child: Stack(
                        children: [
                          numTasks > 0
                              ? Image.asset(
                                  "assets/images/bell.gif",
                                  width: 80,
                                )
                              : RotationTransition(
                                  turns: new AlwaysStoppedAnimation(15 / 360),
                                  child: Image.asset(
                                    "assets/images/bell.png",
                                    width: 80,
                                  ),
                                ),
                          Container(
                              width: 70,
                              //color: redColor,
                              alignment: Alignment.centerRight,
                              child: CircleAvatar(
                                  backgroundColor: redColor,
                                  radius: 10,
                                  child: Text(
                                    "${numTasks}",
                                    style: TextStyle(color: whiteColor),
                                  )))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: OutlinedButton(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: primaryColor,
                              child: !isLodingBalance
                                  ? Icon(
                                      Icons.refresh_rounded,
                                    )
                                  : CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                isLodingBalance ? "    " : balance + "MB",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          getData();
                          isLodingBalance = true;
                          //refreshData(context);
                          startAdsCounter();
                          adCounter();
                          setState(() {});
                          //Navigator.pushNamed(context, "/Dashboard");
                        }),
                  ),
                ],
                backgroundColor: Colors.white,
                elevation: 0.5,
                title: Container(
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                )),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (_index) {
                EasyLoading.dismiss();
                adCounter();
                startAdsCounter();
                currentIndex = _index;
                //print(_index);
                _controller.jumpTo(_index.toDouble());
                _controller.animateToPage(_index,
                    duration: Duration(seconds: 1), curve: Curves.easeOut);
                setState(() {});
                switch (_index) {
                  case 0:
                    return;
                  case 1:
                    return;
                  case 2:
                    return;
                }
              },
              selectedItemColor: primaryColor,
              showUnselectedLabels: true,
              //backgroundColor: Colors.black,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Home"),
                  // backgroundColor: Colors.black
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history,
                  ),
                  title: Text("Activities"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sim_card,
                  ),
                  title: Text("Redeem"),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  title: Text("Me"),
                )
              ],
            ),
            //appBar: AppBar(),
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              allowImplicitScrolling: false,
              pageSnapping: false,
              controller: _controller,
              onPageChanged: (i) {
                currentIndex = i;
                setState(() {});
              },
              children: [
                Activity(),
                Transactions(),
                Redeem(),
                UserProfile(),
              ],
            )));
  }

  Widget myDrawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Container(
                child: Image.asset(
                  "assets/images/banner-4.jpg",
                  fit: BoxFit.fill,
                ),
              )),
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: menu.length,
                itemBuilder: (ctx, index) {
                  adCounter();
                  return SingleMenu(MenuModel.fromJson(menu[index]));
                }),
          ),
          showBannerAdd(height: 200, width: 300)
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  Widget SingleMenu(MenuModel menuModel) {
    print(menuModel.url.toString());
    return ListTile(
      leading: Image.network(
        menuModel.icon.toString(),
        width: 20,
        height: 20,
      ),
      title: Text(menuModel.title.toString()),
      onTap: () {
        if (menuModel.title.toString() == "Share App") {
          String shareApp =
              "*Intall dataminers and earn 1GB daily*: \n ⭐Comment on a post and earn 20MB, \n ⭐Like a post and earn 10MB, \n ⭐ Do special task and earn 200MB \n ⭐ Refer someone and earn 20MB ⭐ Install now! : " +
                  appUrl +
                  " \n use " +
                  userModel.username +
                  " as referers username";

          sharePosts(shareApp);
          return;
        } else if (menuModel.title.toString() == "Rate Us") {
          LaunchReview.launch(
              androidAppId: "dataminners.com", iOSAppId: "585027354");
          return;
        } else if (menuModel.title.toString().contains(".")) {
          _launchInBrowser(menuModel.url.toString());
          return;
        }
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => WebPage(
                      menuModel: menuModel,
                    )));
      },
    );
  }

  quickNotification(BuildContext context, title, msg) {
    Timer(Duration(seconds: 5), () {
      showInstatAd();
    });
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
      content: Text(msg),
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
}
