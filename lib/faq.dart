import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadam_admin/add_faq.dart';
import 'package:sadam_admin/drawer.dart';
import 'package:sadam_admin/controller.dart';

class faq extends StatefulWidget {
  @override
  _faqState createState() => _faqState();
}

class _faqState extends State<faq> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<List<String>> faqList = [];
  FAQ f = FAQ();
  @override
  void initState() {
    super.initState();
    getFAQList();
  }

  Future<void> getFAQList() async {
    final dbget = await db.collection("faq");
    QuerySnapshot snapshot = await dbget.get();

    if (snapshot.docs.isNotEmpty) {
      List<List<String>> tempList = [];
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        String question = doc.get("question");
        String answer = doc.get("answer");
        tempList.add([question, answer]);
      }
      setState(() {
        faqList = tempList;
      });
    }
  }
  void deleteFAQ(String question) async {
    f.deleteFAQ(question); // Firestore에서 문서 삭제
    setState(() {
      // 로컬 리스트에서 삭제된 FAQ 제거
      faqList.removeWhere((element) => element[0] == question);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        actions: [
          TextButton(onPressed: (){getFAQList();}, child: Text('새로고침')),
          TextButton(
            child: Text('FAQ 추가'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('FAQ 추가'),
                    content: Column(
                      children: [
                        TextField(
                          controller: faqquestionController,
                          decoration: InputDecoration(labelText: '질문'),
                        ),
                        TextField(
                          controller: faqanswerController,
                          decoration: InputDecoration(labelText: '답변'),
                        ),
                      ],
                    ),
                    actions: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              f.addFAQ(faqquestionController.text, faqanswerController.text);
                              getFAQList(); // 새로운 FAQ 추가 후 리스트 갱신
                              Navigator.pop(context);
                              faqanswerController.clear();
                              faqquestionController.clear();
                            },
                            child: Text('확인'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('취소'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: bar().drawer(context),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(faqList[index][0]),
            subtitle: Text(faqList[index][1]),
            trailing: ElevatedButton(
              onPressed: () {
                deleteFAQ(faqList[index][0]);
              },
              child: Text('삭제'),
            ),
          );
        },
      ),
    );
  }
}
