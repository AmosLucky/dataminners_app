import 'dart:async';
import 'dart:io';

import 'package:dataminners/constants.dart';
import 'package:dataminners/models/post_model.dart';
import 'package:dataminners/pages/comment_sheet.dart';
import 'package:dataminners/widgets.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PostDetails extends StatefulWidget {
  final PostModel postModel;
  const PostDetails({Key? key, required this.postModel}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  int progress = 0;
  bool isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: whiteColor,
        toolbarHeight: 40,
        title: Text(
          widget.postModel.title,
          style: TextStyle(color: primaryColor),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Container(
              child: Column(
                children: [
                  isLoading
                      ? LinearProgressIndicator(
                          minHeight: 3,
                          backgroundColor: Colors.white,
                          value: progress / 100,
                          color: primaryColor)
                      : Container(),
                  // showBannerAdd(height: 60, width: size.width),
                  Stack(
                    children: [
                      showBannerAdd(height: 60, width: size.width),
                      Container(
                        padding: EdgeInsets.only(bottom: 2),
                        height: size.height * 0.82,
                        child: WebView(
                          initialUrl: widget.postModel.url,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller.complete(webViewController);
                          },
                          onProgress: (int progressInt) {
                            progress = progressInt;
                            if (progress > 90) {
                              isLoading = false;
                            } else {
                              isLoading = true;
                            }
                            print("WebView is loading (progress : $progress%)");
                            setState(() {});
                          },
                          navigationDelegate: (NavigationRequest request) {
                            // if (request.url
                            //     .startsWith('https://www.youtube.com/')) {
                            //   print('blocking navigation to $request}');
                            //   return NavigationDecision.prevent;
                            // }
                            // print('allowing navigation to $request');
                            return NavigationDecision.navigate;
                          },
                          onPageStarted: (String url) {
                            print('Page started loading: $url');
                          },
                          onPageFinished: (String url) {
                            print('Page finished loading: $url');
                          },
                          gestureNavigationEnabled: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),

            /////////////////////buttom activities///////////
            progress > 50
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            showBottomSheet(widget.postModel);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: lightGrey,
                            ),
                            height: 35,
                            child: Row(
                              children: [Icon(Icons.edit), Text("Comment...")],
                            ),
                          ),
                        )),
                        IconButton(
                            onPressed: () {
                              showBottomSheet(widget.postModel);
                            },
                            icon: Icon(
                              Icons.comment,
                              color: primaryColor,
                            )),
                        // IconButton(
                        //     onPressed: () {}, icon: Icon(Icons.favorite_border)),
                        IconButton(
                            onPressed: () {
                              //  FlutterShareMe().shareToSystem(msg: "kckck");
                              sharePosts(widget.postModel.title +
                                  "\n" +
                                  widget.postModel.content +
                                  "\n" +
                                  widget.postModel.url +
                                  "\n" +
                                  "Install dataminners \n Comment and get 10MB per post \n Install now " +
                                  appUrl);
                            },
                            icon: Icon(
                              Icons.share,
                              color: primaryColor,
                            ))
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void showBottomSheet(PostModel postModel) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (context) {
          return CommentSheet(
            postModel: postModel,
          );
        });
  }
}
