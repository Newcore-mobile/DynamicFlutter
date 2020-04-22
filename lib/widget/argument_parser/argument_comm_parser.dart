///
///Author: YoungChan
///Date: 2020-03-12 18:05:59
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 18:42:35
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:dynamicflutter/ast_node.dart';
import '../widget_builders/widget_builder_factory.dart';

Color parseColor(Expression expression) {
  if (expression.isPrefixedIdentifier &&
      (expression.asPrefixedIdentifier).prefix == 'Colors') {
    switch ((expression.asPrefixedIdentifier).identifier) {
      case 'amber':
        return Colors.amber;
      case 'amberAccent':
        return Colors.amberAccent;
      case 'black':
        return Colors.black;
      case 'black12':
        return Colors.black12;
      case 'black26':
        return Colors.black26;
      case 'black38':
        return Colors.black38;
      case 'black45':
        return Colors.black45;
      case 'black54':
        return Colors.black54;
      case 'black87':
        return Colors.black87;
      case 'blue':
        return Colors.blue;
      case 'blueAccent':
        return Colors.blueAccent;
      case 'blueGrey':
        return Colors.blueGrey;
      case 'brown':
        return Colors.brown;
      case 'cyan':
        return Colors.cyan;
      case 'cyanAccent':
        return Colors.cyanAccent;
      case 'deepOrange':
        return Colors.deepOrange;
      case 'deepOrangeAccent':
        return Colors.deepOrangeAccent;
      case 'deepPurple':
        return Colors.deepPurple;
      case 'deepPurpleAccent':
        return Colors.deepPurpleAccent;
      case 'green':
        return Colors.green;
      case 'greenAccent':
        return Colors.greenAccent;
      case 'grey':
        return Colors.grey;
      case 'indigo':
        return Colors.indigo;
      case 'indigoAccent':
        return Colors.indigoAccent;
      case 'lightBlue':
        return Colors.lightBlue;
      case 'lightBlueAccent':
        return Colors.lightBlueAccent;
      case 'lightGreen':
        return Colors.lightGreen;
      case 'lightGreenAccent':
        return Colors.lightGreenAccent;
      case 'lime':
        return Colors.lime;
      case 'limeAccent':
        return Colors.limeAccent;
      case 'orange':
        return Colors.orange;
      case 'orangeAccent':
        return Colors.orangeAccent;
      case 'pink':
        return Colors.pink;
      case 'pinkAccent':
        return Colors.pinkAccent;
      case 'purple':
        return Colors.purple;
      case 'purpleAccent':
        return Colors.purpleAccent;
      case 'red':
        return Colors.red;
      case 'redAccent':
        return Colors.redAccent;
      case 'teal':
        return Colors.teal;
      case 'tealAccent':
        return Colors.tealAccent;
      case 'transparent':
        return Colors.transparent;
      case 'white':
        return Colors.white;
      case 'white10':
        return Colors.white10;
      case 'white12':
        return Colors.white12;
      case 'white24':
        return Colors.white24;
      case 'white30':
        return Colors.white30;
      case 'white38':
        return Colors.white38;
      case 'white54':
        return Colors.white54;
      case 'white60':
        return Colors.white60;
      case 'white70':
        return Colors.white70;
      case 'yellow':
        return Colors.yellow;
      case 'yellowAccent':
        return Colors.yellowAccent;
    }
  } else if (expression.isPropertyAccess) {
    var propertyExpression = expression.asPropertyAccess.expression;
    switch (expression.asPropertyAccess.name) {
      case 'shade50':
        return (parseColor(propertyExpression) as MaterialColor).shade50;
      case 'shade100':
        return (parseColor(propertyExpression) as MaterialColor).shade100;
      case 'shade200':
        return (parseColor(propertyExpression) as MaterialColor).shade200;
      case 'shade300':
        return (parseColor(propertyExpression) as MaterialColor).shade300;
      case 'shade400':
        return (parseColor(propertyExpression) as MaterialColor).shade400;
      case 'shade500':
        return (parseColor(propertyExpression) as MaterialColor).shade500;
      case 'shade600':
        return (parseColor(propertyExpression) as MaterialColor).shade600;
      case 'shade700':
        return (parseColor(propertyExpression) as MaterialColor).shade700;
      case 'shade800':
        return (parseColor(propertyExpression) as MaterialColor).shade800;
      case 'shade900':
        return (parseColor(propertyExpression) as MaterialColor).shade900;
    }
  } else if (expression.isMethodInvocation) {
    var methodInvocation = expression.asMethodInvocation;

    var calleeExpression = methodInvocation.callee;
    if (calleeExpression.isMemberExpression) {
      var callee = calleeExpression.asMemberExpression;
      var masterColor = parseColor(callee.object);
      num argumentValue = 255;
      var argumentList = methodInvocation.argumentList;
      if (argumentList != null && argumentList.length > 0) {
        if (argumentList[0].isNumericLiteral) {
          argumentValue = (argumentList[0] as NumericLiteral).value;
        }
      }
      switch (callee.property) {
        case 'withAlpha':
          return masterColor.withAlpha(argumentValue);
        case 'withBlue':
          return masterColor.withBlue(argumentValue);
        case 'withRed':
          return masterColor.withRed(argumentValue);
        case 'withGreen':
          return masterColor.withGreen(argumentValue);
        case 'withOpacity':
          return masterColor.withOpacity(argumentValue);
      }
    } else if (calleeExpression.isIdentifier &&
        (calleeExpression.asIdentifier).name == 'Color') {
      num argumentValue = 255;
      var argumentList = methodInvocation.argumentList;
      if (argumentList != null && argumentList.length > 0) {
        if (argumentList[0].isNumericLiteral) {
          argumentValue = (argumentList[0] as NumericLiteral).value;
        }
      }
      return Color(argumentValue);
    }
  }
  return Colors.black;
}

