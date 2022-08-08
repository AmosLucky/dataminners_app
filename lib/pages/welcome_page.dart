//import 'package:dataminners/main.dart';

//import 'package:dataminners/pages/add_test.dart';

import 'package:dataminners/pages/add_test.dart';

import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  "banner-11.jpg",
  "banner-12.jpg",
  "banner-13.jpg",
  "banner-4.jpg",
  "banner-1.jpg",
];

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CarouselController _controller = CarouselController();

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            options: CarouselOptions(
                height: size.height * 0.5,
                viewportFraction: 1.0,
                enlargeCenterPage: true,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: imgList
                .map((item) => Container(
                      child: Center(
                          child: Image.asset(
                        "assets/images/" + item,
                        fit: BoxFit.contain,
                        height: size.height,
                      )),
                    ))
                .toList(),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.red
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.2)),
                  ),
                );
              }).toList()),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                    shape: StadiumBorder(),
                    color: primaryColor,
                    textColor: whiteColor,
                    child: Text("Sign In"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/Login");
                    },
                  ),
                  // MaterialButton(
                  //   shape: StadiumBorder(),
                  //   color: primaryColor,
                  //   textColor: whiteColor,
                  //   child: Text("Sign In2"),
                  //   onPressed: () {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //         builder: (BuildContext) => MyApp()));
                  //   },
                  // ),
                  MaterialButton(
                    shape: StadiumBorder(),
                    color: primaryColor,
                    textColor: whiteColor,
                    child: Text("Sign Up"),
                    onPressed: () {
                      Navigator.pushNamed(context, "/Register");
                    },
                  ),
                ],
              ))
        ],
      ),

      // body: Center(
      //   child: Container(
      //       child: CarouselSlider(
      //     options: CarouselOptions(),
      //     items: imgList
      //         .map((item) => Container(
      //               child: Center(
      //                   child: Image.network(item,
      //                       fit: BoxFit.cover, width: 1000)),
      //             ))
      //         .toList(),
      //   )),
      // ),
    );
  }
}
