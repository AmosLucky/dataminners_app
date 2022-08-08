import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dataminners/functions/click_function.dart';
import 'package:dataminners/models/comment_model.dart';
import 'package:dataminners/models/user_model.dart';
import 'package:dataminners/pages/post_details.dart';
import 'package:dataminners/pages/transactions.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:intl/intl.dart';

import 'constants.dart';
import 'models/post_model.dart';
import 'models/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

var interstitialAd;
InterstitialAd? _interstitialAd;
bool _isInterstitialAdReady = false;

/////////////////////////ROUND BUTTON/////////////////////
class RoundButton extends StatelessWidget {
  final onClick;
  final text;
  const RoundButton({Key? key, required this.onClick, this.text})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(29),
      ),
      width: size.width * 0.8,
      child: MaterialButton(
        child: Text(
          text,
          style: TextStyle(color: whiteColor),
        ),
        onPressed: onClick,
      ),
    );
  }
}

/////////////////////////INPUT FIELD/////////////////////

class TextFieldContainer extends StatelessWidget {
  Widget child;
  TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: this.child,
    );
  }
}

class PostIcon extends StatelessWidget {
  Widget icon;
  int count;

  //VoidCallback onClick;
  PostIcon(
      {Key? key,
      required this.icon,
      required this.count,
      VoidCallback? onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, Text(count.toString())],
        //count > 0 ? Text('${count}') : Container()
      ),
    );
  }
}

class SinglePost extends StatefulWidget {
  PostModel postModel;
  bool isAds;
  SinglePost({Key? key, required this.postModel, required this.isAds})
      : super(key: key);

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  bool isLiked = false;

  List likes = [];
  @override
  void initState() {
    likes = widget.postModel.likeCount.split(",");
    if (likes.contains(userModel.username)) {
      isLiked = true;
      setState(() {});
    }
    // TODO: implement initState
    super.initState();
  }

  String returnContent() {
    if (widget.postModel.content.length > 120) {
      return widget.postModel.content.substring(0, 120) + "...";
    } else {
      return widget.postModel.content;
    }
  }

  String returnTitle() {
    if (widget.postModel.title.length > 70) {
      return widget.postModel.title.substring(0, 70) + "...";
    } else {
      return widget.postModel.title;
    }
  }

