///
///Author: YoungChan
///Date: 2020-03-12 16:44:19
///LastEditors: YoungChan
///LastEditTime: 2020-03-24 14:46:38
///Description: widget builder interface
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';

abstract class BaseWidgetBuilder {
  Widget build(Expression widgetExpression, {Map variables}) =>
      SizedBox.fromSize(
        size: Size.square(0),
      );

  String get widgetName => "";
}
