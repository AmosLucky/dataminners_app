import 'dart:async';
import 'dart:convert';

import 'package:dataminners/models/settings_model.dart';
import 'package:dataminners/models/user_model.dart';
import 'package:dataminners/pages/login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../widgets.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
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
                  "Forgot Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/images/forgot-password.png",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  child: TextFieldContainer(
                      child: TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: primaryColor,
                        ),
                        hintText: "Username or email",
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
                      text: "Next",
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Remembered password? "),
                        Text(
                          "Login",
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed("/Login");
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

      if (username.length > 1) {
        print(username + " " + password);
        requestPassword(username);
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

  void requestPassword(String username) async {
    ///SharedPreferences _sharedPreferences = await prefs;
    Uri uri = Uri.parse(rootDomain + "user.php");
    print(uri);
    var resquest = await http
        .post(uri, body: {"action": "passwordResetCode", "email": username});
    print(resquest.statusCode);
    if (resquest.statusCode == 200) {
      var response = jsonDecode(resquest.body);
      if (response['status']) {
        EasyLoading.dismiss();
        showMessage(context, "Success", response['msg'], 1);
        Timer(Duration(seconds: 1), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) => VerifyEmail(username: username)));
        });
        // print(response);
        //var userDetails = response['msg'];
        ///UserModel myUser = UserModel.fromJson(userDetails);
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

///////////////////////////////////////////////////VERIFY EMAIL////////////////////////
///

class VerifyEmail extends StatefulWidget {
  String username;
  VerifyEmail({Key? key, required this.username}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String newPassword = "";
  String resetCode = "";
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
      child: WillPopScope(
        onWillPop: () async {
          return false;
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
                    "Reset Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Image.asset(
                    "assets/images/verify.png",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    child: TextFieldContainer(
                        child: TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: primaryColor,
                          ),
                          hintText: "Password reset code",
                          border: InputBorder.none),
                      onSaved: (value) {
                        resetCode = value!;
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
                  Container(
                    alignment: Alignment.center,
                    child: TextFieldContainer(
                        child: TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.password,
                            color: primaryColor,
                          ),
                          hintText: "New passord",
                          border: InputBorder.none),
                      onSaved: (value) {
                        newPassword = value!;
                      },
                      validator: (value) {
                        if (value.toString().length < 6) {
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
                            "Password must be greater than 6 characters",
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
                        text: "Reset",
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Remebered password? "),
                          Text(
                            "Login",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed("/Login");
                      },
                    ),
                  )
                ],
              ),
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

      if (resetCode.length > 1 && newPassword.length > 5) {
        // print(username);
        restPassword(widget.username, resetCode, newPassword);
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

  void restPassword(
      String username, String restCode, String newPassword) async {
    //SharedPreferences _sharedPreferences = await prefs;
    Uri uri = Uri.parse(rootDomain + "user.php");
    print(uri);
    var resquest = await http.post(uri, body: {
      "action": "forgotPassword",
      "email": username,
      "newPassword": newPassword,
      "resetCode": resetCode
    });
    print(resquest.statusCode);
    if (resquest.statusCode == 200) {
      var response = jsonDecode(resquest.body);
      if (response['status']) {
        EasyLoading.dismiss();
        showMessage(context, "Success", response['msg'], 1);
        Timer(Duration(seconds: 1), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (BuildContext) => Login()));
        });
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
