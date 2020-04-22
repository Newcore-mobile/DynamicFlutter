///
///Author: YoungChan
///Date: 2020-04-18 13:37:28
///LastEditors: YoungChan
///LastEditTime: 2020-04-22 17:42:22
///Description: 变量栈
///
/// 标识变量类型
enum AstVariableType {
  ///基础数据类型
  Base,

  ///函数
  Function,
}

class AstVariableStack {
  List<Map<String, AstVarialbleModel>> _stack = [];

  ///进入代码块的时候调用，新建一个变量集并压栈
  void blockIn() {
    _stack.add(Map());
  }

  ///跳出代码块的时候调用，将栈顶的变量集出栈
  void blockOut() {
    _stack.removeLast();
  }

  ///获取基础数据变量值，考虑变量赋值的情况，通过返回类结构模拟引用变量
  AstVarialbleModel getVariableValue(String name) {
    ///从栈顶开始遍历，直到找到目标变量
    for (var i = _stack.length; i > 0; i--) {
      var top = _stack[i - 1];
      if (top.containsKey(name)) {
        var variableModel = top[name];
        if (variableModel != null &&
            variableModel._variableType == AstVariableType.Base) {
          return variableModel;
        }
      }
    }
    return null;
  }

  T getFunctionInstance<T>(String name) {
    ///从栈顶开始遍历，直到找到目标方法
    for (var i = _stack.length; i > 0; i--) {
      var top = _stack[i - 1];
      if (top.containsKey(name)) {
        var variableModel = top[name];
        if (variableModel != null &&
            variableModel._variableType == AstVariableType.Function &&
            variableModel.value is T) {
          return variableModel.value;
        }
      }
    }
    return null;
  }

  ///设置变量值
  void setVariableValue(String name, dynamic value) {
    assert(_stack.isNotEmpty);

    ///从栈顶开始遍历，直到找到目标变量，赋值后跳出循环
    for (var i = _stack.length; i > 0; i--) {
      var top = _stack[i - 1];
      if (top.containsKey(name)) {
        top[name] = AstVarialbleModel(AstVariableType.Base, value);
        return;
      }
    }
    //如果没有目标变量，则将该变量存入变量栈
    _stack.last[name] = AstVarialbleModel(AstVariableType.Base, value);
  }

  ///设置函数值
  void setFunctionInstance<T>(String name, T instance) {
    assert(_stack.isNotEmpty);
    _stack.last[name] = AstVarialbleModel(AstVariableType.Function, instance);
  }
}

class AstVarialbleModel {
  AstVariableType _variableType;
  dynamic value;
  AstVarialbleModel(this._variableType, this.value);
}