  String returnSource() {
    if (widget.postModel.url.length > 30) {
      return widget.postModel.url.substring(0, 30) + "...";
    } else {
      return widget.postModel.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        adCounter();
        startAdsCounter();
        if (widget.isAds) {
          launchLinkAdsUrl();
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext) =>
                    PostDetails(postModel: widget.postModel)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(top: 10),
        color: Colors.white,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 5),
                //////////////////TITLE CONTAINER//////////
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    // Container(
                    //   child: CircleAvatar(
                    //     radius: 18,
                    //     backgroundColor: primaryColor,
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                returnTitle(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 5,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Author : " + widget.postModel.author!,
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 2),
                                  child: Text(
                                    widget.postModel.date,
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Container(
              //////////////////IMAGE CONTAINER//////////
              height: 200,
              width: size.width,
              child: loadImage(
                widget.postModel.image,
                BoxFit.fill,
              ),
            ),
            Container(
              //////////////////CONTENT CONTAINER//////////
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: size.width,
              color: Colors.grey[200],
              child: Column(
                children: [
                  Text(returnContent()),
                  Row(
                    children: [
                      Icon(
                        Icons.link,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        returnSource(),
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //////////////////ICON CONTAINER//////////
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: PostIcon(
                      count: likes.length,
                      icon: InkWell(
                        child: !isLiked
                            ? Icon(
                                Icons.favorite_border,
                                color: primaryColor,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                              ),
                        onTap: () {
                          adCounter();
                          print(likes);
                          if (likes.contains(userModel.username)) {
                            likes.remove(userModel.username);
                            setState(() {
                              isLiked = false;
                            });
                          } else {
                            likes.add(userModel.username);
                            setState(() {
                              isLiked = true;
                            });
                          }
                          LCS(rootDomain +
                              "post.php?action=lcsCount&accessToken=" +
                              userModel.accessToken +
                              "&username=" +
                              userModel.username +
                              "&postId=" +
                              widget.postModel.postId +
                              "&type=likeCount");
                        },
                      ),
                    )),
                    Expanded(
                        child: PostIcon(
                      count: widget.postModel.commentCount.split(",").length,
                      icon: InkWell(
                        child: Icon(
                          Icons.comment_sharp,
                          color: primaryColor,
                        ),
                        onTap: () {},
                      ),
                    )),
                    Expanded(
                        child: PostIcon(
                      count: widget.postModel.shareCount.split(",").length,
                      icon: InkWell(
                        child: Icon(
                          Icons.share,
                          color: primaryColor,
                        ),
                        onTap: () async {
                          //  FlutterShareMe().shareToSystem(msg: "kckck");
                          sharePosts(widget.postModel.title +
                              "\n" +
                              widget.postModel.content +
                              "\n" +
                              widget.postModel.url +
                              "\n" +
                              "Install dataminners \n Comment and get 10MB per post \n Install now " +
                              appUrl);

                          LCS(rootDomain +
                              "post.php?action=lcsCount&accessToken=" +
                              userModel.accessToken +
                              "&username=" +
                              userModel.username +
                              "&postId=" +
                              widget.postModel.postId +
                              "&type=shareCount");
                        },
                      ),
                    )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SingleTransaction extends StatelessWidget {
  final TransactonModel transactonModel;
  const SingleTransaction({Key? key, required this.transactonModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      width: size.width,
      color: whiteColor,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                transactonModel.type != "withdrawal"
                    ? Icon(
                        Icons.arrow_circle_up_sharp,
                        color: Colors.greenAccent,
                      )
                    : Icon(
                        Icons.arrow_circle_down_sharp,
                        color: Colors.redAccent,
                      ),
                Text(
                  transactonModel.date!,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transactonModel.activity!,
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  " To : " + transactonModel.beneficiary!,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            )),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transactonModel.reward! + "MB",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColor),
                ),
                // transactonModel.status == "success"
                //     ? Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(12),
                //           color: primaryColor,
                //         ),
                //         height: 18,
                //         width: 30,
                //         child: Icon(
                //           Icons.check_outlined,
                //           size: 20,
                //           color: whiteColor,
                //         ))
                //     :
                Text(
                  transactonModel.status! == "1" ? "Success" : "Pending",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SingleComment extends StatelessWidget {
  CommentModel commentModel;
  SingleComment({Key? key, required this.commentModel}) : super(key: key);
  var outputFormat = DateFormat('MM/dd, hh:mm a');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: CircleAvatar(
                backgroundColor: whiteColor,
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  //                    <--- top side
                  color: Colors.grey,
                  width: 0.5,
                ),
              )),
              padding: EdgeInsets.only(
                bottom: 15,
              ),
              margin: EdgeInsets.only(
                left: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      this.commentModel.username!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    this.commentModel.comment!,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        this.commentModel.commentDate!
                        // TimeAgo.timeAgoSinceDate(this.commentModel.commentDate!)
                        // outputFormat.format(
                        //     DateTime.parse(this.commentModel.commentDate!)
                        //     )
                        ,
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

Widget showNoRecord() {
  return Container(child: Image.asset("assets/images/noRecordFound.svg"));
}

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

/////////////////////////Advert///////////
///
final BannerAdListener listener = BannerAdListener(
  // Called when an ad is successfully received.
  onAdLoaded: (Ad ad) => print('Ad loaded.'),
  // Called when an ad request failed.
  onAdFailedToLoad: (Ad ad, LoadAdError error) {
    // Dispose the ad here to free resources.
    ad.dispose();
    print('Ad failed to load: $error');
  },
  // Called when an ad opens an overlay that covers the screen.
  onAdOpened: (Ad ad) => print('Ad opened.'),
  // Called when an ad removes an overlay that covers the screen.
  onAdClosed: (Ad ad) => print('Ad closed.'),
  // Called when an impression occurs on the ad.
  onAdImpression: (Ad ad) => print('Ad impression.'),
);
////////INTERSTITIALADD////////////
///

/////////////////BANNER AD////////////

showBannerAdd({required double height, required double width}) {
  InterstitialAd interstitialAd;
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-7712827866171461/1490335243',
    size: AdSize(width: width.toInt(), height: height.toInt()),
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final AdWidget adWidget = AdWidget(ad: myBanner);
  myBanner.load();
  if (settingsModel.showAdds == "1") {
    return Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
  }
  return Container(
    child: Text("no Add"),
  );
}

showInerstitialAdds() {
  InterstitialAd _interstitialAd;
  FullScreenContentCallback callback;
  interstitialAd = InterstitialAd.load(
      adUnitId: 'ca-app-pub-7712827866171461/5238008569',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ));

  // InterstitialAd.fullScreenContentCallback = FullScreenContentCallback(
  //   onAdShowedFullScreenContent: (InterstitialAd ad) =>
  //       print('$ad onAdShowedFullScreenContent.'),
  //   onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //     print('$ad onAdDismissedFullScreenContent.');
  //     ad.dispose();
  //   },
  //   onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //     print('$ad onAdFailedToShowFullScreenContent: $error');
  //     ad.dispose();
  //   },
  //   onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
  // );
}

loadImage(url, fit) {
  return Container(
    child: CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
          ),
        ),
      ),
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}

Widget showLinkBanner(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  List imageList = [
    "ad1.jpg",
    "ad2.jpg",
    "ad3.jpeg",
    "ad4.jpg",
    "ad4.png",
    "ad4.png",
    "ad5.jpg",
    "ad5.png",
    "ad7.jpg",
    "ad8.jpg",
    "ad9.jpg",
    "ad10.png",
    "ad11.png"
  ];
  Random random = new Random();
  int randomNumber = random.nextInt(imageList.length);
  return InkWell(
    onTap: () {
      launchLinkAdsUrl();

      // if (!await launch(settingsModel.link_ads_url))
      //   throw 'Could not launch $settingsModel.link_ads_url';
      //await launch(settingsModel.link_ads_url;
    },
    child: Container(
      width: width,
      height: 300,
      child: Image.asset(
        "assets/images/" + imageList[randomNumber],
        fit: BoxFit.fill,
        height: 300,
        width: width,
      ),
    ),
  );
}

launchLinkAdsUrl() async {
  String url = settingsModel.link_ads_url;
  if (!await launch(
    url,
    forceSafariVC: false,
    forceWebView: false,
    headers: <String, String>{'my_header_key': 'my_header_value'},
  )) {
    throw 'Could not launch $url';
  }
}
