///
///Author: YoungChan
///Date: 2020-03-17 11:22:54
///LastEditors: YoungChan
///LastEditTime: 2020-04-16 18:59:24
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';

IconData parseIconData(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'face':
        return Icons.face;
    }
  }
  return null;
}
