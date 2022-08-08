import 'dart:convert';

import 'package:dataminners/constants.dart';
import 'package:dataminners/models/transaction_model.dart';
import 'package:dataminners/pages/shima_preloader.dart';
import 'package:dataminners/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  SharedPreferences? sharedPreferences;
  // List<TransactonModel> transactionList = [
  //   TransactonModel(
  //       id: 1,
  //       userId: "1",
  //       activity: "comment on post",
  //       reward: "10MB",
  //       type: "credit",
  //       status: "success",
  //       beneficiary: "me",
  //       date: "03-Oct-21"),
  //   TransactonModel(
  //       id: 2,
  //       userId: "2",
  //       activity: "Reward withdrawal",
  //       reward: "1000MB",
  //       type: "debit",
  //       status: "pending",
  //       beneficiary: "08106799951",
  //       date: "03-Oct-21"),
  // ];
  fetchHistory() async {
    var request = await http.post(Uri.parse(rootDomain + "user.php"),
        body: {"action": "fetchHistory", "username": userModel.username});

    sharedPreferences!.setString("history", request.body);
  }

  fetchTransactionFromLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return jsonDecode(sharedPreferences!.getString("history").toString());
  }

  @override
  void initState() {
    fetchHistory();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
            width: size.width,
            height: size.height * 0.8,
            child: FutureBuilder(
              future: fetchTransactionFromLocal(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  Text(data.toString());
                } else {
                  // EasyLoading.show();
                  return Shima();
                }
                //EasyLoading.dismiss();
                return Container(
                  child: DisplayHistory(data: snapshot.data),
                );
              },
            )
            // SingleTransaction(transactonModel: transactionList[0]),
            // SingleTransaction(transactonModel: transactionList[1])

            ),
      ),
    );
  }
}

class DisplayHistory extends StatefulWidget {
  var data;
  DisplayHistory({Key? key, required this.data}) : super(key: key);

  @override
  _DisplayHistoryState createState() => _DisplayHistoryState();
}

class _DisplayHistoryState extends State<DisplayHistory> {
  bool status = true;
  List list = [];
  @override
  void initState() {
    // TODO: implement initState
    print(list);

    if (widget.data['status']) {
      list = widget.data['msg'];

      setState(() {});
    } else {
      status = false;
      setState(() {});
    }
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return status
        ? Container(
            height: size.height * 0.8,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (ctx, index) {
                  i++;
                  var json = list[index];
                  if (i == int.parse(settingsModel.historyb4adds)) {
                    i = 0;
                    return Column(
                      children: [
                        SingleTransaction(
                            transactonModel: TransactonModel(
                                id: json['id'],
                                userId: json['username'],
                                activity: json['type'],
                                reward: json['amount'],
                                type: json['type'],
                                status: json['transactionStatus'],
                                date: json['date'],
                                beneficiary: json['beneficiaryNumber'])),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: showLinkBanner(context),

                          ///showBannerAdd(height: 200, width: size.width)
                        )
                      ],
                    );
                  }

                  return SingleTransaction(
                      transactonModel: TransactonModel(
                          id: json['id'],
                          userId: json['username'],
                          activity: json['type'],
                          reward: json['amount'],
                          type: json['type'],
                          status: json['transactionStatus'],
                          date: json['date'],
                          beneficiary: 'beneficiaryNumber'));
                }),
          )
        : Container(
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/norecord.png",
                    width: size.width,
                  ),
                  Text("No history yet")
                ],
              ),
            ),
          );
  }
}
