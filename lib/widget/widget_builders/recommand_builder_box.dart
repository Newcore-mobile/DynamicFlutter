///
///Author: YoungChan
///Date: 2020-03-19 11:22:10
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 23:26:43
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';
import 'basewidget_builder.dart';
import 'basebuilder_box.dart';
import 'components_builders.dart';
import 'layout_builders.dart';

class RecommandBuilderBox implements BaseBuilderBox {
  List<BaseWidgetBuilder> _widgetBuilders = [
    TextWidgetBuilder(),
    CircularProgressIndicatorBuilder(),
    IconBuilder(),
    ImageBuilder(),
    AppBarBuilder(),
    ContainerBuilder(),
    ScaffoldBuilder(),
    DividerBuilder(),
    ListViewBuilder(),
    RowBuilder(),
    ColumnBuilder(),
  ];

  @override
  Widget build(Expression widgetExpression, {Map variables}) {
    if (widgetExpression != null && widgetExpression.isMethodInvocation) {
      var callee = widgetExpression.asMethodInvocation.callee;
      if (callee.isIdentifier) {
        for (var builder in _widgetBuilders) {
          if (builder.widgetName == callee.asIdentifier.name) {
            return builder?.build(widgetExpression, variables: variables);
          }
        }
      } else if (callee.isMemberExpression) {
        for (var builder in _widgetBuilders) {
          if (builder.widgetName ==
              callee.asMemberExpression.object.asIdentifier.name) {
            return builder?.build(widgetExpression, variables: variables);
          }
        }
      }
    }
    return null;
  }
}
