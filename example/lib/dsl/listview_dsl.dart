///
///Author: YoungChan
///Date: 2020-04-16 15:37:16
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 20:33:59
///Description: file content
///
import 'package:flutter/material.dart';

class ListViewDSL extends StatefulWidget {
  @override
  _ListViewDSLState createState() => _ListViewDSLState();
}

class _ListViewDSLState extends State<ListViewDSL> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'ListViewDSL',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.centerLeft,
            child: Text('Hellow World',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            color: Colors.lightBlue.shade300,
            height: 45,
          );
        },
        itemCount: 50,
      ),
    );
  }
}
