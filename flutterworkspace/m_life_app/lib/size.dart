import 'package:flutter/material.dart';
double getScreenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double getDrawerWidth(BuildContext context){
  return getScreenWidth(context) * 0.6;
}
const double small_gap = 5.0;
const double medium_gap = 10.0;
const double large_gap = 20.0;
const double xlarge_gap = 100.0;
