///
///Author: YoungChan
///Date: 2020-03-16 18:40:23
///LastEditors: YoungChan
///LastEditTime: 2020-04-16 19:05:49
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';

BoxFit parseBoxFit(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'fill':
        return BoxFit.fill;
      case 'cover':
        return BoxFit.cover;
      case 'contain':
        return BoxFit.contain;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'scaleDown':
        return BoxFit.scaleDown;
      case 'none':
        return BoxFit.none;
    }
  }

  return BoxFit.none;
}
