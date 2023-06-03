import 'package:flutter/cupertino.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:movie_metric/main.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  enableFlutterDriverExtension();
  runApp(MovieMetric());
}