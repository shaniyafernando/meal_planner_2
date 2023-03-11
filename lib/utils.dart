import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)));
}

convertListToString(List<dynamic> list) {
  String line = list.toString();
  int i = line.length;
  return line.substring(1, i - 1);
}