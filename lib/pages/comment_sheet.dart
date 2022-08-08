import 'dart:async';
import 'dart:convert';

import 'package:dataminners/constants.dart';
import 'package:dataminners/models/comment_model.dart';
import 'package:dataminners/models/post_model.dart';
import 'package:dataminners/pages/shima_preloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:startapp/startapp.dart';
import '../widgets.dart';
import 'package:http/http.dart' as http;

class CommentSheet extends StatefulWidget {
  PostModel postModel;
  CommentSheet({Key? key, required this.postModel}) : super(key: key);

  @override
  _CommentSheetState createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  StreamController controller = StreamController();
  bool isEnoughText = false;
  TextEditingController _commentController = TextEditingController();
  String comment = "";
  // List<CommentModel> commentList = [
  //   CommentModel(
  //       id: 1,
  //       comment:
  //           "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod",
  //       username: "Lucky Amos",
  //       commentDate: "2-oct-21"),
  //   CommentModel(
  //       id: 2,
  //       comment:
  //           "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod",
  //       username: "Iyida Amos",
  //       commentDate: "2-oct-21"),
  // ];
  List msg = [];
  Future<List> fetchComment() async {
    var request = await http.get(Uri.parse(rootDomain +
        "comment.php?action=fetchComment&accessToken=" +
        userModel.accessToken +
        "&username=" +
        userModel.username +
        "&limit=1000&postId=" +
        widget.postModel.postId));
    var response = jsonDecode(request.body);
    if (response['status']) {
      msg = response['msg'];
      controller.add(msg);
      return response['msg'];
    } else {
      controller.sink.add([]);
      return response;
    }
  }

  @override
  void initState() {
    fetchComment();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    // Destroy the Stream Controller when use exit the app
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 200,
          title: Container(
            height: 200,
            padding: EdgeInsets.only(top: 20),
            width: size.width,
            // color: Colors.red,
            child: Container(
                //color: Colors.yellow,
                child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 150,
                    //color: Colors.yellow,
                    child: showBannerAdd(height: 150, width: size.width))),
          )),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: size.height * 0.85,
          child: DraggableScrollableActuator(
              child: StreamBuilder(
            stream: controller.stream,
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                var data = snapshot.data;
                Text(data.toString());
              } else {
                // EasyLoading.show();
                return Shima();
              }
              EasyLoading.dismiss();
              return Container(
                child: DisplayComment(data: snapshot.data),
              );
            },
          ))),
      floatingActionButton: Container(
        color: whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        width: size.width,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: lightGrey,
          ),
          height: size.height * 0.08,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.face,
                    color: Colors.black,
                  )),
              Expanded(
                  child: TextFormField(
                controller: _commentController,
                minLines: 10,
                maxLines: 10,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  comment = value;
                  if (value.trim().length > 5) {
                    setState(() {
                      isEnoughText = true;
                    });
                  } else {
                    setState(() {
                      isEnoughText = false;
                    });
                  }
                },
              )),
              IconButton(
                  onPressed: () {
                    if (isEnoughText) {
                      print(comment);
                      postComment(comment, int.parse(widget.postModel.postId));
                    } else {
                      // EasyLoading.dismiss();
                      //EasyLoading.showToast("Not Enough Text");
                    }
                  },
                  icon: Icon(Icons.send,
                      color: isEnoughText ? primaryColor : Colors.grey))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    var request = await http.post(Uri.parse(rootDomain + "user.php"), body: {
      "action": "refresh",
      "username": userModel.username,
    });
    if (request.statusCode == 200) {
      var response = jsonDecode(request.body);
      // isLodingBalance = false;
      balance = response['bio']['balance'];
      setState(() {});
    }
  }

  postComment(String comment, int postId) async {
    //showMessage(context, "successflu", "msg", 2);
    print(postId);
    var request = await http.post(Uri.parse(rootDomain + "comment.php"), body: {
      "action": "newComment",
      "username": userModel.username,
      "accessToken": userModel.accessToken,
      "comment": comment,
      "postId": postId.toString()
    });
    if (request.statusCode == 200) {
      // var n = double.parse(balance) + 10;

      // setState(() {
      //   balance = n.toString();
      // });
      //print(res)
      var h = {};
      h['username'] = userModel.username;
      h['postId'] = postId.toString();
      h['comment'] = comment;
      h['date'] = "now";
      h['id'] = "100000";

      setState(() {
        msg.add(h);

        ///fetchComment();
      });
      var response = jsonDecode(request.body);
      if (response['status']) {
        print(response);
        showAlertDialog(context, "Successful", response['msg']);

        _commentController.text = "";
        isEnoughText = false;
        // fetchComment();
        getData();

        // refreshData(context);
        setState(() {});
        //Navigator.pop(context);
      } else {
        showMessage(context, "failed", response['msg'], 2);
      }

      // showSuccess(context, 2);
    } else {
      showMessage(context, "failed", "An error occoured", 2);
    }
  }
}

