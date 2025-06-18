import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(
      {required BuildContext context, required String message}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text(message),
              ],
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(
      {required BuildContext context,
      String title = '',
      required String content,
      String? posName,
      Function? posAction,
      String? negName,
      Function? negAction}) {
    showDialog(
        context: context,
        builder: (context) {
          List<Widget> actions = [];
          if (posName != null) {
            actions.add(TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (posAction != null) {
                    posAction.call();
                  }
                },
                child: Text(posName)));
          }
          if (negName != null) {
            actions.add(TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (negAction != null) {
                    negAction.call();
                  }
                },
                child: Text(negName)));
          }
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: actions,
          );
        });
  }
}
