import 'package:flutter/material.dart';

Future<dynamic> showDialogWarning(
    String title, String content, BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Container(
          color: const Color(0xFF1976D2),
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Expanded(
              //child:
              Text(
                title,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              //),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.error,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(fontSize: 15),
        ),
        titlePadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        contentPadding: const EdgeInsets.all(18),
        actionsPadding: const EdgeInsets.only(bottom: 4, right: 8),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.black),
            ),
          ),
/*           TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.black),
            ),
          ), */
        ],
      );
    },
  );
}
