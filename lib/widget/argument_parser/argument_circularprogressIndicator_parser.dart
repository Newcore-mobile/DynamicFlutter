///
///Author: YoungChan
///Date: 2020-03-17 13:24:11
///LastEditors: YoungChan
///LastEditTime: 2020-04-16 18:56:47
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';
import 'argument_comm_parser.dart';

Animation<Color> parseValueColor(Expression expression) {
  if (expression.isMethodInvocation &&
      expression.asMethodInvocation.callee.isIdentifier &&
      expression.asMethodInvocation.callee.asIdentifier.name ==
          'AlwaysStoppedAnimation') {
    var argumentList = expression.asMethodInvocation.argumentList;
    if ((argumentList?.length ?? 0) > 0) {
      return AlwaysStoppedAnimation(parseColor(argumentList[0]));
    }
  }
  return AlwaysStoppedAnimation(Colors.black);
}
