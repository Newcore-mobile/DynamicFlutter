///
///Author: YoungChan
///Date: 2020-03-16 13:35:48
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 18:44:09
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';
import 'argument_parser.dart';

TextStyle parseTextStyle(Expression expression) {
  var color = Colors.black;
  var fontStyle = FontStyle.normal;
  double fontSize = 14;
  var fontWeight = FontWeight.normal;
  if (expression.isMethodInvocation) {
    var argumentList = expression.asMethodInvocation.argumentList;
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        switch (arg.asNamedExpression.label) {
          case 'color':
            color = parseColor(arg.asNamedExpression.expression);
            break;
          case 'fontStyle':
            fontStyle = parseFontStyle(arg.asNamedExpression.expression);
            break;
          case 'fontWeight':
            fontWeight = parseFontWeight(arg.asNamedExpression.expression);
            break;
          case 'fontSize':
            fontSize = parseBaseLiteral(arg.asNamedExpression.expression)
                    ?.toDouble() ??
                14.0;
            break;
        }
      }
    }
  }

  return TextStyle(
      color: color,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      fontSize: fontSize);
}

TextAlign parseTextAlign(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'center':
        return TextAlign.center;
      case 'end':
        return TextAlign.end;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
    }
  }

  return TextAlign.center;
}

TextDirection parseTextDirection(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'ltr':
        return TextDirection.ltr;
      case 'rtl':
        return TextDirection.rtl;
    }
  }

  return TextDirection.ltr;
}

TextOverflow parseTextOverflow(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'clip':
        return TextOverflow.clip;
      case 'ellipsis':
        return TextOverflow.ellipsis;
      case 'fade':
        return TextOverflow.fade;
    }
  }

  return TextOverflow.ellipsis;
}

TextDecoration parseTextDecoration(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'lineThrough':
        return TextDecoration.lineThrough;
      case 'none':
        return TextDecoration.none;
      case 'overline':
        return TextDecoration.overline;
      case 'underline':
        return TextDecoration.underline;
    }
  }

  return TextDecoration.none;
}

FontStyle parseFontStyle(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'normal':
        return FontStyle.normal;
      case 'italic':
        return FontStyle.italic;
    }
  }

  return FontStyle.normal;
}

FontWeight parseFontWeight(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'normal':
        return FontWeight.normal;
      case 'bold':
        return FontWeight.bold;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
    }
  }

  return FontWeight.normal;
}
