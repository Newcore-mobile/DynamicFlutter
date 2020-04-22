///
///Author: YoungChan
///Date: 2020-03-17 18:55:07
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 18:43:34
///Description: file content
///
import 'package:flutter/material.dart';
import 'argument_comm_parser.dart';
import 'package:dynamicflutter/ast_node.dart';

BoxDecoration parseBoxDecoration(Expression expression) {
  if (expression.isMethodInvocation) {
    if ((expression.asMethodInvocation.callee.asIdentifier).name ==
        'BoxDecoration') {
      var argumentList = expression.asMethodInvocation.argumentList;
      var color = Colors.black;
      var border = Border.all(style: BorderStyle.none);
      var borderRadius = BorderRadius.circular(0);
      var shape = BoxShape.rectangle;

      for (var arg in argumentList) {
        if (arg.isNamedExpression) {
          switch (arg.asNamedExpression.label) {
            case 'color':
              color = parseColor(arg.asNamedExpression.expression);
              break;
            case 'border':
              border = parseBoxBorder(arg.asNamedExpression.expression);
              break;
            case 'borderRadius':
              borderRadius =
                  parseBorderRadius(arg.asNamedExpression.expression);
              break;
            case 'shape':
              shape = parseBoxShape(arg.asNamedExpression.expression);
              break;
          }
        }
      }
      return BoxDecoration(
          color: color,
          border: border,
          borderRadius: borderRadius,
          shape: shape);
    }
  }

  return null;
}

BoxBorder parseBoxBorder(Expression expression) {
  var borderStyle = BorderStyle.solid;
  var color = Colors.black;
  num width = 1;
  if (expression.isMethodInvocation) {
    var argumentList = expression.asMethodInvocation.argumentList;
    for (var arg in argumentList) {
      switch (arg.asIdentifier.name) {
        case 'color':
          color = parseColor(arg.asNamedExpression.expression);
          break;
        case 'width':
          width = arg.asNamedExpression.expression.asNumericLiteral.value;
          break;
        case 'style':
          if (arg.asNamedExpression.expression.isPrefixedIdentifier &&
              arg.asNamedExpression.expression.asPrefixedIdentifier.prefix ==
                  'BorderStyle') {
            switch (arg
                .asNamedExpression.expression.asPrefixedIdentifier.identifier) {
              case 'solid':
                borderStyle = BorderStyle.solid;
                break;
              case 'none':
                borderStyle = BorderStyle.none;
                break;
            }
          }
          break;
      }
    }
  }

  return Border.all(color: color, width: width.toDouble(), style: borderStyle);
}

BorderRadius parseBorderRadius(Expression expression) {
  if (expression.isMethodInvocation) {
    var argumentList = expression.asMethodInvocation.argumentList;
    var callee = expression.asMethodInvocation.callee;
    if (callee.isMemberExpression) {
      switch (callee.asMemberExpression.property) {
        case 'circular':
          num circular = 0;
          if ((argumentList?.length ?? 0) == 1) {
            circular = argumentList[0].asNumericLiteral.value;
          }
          return BorderRadius.circular(circular);
        case 'only':
          Radius topLeft = Radius.zero,
              topRight = Radius.zero,
              bottomLeft = Radius.zero,
              bottomRight = Radius.zero;
          for (var arg in argumentList) {
            switch (arg.asNamedExpression.label) {
              case 'topLeft':
                topLeft = parseRadius(
                    arg.asNamedExpression.expression.asMethodInvocation);
                break;
              case 'topRight':
                topRight = parseRadius(
                    arg.asNamedExpression.expression.asMethodInvocation);
                break;
              case 'bottomLeft':
                bottomLeft = parseRadius(
                    arg.asNamedExpression.expression.asMethodInvocation);
                break;
              case 'bottomRight':
                bottomRight = parseRadius(
                    arg.asNamedExpression.expression.asMethodInvocation);
                break;
            }
          }
          return BorderRadius.only(
              topLeft: topLeft,
              topRight: topRight,
              bottomLeft: bottomLeft,
              bottomRight: bottomRight);
      }
    }
  }

  return BorderRadius.circular(0);
}

BoxShape parseBoxShape(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'rectangle':
        return BoxShape.rectangle;
      case 'circle':
        return BoxShape.circle;
    }
  }

  return BoxShape.rectangle;
}
