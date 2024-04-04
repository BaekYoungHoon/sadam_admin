import 'package:flutter/material.dart';
import 'package:sadam_admin/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        measurementId: "G-CD7L4XQ12L")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보험 사고 알리미'),
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
