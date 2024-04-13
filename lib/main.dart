
import 'package:flutter/material.dart';
import 'package:sadam_admin/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBTjw9V82ijMHcJqzvPMtui3FLBFoh7BYw",
        authDomain: "claimassistant-45a0c.firebaseapp.com",
        projectId: "claimassistant-45a0c",
        storageBucket: "claimassistant-45a0c.appspot.com",
        messagingSenderId: "891306650978",
        appId: "1:891306650978:web:eb002571a054c8bae7103b",
        measurementId: "G-CD7L4XQ12L",

    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // subscribeToTopicForWebUsers();
  }

  // void subscribeToTopicForWebUsers() {
  //   // 모든 웹 앱 사용자를 'web_notifications' 주제에 구독
  //   _firebaseMessaging.subscribeToTopic('web_notifications');
  // }

  void sendPushNotification(String title, String body) async {
    try {
      final String serverKey = 'ya29.a0Ad52N3-ZTfFl6GP-4VWY_xxA1W7BIzniRSmoGOD1oCBVT_DVbX22OHwL1OKtEMx9KNkVo9nSSnttPLafU5kd6xoYbnAjotIEjDPCAGNTyGNDt0fXL7vAIEOA0ffhJ2CDVvhnQTLD592gsYd4CdQZNpFmTVIYHGdlNN0EaCgYKAcISARESFQHGX2MiSTVvU0dhYo_RpFnxZmU8uw0171'; // FCM 서버 키 입력
      final String url = "https://fcm.googleapis.com/v1/projects/claimassistant-45a0c/messages:send"; // 프로젝트 ID 입력
      final String fcmToken = 'f7uvn0goMFH2RZI6JcE2xD:APA91bGXkaZ0nNXtXO4DXatdzr4tmV5cIHgx16eG5pJgpm27ZNIYaaLqAhuy6bTzYC2KzIIF5wYHjGCMbG89btr0DSmt5Tfw555ciol83Ed8O6pIKVA4XVsM8uTaKtI3RBcvavlRKXBL';
      Uri fcmUrl = Uri.parse(url);

      final Map<String, dynamic> notification = {
        'title': title,
        'body': body,
      };

      final Map<String, dynamic> message = {
        'notification': notification,
        'token': fcmToken,
        'topic': 'all',

      };

      final String jsonMessage = jsonEncode(message);

      final http.Response response = await http.post(
        fcmUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $serverKey',
        },
        body: json.encode({
          "message": {
            "token": fcmToken,
            // "topic": "user_uid",

            "notification": {
              "title": title,
              "body": body,
            },
            "data": {
              "click_action": "FCM Test Click Action",
            },
            "android": {
              "notification": {
                "click_action": "Android Click Action",
              }
            },
            "apns": {
              "payload": {
                "aps": {
                  "category": "Message Category",
                  "content-available": 1
                }
              }
            }
          }
        })
        // jsonMessage,
      );

      if (response.statusCode == 200) {
        print('Push notification sent to all users successfully');
      } else {
        print('Failed to send push notification. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending push notification to all users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보험 사고 알리미'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              sendPushNotification('새로운 보험 사고 발생', '새로운 보험 사고가 발생했습니다. 확인해주세요.');
            },
          ),
        ],
      ),
      drawer: bar().drawer(context),
      body: Center(
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Age',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(const Text('John')),
                DataCell(const Text('28')),
                DataCell(const Text('Developer')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(const Text('Jane')),
                DataCell(const Text('32')),
                DataCell(const Text('Designer')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(const Text('Doe')),
                DataCell(const Text('25')),
                DataCell(const Text('Tester')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}