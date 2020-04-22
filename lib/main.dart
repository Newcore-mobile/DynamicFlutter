///
///Author: YoungChan
///Date: 2020-04-11 15:17:06
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 17:45:42
///Description: file content
///
import 'dart:io';
import 'dart:convert';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:args/args.dart';
import 'ast_runtime_class.dart';

main(List<String> arguments) async {
  exitCode = 0; // presume success
  final parser = ArgParser()..addFlag("file", negatable: false, abbr: 'f');

  var argResults = parser.parse(arguments);
  final paths = argResults.rest;
  if (paths.isEmpty) {
    stdout.writeln('No file found');
  } else {
    var ast = await generate(paths[0]);
    var astRuntime = AstRuntime(ast);
    var res = await astRuntime.callFunction('incTen', params: [100]);
    stdout.writeln('Invoke incTec(100) result: $res');
  }
}

class DemoAstVisitor extends GeneralizingAstVisitor<Map> {
  @override
  Map visitNode(AstNode node) {
    //输出遍历AST Node 节点内容
    stdout.writeln("${node.runtimeType}<---->${node.toSource()}");
    return super.visitNode(node);
  }
}

class MyAstVisitor extends SimpleAstVisitor<Map> {
  /// 遍历节点
  Map _safelyVisitNode(AstNode node) {
    if (node != null) {
      return node.accept(this);
    }
    return null;
  }

  /// 遍历节点列表
  List<Map> _safelyVisitNodeList(NodeList<AstNode> nodes) {
    List<Map> maps = [];
    if (nodes != null) {
      int size = nodes.length;
      for (int i = 0; i < size; i++) {
        var node = nodes[i];
        if (node != null) {
          var res = node.accept(this);
          if (res != null) {
            maps.add(res);
          }
        }
      }
    }
    return maps;
  }

  //构造根节点
  Map _buildAstRoot(List<Map> body) {
    if (body.isNotEmpty) {
      return {
        "type": "Program",
        "body": body,
      };
    } else {
      return null;
    }
  }

  //构造代码块Bloc 结构
  Map _buildBloc(List body) => {"type": "BlockStatement", "body": body};

  //构造运算表达式结构
  Map _buildBinaryExpression(Map left, Map right, String lexeme) => {
        "type": "BinaryExpression",
        "operator": lexeme,
        "left": left,
        "right": right
      };

  //构造变量声明
  Map _buildVariableDeclaration(Map id, Map init) => {
        "type": "VariableDeclarator",
        "id": id,
        "init": init,
      };

  //构造变量声明
  Map _buildVariableDeclarationList(
          Map typeAnnotation, List<Map> declarations) =>
      {
        "type": "VariableDeclarationList",
        "typeAnnotation": typeAnnotation,
        "declarations": declarations,
      };
  //构造标识符定义
  Map _buildIdentifier(String name) => {"type": "Identifier", "name": name};

  //构造数值定义
  Map _buildNumericLiteral(num value) =>
      {"type": "NumericLiteral", "value": value};

  //构造函数声明
  Map _buildFunctionDeclaration(Map id, Map expression) => {
        "type": "FunctionDeclaration",
        "id": id,
        "expression": expression,
      };

  //构造函数表达式
  Map _buildFunctionExpression(Map params, Map body, {bool isAsync: false}) => {
        "type": "FunctionExpression",
        "parameters": params,
        "body": body,
        "isAsync": isAsync,
      };

  //构造函数参数
  Map _buildFormalParameterList(List<Map> parameterList) =>
      {"type": "FormalParameterList", "parameterList": parameterList};

  //构造函数参数
  Map _buildSimpleFormalParameter(Map type, String name) =>
      {"type": "SimpleFormalParameter", "paramType": type, "name": name};

  //构造函数参数类型
  Map _buildTypeName(String name) => {
        "type": "TypeName",
        "name": name,
      };

  //构造返回数据定义
  Map _buildReturnStatement(Map argument) => {
        "type": "ReturnStatement",
        "argument": argument,
      };

  @override
  Map visitCompilationUnit(CompilationUnit node) {
    return _buildAstRoot(_safelyVisitNodeList(node.declarations));
  }

  @override
  Map visitBlock(Block node) {
    return _buildBloc(_safelyVisitNodeList(node.statements));
  }

  @override
  Map visitBlockFunctionBody(BlockFunctionBody node) {
    return _safelyVisitNode(node.block);
  }

  @override
  Map visitVariableDeclaration(VariableDeclaration node) {
    return _buildVariableDeclaration(
        _safelyVisitNode(node.name), _safelyVisitNode(node.initializer));
  }

  @override
  Map visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    return _safelyVisitNode(node.variables);
  }

  @override
  Map visitVariableDeclarationList(VariableDeclarationList node) {
    return _buildVariableDeclarationList(
        _safelyVisitNode(node.type), _safelyVisitNodeList(node.variables));
  }

  @override
  Map visitSimpleIdentifier(SimpleIdentifier node) {
    return _buildIdentifier(node.name);
  }

  @override
  Map visitBinaryExpression(BinaryExpression node) {
    return _buildBinaryExpression(_safelyVisitNode(node.leftOperand),
        _safelyVisitNode(node.rightOperand), node.operator.lexeme);
  }

  @override
  Map visitIntegerLiteral(IntegerLiteral node) {
    return _buildNumericLiteral(node.value);
  }

  @override
  Map visitFunctionDeclaration(FunctionDeclaration node) {
    return _buildFunctionDeclaration(
        _safelyVisitNode(node.name), _safelyVisitNode(node.functionExpression));
  }

  @override
  Map visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {
    return _safelyVisitNode(node.functionDeclaration);
  }

  @override
  Map visitFunctionExpression(FunctionExpression node) {
    return _buildFunctionExpression(
        _safelyVisitNode(node.parameters), _safelyVisitNode(node.body),
        isAsync: node.body.isAsynchronous);
  }

  @override
  Map visitSimpleFormalParameter(SimpleFormalParameter node) {
    return _buildSimpleFormalParameter(
        _safelyVisitNode(node.type), node.identifier.name);
  }

  @override
  Map visitFormalParameterList(FormalParameterList node) {
    return _buildFormalParameterList(_safelyVisitNodeList(node.parameters));
  }

  @override
  Map visitTypeName(TypeName node) {
    return _buildTypeName(node.name.name);
  }

  @override
  Map visitReturnStatement(ReturnStatement node) {
    return _buildReturnStatement(_safelyVisitNode(node.expression));
  }
}

///生成AST
Future generate(String path) async {
  if (path.isEmpty) {
    stdout.writeln("No file found");
  } else {
    await _handleError(path);
    if (exitCode == 2) {
      try {
        var parseResult =
            parseFile(path: path, featureSet: FeatureSet.fromEnableFlags([]));
        var compilationUnit = parseResult.unit;
        //遍历AST
        var astData = compilationUnit.accept(MyAstVisitor());
        // stdout.writeln(jsonEncode(astData));
        return Future.value(astData);
      } catch (e) {
        stdout.writeln('Parse file error: ${e.toString()}');
      }
    }
  }
  return Future.value();
}

Future _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
