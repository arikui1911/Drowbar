module drowbar.ast;

import drowbar.interpreter;
import std.stdio;
import std.string;

void dumpTree(Node tree, File output = std.stdio.stdout){
    tree.dump(output, 0);
}

abstract class Node {
    abstract void dump(File f, uint nest);

    final private void indent(File f, uint level){
        foreach (i; 0 .. level) f.write("  ");
    }
}

abstract class FunctionDefinition : Node {
    abstract @property string name();
    abstract @property bool isNative();
}

class NativeFunctionDefinition : FunctionDefinition {
    alias Value delegate(Interpreter, Value[]) Implementation;

    private string _name;
    private Implementation _proc;

    this (string name, Implementation proc) {
        _name = name;
        _proc = proc;
    }

    @property override string name(){ return _name; }
    @property override bool isNative(){ return true; }

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("--- Native Function: %s()", _name);
    }

    Value call(Interpreter interpreter, Value[] args){
        return _proc(interpreter, args);
    }
}

class InterpreteredFunctionDefinition : FunctionDefinition {
    private string _name;
    private string[] _parameters;
    private Block _block;

    this (string name, string[] params, Block block) {
        _name = name;
        _parameters = params;
        _block = block;
    }

    @property override string name(){ return _name; }
    @property string[] parameters(){ return _parameters; }
    @property override bool isNative(){ return false; }
    @property Block block(){ return _block; }

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("--- Interpretered Function: %s(%s)", name, parameters.join(", "));
        _block.dump(f, nest);
    }
}

abstract class Statement : Node {
    abstract StatementResult accept(Executer visitor, LocalEnvironment env);
}

abstract class Expression : Node {
    abstract Value accept(Evaluater visitor, LocalEnvironment env);
    bool isNumberLiteral(){ return false; }
}

private mixin template Acceptable(V, R){
    override R accept(V visitor, LocalEnvironment env){ return visitor.visit(this, env); }
}

class  Block : Node {
    private Statement[] _statements;

    this (Statement[] list) {
        _statements = list;
    }

    @property Statement[] statements(){ return _statements; }

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("Block");
        if (_statements) {
            foreach (s; _statements) s.dump(f, nest + 1);
        } else {
            indent(f, nest + 1);
            f.writeln("null");
        }
    }
}

class GlobalStatement : Statement {
    private string[] _identifiers;

    this (string[] idents) {
        _identifiers = idents;
    }

    @property string[] identifiers(){ return _identifiers; }

    mixin Acceptable!(Executer, StatementResult);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("GlobalStatement: %s", identifiers.join(", "));
    }
}

class IfStatement : Statement {
    private Expression _condition;
    private Block _then_block;
    private Elsif[] _elsifs;
    private Block _else_block;

    this (Expression c, Block tb, Elsif[] el, Block eb) {
        _condition = c;
        _then_block = tb;
        _elsifs = el;
        _else_block = eb;
    }

    @property Expression condition(){ return _condition; }
    @property Block then_block(){ return _then_block; }
    @property Elsif[] elsifs(){ return _elsifs; }
    @property Block else_block(){ return else_block; }

    mixin Acceptable!(Executer, StatementResult);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("IfStatement");
        _condition.dump(f, nest + 1);
        _then_block.dump(f, nest + 1);
        if (_elsifs) {
            indent(f, nest + 1);
            f.writeln("ElsifList");
            foreach (e; _elsifs) e.dump(f, nest + 2);
        } else {
            indent(f, nest + 1);
            f.writeln("null");
        }
        if (_else_block) {
            _else_block.dump(f, nest + 1);
        } else {
            indent(f, nest + 1);
            f.writeln("null");
        }
    }
}

class Elsif : Node {
    private Expression _condition;
    private Block _block;

    this (Expression c, Block b) {
        _condition = c;
        _block = b;
    }

    @property Expression condition(){ return _condition; }
    @property Block block(){ return _block; }

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("Elsif");
        _condition.dump(f, nest + 1);
        _block.dump(f, nest + 1);
    }
}

class WhileStatement : Statement {
    private Expression _condition;
    private Block _block;

    this (Expression c, Block b) {
        _condition = c;
        _block = b;
    }

    @property Expression condition(){ return _condition; }
    @property Block block(){ return _block; }

    mixin Acceptable!(Executer, StatementResult);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("WhileStatement");
        _condition.dump(f, nest + 1);
        _block.dump(f, nest + 1);
    }
}

class ForStatement : Statement {
    private Expression _init;
    private Expression _condition;
    private Expression _post;
    private Block _block;

