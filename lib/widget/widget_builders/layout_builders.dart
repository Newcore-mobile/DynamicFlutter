///
///Author: YoungChan
///Date: 2020-03-18 12:22:32
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 23:33:00
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';
import 'basewidget_builder.dart';
import 'widget_builder_factory.dart';
import '../argument_parser/argument_parser.dart';

class ScaffoldBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;
    var color = Colors.white;
    var appBar;
    var body;
    var floatingActionButton;
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        var expression = arg.asNamedExpression.expression;
        switch (arg.asNamedExpression.label) {
          case 'backgroundColor':
            color = parseColor(expression);
            break;
          case 'appBar':
            appBar =
                FHWidgetBuilderFactory.buildWidgetWithExpression(expression);
            break;
          case 'body':
            body = FHWidgetBuilderFactory.buildWidgetWithExpression(expression);
            break;
          case 'floatingActionButton':
            floatingActionButton =
                FHWidgetBuilderFactory.buildWidgetWithExpression(expression);
            break;
        }
      }
    }
    return Scaffold(
      backgroundColor: color,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }

  @override
  String get widgetName => 'Scaffold';
}

class ContainerBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;
    var color;
    double width;
    double height;
    var alignment = Alignment.center;
    var padding = EdgeInsets.zero;
    var margin = EdgeInsets.zero;
    var constraints;
    var decoration;
    var foregroundDecoration;
    Widget child;
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        var expression = arg.asNamedExpression.expression;
        switch (arg.asNamedExpression.label) {
          case 'color':
            color = parseColor(expression);
            break;
          case 'width':
            width = parseBaseLiteral(expression)?.toDouble();
            break;
          case 'height':
            height = parseBaseLiteral(expression)?.toDouble();
            break;
          case 'alignment':
            alignment = parseAlignment(expression);
            break;
          case 'padding':
            padding = parseEdgeInsets(expression);
            break;
          case 'margin':
            margin = parseEdgeInsets(expression);
            break;
          case 'constraints':
            constraints = parseBoxConstraints(expression);
            break;
          case 'decoration':
            decoration = parseBoxDecoration(expression);
            break;
          case 'foregroundDecoration':
            foregroundDecoration = parseBoxDecoration(expression);
            break;
          case 'child':
            child =
                FHWidgetBuilderFactory.buildWidgetWithExpression(expression);
            break;
        }
      }
    }
    return Container(
      color: color,
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      margin: margin,
      constraints: constraints,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      child: child,
    );
  }

  @override
  String get widgetName => 'Container';
}

class ListViewBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var callee = widgetExpression.asMethodInvocation.callee;
    var argumentList = widgetExpression.asMethodInvocation.argumentList;

    var reverse = false;
    double itemExtent;
    var padding = EdgeInsets.zero;
    var scrollDirection = Axis.vertical;
    var shrinkWrap = false;
    var itemCount = 0;
    Expression itemBuilderExpression;
    Expression separatorBuilderExpression;
    List<Widget> children = [];
    print("Build listview");
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        var expression = arg.asNamedExpression.expression;
        switch (arg.asNamedExpression.label) {
          case 'reverse':
            reverse = parseBaseLiteral(expression);
            break;
          case 'itemExtent':
            itemExtent = parseBaseLiteral(expression)?.toDouble();
            break;
          case 'padding':
            padding = parseEdgeInsets(expression);
            break;
          case 'scrollDirection':
            scrollDirection = parseAxis(expression);
            break;
          case 'shrinkWrap':
            shrinkWrap = parseBaseLiteral(expression);
            break;
          case 'itemCount':
            itemCount = parseBaseLiteral(expression);
            break;
          case 'itemBuilder':
            //读取itemBuilder 中返回的widget
            print("itemBuild: ${arg.asNamedExpression.expression}");
            itemBuilderExpression = arg.asNamedExpression.expression
                .asFunctionExpression.body.body[0].asReturnStatement.argument;
            break;
          case 'separatorBuilder':
            //读取separatorBuilder 中返回的Widget
            separatorBuilderExpression = arg.asNamedExpression.expression
                .asFunctionExpression.body.body[0].asReturnStatement.argument;
            break;
          case 'children':
            var childrenArgument =
                arg.asNamedExpression.expression.asListLiteral;
            for (var childExpression in childrenArgument.elements) {
              children.add(FHWidgetBuilderFactory.buildWidgetWithExpression(
                  childExpression));
            }
            break;
        }
      }
    }
    if (callee.isMemberExpression) {
      if (callee.asMemberExpression.property == 'builder') {
        return ListView.builder(
          itemBuilder: (context, index) {
            return FHWidgetBuilderFactory.buildWidgetWithExpression(
                itemBuilderExpression);
          },
          itemCount: itemCount,
          scrollDirection: scrollDirection,
          reverse: reverse,
          itemExtent: itemExtent,
          padding: padding,
          shrinkWrap: shrinkWrap,
        );
      } else if (callee.asMemberExpression.property == 'separated') {
        return ListView.separated(
          itemBuilder: (context, index) {
            return FHWidgetBuilderFactory.buildWidgetWithExpression(
                itemBuilderExpression);
          },
          itemCount: itemCount,
          scrollDirection: scrollDirection,
          reverse: reverse,
          separatorBuilder: (context, index) {
            return FHWidgetBuilderFactory.buildWidgetWithExpression(
                separatorBuilderExpression);
          },
          padding: padding,
          shrinkWrap: shrinkWrap,
        );
      }
    }
    return ListView(
      children: children,
      reverse: reverse,
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
    );
  }

  @override
  String get widgetName => 'ListView';
}

class RowBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;

    var mainAlignment = MainAxisAlignment.start;
    var mainAxisSize = MainAxisSize.max;
    var crossAlignment = CrossAxisAlignment.center;
    var textDirection = TextDirection.ltr;
    var verticalDirection = VerticalDirection.down;
    var children = <Widget>[];
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        var expression = arg.asNamedExpression.expression;
        switch (arg.asNamedExpression.label) {
          case 'mainAxisAlignment':
            mainAlignment = parseMainAxisAlignment(expression);
            break;
          case 'mainAxisSize':
            mainAxisSize = parseMainAxisSize(expression);
            break;
          case 'CrossAxisAlignment':
            crossAlignment = parseCrossAxisAlignment(expression);
            break;
          case 'textDirection':
            textDirection = parseTextDirection(expression);
            break;
          case 'verticalDirection':
            verticalDirection = parseVerticalDirection(expression);
            break;
          case 'children':
            var childrenArgument = expression.asListLiteral;
            for (var childExpression in childrenArgument.elements) {
              children.add(FHWidgetBuilderFactory.buildWidgetWithExpression(
                  childExpression));
            }
            break;
        }
      }
    }
    return Row(
      children: children,
      mainAxisAlignment: mainAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
    );
  }

  @override
  String get widgetName => 'Row';
}

class ColumnBuilder implements BaseWidgetBuilder {
  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    var argumentList = widgetExpression.asMethodInvocation.argumentList;

    var mainAlignment = MainAxisAlignment.start;
    var mainAxisSize = MainAxisSize.max;
    var crossAlignment = CrossAxisAlignment.center;
    var textDirection = TextDirection.ltr;
    var verticalDirection = VerticalDirection.down;
    var children = <Widget>[];
    for (var arg in argumentList) {
      if (arg.isNamedExpression) {
        var expression = arg.asNamedExpression.expression;
        switch (arg.asNamedExpression.label) {
          case 'mainAxisAlignment':
            mainAlignment = parseMainAxisAlignment(expression);
            break;
          case 'mainAxisSize':
            mainAxisSize = parseMainAxisSize(expression);
            break;
          case 'CrossAxisAlignment':
            crossAlignment = parseCrossAxisAlignment(expression);
            break;
          case 'textDirection':
            textDirection = parseTextDirection(expression);
            break;
          case 'verticalDirection':
            verticalDirection = parseVerticalDirection(expression);
            break;
          case 'children':
            var childrenArgument = expression.asListLiteral;
            for (var childExpression in childrenArgument.elements) {
              children.add(FHWidgetBuilderFactory.buildWidgetWithExpression(
                  childExpression));
            }
            break;
        }
      }
    }

    return Column(
      children: children,
      mainAxisAlignment: mainAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
    );
  }

  @override
  String get widgetName => 'Column';
}
