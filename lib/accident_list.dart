import 'package:flutter/material.dart';
import 'package:sadam_admin/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccidentList extends StatefulWidget {
  @override
  _AccidentListState createState() => _AccidentListState();
}

class _AccidentListState extends State<AccidentList> {
  List<Map<String, dynamic>> accidentDataList = [];

  @override
  void initState() {
    super.initState();
    // 화면이 처음 로드될 때 알림사고 목록을 가져옵니다.
    getAllUsersAccidents();
  }

  @override
  Widget build(BuildContext context) {
    bar D = bar();
    return Scaffold(
      appBar: AppBar(
        title: Text('알림사고 목록'),
      ),
      drawer: D.drawer(context),
      body: ListView.builder(
        itemCount: accidentDataList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> accidentData = accidentDataList[index];
          return ListTile(
            title: Text('사용자 이름 : ${accidentData['userId']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('사고 내용 : ${accidentData['description']}'),
                Text('전문가 질문 내용: ${accidentData['question']}'),
                // 추가적인 정보 표시 가능
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> getAllUsersAccidents() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> allAccidents = [];

    QuerySnapshot usersSnapshot = await firestore.collection('users').get();

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      String? userId = (userDoc.data() as Map<String, dynamic>?)?["UserName"];

      QuerySnapshot accidentsSnapshot = await userDoc.reference.collection('myAccident').get();

      for (QueryDocumentSnapshot accidentDoc in accidentsSnapshot.docs) {
        Map<String, dynamic> accidentData = accidentDoc.data() as Map<String, dynamic>;
        accidentData['userId'] = userId;
        allAccidents.add(accidentData);
      }
    }

    // 가져온 알림사고 목록을 상태에 저장하여 화면에 표시합니다.
    setState(() {
      accidentDataList = allAccidents;
    });
  }
}