/// 解析基础数据类型，String， number， bool
dynamic parseBaseLiteral(Expression expression) {
  if (expression.isStringLiteral) {
    return (expression.asStringLiteral).value;
  } else if (expression.isNumericLiteral) {
    return (expression.asNumericLiteral).value;
  } else if (expression.isBooleanLiteral) {
    return (expression.asBooleanLiteral).value;
  } else {
    return null;
  }
}

EdgeInsets parseEdgeInsets(Expression expression) {
  if (expression.isMethodInvocation) {
    var methodInvocation = expression.asMethodInvocation;
    var callee = methodInvocation.callee;
    if (callee.isMemberExpression) {
      var memberExpression = callee.asMemberExpression;
      var argumentList = methodInvocation.argumentList;
      switch (memberExpression.property) {
        case 'symmetric':
          num vertical = .0, horizontal = .0;
          for (var arg in argumentList) {
            if (arg.isNamedExpression) {
              if (arg.asNamedExpression.label == 'vertical') {
                vertical = parseBaseLiteral(arg.asNamedExpression.expression)
                        ?.toDouble() ??
                    .0;
              } else if (arg.asNamedExpression.label == 'horizontal') {
                horizontal = parseBaseLiteral(arg.asNamedExpression.expression)
                        ?.toDouble() ??
                    .0;
              }
            }
          }
          return EdgeInsets.symmetric(
              vertical: vertical, horizontal: horizontal);
        case 'only':
          num left = 0, top = 0, right = 0, bottom = 0;
          for (var arg in argumentList) {
            if (arg.isNamedExpression) {
              switch (arg.asNamedExpression.label) {
                case 'left':
                  left = parseBaseLiteral(arg.asNamedExpression.expression)
                          ?.toDouble() ??
                      .0;
                  break;
                case 'top':
                  top = parseBaseLiteral(arg.asNamedExpression.expression)
                          ?.toDouble() ??
                      .0;
                  break;
                case 'right':
                  right = parseBaseLiteral(arg.asNamedExpression.expression)
                          ?.toDouble() ??
                      .0;
                  break;
                case 'bottom':
                  bottom = parseBaseLiteral(arg.asNamedExpression.expression)
                          ?.toDouble() ??
                      .0;
                  break;
              }
            }
          }
          return EdgeInsets.only(
              left: left.toDouble(),
              top: top.toDouble(),
              right: right.toDouble(),
              bottom: bottom.toDouble());
        case 'all':
          num all = 0;
          if ((argumentList?.length ?? 0) > 0 &&
              argumentList[0].isNumericLiteral) {
            all = (argumentList[0].asNumericLiteral).value;
          }
          return EdgeInsets.all(all.toDouble());
        case 'fromLTRB':
          num left = 0, top = 0, right = 0, bottom = 0;
          if ((argumentList?.length ?? 0) == 4) {
            if (argumentList[0].isNumericLiteral) {
              left = (argumentList[0].asNumericLiteral).value;
            }
            if (argumentList[1].isNumericLiteral) {
              top = (argumentList[1].asNumericLiteral).value;
            }
            if (argumentList[2].isNumericLiteral) {
              right = (argumentList[2].asNumericLiteral).value;
            }
            if (argumentList[3].isNumericLiteral) {
              bottom = (argumentList[3].asNumericLiteral).value;
            }
          }
          return EdgeInsets.fromLTRB(left.toDouble(), top.toDouble(),
              right.toDouble(), bottom.toDouble());
      }
    }
  } else if (expression.isPrefixedIdentifier) {
    var prefixedIdentifier = expression.asPrefixedIdentifier;
    if (prefixedIdentifier.prefix == 'EdgeInsets' &&
        prefixedIdentifier.identifier == 'zero') {
      return EdgeInsets.zero;
    }
  }
  return EdgeInsets.zero;
}

