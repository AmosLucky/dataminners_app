import 'dart:async';
import 'dart:convert';

import 'package:dataminners/constants.dart';
import 'package:dataminners/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  void initState() {
    emailController.text = userModel.email;
    phoneController.text = userModel.phoneNumber;
    passwordController.text = "";
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          toolbarHeight: 0.0,
          bottom: const TabBar(
            indicatorColor: whiteColor,
            tabs: [
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.edit)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: profile(size),
            ),
            SingleChildScrollView(
              child: Container(
                width: size.width,
                height: size.height,
                color: lightGrey,
                child: editDetails(size, 1),
              ),
            )
          ],
        ),
      ),
    );
  }

  profile(Size size) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200)),
              ),
              // height: size.height * 0.40,
              width: size.width,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                        backgroundColor: whiteColor,
                        radius: 1,
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 70,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userModel.username,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              int.parse(userModel.isVerified) > 0
                                  ? Icon(
                                      Icons.verified,
                                      color: primaryColor,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        Text(
                          "DataMinner",
                          style: TextStyle(color: primaryColor, fontSize: 10),
                        ),

                        // Container(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [Text("Data Balance:"), Text("300MB")],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [],
                    ),
                  ),
                ],
              ),
            ),

            //
          ],
        ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          margin: EdgeInsets.only(top: 0, left: 20, right: 20),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: size.height / 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   alignment: Alignment.topRight,
              //   child: MaterialButton(
              //     onPressed: () async {
              // SharedPreferences _sharedPreferences = await prefs;
              // _sharedPreferences.clear();
              // Navigator.pushNamed(context, "/Login");
              //     },
              //     child: Column(
              //       children: [
              //         Icon(Icons.logout),
              //         Text("Logout"),
              //       ],
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Data Balance:",
                    style: TextStyle(color: primaryColor, fontSize: 20),
                  ),
                  Text(
                    userModel.balance + "MB",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                  child: MaterialButton(
                shape: StadiumBorder(),
                color: primaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, "/Redeem");
                },
                child: Text(
                  "Reedem",
                  style: TextStyle(color: whiteColor),
                ),
              )),

              // Container(
              //     child: OutlinedButton(
              //   child: Text("Logout"),
              //   onPressed: () {},
              // )),
            ],
          ),
        ),

        details(size, 0),
        // showBannerAdd(height: 300, width: size.width)
      ],
    );
  }

  details(size, type) {
    return Container(
      width: size.width,
      // height: size.height / 5,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: 0, left: 20, right: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //margin: EdgeInsets.only(top: 300),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(
              Icons.email,
              color: primaryColor,
            )),
            controller: emailController,
            validator: (value) {
              bool validEmail = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value!);
              print(validEmail);
              if (!validEmail) {
                return "Invalid Email";
              }
            },
          ),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
                prefixIcon: Icon(
              Icons.phone,
              color: primaryColor,
            )),
            validator: (value) {
              if (value.toString().length < 11) {
                return "Invalid Phone number";
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          // TextFormField(
          //   obscureText: true,
          //   decoration: InputDecoration(
          //       prefixIcon: Icon(
          //     Icons.lock,
          //     color: primaryColor,
          //   )),
          //   controller: passwordController,
          // ),
          // Row(
          //   children: [
          //     type != 0
          //         ? Expanded(
          //             child: MaterialButton(
          //             shape: StadiumBorder(),
          //             color: primaryColor,
          //             textColor: whiteColor,
          //             onPressed: () {},
          //             child: Text("Update"),
          //           ))
          //         : Container()
          //   ],
          // )]
          Container(
              child: OutlinedButton(
            child: Text("Logout"),
            onPressed: () async {
              SharedPreferences _sharedPreferences = await prefs;
              _sharedPreferences.clear();
              Navigator.pushNamed(context, "/Login");
            },
          )),
        ],
      ),
    );
  }

  editDetails(size, type) {
    GlobalKey<FormState> _formState = new GlobalKey();
    String oldPassword = "";
    String newPassword = "";
    return Column(
      children: [
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Change Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                //margin: EdgeInsets.only(top: 300),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                        Icons.email,
                        color: primaryColor,
                      )),
                      controller: emailController,
                      validator: (value) {
                        bool validEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        print(validEmail);
                        if (!validEmail) {
                          return "Invalid Email";
                        }
                      },
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                        Icons.phone,
                        color: primaryColor,
                      )),
                      validator: (value) {
                        if (value.toString().length < 11) {
                          return "Invalid Phone number";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // TextFormField(
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //       prefixIcon: Icon(
                    //     Icons.lock,
                    //     color: primaryColor,
                    //   )),
                    //   controller: passwordController,
                    // ),
                    Row(
                      children: [
                        int.parse(userModel.isVerified) == 0
                            ? Expanded(
                                child: MaterialButton(
                                shape: StadiumBorder(),
                                color: primaryColor,
                                textColor: whiteColor,
                                onPressed: () {
                                  sendCode();
                                },
                                child: Text("Verify Email"),
                              ))
                            : Container()
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _formState,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Change password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  //margin: EdgeInsets.only(top: 300),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Old password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: primaryColor,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Invalid password";
                          }
                        },
                        onSaved: (value) {
                          oldPassword = value!;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "New password",
                            prefixIcon: Icon(
                              Icons.password,
                              color: primaryColor,
                            )),
                        validator: (value) {
                          if (value.toString().length < 6) {
                            return "password must be greater than 6 characters";
                          }
                        },
                        onSaved: (value) {
                          newPassword = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // TextFormField(
                      //   obscureText: true,
                      //   decoration: InputDecoration(
                      //       prefixIcon: Icon(
                      //     Icons.lock,
                      //     color: primaryColor,
                      //   )),
                      //   controller: passwordController,
                      // ),
                      Row(
                        children: [
                          Expanded(
                              child: MaterialButton(
                            shape: StadiumBorder(),
                            color: primaryColor,
                            textColor: whiteColor,
                            onPressed: () {
                              if (_formState.currentState!.validate()) {
                                _formState.currentState!.save();
                                changePassword(oldPassword, newPassword);
                              }
                            },
                            child: Text("Change"),
                          ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  changePassword(String oldPassword, String newPassword) async {
    EasyLoading.show();
    print(oldPassword + newPassword);
    var request = await http.post(Uri.parse(rootDomain + "user.php"), body: {
      "action": "changePassword",
      "accessToken": userModel.accessToken,
      "username": userModel.username,
      "currentPassword": oldPassword,
      "newPassword": newPassword
    });
    if (request.statusCode == 200) {
      EasyLoading.dismiss();
      var response = jsonDecode(request.body);
      if (response['status']) {
        showMessage(context, "Successful", response['msg'], 1);

        Timer(
            Duration(seconds: 2), () => Navigator.pushNamed(context, "/Login"));
      } else {
        showMessage(context, "Error", response['msg'], 2);
      }
    } else {
      EasyLoading.dismiss();
      showMessage(context, "Error", "An error occoured", 2);
    }
  }

  sendCode() async {
    EasyLoading.show();
    var request = await http.post(Uri.parse(rootDomain + "user.php"), body: {
      "action": "resendCode",
      "accessToken": userModel.accessToken,
      "username": userModel.username,
    });
    //print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    if (request.statusCode == 200) {
      EasyLoading.dismiss();

      /// quickNotification(context, "", "");
      //print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      var response = jsonDecode(request.body);
      print(response);
      if (response['status']) {
        Fluttertoast.showToast(msg: "Code Sent to : " + userModel.email);
        //Timer(Duration(seconds: 2), () {
        showVerificationNotification(context, "Message", response['msg']);
        // });
      } else {
        showMessage(context, "Message", response['msg'], 2);
      }
    } else {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Error occoured");
    }
  }

  showVerificationNotification(
    BuildContext context,
    title,
    msg,
  ) {
    TextEditingController controller = TextEditingController();
    // set up the button
    Widget okButton = TextButton(
      child: Text("Confirm"),
      onPressed: () {
        if (controller.text.length < 3) {
          Fluttertoast.showToast(msg: "Invalid Code");
        } else {
          verifyEmail(controller.text);
          Navigator.pop(context);
        }
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
            TextFormField(
              controller: controller,
              decoration: InputDecoration(hintText: "Enter Code"),
            )
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

  verifyEmail(String code) async {
    EasyLoading.show();
    var request = await http.post(Uri.parse(rootDomain + "user.php"), body: {
      "action": "verifyEmail",
      "accessToken": userModel.accessToken,
      "username": userModel.username,
      "verifyCode": code
    });
    //print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    if (request.statusCode == 200) {
      EasyLoading.dismiss();

      /// quickNotification(context, "", "");
      //print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      var response = jsonDecode(request.body);
      print(response);
      if (response['status']) {
        Fluttertoast.showToast(msg: "Successfully verified");
        refreshData(context);
        Navigator.pushNamed(context, "/Dashboard");
        //Timer(Duration(seconds: 2), () {
        //showVerificationNotification(context, "Message", response['msg']);
        // });
      } else {
        showMessage(context, "Message", response['msg'], 2);
      }
    } else {
      Fluttertoast.showToast(msg: "Error occoured");
      EasyLoading.dismiss();
    }
  }
}
