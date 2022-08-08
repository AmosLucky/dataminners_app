import 'dart:async';
import 'dart:convert';

import 'package:dataminners/constants.dart';
import 'package:dataminners/functions/click_function.dart';
import 'package:dataminners/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;

class Redeem extends StatefulWidget {
  const Redeem({Key? key}) : super(key: key);

  @override
  _RedeemState createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  String selectedPlan = "A";
  String selectedNetwork = "MTN";
  String phoneNumber = "";
  var avalibaleDataArr = settingsModel.availableData.split(",");
  String error_message = "";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    selectedPlan = avalibaleDataArr[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: lightGrey,
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   title: Text("Redeem Data"),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child:
                    showBannerAdd(height: size.height / 5, width: size.width),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: size.width * 0.8,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: lightGrey,
                            ),
                            fillColor: whiteColor,
                            filled: true,
                            labelText: "Phone number",
                            disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.orange),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              borderSide:
                                  BorderSide(width: 1, color: lightGrey),
                            ),
                            border: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey, width: 0.0),
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) {
                            if (value.toString().trim().length < 11) {
                              // return "Invalid phone number";
                            }
                          },
                          onChanged: (value) {
                            phoneNumber = value;
                          },
                          onSaved: (value) {
                            phoneNumber = value!;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(width: 0.5, color: lightGrey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: selectedNetwork,
                          underline: Container(),
                          hint: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.sim_card,
                                    color: lightGrey,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Select Network",
                                    style: TextStyle(),
                                  ),
                                ],
                              )),
                          isExpanded: true,
                          style: TextStyle(color: Colors.black),
                          items: <String>["MTN", "AIRTEL", "GLO", "9MOBILE"]
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            selectedNetwork = newValue.toString();
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(width: 0.5, color: lightGrey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: selectedPlan,
                          underline: Container(),
                          hint: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.compare_arrows,
                                    color: lightGrey,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Select Data Plan",
                                    style: TextStyle(),
                                  ),
                                ],
                              )),
                          isExpanded: true,
                          style: TextStyle(color: Colors.black),
                          items: avalibaleDataArr.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(value)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            selectedPlan = newValue.toString();
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text(
                          error_message,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: size.width * 0.8,
                        child: MaterialButton(
                          color: primaryColor,
                          textColor: whiteColor,
                          shape: StadiumBorder(),
                          child: Text("Recharge"),
                          onPressed: () {
                            // return;
                            error_message = "";
                            setState(() {});
                            if (phoneNumber.trim().length == 11) {
                              error_message = "";
                              EasyLoading.show();
                              recharge(
                                  phoneNumber, selectedNetwork, selectedPlan);
                            } else {
                              error_message = "Invalid phone number";
                              setState(() {});
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void recharge(
      String phoneNumber, String selectnetwork, String selectedPlan) async {
    print(selectedPlan);
    // showInstatAd();S
    //EasyLoading.dismiss();
    var request = await http.post(Uri.parse(rootDomain + "user.php"), body: {
      "action": "withdrawal",
      "username": userModel.username,
      "accessToken": userModel.accessToken,
      "network": selectedNetwork,
      "baneficiaryNumber": phoneNumber,
      "amount": selectedPlan
    });

    if (request.statusCode == 200) {
      EasyLoading.dismiss();
      var response = jsonDecode(request.body);
      showAlertDialog(context, "massage", response['msg']);
    } else {
      showAlertDialog(context, "massage", "An error occoured");
    }
  }

  showAlertDialog(BuildContext context, title, msg) {
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
