import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:students_app/View/4-profile/profile.dart';
import 'package:students_app/View/Notifications/notifications.dart';

var results;

class Appbar extends AppBar {
  Appbar({Key? key}) : super(key: key);

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  StreamController _streamController = StreamController();
  late Timer _timer;
  bool isLoading = false;
  int user_id = 0;
  int count = 0;
  int stored_count = 0;
  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      user_id = prefs.getInt("id")!;
      stored_count = prefs.getInt("notification_count") ?? 0;
      var url = "https://safrji.com/api/v1/admins/get-student-id";
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "id": user_id,
        }),
        headers: {"Content-type": "Application/json;charset=UTF-8"},
      );

      results = jsonDecode(response.body);
      count = results["notifications"].length;
      _streamController.add(results);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    // getCartData();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => getData());
    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer.isActive) _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
          return AppBar(
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Color(0xff61B1DF),
            // title: Text("الرئيسية"),
            actions: <Widget>[
              count == stored_count
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => UserNotification())));
                      },
                      icon: Icon(Icons.notifications),
                      tooltip: "الاشعارات",
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) =>
                                        UserNotification())));
                              },
                              icon: Icon(Icons.notifications),
                              tooltip: "الاشعارات",
                            ),
                            Positioned(
                                left: 25,
                                top: 23,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red),
                                    width: 16,
                                    height: 16,
                                    child: Center(
                                        child: Text(
                                            (count - stored_count).toString(),
                                            style: TextStyle(fontSize: 9)))))
                          ],
                        ),
                      ],
                    ),
            ],
          );
        return Container(
          color: Color(0xff61B1DF),
        );
      },
    );
  }
}
