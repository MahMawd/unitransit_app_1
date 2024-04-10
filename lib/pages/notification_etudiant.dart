
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView ({super.key});

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      //appBar: appBar(),
      body: listView(),
    );
  }
  /*PreferredSizeWidget appBar(){
    return AppBar(
      title: const Text('Notification bus'),
    );
  }*/
  Widget listView(){
    return ListView.separated(
      
      itemBuilder: (context, index) {
        return listViewItem(index);
      }, 
       separatorBuilder: (context, index) {
         return const Divider(height: 0);
       }, 
       itemCount: 15,
       );
  }
  Widget listViewItem(int index){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message(index),
                  timeAndData(index),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget prefixIcon(){
    return Container(
      height: 50,
      width: 50,
      padding:const  EdgeInsets.all(10),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.notifications,
      size: 25,
      color: Colors.black,),

    );
  }
  Widget message(int index){
    double textSize =14;
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: 'Message',
        style: TextStyle(
          fontSize: textSize,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children:const [
           TextSpan(
            text: 'Message Description',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ]
      ),
      );
  }
  Widget timeAndData(int index){
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '27-03-2024',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            '14:30',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}