import 'package:dataminners/constants.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

showAlertDialogUPdate(
  BuildContext context,
  String title,
  String message,
) {
  // set up the button

  // show the dialog
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: primaryColor),
          ),
          content: Text(message),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                LaunchReview.launch(
                    androidAppId: "dataminners.com", iOSAppId: "585027354");
              },
              child: Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}
