///
///Author: YoungChan
///Date: 2020-04-17 11:30:50
///LastEditors: YoungChan
///LastEditTime: 2020-04-17 11:40:22
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';

MainAxisAlignment parseMainAxisAlignment(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
    }
  }
  return MainAxisAlignment.start;
}

MainAxisSize parseMainAxisSize(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'max':
        return MainAxisSize.max;
      case 'min':
        return MainAxisSize.min;
    }
  }
  return MainAxisSize.max;
}

CrossAxisAlignment parseCrossAxisAlignment(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      case 'stretch':
        return CrossAxisAlignment.stretch;
    }
  }
  return CrossAxisAlignment.center;
}

VerticalDirection parseVerticalDirection(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'down':
        return VerticalDirection.down;
      case 'up':
        return VerticalDirection.up;
    }
  }
  return VerticalDirection.down;
}
