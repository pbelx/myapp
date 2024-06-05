

import 'package:flutter/material.dart';
import 'package:myapp/themes/dark_mode.dart';
import 'package:myapp/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightmode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode; 

  set themeData(ThemeData themeData){
    //set theme
    _themeData = themeData;
    //update ui
    notifyListeners();
  }

  // toggl theme method 
  void toggleTheme(){
    if (_themeData == lightmode){
      themeData = darkMode;
    }else{
      themeData = lightmode;
    }
  }


}