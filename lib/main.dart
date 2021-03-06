import 'package:cityone_driver/const/route_names.dart';
import 'package:cityone_driver/route_pages.dart';
import 'package:cityone_driver/services/background_locator_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cityone_driver/repository/settings_repository.dart' as settingRepo;
import 'package:cityone_driver/helpers/app_config.dart' as config;
import 'package:global_configuration/global_configuration.dart';
import 'package:cityone_driver/repository/user_repository.dart' as userRepo;

import 'locator.dart';
import 'models/setting.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  await GetStorage.init();
  await Firebase.initializeApp();

  setupLocator();

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  final BackgroundLocatorServices _backgroundLocatorServices  = locator<BackgroundLocatorServices>();




  @override
  void initState() {
    settingRepo.initSettings();
     userRepo.getCurrentUser();
     _backgroundLocatorServices.initLocator();
     super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          return GetMaterialApp(
            getPages: RoutePages.routes,
              title: _setting.appName,
              initialRoute: SplashViewRoute,
              debugShowCheckedModeBanner: false,
              locale: _setting.mobileLanguage.value,
              theme: _setting.brightness.value == Brightness.light
                  ? ThemeData(
                fontFamily: 'ProductSans',
                primaryColor: Colors.white,
                floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                brightness: Brightness.light,
                accentColor: config.Colors().mainColor(1),
                dividerColor: config.Colors().accentColor(0.05),
                focusColor: config.Colors().accentColor(1),
                hintColor: config.Colors().secondColor(1),
                textTheme: TextTheme(
                  headline: TextStyle(fontSize: 22.0, color: config.Colors().secondColor(1)),
                  display1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1)),
                  display2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1)),
                  display3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                  display4: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1)),
                  subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1)),
                  title: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1)),
                  body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1)),
                  body2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1)),
                  caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().accentColor(1)),
                ),
              )
                  : ThemeData(
                fontFamily: 'ProductSans',
                primaryColor: Color(0xFF252525),
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Color(0xFF2C2C2C),
                accentColor: config.Colors().mainDarkColor(1),
                hintColor: config.Colors().secondDarkColor(1),
                focusColor: config.Colors().accentDarkColor(1),
                textTheme: TextTheme(
                  headline: TextStyle(fontSize: 22.0, color: config.Colors().secondDarkColor(1)),
                  display1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1)),
                  display2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1)),
                  display3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1)),
                  display4: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(1)),
                  subhead: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1)),
                  title: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1)),
                  body1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1)),
                  body2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1)),
                  caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(0.6)),
                ),
              ));
        });
  }
}