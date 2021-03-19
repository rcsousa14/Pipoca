import 'package:flutter/material.dart';

class ListData {
  Icon icon;
  String text;
  String description;
  Function onTap;

  ListData({this.icon, this.text, this.onTap, this.description});
}
