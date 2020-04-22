///
///Author: YoungChan
///Date: 2020-03-24 14:45:29
///LastEditors: YoungChan
///LastEditTime: 2020-03-24 14:46:14
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';

abstract class BaseBuilderBox {
  Widget build(Expression widgetExpression, {Map variables}) =>
      SizedBox.fromSize(
        size: Size.square(0),
      );
}
