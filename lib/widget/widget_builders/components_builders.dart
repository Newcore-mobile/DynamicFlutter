import 'dart:convert';

///
///Author: YoungChan
///Date: 2020-03-18 12:22:42
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 18:55:51
///Description: file content
///
import 'dart:io';
import '../argument_parser/argument_parser.dart';
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';
import 'widget_builder_factory.dart';
import 'basewidget_builder.dart';

///构造Text，支持以下属性的解析：
///* text
///* style
///* textAlign
///* textDirection
///* overflow
///* maxLines
///* softWrap
///
class TextWidgetBuilder implements BaseWidgetBuilder {
  TextWidgetBuilder();

  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;
    String text = '';
    var style;
    var textAlign = TextAlign.left;
    var textDirection = TextDirection.ltr;
    var overflow = TextOverflow.ellipsis;
    int maxLines = 1;
    bool softWrap = true;
    for (var arg in argumentList) {
      if (arg.isStringLiteral) {
        text = arg.asStringLiteral.value;
      } else if (arg.isNamedExpression) {
        var expression = arg.asNamedExpression.expression;
        switch (arg.asNamedExpression.label) {
          case 'style':
            style = parseTextStyle(expression);
            break;
          case 'textAlign':
            textAlign = parseTextAlign(expression);
            break;
          case 'textDirection':
            textDirection = parseTextDirection(expression);
            break;
          case 'textOverflow':
            overflow = parseTextOverflow(expression);
            break;
          case 'maxLines':
            maxLines = parseBaseLiteral(expression) ?? 1;
            break;
          case 'softWrap':
            softWrap = parseBaseLiteral(expression) ?? false;

            break;
        }
      }
    }
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }

  @override
  String get widgetName => 'Text';
}

///构造CircularProgressIndicator,支持以下属性解析:
///* value
///* valueColor
///* strokeWidth
class CircularProgressIndicatorBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;
    var value;
    var valueColor = AlwaysStoppedAnimation(Colors.black);
    double strokeWidth = 1.5;
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        var expression = arg.asNamedExpression.expression;
        switch (arg.asNamedExpression.label) {
          case 'value':
            value = parseBaseLiteral(expression);
            break;
          case 'valueColor':
            valueColor = parseValueColor(expression);
            break;
          case 'strokeWidth':
            strokeWidth = parseBaseLiteral(expression)?.toDouble() ?? 1.5;
            break;
        }
      }
    }
    return CircularProgressIndicator(
      value: value,
      valueColor: valueColor,
      strokeWidth: strokeWidth,
    );
  }

  @override
  String get widgetName => 'CircularProgressIndicator';
}

///构造Icon,支持以下属性解析
///* icon
///* size
///* color
class IconBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;
    var icon = Icons.face;
    double size = 25;
    var color = Colors.black;
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        if (arg.asNamedExpression.label == 'size') {
          size =
              parseBaseLiteral(arg.asNamedExpression.expression)?.toDouble() ??
                  25.0;
        } else if (arg.asNamedExpression.label == 'color') {
          color = parseColor(arg.asNamedExpression.expression);
        }
      } else {
        var argIcon = parseIconData(arg);
        if (argIcon != null) {
          icon = argIcon;
        }
      }
    }
    return Icon(
      icon,
      size: size.toDouble(),
      color: color,
    );
  }

  @override
  String get widgetName => 'Icon';
}

///构造Image，支持以下构造方法：
///* asset
///* file
///* network
///
///支持以下属性解析：
///* width
///* height
///* scale
///* fit
class ImageBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var callee = widgetExpression.asMethodInvocation.callee;
    var argumentList = widgetExpression.asMethodInvocation.argumentList;
    num width;
    num height;
    num scale;
    var fit = BoxFit.none;
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        var expression = arg.asNamedExpression.expression;
        switch (arg.asNamedExpression.label) {
          case 'width':
            width = parseBaseLiteral(expression)?.toDouble() ?? .32;
            break;
          case 'height':
            height = parseBaseLiteral(expression)?.toDouble() ?? .32;
            break;
          case 'scale':
            scale = parseBaseLiteral(expression)?.toDouble() ?? .1;
            break;
          case 'fit':
            fit = parseBoxFit(expression);
            break;
        }
      }
    }
    if (callee.isMemberExpression) {
      switch (callee.asMemberExpression.property) {
        case 'asset':
          var arg0 = argumentList[0];
          var arg0Value = '';
          if (arg0.isStringLiteral) {
            arg0Value = arg0.asStringLiteral.value;
          } else if (arg0.isIdentifier) {
            arg0Value = variables[arg0.asIdentifier.name] ?? '';
          }
          return Image.asset(
            arg0Value,
            width: width,
            height: height,
            scale: scale,
            fit: fit,
          );
        case 'file':
          var arg0 = argumentList[0];
          File arg0Value;

          if (arg0.isMethodInvocation) {
            arg0Value = parseFileObject(arg0.asMethodInvocation);
          } else if (arg0.isIdentifier) {
            arg0Value = variables[arg0.asIdentifier.name];
          }
          return Image.file(
            arg0Value,
            width: width,
            height: height,
            scale: scale,
            fit: fit,
          );
        case 'network':
          var arg0 = argumentList[0];
          var arg0Value = '';
          if (arg0.isStringLiteral) {
            arg0Value = arg0.asStringLiteral.value;
          } else if (arg0.isIdentifier) {
            arg0Value = variables[arg0.asIdentifier.name] ?? '';
          }
          return Image.network(
            arg0Value,
            width: width,
            height: height,
            scale: scale,
            fit: fit,
          );
      }
    }
    return null;
  }

  @override
  String get widgetName => 'Image';
}

///构造AppBar，支持以下属性解析：
///* backgroundColor
///* centerTitle
///* title
class AppBarBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;
    var color = Colors.white;
    var title;
    var centerTitle;
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        switch (arg.asNamedExpression.label) {
          case 'backgroundColor':
            color = parseColor(arg.asNamedExpression.expression);
            break;
          case 'centerTitle':
            centerTitle =
                parseBaseLiteral(arg.asNamedExpression.expression) ?? true;
            break;
          case 'title':
            title = FHWidgetBuilderFactory.buildWidgetWithExpression(
                arg.asNamedExpression.expression);
            break;
        }
      }
    }

    return AppBar(
      backgroundColor: color,
      title: title,
      centerTitle: centerTitle,
    );
  }

  @override
  String get widgetName => 'AppBar';
}

class DividerBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;
    double height = 1.0;
    var color = Colors.black87;
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        if (arg.asNamedExpression.label == 'height') {
          height =
              parseBaseLiteral(arg.asNamedExpression.expression)?.toDouble() ??
                  1.0;
        } else if (arg.asNamedExpression.label == 'color') {
          color = parseColor(arg.asNamedExpression.expression);
        }
      }
    }
    return Divider(
      height: height,
      color: color,
    );
  }

  @override
  String get widgetName => 'Divider';
}
