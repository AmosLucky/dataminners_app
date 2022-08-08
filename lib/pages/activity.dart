import 'dart:convert';

import 'package:dataminners/constants.dart';
import 'package:dataminners/models/post_model.dart';
import 'package:dataminners/models/user_model.dart';
import 'package:dataminners/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  SharedPreferences? sharedPreferences;
  fetchPost() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var request = await http.get(Uri.parse(rootDomain +
        "post.php?action=fetchPost&accessToken=" +
        userModel.accessToken +
        "&username=" +
        userModel.username +
        "&limit=10000"));
    print(request.body);
    sharedPreferences!.setString("posts", request.body);
    //return jsonDecode(request.body);
  }

  fetchPostFromLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return jsonDecode(sharedPreferences!.getString("posts").toString());
  }

  List<PostModel> postList = [
    // PostModel(
    //     postId: "",
    //     category: "blog",
    //     type: "type",
    //     image: "assets/images/login_ill.png",
    //     url:
    //         "https://guardian.ng/news/police-arrest-suspected-kidnappers-while-collecting-ransom/",
    //     title: "Lorem ipsum dolor sit amet, consectetur ",
    //     content:
    //         "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod sed do eiusmod sed do eiusmodsed do eiusmod",
    //     date: "2h ago"),
    // PostModel(
    //     postId: "",
    //     category: "blog",
    //     type: "type",
    //     image: "assets/images/register_ill.png",
    //     url: "https://google.com",
    //     title: "Lorem ipsum dolor sit amet, consectetur ",
    //     content:
    //         "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod sed do eiusmod sed do eiusmodsed do eiusmod",
    //     date: "2h ago")
  ];

  @override
  void initState() {
    fetchPost();
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
            child: Column(
              children: [
                RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration(seconds: 0), () {
                      setState(() async {
                        fetchPost();
                        fetchPostFromLocal();
                        refreshData(context);
                        await http
                            .post(Uri.parse(rootDomain + "user.php"), body: {
                          "action": "refresh",
                          "username": userModel.username,
                        });
                        Navigator.pushNamed(context, "/Dashboard");
                        setState(() {});
                        // _demoData.addAll(["Ionic", "Xamarin"]);
                      });
                    });
                  },
                  child: FutureBuilder(
                    future: fetchPostFromLocal(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Container(
                          margin: EdgeInsets.only(top: 200),
                          child: CircularProgressIndicator(),
                        ));
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
                        child: DisplayData(data: snapshot.data),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class DisplayData extends StatefulWidget {
  var data;
  DisplayData({Key? key, required this.data}) : super(key: key);

  @override
  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  bool status = true;
  List list = [];
  @override
  void initState() {
    // TODO: implement initState

    if (widget.data['status']) {
      list = widget.data['msg'];
      setState(() {});
    } else {
      status = false;
      setState(() {});
    }
  }

  int i = 0;
  int linkAdsCount = 0;

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
                  linkAdsCount++;
                  var json = list[index];
                  bool isAds = false;

                  if (linkAdsCount == int.parse(settingsModel.link_ads_count)) {
                    isAds = true;
                    linkAdsCount = 0;
                  }

                  if (i == int.parse(settingsModel.postb4adds)) {
                    i = 0;

                    return Column(
                      children: [
                        SinglePost(
                            isAds: isAds,
                            postModel: PostModel(
                                postId: json['postId'],
                                category: json['category'],
                                type: json['type'],
                                image: json['image'],
                                url: json['url'],
                                title: json['title'],
                                content: json['content'],
                                date: json['date'],
                                likeCount: json['likeCount'],
                                commentCount: json['commentCount'],
                                shareCount: json['shareCount'],
                                author: json['author'])),
                        Container(
                          color: whiteColor,
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.grey,
                                        size: 15.0,
                                      ),
                                      Text(
                                        " Ads",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                      ),
                                    ],
                                  )),
                              showLinkBanner(context)
                              // showBannerAdd(height: 300, width: size.width)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }
                  return SinglePost(
                      isAds: isAds,
                      postModel: PostModel(
                          postId: json['postId'],
                          category: json['category'],
                          type: json['type'],
                          image: json['image'],
                          url: json['url'],
                          title: json['title'],
                          content: json['content'],
                          date: json['date'],
                          likeCount: json['likeCount'],
                          commentCount: json['commentCount'],
                          shareCount: json['shareCount'],
                          author: json['author']));
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
                  Text("No Post yet")
                ],
              ),
            ),
          );
  }
}

class Shima extends StatefulWidget {
  const Shima({Key? key}) : super(key: key);

  @override
  _ShimaState createState() => _ShimaState();
}

class _ShimaState extends State<Shima> {
  bool _enabled = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: const Color(0xffeeeeee),
              enabled: _enabled,
              child: ListView.builder(
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: size.width,
                        height: 200.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 30.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 30.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                itemCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
