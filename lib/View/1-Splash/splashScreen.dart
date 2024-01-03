import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:students_app/View/2-Login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students_app/View/3-Home/home.dart';
import 'package:students_app/View/8-TeacherHome/homeTeacher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int timeout = 0;

  getStart() async {
    Timer(Duration(seconds: 8), () {
      timeout = 1;
      setState(() {});
    });
  }

  void initState() {
    getStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return timeout == 1
        ? FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder:
                (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
              var x = prefs.data;
              if (prefs.hasData) {
                if (x?.getInt('isLoggedIn') != null) {
                  if (x?.getInt('isLoggedIn') == 1) {
                    return MaterialApp(
                      color: Colors.white,
                      home: Login(),
                      debugShowCheckedModeBanner: false,
                    );
                  } else if (x?.getInt('isLoggedIn') == 2) {
                    return MaterialApp(
                      color: Color.fromARGB(255, 240, 240, 240),
                      home: Home(),
                      debugShowCheckedModeBanner: false,
                    );
                  } else {
                    return MaterialApp(
                      color: Color.fromARGB(255, 240, 240, 240),
                      home: HomeTeacher(),
                      debugShowCheckedModeBanner: false,
                    );
                  }
                }
              }
              return MaterialApp(
                color: Color.fromARGB(255, 240, 240, 240),
                home: Login(),
                debugShowCheckedModeBanner: false,
              );
            })
        : Scaffold(
            body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: TextButton(
                // splashLco (1:1099)
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      60 * fem, 257 * fem, 60 * fem, 210 * fem),
                  width: double.infinity,
                  height: 800 * fem,
                  decoration: BoxDecoration(
                    color: Color(0xffF7F8F9),
                    borderRadius: BorderRadius.circular(25 * fem),
                  ),
                  child: Container(
                    // group29832c4X (1:1188)
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // image18kRd (1:1189)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 10.98 * fem),
                          width: 210 * fem,
                          height: 250 * fem,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/images/login_logo.jpg',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Text("برنامج متابعة الطلاب",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25 * ffem,
                                  color: Color(0xff9F279E))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
  }
}
