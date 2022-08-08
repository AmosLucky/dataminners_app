import 'dart:convert';

import 'package:dataminners/models/settings_model.dart';
import 'package:dataminners/models/user_model.dart';
import 'package:dataminners/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username = "";
  String email = "";
  String phoneNnumber = "";
  String password = "";
  String referrer = "";
  bool user_err = false;
  bool pass_err = false;
  bool phone_err = false;
  bool email_err = false;
  String erro_messsage = "";
  GlobalKey<FormState> _formKey = new GlobalKey();

  @override
  void initState() {
    setEasyLoading(EasyLoading.instance);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
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
                SizedBox(height: size.height * 0.09),
                Text(
                  "SINGN UP",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/images/register_ill.png",
                  height: size.height * 0.25,
                ),
                SizedBox(height: size.height * 0.00),
                // Container(
                //   alignment: Alignment.center,
                //   height: 60,
                //   child: TextFieldContainer(
                //       child: TextFormField(
                //     decoration: InputDecoration(
                //         icon: Icon(
                //           Icons.person,
                //           color: primaryColor,
                //         ),
                //         hintText: "Name",
                //         border: InputBorder.none),
                //   )),
                // ),
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
                      if (value!.length < 2) {
                        setState(() {
                          user_err = true;
                        });
                        return;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        user_err = false;
                      });
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
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: primaryColor,
                          ),
                          hintText: "Phone number",
                          border: InputBorder.none),
                      onSaved: (value) {
                        phoneNnumber = value!;
                      },
                      validator: (value) {
                        if (value!.length < 11) {
                          setState(() {
                            phone_err = true;
                          });
                          return;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          phone_err = false;
                        });
                      },
                    ),
                  ),
                ),
                phone_err
                    ? Container(
                        child: Text(
                          "Invalid phone number",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                Container(
                  alignment: Alignment.center,
                  child: TextFieldContainer(
                      child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: primaryColor,
                        ),
                        hintText: "Email",
                        border: InputBorder.none),
                    onSaved: (value) {
                      email = value!;
                    },
                    validator: (value) {
                      bool validEmail = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!);
                      print(validEmail);
                      if (!validEmail) {
                        setState(() {
                          email_err = true;
                        });
                        return;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        email_err = false;
                      });
                    },
                  )),
                ),
                email_err
                    ? Container(
                        child: Text(
                          "Invalid email",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                Container(
                  alignment: Alignment.center,
                  child: TextFieldContainer(
                      child: TextFormField(
                    //obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: primaryColor,
                      ),
                      hintText: "Password",
                      border: InputBorder.none,
                      // suffixIcon: Icon(
                      //   Icons.remove_red_eye,
                      //   color: primaryColor,
                      // )
                    ),
                    onSaved: (value) {
                      password = value!;
                    },
                    validator: (value) {
                      if (value!.length < 6) {
                        setState(() {
                          pass_err = true;
                        });
                        return;
                      }
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
                          "Password must be greater than 5 characters",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Container(),
                Container(
                  alignment: Alignment.center,
                  child: TextFieldContainer(
                      child: TextFormField(
                    //obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.people_alt,
                        color: primaryColor,
                      ),
                      hintText: "Referer's username / phone",
                      border: InputBorder.none,
                      // suffixIcon: Icon(
                      //   Icons.remove_red_eye,
                      //   color: primaryColor,
                      // )
                    ),

                    onChanged: (value) {
                      setState(() {
                        referrer = value;
                      });
                    },
                  )),
                ),
                Container(
                  child: Text(
                    erro_messsage,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: RoundButton(
                      onClick: () {
                        erro_messsage = "";
                        setState(() {});
                        validateForm();
                        //Navigator.of(context).pushNamed("/Dashboard");
                      },
                      text: "Sign Up",
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        Text(
                          "Sign In",
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

  validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (username.isNotEmpty &&
          phoneNnumber.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty) {
        EasyLoading.show(dismissOnTap: false);
        register(username, phoneNnumber, email, password, referrer);
        // print("nnnnbbb");
      } else {
        print("Nooo");
      }
    }
  }

  void register(String username, String phoneNumber, String email,
      String password, String referrer) async {
    SharedPreferences _sharedPreferences = await prefs;
    print(password);
    Uri uri = Uri.parse(rootDomain + "user.php");
    var request = await http.post(uri, body: {
      "action": "register",
      "username": username,
      "phoneNumber": phoneNnumber,
      "email": email,
      "password": password,
      "referedBy": referrer
    });

    if (request.statusCode == 200) {
      var response = jsonDecode(request.body);

      if (response['status']) {
        _sharedPreferences.setString("username", username);
        _sharedPreferences.setString("password", password);
        print(response);
        var userDetails = response['msg']['bio'];
        var settingsDetails = response['msg']['settings'];
        menu = response['msg']['menu'];
        userModel = UserModel.fromJson(userDetails);
        settingsModel = SettingsModel.fromjson(settingsDetails);
        EasyLoading.dismiss();
        Navigator.pushNamed(context, "/Dashboard");
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Dashboard(userModel: userModel)));
      } else {
        EasyLoading.dismiss();
        erro_messsage = response['msg'];
        setState(() {});
      }
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to Register');
    }
  }
}
