import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dsl/listview_dsl.dart';
import 'package:dynamicflutter/widget/ast_statefulwidget.dart';

import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with \"flutter run\". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // \"hot reload\" (press \"r\" in the console where you ran \"flutter run\",
        // or simply save your changes to \"hot reload\" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('DSL模板'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => _DSLListPage()));
              },
            ),
            ListTile(
              title: Text('动态渲染'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _DynamicFlutterList()));
              },
            ),
          ],
        ));
  }
}

class _DSLListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DSL模板列表'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('ListView'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListViewDSL()));
            },
          ),
        ],
      ),
    );
  }
}

class _DynamicFlutterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('动态渲染列表'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('ListView'),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AstStatefulWidget(jsonDecode(listViewAst) as Map)));
            },
          ),
        ],
      ),
    );
  }
}

const listViewAst =
    '{"type":"Program","body":[{"type":"ClassDeclaration","id":{"type":"Identifier","name":"ListViewDSL"},"superClause":{"type":"TypeName","name":"StatefulWidget"},"implementsClause":null,"mixinClause":null,"metadata":[],"body":[{"type":"MethodDeclaration","id":{"type":"Identifier","name":"createState"},"parameters":{"type":"FormalParameterList","parameterList":[]},"typeParameters":null,"body":null,"isAsync":false,"returnType":{"type":"TypeName","name":"_ListViewDSLState"}}]},{"type":"ClassDeclaration","id":{"type":"Identifier","name":"_ListViewDSLState"},"superClause":{"type":"TypeName","name":"State"},"implementsClause":null,"mixinClause":null,"metadata":[],"body":[{"type":"MethodDeclaration","id":{"type":"Identifier","name":"build"},"parameters":{"type":"FormalParameterList","parameterList":[{"type":"SimpleFormalParameter","paramType":{"type":"TypeName","name":"BuildContext"},"name":"context"}]},"typeParameters":null,"body":{"type":"BlockStatement","body":[{"type":"ReturnStatement","argument":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"Scaffold"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","id":{"type":"Identifier","name":"appBar"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"AppBar"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","id":{"type":"Identifier","name":"backgroundColor"},"expression":{"type":"PrefixedIdentifier","identifier":{"type":"Identifier","name":"red"},"prefix":{"type":"Identifier","name":"Colors"}}},{"type":"NamedExpression","id":{"type":"Identifier","name":"title"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"Text"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"StringLiteral","value":"ListViewDSL"},{"type":"NamedExpression","id":{"type":"Identifier","name":"style"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"TextStyle"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","id":{"type":"Identifier","name":"fontSize"},"expression":{"type":"NumericLiteral","value":20}},{"type":"NamedExpression","id":{"type":"Identifier","name":"color"},"expression":{"type":"PrefixedIdentifier","identifier":{"type":"Identifier","name":"white"},"prefix":{"type":"Identifier","name":"Colors"}}}]}}}]}}},{"type":"NamedExpression","id":{"type":"Identifier","name":"centerTitle"},"expression":{"type":"BooleanLiteral","value":true}}]}}},{"type":"NamedExpression","id":{"type":"Identifier","name":"body"},"expression":{"type":"MethodInvocation","callee":{"type":"MemberExpression","object":{"type":"Identifier","name":"ListView"},"property":{"type":"Identifier","name":"builder"}},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","id":{"type":"Identifier","name":"itemBuilder"},"expression":{"type":"FunctionExpression","parameters":{"type":"FormalParameterList","parameterList":[{"type":"SimpleFormalParameter","paramType":null,"name":"context"},{"type":"SimpleFormalParameter","paramType":null,"name":"index"}]},"body":{"type":"BlockStatement","body":[{"type":"ReturnStatement","argument":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"Container"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","id":{"type":"Identifier","name":"padding"},"expression":{"type":"MethodInvocation","callee":{"type":"MemberExpression","object":{"type":"Identifier","name":"EdgeInsets"},"property":{"type":"Identifier","name":"only"}},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","id":{"type":"Identifier","name":"left"},"expression":{"type":"NumericLiteral","value":16}},{"type":"NamedExpression","id":{"type":"Identifier","name":"right"},"expression":{"type":"NumericLiteral","value":16}}]}}},{"type":"NamedExpression","id":{"type":"Identifier","name":"alignment"},"expression":{"type":"PrefixedIdentifier","identifier":{"type":"Identifier","name":"centerLeft"},"prefix":{"type":"Identifier","name":"Alignment"}}},{"type":"NamedExpression","id":{"type":"Identifier","name":"child"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"Text"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"StringLiteral","value":"Hellow World"},{"type":"NamedExpression","id":{"type":"Identifier","name":"style"},"expression":{"type":"MethodInvocation","callee":{"type":"Identifier","name":"TextStyle"},"typeArguments":null,"argumentList":{"type":"ArgumentList","argumentList":[{"type":"NamedExpression","id":{"type":"Identifier","name":"color"},"expression":{"type":"PrefixedIdentifier","identifier":{"type":"Identifier","name":"white"},"prefix":{"type":"Identifier","name":"Colors"}}},{"type":"NamedExpression","id":{"type":"Identifier","name":"fontSize"},"expression":{"type":"NumericLiteral","value":18}}]}}}]}}},{"type":"NamedExpression","id":{"type":"Identifier","name":"color"},"expression":{"type":"PropertyAccess","id":{"type":"Identifier","name":"shade300"},"expression":{"type":"PrefixedIdentifier","identifier":{"type":"Identifier","name":"lightBlue"},"prefix":{"type":"Identifier","name":"Colors"}}}},{"type":"NamedExpression","id":{"type":"Identifier","name":"height"},"expression":{"type":"NumericLiteral","value":45}}]}}}]},"isAsync":false}},{"type":"NamedExpression","id":{"type":"Identifier","name":"itemCount"},"expression":{"type":"NumericLiteral","value":50}}]}}}]}}}]},"isAsync":false,"returnType":{"type":"TypeName","name":"Widget"}}]}]}';
