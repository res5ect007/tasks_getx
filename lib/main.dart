import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tasks_getx/services/tranlations.dart';
import 'package:tasks_getx/views/errors/no_connection_page.dart';
import 'package:tasks_getx/views/pages/home_page.dart';
import 'package:tasks_getx/views/pages/login_page.dart';
import 'package:tasks_getx/views/pages/task_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: '/',
        defaultTransition: Transition.cupertino,
        translations: DialogsTranslations(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'UK'),
        debugShowCheckedModeBanner: false,
        // scrollBehavior: const MaterialScrollBehavior(
        //   androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
        // ),
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          // primaryColor: Colors.blue,
          // bottomAppBarColor: Colors.blue,
          cardColor: Colors.blue[100],
          fontFamily: 'Nunito',
    textTheme: TextTheme(
        headline1: TextStyle(color: Colors.deepPurpleAccent),
        headline2: TextStyle(color: Colors.orange),
        bodyText2: TextStyle(color: Colors.black),
        subtitle1: TextStyle(color: Colors.black),
      bodyText1:TextStyle(color: Colors.lightGreen),
      subtitle2: TextStyle(color: Colors.black),
      button: TextStyle(color: Colors.lightGreen),

     ),
          //scaffoldBackgroundColor: Colors.blue,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light, // 2
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
         useMaterial3: true,
          //primaryColor: Colors.blue,
          bottomAppBarColor: Colors.blue,
         // cardColor: Colors.orangeAccent,
          fontFamily: 'Nunito',
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        getPages: [
          GetPage(name: '/', page: () => const LoginPage()),
          GetPage(name: '/home', page: () => HomePage()),
          GetPage(name: '/task', page: () => const TaskPage()),
          //GetPage(name: '/task_edit', page: () => TaskEditPage()),
          GetPage(name: '/no_connection', page: () => NoConnectionPage()),
        ]);
  }
}
