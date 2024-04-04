import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadam_admin/drawer.dart';
import 'package:sadam_admin/controller.dart';
import 'package:sadam_admin/user_detail.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bar D = bar();

    void _showPopup(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('수정할 정보를 입력해주세요.'),
            content: Column(
              children: [
                TextField(
                  controller: userNameController,
                  decoration: InputDecoration(labelText: '회원명'),
                ),
                TextField(
                  controller: userIdController,
                  decoration: InputDecoration(labelText: '회원번호'),
                ),
                TextField(
                  controller: sponsorNameController,
                  decoration: InputDecoration(labelText: '소개회원'),
                ),
                TextField(
                  controller: sponsorIdController,
                  decoration: InputDecoration(labelText: '소개회원번호'),
                ),
                TextField(
                  controller: bankController,
                  decoration: InputDecoration(labelText: '은행'),
                ),
                TextField(
                  controller: accountNumberController,
                  decoration: InputDecoration(labelText: '계좌번호'),
                ),
                TextField(
                  controller: accountHolderController,
                  decoration: InputDecoration(labelText: '예금주'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: '핸드폰번호'),
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('users').doc(uidController.text).update({
                        'UserName': userNameController.text,
                        'UserId': userIdController.text,
                        'SponsorName': sponsorNameController.text,
                        'SponsorId': sponsorIdController.text,
                        'Bank': bankController.text,
                        'AccountNumber': accountNumberController.text,
                        'BankOwner': accountHolderController.text,
                        'PhoneNumber': phoneNumberController.text,
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
      drawer: D.drawer(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').orderBy("UserId", descending: false).snapshots(),
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
                DataColumn(label: Text('회원번호', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('회원명', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('가입경로', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('소개회원', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('소개회원번호',  style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('은행', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('계좌번호', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('예금주', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('핸드폰번호', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('UID', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('유저 정보 보기', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('유저 정보 수정', style: TextStyle(fontWeight: FontWeight.bold)))
              ],
              rows: documents.map((document) {
                final data = document.data() as Map<String, dynamic>;
                final userName = data['UserName'] ?? 'N/A';
                final userId = data['UserId'] ?? 'N/A';
                final loginType = data['LoginType'] ?? 'N/A';
                final sponsorName = data['SponsorName'] ?? 'N/A';
                final sponsorId = data['SponsorId'] ?? 'N/A';
                final bank = data['Bank'] ?? 'N/A';
                final accountNumber = data['AccountNumber'] ?? 'N/A';
                final accountHolder = data['BankOwner'] ?? 'N/A';
                final phoneNumber = data['PhoneNumber'] ?? 'N/A';
                final uid = document.id;

                return DataRow(cells: [
                  DataCell(Text(userId)),
                  DataCell(Text(userName)),
                  DataCell(Text(loginType)),
                  DataCell(Text(sponsorName)),
                  DataCell(Text(sponsorId)),
                  DataCell(Text(bank)),
                  DataCell(Text(accountNumber)),
                  DataCell(Text(accountHolder)),
                  DataCell(Text(phoneNumber)),
                  DataCell(Text(uid)),
                  DataCell(
                    TextButton(
                      child: Text('유저 정보 보기'),
                      onPressed: () {
                        // 수정 버튼 클릭 시 사용자 정보 수정 페이지로 이동

                        userNameController.text = userName;
                        userIdController.text = userId;
                        sponsorNameController.text = sponsorName;
                        sponsorIdController.text = sponsorId;
                        bankController.text = bank;
                        accountNumberController.text = accountNumber;
                        accountHolderController.text = accountHolder;
                        phoneNumberController.text = phoneNumber;
                        uidController.text = uid;
                        print(document.id);
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => UserDetail()));
                      },
                    ),
                  ),
                  DataCell(
                    TextButton(
                      child: Text('유저 정보 수정'),
                      onPressed: () {
                        userNameController.text = userName;
                        userIdController.text = userId;
                        sponsorNameController.text = sponsorName;
                        sponsorIdController.text = sponsorId;
                        bankController.text = bank;
                        accountNumberController.text = accountNumber;
                        accountHolderController.text = accountHolder;
                        phoneNumberController.text = phoneNumber;
                        _showPopup(context);
                        print(document.id);
                      },
                    ),
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
