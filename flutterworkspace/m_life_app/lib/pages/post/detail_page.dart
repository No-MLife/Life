import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_life_app/pages/post/home_page.dart';
import 'package:m_life_app/pages/post/update_page.dart';
import 'package:m_life_app/size.dart';

class DetailPage extends StatelessWidget {
  final int id;
  const DetailPage(this.id);

  @override
  Widget build(BuildContext context) {
    // String data = Get.arguments;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("글 제목!!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
            Divider(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: (){
                    print("삭제 버튼 클릭");
                    Get.off(() => HomePage());
                  },
                  child: Text("삭제"),
                ),
                SizedBox(width: large_gap),
                ElevatedButton(
                  onPressed: (){
                    print("수정 버튼 클릭");
                    Get.to(() => UpdatePage());
                  },
                  child: Text("수정"),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child:
                Text("글 내용!!" * 500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
