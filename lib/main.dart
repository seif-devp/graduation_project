import 'package:flutter/material.dart';
import 'package:graduation_project/core/helpers/cache_helpers.dart';
import 'package:graduation_project/work.dart';

void main() {
  CacheHelper.init();
  runApp(const Work());
}
