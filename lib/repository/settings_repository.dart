import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;



import '../models/setting.dart';

ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
final navigatorKey = GlobalKey<NavigatorState>();

GetStorage box = GetStorage();

//LocationData locationData;

Future<Setting> initSettings() async {
  Setting _settingVar;
  final String url = '${GlobalConfiguration().getString('api_base_url')}settings';
  try {
    final response = await http.get(url, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200 && response.headers.containsValue('application/json')) {
      if (json.decode(response.body)['data'] != null) {
        await box.write('settings', json.encode(json.decode(response.body)['data']));
        _settingVar = Setting.fromJSON(json.decode(response.body)['data']);
        if (box.hasData('language')) {
          _settingVar.mobileLanguage.value = Locale(box.read('language'), '');
        }
        _settingVar.brightness.value = box.read('isDark') ?? false ? Brightness.dark : Brightness.light;
        setting.value = _settingVar;
      }
    } else {
      //print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e) {
    return Setting.fromJSON({});
  }
  return setting.value;
}