BoxConstraints parseBoxConstraints(Expression expression) {
  if (expression.isMethodInvocation) {
    var callee = expression.asMethodInvocation.callee;
    if (callee.isMemberExpression) {
      var memberExpression = callee.asMemberExpression;
      var argumentList = expression.asMethodInvocation.argumentList;
      switch (memberExpression.property) {
        case 'expand':
          double width = .0, height = .0;
          for (var arg in argumentList) {
            if (arg.isNamedExpression) {
              if (arg.asNamedExpression.label == 'width') {
                width = parseBaseLiteral(arg.asNamedExpression.expression)
                        ?.toDouble() ??
                    .0;
              } else if (arg.asNamedExpression.label == 'height') {
                height = parseBaseLiteral(arg.asNamedExpression.expression)
                        ?.toDouble() ??
                    .0;
              }
            }
          }
          return BoxConstraints.expand(width: width, height: height);
        case 'loose':
          Size size = Size.zero;
          if ((argumentList?.length ?? 0) == 1) {
            size = parseSize(argumentList[0]);
          }
          return BoxConstraints.loose(size);
        case 'tight':
          Size size = Size.zero;
          if ((argumentList?.length ?? 0) == 1) {
            size = parseSize(argumentList[0]);
          }
          return BoxConstraints.tight(size);
        case 'tightFor':
          double width = .0, height = .0;
          for (var arg in argumentList) {
            if (arg.isNamedExpression) {
              if (arg.asNamedExpression.label == 'width') {
                width = parseBaseLiteral(arg.asNamedExpression.expression)
                        ?.toDouble() ??
                    .0;
              } else if (arg.asNamedExpression.label == 'height') {
                height = parseBaseLiteral(arg.asNamedExpression.expression)
                        ?.toDouble() ??
                    .0;
              }
            }
          }
          return BoxConstraints.tightFor(width: width, height: height);
        case 'tightForFinite':
          double width = double.infinity, height = double.infinity;
          for (var arg in argumentList) {
            if (arg.isNamedExpression) {
              if (arg.asNamedExpression.label == 'width') {
                width = parseBaseLiteral(arg.asNamedExpression.expression)
                        ?.toDouble() ??
                    .0;
              } else if (arg.asNamedExpression.label == 'height') {
                height = parseBaseLiteral(arg.asNamedExpression.expression)
                        ?.toDouble() ??
                    .0;
              }
            }
          }
          return BoxConstraints.tightForFinite(width: width, height: height);
      }
    }
  }
  return null;
}

