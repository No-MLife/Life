import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/components/Logo.dart';
import 'package:m_life_app/pages/post/detail_page.dart';
import 'package:m_life_app/pages/post/wrtie_page.dart';
import 'package:m_life_app/pages/user/user_info.dart';
import 'package:m_life_app/size.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _nvaigation(context),
      appBar: AppBar(),
      body: ListView.separated(
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: (){
                Get.to(() => DetailPage(index), arguments: "매개변수 테스트용");
              },
              title: Text("제목"),
              leading: Text("1"),
            );
          }, separatorBuilder: (context, index) {
            return Divider();
          }, ),
    );
  }

  Widget _nvaigation(BuildContext context) {
    return Container(
      width : getDrawerWidth(context),
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: (){
                  Get.to(() => WritePage());
                },
                child:
                Text(
                  "글쓰기",
                  style:
                  TextStyle(
                      fontSize: 20,
                      fontWeight:  FontWeight.bold,
                      color: Colors.black54),),
              ),
              Divider(),
              TextButton(
                onPressed: (){
                  Get.to(() => UserInfo());
                },
                child:
                Text(
                  "회원정보보기",
                  style:
                  TextStyle(
                      fontSize: 20,
                      fontWeight:  FontWeight.bold,
                      color: Colors.black54),),
              ),
              Divider(),
              TextButton(
                onPressed: (){},
                child:
                Text(
                  "로그아웃",
                  style:
                  TextStyle(
                      fontSize: 20,
                      fontWeight:  FontWeight.bold,
                      color: Colors.black54),),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
