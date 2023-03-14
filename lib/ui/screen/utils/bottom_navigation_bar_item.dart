import 'package:flutter/material.dart';

BottomNavigationBarItem bottomNavigationBarItem(
    {required iconName, required labelName}) {
  return BottomNavigationBarItem(
      icon: Icon(iconName), label: labelName);
}
