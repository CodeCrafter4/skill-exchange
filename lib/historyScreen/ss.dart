
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {

  List<Tab> tabs = [
    Tab(child: Text("Teal")),
    Tab(child: Text("Green")),
    Tab(child: Text("Blue")),
    Tab(child: Text("Yellow")),
    Tab(child: Text("Red")),
    Tab(child: Text("Orange")),
    Tab(child: Text("Grey")),
  ];

  List<Widget> tabsContent = [

    Container(color: Colors.teal),
    Container(color: Colors.green),
    Container(color: Colors.blue),
    Container(color: Colors.yellow),
    Container(color: Colors.red),
    Container(color: Colors.orange),
    Container(color: Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Scrollable Tab"),
          backgroundColor: Colors.green[700],
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: TabBar(
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: tabs,
            ),
          ), systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: TabBarView(
          children: tabsContent,
        ),
      ),
    );
  }
}