showAlertDialog(BuildContext context, title, msg) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Back"),
    onPressed: () {
      Navigator.of(context)
          .popUntil((route) => route.settings.name == "/Dashboard");
    },
  );
  Widget continueButton = TextButton(
    child: Text("Refresh"),
    onPressed: () {
      Navigator.pushNamed(context, "/Dashboard");
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/success1.png",
          width: 100,
          height: 100,
        ),
      ],
    ),
    actions: [
      cancelButton,
      continueButton,
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

succesComment(
  BuildContext context,
  title,
  msg,
  int type,
) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context)
          .popUntil((route) => route.settings.name == "/Dashboard");
      refreshData(context);
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

int showAds = 0;

Widget oneComment(BuildContext context, var list) {
  Size size = MediaQuery.of(context).size;
  return list.length > 0
      ? Container(
          height: size.height * 0.8,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (ctx, index) {
                var json = list[index];
                return SingleComment(
                    commentModel: CommentModel(
                        id: json['id'],
                        comment: json['comment'],
                        username: json['username'],
                        commentDate: json['date']));
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
                Text("No comment yet")
              ],
            ),
          ),
        );
}

Widget dhow(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(
          child: Column(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined)),
          SizedBox(
            height: 30,
            child: Text(
              "Hot Comments",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      )),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: lightGrey,
        ),
        height: 50,
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.face,
                  color: Colors.black,
                )),
            Expanded(
                child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(border: InputBorder.none),
            )),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.send, color: primaryColor))
          ],
        ),
      )
    ],
  );
}

class DisplayComment extends StatefulWidget {
  var data;
  DisplayComment({Key? key, required this.data}) : super(key: key);

  @override
  _DisplayCommentState createState() => _DisplayCommentState();
}

class _DisplayCommentState extends State<DisplayComment> {
  bool status = true;
  List list = [];

  @override
  void initState() {
    // TODO: implement initState
    list = widget.data;

    if (list.length < 1) {
      status = false;
      setState(() {});
    }
  }

  int showAds = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return list.length > 0
        ? Container(
            height: size.height * 0.8,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (ctx, index) {
                  showAds++;
                  var json = list[index];
                  if (showAds == int.parse(settingsModel.postb4adds)) {
                    showAds = 0;
                    return Column(
                      children: [
                        SingleComment(
                            commentModel: CommentModel(
                                id: json['id'],
                                comment: json['comment'],
                                username: json['username'],
                                commentDate: json['date'])),
                        // showBannerAdd(height: 100, width: size.width)
                        showLinkBanner(context)
                      ],
                    );
                  } else {
                    return SingleComment(
                        commentModel: CommentModel(
                            id: json['id'],
                            comment: json['comment'],
                            username: json['username'],
                            commentDate: json['date']));
                  }
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
                  Text("No comment yet")
                ],
              ),
            ),
          );
  }
}
