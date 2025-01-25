import 'package:flutter/material.dart';

abstract class HasCommand extends StatefulWidget {
  final int commandNumber;
  final String commandDelimiter = 'ENDCMD';
  const HasCommand(this.commandNumber, {super.key});

  String constructCommand(List<String> arguments){
    String toRet = '$commandNumber ';
    for (String element in arguments) {
      toRet += '"$element" ';
    }
    toRet += commandDelimiter;
    return toRet;
  }
}
