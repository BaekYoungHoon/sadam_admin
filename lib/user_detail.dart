import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadam_admin/controller.dart';

class UserDetail extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    int i = 0;

    void _showPopup(BuildContext context, String id){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('수정할 정보를 입력해주세요.'),
            content: Column(
              children: [
                TextField(
                  controller: accidentTypeController,
                  decoration: InputDecoration(labelText: '사고 종류'),
                ),
                TextField(
                  controller: accidentSiteController,
                  decoration: InputDecoration(labelText: '사고 지역'),
                ),
                TextField(
                  controller: coverageTypeController,
                  decoration: InputDecoration(labelText: '보험 사고 종류'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: '사고 내용'),
                ),
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(labelText: '질문 내용'),
                ),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(labelText: '답변 내용'),
                ),
                TextField(
                  controller: commissionController,
                  decoration: InputDecoration(labelText: '수수료'),
                ),
                TextField(
                  controller: isSignedController,
                  decoration: InputDecoration(labelText: '손해 사정 계약 체결 여부'),
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('users').doc(uidController.text).collection('myAccident').doc(id).update({
                        'accidentType': accidentTypeController.text,
                        'accidentSite': accidentSiteController.text,
                        'coverageType': coverageTypeController.text,
                        'description': descriptionController.text,
                        'question': questionController.text,
                        'answer': answerController.text,
                        'commission': int.parse(commissionController.text),
                        'isSigned': isSignedController.text,
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('수정'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('취소'),
                  ),
                ],
              )
            ],
          );
        },
      );

    }
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uidController.text).collection('myAccident').orderBy("timeStamp", descending: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            final error = snapshot.error.toString(); // 예외 객체를 문자열로 변환
            return Center(
              child: Text('Error: $error'), // 오류 문자열 출력
            );
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return FittedBox(
            child: DataTable(
              columns: [
                DataColumn(label: Text('No.')),
                DataColumn(label: Text('사고 종류')),
                DataColumn(label: Text('사고 지역')),
                DataColumn(label: Text('보험 사고 종류')),
                DataColumn(label: Text('사고 내용')),
                DataColumn(label: Text('질문 내용')),
                DataColumn(label: Text('답변 내용')),
                DataColumn(label: Text('수수료')),
                DataColumn(label: Text('손해 사정 계약 체결 여부')),
                DataColumn(label: Text('댓글 보기')),
                DataColumn(label: Text('수정 하기')),
              ],
              rows: documents.map((document) {
                final data = document.data() as Map<String, dynamic>;
                final accidentType = data['accidentType'] ?? 'N/A';
                final accidentSite = data['accidentSite'] ?? 'N/A';
                final coverageType = data['coverageType'] ?? 'N/A';
                final description = data['description'] ?? 'N/A';
                final question = data['question'] ?? 'N/A';
                final answer = data['answer'] ?? 'N/A';
                final commission = data['commission'] ?? 'N/A';
                final isSigned = data['isSigned'] ?? 'N/A';

                i++;
                return DataRow(cells: [
                  DataCell(Text(i.toString())),
                  DataCell(Text(accidentType)),
                  DataCell(Text(accidentSite)),
                  DataCell(Text(coverageType)),
                  DataCell(Text(description, overflow: TextOverflow.ellipsis, maxLines: 3)),
                  DataCell(Text(question, overflow: TextOverflow.ellipsis, maxLines: 3)),
                  DataCell(Text(answer, overflow: TextOverflow.ellipsis, maxLines: 3)),
                  DataCell(Text(commission.toString())),
                  DataCell(Text(isSigned)),
                  DataCell(
                      TextButton(
                        child: Text('댓글 보기'),
                        onPressed: () {
                          // 수정 버튼 클릭 시 사용자 정보 수정 페이지로 이동

                          print(document.id);
                          // Navigator.of(context).pushNamed('/edit_user', arguments: document.id);
                        },
                      )
                  ),
                  DataCell(
                      TextButton(
                        child: Text('수정 하기'),
                        onPressed: () {
                          accidentTypeController.text = accidentType;
                          accidentSiteController.text = accidentSite;
                          coverageTypeController.text = coverageType;
                          descriptionController.text = description;
                          questionController.text = question;
                          answerController.text = answer;
                          commissionController.text = commission.toString();
                          isSignedController.text = isSigned;
                          _showPopup(context, document.id);
                          print(document.id);
                        },
                      )
                  ),
                ],
                );
              }).toList(),

            ),
          );
        },
      ),
    );
  }
}
