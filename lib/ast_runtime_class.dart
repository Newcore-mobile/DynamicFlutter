///
///Author: YoungChan
///Date: 2020-04-18 19:47:09
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 17:42:57
///Description: runtime 数据类定义
///
import 'ast_node.dart';
import 'ast_varialble_stack.dart';

String _TAG = "[Ast Runtime Class] ";

class AstRuntime {
  AstClass _astClass;
  AstVariableStack _variableStack;

  AstRuntime(Map ast) {
    if (ast['type'] == astNodeNameValue(AstNodeName.Program)) {
      var body = ast['body'] as List;
      _variableStack = AstVariableStack();
      _variableStack.blockIn();
      body?.forEach((b) {
        if (b['type'] == astNodeNameValue(AstNodeName.ClassDeclaration)) {
          //解析类
          _astClass = AstClass.fromAst(b, variableStack: _variableStack);
        } else if (b['type'] ==
            astNodeNameValue(AstNodeName.FunctionDeclaration)) {
          //解析全局函数
          var func = AstFunction.fromAst(b);
          _variableStack.setFunctionInstance<AstFunction>(func.name, func);
        }
      });
    }
  }

  ///调用类方法，注意参数列表顺序与模版代码相同
  Future callMethod(String methodName, {List params}) async {
    if (_astClass != null) {
      return _astClass.callMethod(methodName, params: params);
    }
    return Future.value();
  }

  ///调用全局函数，注意参数列表顺序与模版代码相同
  Future callFunction(String functionName, {List params}) async {
    var function =
        _variableStack.getFunctionInstance<AstFunction>(functionName);
    if (function != null) {
      return function.invoke(params, variableStack: _variableStack);
    }
    return Future.value();
  }
}

class AstClass {
  AstVariableStack _variableStack;

  AstClass(this._variableStack);

  dynamic callMethod(String name, {List params}) {
    var method = _variableStack.getFunctionInstance<AstFunction>(name);
    if (method != null) {
      return method.invoke(params, variableStack: _variableStack);
    }
    return null;
  }

  factory AstClass.fromAst(Map ast, {AstVariableStack variableStack}) {
    if (ast['type'] == astNodeNameValue(AstNodeName.ClassDeclaration)) {
      var classNode = ClassDeclaration.fromAst(ast);

      if (variableStack == null) {
        variableStack = AstVariableStack();
      }
      variableStack.blockIn();

      for (var b in classNode.body) {
        if (b.isMethodDeclaration) {
          //解析类方法
          var method = b.asMethodDeclaration;
          variableStack.setFunctionInstance<AstFunction>(
              method.name,
              AstFunction(method.name, method.parameterList, method.body,
                  method.isAsync));
        } else if (b.isVariableDeclarationList) {
          //解析类成员变量
          variableStack.setVariableValue(
              b.asVariableDeclarationList.declarationList[0].name,
              _executeBaseExpression(b, variableStack));
        }
      }
      return AstClass(variableStack);
    }
    return null;
  }
}

class AstFunction {
  List<SimpleFormalParameter> _parameterList;
  BlockStatement _body;
  String name;
  bool _isAsync;
  AstFunction(this.name, this._parameterList, this._body, this._isAsync);

  Future invoke(List params, {AstVariableStack variableStack}) async {
    if (variableStack == null) {
      variableStack = AstVariableStack();
    }
    variableStack.blockIn();
    //初始化函数参数
    if (params?.isNotEmpty == true && params.length == _parameterList.length) {
      for (var i = 0; i < params.length; i++) {
        variableStack.setVariableValue(_parameterList[i].name, params[i]);
      }
    }

    var result = await _executeBlockStatement(_body, variableStack);
    variableStack.blockOut();
    return Future.value(result);
  }

  factory AstFunction.fromExpression(Expression expression) {
    if (expression.isFunctionDeclaration) {
      var function = expression.asFunctionDeclaration;
      return AstFunction(function.name, function.expression.parameterList,
          function.expression.body, function.expression.isAsync);
    } else if (expression.isMethodDeclaration) {
      var method = expression.asMethodDeclaration;
      return AstFunction(
          method.name, method.parameterList, method.body, method.isAsync);
    }

    return null;
  }

  factory AstFunction.fromAst(Map ast) {
    if (ast != null) {
      if (ast['type'] == astNodeNameValue(AstNodeName.MethodDeclaration)) {
        var method = MethodDeclaration.fromAst(ast);
        return AstFunction(
            method.name, method.parameterList, method.body, method.isAsync);
      } else if (ast['type'] ==
          astNodeNameValue(AstNodeName.FunctionDeclaration)) {
        var function = FunctionDeclaration.fromAst(ast);
        return AstFunction(function.name, function.expression.parameterList,
            function.expression.body, function.expression.isAsync);
      }
    }
    return null;
  }
}

