import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:dart_date/dart_date.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:students_app/View/general/appbar.dart';

class UserNotification extends StatefulWidget {
  UserNotification({Key? key}) : super(key: key);

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  bool isLoading = false;
  var results;
  var moreNotificationsResults;
  int user_id = 0;
  List<_Notification> notifications = [];
  late ScrollController _controller = ScrollController();
  int pages = 1;
  int notification_count = 0;

  getNotifications() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt("id")!;
    var url = "https://safrji.com/api/v1/admins/get-student-id";
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "id": user_id,
      }),
      headers: {"Content-type": "Application/json;charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      results = jsonDecode(response.body);

      for (int i = 0; i < results["notifications"].length; i++) {
        _Notification notification = new _Notification(
          results["notifications"][i]["student_id"],
          results["notifications"][i]["message"].toString(),
          results["notifications"][i]["created_at"].toString(),
        );
        notifications.add(notification);
      }
      prefs.setInt("notification_count", results["notifications"].length);
    }
    setState(() {
      isLoading = false;
    });
  }

  String notificationTime(String stringdate) {
    DateTime date = DateTime.parse(stringdate);
    DateTime now = DateTime.now();
    String time = "";
    if (date.isSameMonth(now)) {
      if (date.isSameDay(now) || now.difference(date).inDays == 0) {
        if (date.isSameHour(now) || now.difference(date).inHours == 0) {
          if (date.isSameMinute(now) || now.difference(date).inMinutes == 0) {
            if (now.difference(date).inSeconds < 3) {
              time = "الان";
            } else {
              if (now.difference(date).inSeconds >= 3 &&
                  now.difference(date).inSeconds <= 10) {
                time = "منذ ${now.difference(date).inSeconds} ثواني";
              } else {
                time = "منذ ${now.difference(date).inSeconds} ثانية";
              }
            }
          } else {
            if (now.difference(date).inSeconds <= 10) {
              if (now.difference(date).inSeconds == 1) {
                time = "منذ دقيقة";
              } else if (now.difference(date).inSeconds == 2) {
                time = "منذ دقيقتان";
              } else {
                time = "منذ ${now.difference(date).inMinutes} دقائق";
              }
            } else {
              time = "منذ ${now.difference(date).inMinutes} دقيقة";
            }
          }
        } else {
          if (now.difference(date).inHours <= 10) {
            if (now.difference(date).inHours == 1) {
              time = "منذ ساعة";
            } else if (now.difference(date).inHours == 2) {
              time = "منذ ساعتان";
            } else {
              time = "منذ ${now.difference(date).inHours} ساعات";
            }
          } else {
            time = "منذ ${now.difference(date).inHours} ساعة";
          }
        }
      } else {
        if (now.difference(date).inDays <= 10) {
          if (now.difference(date).inDays == 1) {
            time = "منذ يوم";
          } else if (now.difference(date).inDays == 2) {
            time = "منذ يومين";
          } else {
            time = "منذ ${now.difference(date).inDays} ايام";
          }
        } else {
          time = "منذ ${now.difference(date).inDays} يوم";
        }
      }
    } else {
      time = intl.DateFormat('yyyy-MM-dd').format(date);
    }
    return time;
  }

  String msg(String msg) {
    List<String> splitMsg = msg.split(" ");
    splitMsg[0] = "لقد قمت";
    splitMsg.removeAt(1);
    String finalMsg = "";
    for (int i = 0; i < splitMsg.length; i++) {
      finalMsg += splitMsg[i] + " ";
    }
    return finalMsg.toString();
  }

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Appbar(),
        body: Center(
          child: isLoading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: Color(0xff61B1DF),
                    ), //show this if state is loading
                  ],
                )
              : Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                          color: Colors.white,
                          height: screenHeight - (screenHeight / 17.5),
                          child: Container(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: ListView.builder(
                                controller: _controller,
                                shrinkWrap: true,
                                itemCount: notifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: ListTile(
                                            title: Text(
                                              notifications[index].msg,
                                              style: TextStyle(
                                                  color: Color(0xff61B1DF)),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            subtitle: InkWell(
                                              child: Text(
                                                notificationTime(
                                                    notifications[index]
                                                        .created_at),
                                                style: TextStyle(
                                                  color: Color(0xff61B1DF),
                                                ),
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
        ));
  }
}

class _Notification {
  final int user_id;
  final String msg;
  final String created_at;
  _Notification(this.user_id, this.msg, this.created_at);
}
