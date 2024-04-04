import 'package:flutter/material.dart';
import 'package:sadam_admin/main.dart';
import 'package:sadam_admin/user_list.dart';
import 'package:sadam_admin/accident_list.dart';

class bar{
  Widget drawer(BuildContext context){
    return Drawer(
      backgroundColor: Color(0xff1B1B1B),
      child: ListView(
        children: [
          SizedBox(height: 50,),
          list("관리자 페이지", context, MyApp(), 14),
          SizedBox(height: 50,),
          list("회원 리스트", context, UserList(), 14),
          list("알림사고 리스트", context, AccidentList(), 14),
        ],
      ),
    );
  }
  Widget list(String title, BuildContext context, Widget page, double fontSize){
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'nanumRegular',
            fontSize: fontSize,
            fontWeight: FontWeight.w400
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}