Future _executeBlockStatement(
    BlockStatement block, AstVariableStack variableStack) async {
  variableStack.blockIn();
  var result;
  if (block.body?.isNotEmpty == true) {
    for (var expression in block.body) {
      result = await _executeBodyExpression(expression, variableStack);
    }
  }

  variableStack.blockOut();
  return Future.value(result);
}

//解析执行语法逻辑
Future _executeBodyExpression(
    Expression expression, AstVariableStack variableStack) async {
  if (expression.isVariableDeclarationList) {
    await _executeVariableDeclaration(
        expression.asVariableDeclarationList, variableStack);
  } else if (expression.isAssignmentExpression) {
    await _executeAssignmentExpression(
        expression.asAssignmentExpression, variableStack);
  } else if (expression.isIfStatement) {
    await _executeIfStatement(expression.asIfStatement, variableStack);
  } else if (expression.isForStatement) {
    await _executeForStatement(expression.asForStatement, variableStack);
  } else if (expression.isExpressionStatement) {
    await _executeBodyExpression(expression.asExpression, variableStack);
  } else if (expression.isSwitchStatement) {
    await _executeSwitchStatement(expression.asSwitchStatement, variableStack);
  } else if (expression.isFunctionDeclaration) {
    //构造函数调用的参数值
    var params = [];
    var function = expression.asFunctionDeclaration;
    function.expression.parameterList?.forEach((p) {
      params.add(variableStack.getVariableValue(p.name).value);
    });
    return AstFunction.fromExpression(expression)
        .invoke(params, variableStack: variableStack);
  } else if (expression.isMethodDeclaration) {
    //构造方法调用的参数值
    var params = [];
    var function = expression.asFunctionDeclaration.expression;
    function.parameterList?.forEach((p) {
      params.add(variableStack.getVariableValue(p.name).value);
    });
    return AstFunction.fromExpression(expression)
        .invoke(params, variableStack: variableStack);
  } else if (expression.isReturnStatement) {
    return _executeBaseExpression(
        expression.asReturnStatement.argument, variableStack);
  }
  return Future.value();
}

///解析有返回值的基础表达式
dynamic _executeBaseExpression(
    Expression expression, AstVariableStack variableStack) {
  if (expression.isIdentifier) {
    return variableStack.getVariableValue(expression.asIdentifier.name)?.value;
  } else if (expression.isStringLiteral) {
    return expression.asStringLiteral.value;
  } else if (expression.isNumericLiteral) {
    return expression.asNumericLiteral.value;
  } else if (expression.isBooleanLiteral) {
    return expression.asBooleanLiteral.value;
  } else if (expression.isListLiteral) {
    return _executeListLiteral(expression.asListLiteral, variableStack);
  } else if (expression.isMapLiteral) {
    return _executeMapLiteral(expression.asMapLiteral, variableStack);
  } else if (expression.isBinaryExpression) {
    return _executeBinaryExpression(
        expression.asBinaryExpression, variableStack);
  } else if (expression.isPrefixedIdentifier) {
    //TODO prefix identifier
  } else if (expression.isIndexExpression) {
    return _executeIndexExpression(expression.asIndexExpression, variableStack);
  }
  return null;
}

List _executeListLiteral(
    ListLiteral listLiteral, AstVariableStack variableStack) {
  var list = [];
  listLiteral.elements.forEach((e) {
    list.add(_executeBaseExpression(e, variableStack));
  });
  return list;
}

Map _executeMapLiteral(MapLiteral mapLiteral, AstVariableStack variableStack) {
  var map = {};
  mapLiteral.elements.forEach((k, v) {
    map[k] = _executeBaseExpression(v, variableStack);
  });
  return map;
}

Future _executeVariableDeclaration(
    VariableDeclarationList variableDeclarationList,
    AstVariableStack variableStack) async {
  var variableDeclarator = variableDeclarationList.declarationList[0];
  if (variableDeclarator.init.isAwaitExpression) {
    //await expression;
    var value = await _executeMethodInvocation(
        variableDeclarator.init.asAwaitExpression.expression, variableStack);
    //存入声明的初始化变量值
    variableStack.setVariableValue(variableDeclarator.name, value);
  } else if (variableDeclarator.init.isMethodInvocation) {
    var value = await _executeMethodInvocation(
        variableDeclarator.init.asMethodInvocation, variableStack);
    //存入声明的初始化变量值
    variableStack.setVariableValue(variableDeclarator.name, value);
  } else {
    //存入声明的初始化变量值
    var v = _executeBaseExpression(variableDeclarator.init, variableStack);
    variableStack.setVariableValue(variableDeclarator.name, v);
  }
  return Future.value();
}

