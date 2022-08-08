import 'dart:convert';

import 'package:dataminners/models/settings_model.dart';
import 'package:dataminners/models/user_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String password = "";
  String username = "";
  bool pass_err = false;
  bool user_err = false;
  String erro_messsage = "";
  EasyLoading easyLoading = EasyLoading();
  bool showPassword = false;

  @override
  void initState() {
    setEasyLoading(EasyLoading.instance);

    // TODO: implement initState
    super.initState();
  }

  switchPassword() {
    if (showPassword) {
      showPassword = false;
      setState(() {});
    } else {
      showPassword = true;
      setState(() {});
    }
  }

  Future<bool> returnt() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return returnt();
      },
      child: Scaffold(
        // appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // showBannerAdd(width: size.width, height: 100),
                SizedBox(height: size.height * 0.09),
                Text(
                  "SIGN IN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/images/login_ill.png",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.00),
                Container(
                  alignment: Alignment.center,
                  child: TextFieldContainer(
                      child: TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: primaryColor,
                        ),
                        hintText: "Username",
                        border: InputBorder.none),
                    onSaved: (value) {
                      username = value!;
                    },
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        setState(() {
                          user_err = true;
                        });
                        return;
                        //return "Please fill";
                      }
                      return;
                    },
                    onChanged: (value) {
                      setState(() {
                        user_err = false;
                      });
                      return;
                    },
                  )),
                ),
                user_err
                    ? Container(
                        child: Text(
                          "Please fill",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                Container(
                  alignment: Alignment.center,
                  child: TextFieldContainer(
                      child: TextFormField(
                    obscureText: !showPassword ? true : false,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: primaryColor,
                        ),
                        hintText: "Password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            switchPassword();
                          },
                          icon: Icon(
                            !showPassword
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                            color: primaryColor,
                          ),
                        )),
                    onSaved: (value) {
                      password = value!;
                    },
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        setState(() {
                          pass_err = true;
                        });
                        return;
                      }
                      return;
                    },
                    onChanged: (value) {
                      setState(() {
                        pass_err = false;
                      });
                    },
                  )),
                ),
                pass_err
                    ? Container(
                        child: Text(
                          "Please fill",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                Container(
                  child: Text(
                    erro_messsage,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    height: 60,
                    child: RoundButton(
                      onClick: () {
                        erro_messsage = "";
                        setState(() {});
                        // Navigator.of(context).pushNamed("/Dashboard");
                        // goOnline();
                        validateForm();
                      },
                      text: "Sign In",
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("D'ont have an account? "),
                        Text(
                          "Sign Up",
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed("/Register");
                    },
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: InkWell(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed("/ForgetPassword");
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // goOnline() async {
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Client-Id': 'dGVzdF9Qcm92aWR1cw==',
  //     'X-Auth-Signature':
  //         'BE09BEE831CF262226B426E39BD1092AF84DC63076D4174FAC78A2261F9A3D6E59744983B8326B69CDF2963FE314DFC89635CFA37A40596508DD6EAAB09402C7'
  //   };
  //   var request = http.Request(
  //       'POST',
  //       Uri.parse(
  //           'http://192.168.1.210:8088/appdevapi/api/PiPCreateReservedAccountNumber'));

  //   request.body = json.encode({"account_name": "lemuel", "bvn": ""});
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();
  //   print("kk");

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  void validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (username.length > 1 && password.length > 1) {
        print(username + " " + password);
        login(username, password);
        EasyLoading.show(
            status: 'loading...',
            maskType: EasyLoadingMaskType.black,
            dismissOnTap: true);
      } else {
        print("No");
      }

      print("true");
    } else {
      print("false");
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
        menu = response['menu'];
        userModel = UserModel.fromJson(userDetails);
        settingsModel = SettingsModel.fromjson(settingsDetails);
        EasyLoading.dismiss();
        Navigator.pushNamed(context, "/Dashboard");
      } else {
        EasyLoading.dismiss();
        // EasyLoading.showToast(response['msg']);
        EasyLoading.showError(response['msg'],
            dismissOnTap: true, duration: Duration(seconds: 1));
        erro_messsage = response['msg'];
        setState(() {});
      }
    } else {
      EasyLoading.showError("Failed",
          dismissOnTap: true, duration: Duration(seconds: 1));
      throw Exception('Failed to login');
    }
  }
}
