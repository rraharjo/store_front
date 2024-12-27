import 'package:flutter/material.dart';
import 'error_page.dart';
import 'inventory_pages/inventory_page.dart';
import 'assets_pages/assets_page.dart';
import 'server_socket.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> connectStatus = ServerSocket.instance.connect();

  int _idx = 0;
  static List<Widget> functionalWidgets = <Widget>[
    InventoryGrid(),
    AssetsGrid(),
  ];
  List<BottomNavigationBarItem> navBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.inventory),
      label: "Inventory",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.house),
      label: "Assets",
    ),
  ];

  void _changeIdx(int idx) {
    setState(() {
      _idx = idx;
    });
  }

  Widget builder(BuildContext _, AsyncSnapshot<bool> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return const ErrorPage("Can't connect to Server");
      }
      return Scaffold(
        body: Center(
          child: functionalWidgets.elementAt(_idx),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: navBarItems,
          onTap: _changeIdx,
          currentIndex: _idx,
          backgroundColor: Colors.blue[600],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.lightBlueAccent[100],
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text("Waiting"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: connectStatus, builder: builder);
  }
}
