import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppFunctions {
  static errorShowToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }

  static successShowToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.green,
      textColor: Colors.black,
      gravity: ToastGravity.TOP
    );
  }

  static warningShowToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.yellow,
      textColor: Colors.black,
      gravity: ToastGravity.TOP
    );
  }
}