    this (Expression i, Expression c, Expression p, Block b) {
        _init = i;
        _condition = c;
        _post = p;
        _block = b;
    }

    @property Expression init(){ return _init; }
    @property Expression condition(){ return _condition; }
    @property Expression post(){ return _post; }
    @property Block block(){ return _block; }

    mixin Acceptable!(Executer, StatementResult);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("ForStatement");
        foreach(e; [_init, _condition, _post]) {
            if (e) {
                e.dump(f, nest + 1);
            } else {
                indent(f, nest + 1);
                f.writeln("null");
            }
        }
        block.dump(f, nest + 1);
    }
}


class ReturnStatement : Statement {
    private Expression _returnValue;

    this (Expression expr) {
        _returnValue = expr;
    }

    @property Expression returnValue(){ return _returnValue; }

    mixin Acceptable!(Executer, StatementResult);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("ReturnStatement");
        if (_returnValue) {
            _returnValue.dump(f, nest + 1);
        } else {
            indent(f, nest + 1);
            f.writeln("null");
        }
    }
}

class BreakStatement : Statement {
    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("BreakStatement");
    }

    mixin Acceptable!(Executer, StatementResult);
}

class ContinueStatement : Statement {
    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("ContinueStatement");
    }

    mixin Acceptable!(Executer, StatementResult);
}

class ExpressionStatement : Statement {
    private Expression _expression;

    this (Expression expr) {
        _expression = expr;
    }

    @property Expression expression(){ return _expression; }

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("ExpressionStatement");
        expression.dump(f, nest + 1);
    }

    mixin Acceptable!(Executer, StatementResult);
}


class FunctionCallExpression :  Expression {
    string _identifier;
    Expression[] _argument;

    this (string name, Expression[] args) {
        _identifier = name;
        _argument = args;
    }

    @property string identifier(){ return _identifier; }
    @property Expression[] argument(){ return _argument; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("FunctionCallExpression: %s", _identifier);
        foreach (arg; _argument) {
            arg.dump(f, nest + 1);
        }
    }
}

class MinusExpression : Expression {
    private Expression _expression;

    this (Expression expr) {
        _expression = expr;
    }

    @property Expression expression(){ return _expression; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("MinusExpression");
        _expression.dump(f, nest + 1);
    }
}

enum ArithmeticOperators {
    LOGICAL_OR,
    LOGICAL_AND,
    EQ,
    NE,
    GT,
    GE,
    LT,
    LE,
    ADD,
    SUB,
    MUL,
    DIV,
    MOD,
}

class BinaryExpression : Expression {
    ArithmeticOperators _operator;
    private Expression _left;
    private Expression _right;

    this (ArithmeticOperators op, Expression x, Expression y) {
        _operator = op;
        _left = x;
        _right = y;
    }

    @property ArithmeticOperators operator(){ return _operator; }
    @property Expression left(){ return _left; }
    @property Expression right(){ return _right; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("BinaryExpression: %s", _operator);
        _left.dump(f, nest + 1);
        _right.dump(f, nest + 1);
    }
}

class AssignExpression : Expression {
    private string _variable;
    private Expression _operand;

    this (string var, Expression expr) {
        _variable = var;
        _operand = expr;
    }

    @property string variable(){ return _variable; }
    @property Expression operand(){ return _operand; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("AssignExpression: %s", _variable);
        _operand.dump(f, nest + 1);
    }
}

class IdentifierExpression : Expression {
    private string _name;

    this (string name) {
        _name = name;
    }

    @property string name(){ return _name; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("IdentifierExpression: %s", _name);
    }
}

class IntegerExpression : Expression {
    private int _value;

    this (int v) {
        _value = v;
    }

    int value(){ return _value; }

    override bool isNumberLiteral(){ return true; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("IntegerExpression: %d", _value);
    }
}

class DoubleExpression : Expression {
    double _value;

    this (double v) {
        _value = v;
    }

    double value(){ return _value; }

    override bool isNumberLiteral(){ return true; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("DoubleExpression: %f", _value);
    }
}

class StringExpression : Expression {
    string _value;

    this (string v) {
        _value = v;
    }

    string value(){ return _value; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln(`StringExpression: "%s"`, _value);
    }
}

class BooleanExpression : Expression {
    bool _value;

    this (bool v) {
        _value = v;
    }

    bool value(){ return _value; }

    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writefln("BooleanExpression: %s", _value);
    }
}

class NullExpression : Expression {
    mixin Acceptable!(Evaluater, Value);

    override void dump(File f, uint nest){
        indent(f, nest);
        f.writeln("NullExpression");
    }
}