Future _executeIfStatement(
    IfStatement ifStatement, AstVariableStack variableStack) async {
  bool condition =
      _executeBinaryExpression(ifStatement.condition, variableStack) as bool;
  if (condition) {
    await _executeBlockStatement(ifStatement.consequent, variableStack);
  } else {
    await _executeBlockStatement(ifStatement.alternate, variableStack);
  }
  return Future.value();
}

Future _executeForStatement(
    ForStatement forStatement, AstVariableStack variableStack) async {
  var forLoopParts = forStatement.forLoopParts;
  //for...in... 语句处理
  if (forStatement.type == ForLoopParts.forEachPartsWithDeclaration) {
    //获取迭代数据集
    var iterableValue =
        (variableStack.getVariableValue(forLoopParts.iterable)?.value ?? [])
            as List;
    if (iterableValue?.isNotEmpty == true) {
      iterableValue.forEach((v) {
        //将迭代值存入变量栈
        variableStack.setVariableValue(forLoopParts.loopVariable, v);
        //执行循环内的逻辑
        _executeBlockStatement(forStatement.body, variableStack);
      });
    }
  } else {
    //初始化
    if (forStatement.type == ForLoopParts.forPartsWithDeclarations) {
      await _executeVariableDeclaration(
          forLoopParts.variableList, variableStack);
    } else if (forStatement.type == ForLoopParts.forPartsWithExpression) {
      await _executeAssignmentExpression(
          forLoopParts.initialization, variableStack);
    }
    //循环判断条件位
    bool condition =
        _executeBinaryExpression(forLoopParts.condition, variableStack);
    while (condition) {
      //解析循环步长
      if (forLoopParts.updater.isPrefixExpression) {
        _executePrefixExpression(
            forLoopParts.updater.asPrefixExpression, variableStack);
      } else if (forLoopParts.updater.isAssignmentExpression) {
        await _executeAssignmentExpression(
            forLoopParts.updater.asAssignmentExpression, variableStack);
      }
      //执行循环体的逻辑
      _executeBlockStatement(forStatement.body, variableStack);
      //循环判断条件位
      condition =
          _executeBinaryExpression(forLoopParts.condition, variableStack);
    }
  }
  return Future.value();
}

Future _executeSwitchStatement(
    SwitchStatement switchStatement, AstVariableStack variableStack) async {
  var conditionValue;
  if (switchStatement.checkValue.isIdentifier) {
    conditionValue = variableStack
        .getVariableValue(switchStatement.checkValue.asIdentifier.name)
        ?.value;
  } else {
    //TODO Others expression
  }
  for (var c in switchStatement.body) {
    if (c.isDefault ||
        conditionValue == _executeBaseExpression(c.condition, variableStack)) {
      for (var b in c.statements) {
        await _executeBodyExpression(b, variableStack);
      }
      break;
    }
  }
  return Future.value();
}

num _executePrefixExpression(
    PrefixExpression prefixExpression, AstVariableStack variableStack) {
  var argValue = variableStack.getVariableValue(prefixExpression.argument);
  num returnValue;
  if (argValue?.value is int || argValue?.value is double) {
    if (prefixExpression.operator == '++') {
      if (prefixExpression.prefix) {
        returnValue = ++argValue.value;
      } else {
        returnValue = argValue.value++;
      }
    } else if (prefixExpression.operator == '--') {
      if (prefixExpression.prefix) {
        returnValue = --argValue.value;
      } else {
        returnValue = argValue.value--;
      }
    }
  }
  return returnValue;
}

dynamic _executeIndexExpression(
    IndexExpression indexExpression, AstVariableStack variableStack) {
  var target;
  if (indexExpression.target.isIndexExpression) {
    target = _executeIndexExpression(
        indexExpression.target.asIndexExpression, variableStack);
  } else if (indexExpression.target.isIdentifier) {
    target = variableStack
        .getVariableValue(indexExpression.target.asIdentifier.name)
        ?.value;
  }
  if (target != null) {
    if (target is List) {
      var index = indexExpression.index.asNumericLiteral.value;
      if (target.length > index) {
        return target[index];
      }
    } else if (target is Map) {
      var index = indexExpression.index.asIdentifier.name;
      return target[index];
    }
  }

  return null;
}

