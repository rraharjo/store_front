import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<RawSocket> serverSocket = RawSocket.connect("127.0.0.1", 8000);

  Widget builder(BuildContext b, AsyncSnapshot<RawSocket> snapshot) {
    if (snapshot.connectionState == ConnectionState.done){
      return Scaffold();
    }
    else{
      return Text("waiting");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: serverSocket, builder: builder);
    //return Scaffold();
  }
}
