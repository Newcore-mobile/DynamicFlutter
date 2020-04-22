///
///Author: YoungChan
///Date: 2020-03-18 14:50:56
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 15:06:38
///Description: Widget 构建类
///
import 'package:flutter/material.dart';
import 'recommand_builder_box.dart';
import 'basebuilder_box.dart';
import 'package:dynamicflutter/ast_node.dart';

class FHWidgetBuilderFactory {
  static List<BaseBuilderBox> _builderBox = [RecommandBuilderBox()];

  ///设置自定义扩展Widget 构建器
  static void setExtendBuilderBox(BaseBuilderBox builderBox) {
    if (_builderBox.length == 2) {
      _builderBox.removeLast();
    }
    _builderBox.add(builderBox);
  }

  static Widget buildWidget(Map widgetAst, {Map variables}) {
    return buildWidgetWithExpression(Expression.fromAst(widgetAst),
        variables: variables);
  }

  static Widget buildWidgetWithExpression(Expression widgetExpression,
      {Map variables}) {
    if (widgetExpression != null) {
      //从builder box 中查找匹配的widget builder， 优先顺序 ExtendBuilderBox > RecommandBuilderBox
      for (var i = _builderBox.length; i > 0; i--) {
        var w =
            _builderBox[i - 1].build(widgetExpression, variables: variables);
        if (w != null) {
          return w;
        }
      }
    }

    return Container();
  }
}

Widget invokeWidgetBuilderFunction(Expression widgetExpression) {
  return null;
}
