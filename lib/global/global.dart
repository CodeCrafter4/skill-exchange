import 'package:shared_preferences/shared_preferences.dart';

import '../assistantMethods/bookmark_methods.dart';



SharedPreferences? sharedPreferences;
BookmarkMethods bookmarkMethods =BookmarkMethods();
String previousUnit="";
double countStarsRating = 0.0;
String titleStarsRating = "";
String fcmServerToken="key=AAAAdNddJP0:APA91bHaXZFfrgJcqNhNPvDiWlkVM3VXX4BW-EtHjLKojpiyCroc4amNzmSWELnGYg54vV9KXn33oroVLVyJDlOFVYqrG3-cAlv_ezCZtxIdeb_3J34MYNnPUACl9irzRdcD5QkPHMIr";