///更新IndexExpression 表达式的值
void _updateIndexExpressionValue(IndexExpression indexExpression, dynamic value,
    AstVariableStack variableStack) {
  var target;
  if (indexExpression.target.isIndexExpression) {
    target = _executeIndexExpression(
        indexExpression.target.asIndexExpression, variableStack);
  } else if (indexExpression.target.isIdentifier) {
    target = variableStack
        .getVariableValue(indexExpression.target.asIdentifier.name)
        ?.value;
  }
  if (target != null) {
    if (target is List) {
      var index = indexExpression.index.asNumericLiteral.value;
      if (target.length > index) {
        target[index] = value;
      }
    } else if (target is Map) {
      var index = indexExpression.index.asIdentifier.name;
      target[index] = value;
    }
  }
}

Future _executeAssignmentExpression(AssignmentExpression assignmentExpression,
    AstVariableStack variableStack) async {
  var leftValue =
      _executeBaseExpression(assignmentExpression.left, variableStack);
  var rightValue;
  if (assignmentExpression.right.isAwaitExpression) {
    rightValue = await _executeMethodInvocation(
        assignmentExpression.right.asAwaitExpression.expression, variableStack);
  }
  if (assignmentExpression.right.isMethodInvocation) {
    rightValue = await _executeMethodInvocation(
        assignmentExpression.right.asMethodInvocation, variableStack);
  } else {
    rightValue =
        _executeBaseExpression(assignmentExpression.right, variableStack);
  }

  switch (assignmentExpression.operator) {
    case '+=':
      rightValue = leftValue + rightValue;
      break;
    case '+=':
      rightValue = leftValue - rightValue;
      break;
    case '*=':
      rightValue = leftValue * rightValue;
      break;
    case '/=':
      rightValue = leftValue / rightValue;
      break;
  }
  if (assignmentExpression.left.isIdentifier) {
    var variableValue = variableStack
        .getVariableValue(assignmentExpression.left.asIdentifier.name);
    variableValue.value = rightValue;
  } else if (assignmentExpression.left.isPrefixedIdentifier) {
    //TODO: Prefixed 类型处理
  } else if (assignmentExpression.left.isIndexExpression) {
    _updateIndexExpressionValue(
        assignmentExpression.left.asIndexExpression, rightValue, variableStack);
  }
  return Future.value();
}

dynamic _executeBinaryExpression(
    BinaryExpression binaryExpression, AstVariableStack variableStack) {
  //获取左操作符的值
  var leftValue = _executeBaseExpression(binaryExpression.left, variableStack);

  //获取右操作符的值
  var rightValue =
      _executeBaseExpression(binaryExpression.right, variableStack);

  //操作符
  switch (binaryExpression.operator) {
    case '+':
      return leftValue + rightValue;
    case '-':
      return leftValue - rightValue;
    case '*':
      return leftValue * rightValue;
    case '/':
      return leftValue / rightValue;
    case '<':
      return leftValue < rightValue;
    case '>':
      return leftValue > rightValue;
    case '<=':
      return leftValue <= rightValue;
    case '>=':
      return leftValue >= rightValue;
    case '==':
      return leftValue == rightValue;
    case '&&':
      return leftValue && rightValue;
    case '||':
      return leftValue || rightValue;
    case '%':
      return leftValue % rightValue;
    case '<<':
      return leftValue << rightValue;
    case '|':
      return leftValue | rightValue;
    case '&':
      return leftValue & rightValue;
    case '>>':
      return leftValue >> rightValue;
    default:
      return null;
  }
}

Future _executeMethodInvocation(
    MethodInvocation invocation, AstVariableStack variableStack) async {
  if (invocation.callee.isIdentifier) {
    var methodName = invocation.callee.asIdentifier.name;
    if (methodName == 'selectNewModel') {
      return Future.value({});
    } else {
      //构造方法参数值
      var params = [];
      if (invocation.argumentList?.isNotEmpty == true) {
        for (var arg in invocation.argumentList) {
          params.add(_executeBaseExpression(arg, variableStack));
        }
      }
      var method = variableStack.getFunctionInstance<AstFunction>(methodName);
      if (method != null) {
        //调用方法
        return method.invoke(params, variableStack: variableStack);
      }
    }
  } else if (invocation.callee.isMemberExpression) {
    //TODO MemberExression
  }
  return Future.value();
}