Size parseSize(Expression sizeExpression) {
  if (sizeExpression != null) {
    if (sizeExpression.isMethodInvocation) {
      var methodInvocation = sizeExpression.asMethodInvocation;
      var callee = methodInvocation.callee;
      var argumentList = methodInvocation.argumentList;
      if (callee.isMemberExpression) {
        var memberExpression = callee.asMemberExpression;
        switch (memberExpression.property) {
          case 'fromWidth':
            num width = 0;
            if ((argumentList?.length ?? 0) == 1) {
              width = (argumentList[0].asNumericLiteral).value;
            }
            return Size.fromWidth(width.toDouble());
          case 'fromHeight':
            num height = 0;
            if ((argumentList?.length ?? 0) == 1) {
              height = (argumentList[0].asNumericLiteral).value;
            }
            return Size.fromHeight(height.toDouble());
          case 'fromRadius':
            num radius = 0;
            if ((argumentList?.length ?? 0) == 1) {
              radius = (argumentList[0].asNumericLiteral).value;
            }
            return Size.fromRadius(radius.toDouble());
          case 'square':
            num dimension = 0;
            if ((argumentList?.length ?? 0) == 1) {
              dimension = (argumentList[0].asNumericLiteral).value;
            }
            return Size.square(dimension.toDouble());
        }
      } else if (callee.isIdentifier) {
        var identifier = callee.asIdentifier;
        if (identifier.name == 'Size') {
          num width = 0, height = 0;
          if ((argumentList?.length ?? 0) == 2) {
            width = (argumentList[0].asNumericLiteral).value;
            height = (argumentList[0].asNumericLiteral).value;
          }
          return Size(width.toDouble(), height.toDouble());
        }
      }
    } else if (sizeExpression.isPrefixedIdentifier) {
      var prefixedIdentifier = sizeExpression.asPrefixedIdentifier;
      if (prefixedIdentifier.prefix == 'Size') {
        switch (prefixedIdentifier.identifier) {
          case 'zero':
            return Size.zero;
          case 'infinite':
            return Size.infinite;
        }
      }
    }
  }

  return Size.zero;
}

Radius parseRadius(MethodInvocation radiusNode) {
  if (radiusNode != null) {
    var callee = radiusNode.callee;
    if (callee.isMemberExpression) {
      var memberExpression = callee.asMemberExpression;
      if ((memberExpression.object.asIdentifier).name == 'Radius' &&
          memberExpression.property == 'circular') {
        num circular = 0;
        if (radiusNode.argumentList.length == 1) {
          circular = (radiusNode.argumentList[0].asNumericLiteral).value;
        }
        return Radius.circular(circular.toDouble());
      }
    }
  }

  return Radius.zero;
}

Axis parseAxis(Expression expression) {
  if (expression.isPrefixedIdentifier &&
      expression.asPrefixedIdentifier.prefix == 'Axis') {
    if (expression.asPrefixedIdentifier.identifier == 'vertical') {
      return Axis.vertical;
    } else if (expression.asPrefixedIdentifier.identifier == 'horizontal') {
      return Axis.horizontal;
    }
  }
  return Axis.vertical;
}

Alignment parseAlignment(Expression expression) {
  if (expression.isPrefixedIdentifier) {
    switch (expression.asPrefixedIdentifier.identifier) {
      case 'topLeft':
        return Alignment.topLeft;
      case 'topRight':
        return Alignment.topRight;
      case 'topCenter':
        return Alignment.topCenter;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomRight':
        return Alignment.bottomRight;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'center':
        return Alignment.center;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
    }
  }

  return Alignment.center;
}
