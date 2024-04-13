import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FAQ{
  FirebaseFirestore db = FirebaseFirestore.instance;

  void addFAQ(String question, String answer) async {
    await db.collection("faq").doc().set({
      "question": question,
      "answer": answer,
    });
  }
  void deleteFAQ(String question) async {
    QuerySnapshot snapshot = await db.collection("faq").where("question", isEqualTo: question).get();
    snapshot.docs.forEach((element) {
      element.reference.delete();
    });
  }
  // Future<List<List<String>>> getFAQList() async {
  //   List<String> list = [];
  //   List<List<String>> a = [];
  //   final dbget = await db.collection("faq");
  //   QuerySnapshot snapshot = await dbget.get();
  //
  //   if (snapshot.docs.isNotEmpty) {
  //     for (QueryDocumentSnapshot doc in snapshot.docs) {
  //       list.add(doc.get("question"));
  //       list.add(doc.get("answer"));
  //       a.add(list);
  //     }
  //   }
  //   return a;
  // }

}