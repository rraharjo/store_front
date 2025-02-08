interface class HasCommand {
  const HasCommand();

  /*String constructCommand(List<String> arguments){
    final String commandDelimiter = 'ENDCMD';
    String toRet = 'Command number here ';
    for (String element in arguments) {
      toRet += '"$element" ';
    }
    toRet += commandDelimiter;
    return toRet;
  }*/

  int getCommand(){
    return -1;
  }

}
