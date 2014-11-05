module drowbar.parser.api;

import drowbar.ast;
import drowbar.parser.lexer;
import drowbar.parser.parser;
import drowbar.interpreter;
import std.stdio;
import std.string;
import std.variant;


void parseString(Interpreter machine, string source){
    SemanticAction sa;
    sa.interpreter = machine;
    auto lexer = new Lexer(source);
    auto parser = new Parser!(Variant, SemanticAction)(sa);

    for (;;) {
        auto lv = lexer.read();
        if (parser.post(lv.token, lv.value)) break;
    }

    Variant result;
    if (parser.accept(result)) {
        // do nothing
    } else {
        "ACCEPT NG".writeln();
        throw new Exception("parse error");
    }
}

void parseFile(Interpreter machine, File f){
    string buf;
    foreach (line; f.byLine) buf ~= line;
    return parseString(machine, buf);
}

private struct SemanticAction {
    Interpreter interpreter;

    void syntax_error(){
        "SYNTAX ERROR".writeln();
    }

    void stack_overflow(){
        "STACK OVERFLOW".writeln();
    }

    void upcast(ref Variant x, Variant y){ x = y; }
    void downcast(ref Variant x, Variant y){ x = y; }

    Variant return1st(Variant v){ return v; }
    Variant doNothing(){ return Variant(null); }

    private bool isNull(Variant v){ return v.type == typeid(null); }

    Variant toplevelStatementAdd(Variant stmt){
        interpreter.addStatement(stmt.get!(Statement));
        return doNothing();
    }

    Variant functionDefine(Variant ident, Variant block, Variant params = null){
        auto name = ident.get!string;
        if (interpreter.lookupFunction(name)) {
            throw new Exception("multiple definition - %s()".format(name));
        }
        interpreter.addFunction(new InterpreteredFunctionDefinition(name,
                                                                    isNull(params) ? null : params.get!(string[]),
                                                                    block.get!Block));
        return doNothing();
    }

    Variant parameterList(Variant ident, Variant list = null){
        if (isNull(list)) list = new string[0];
        list ~= ident.get!(string);
        return list;
    }

    Variant globalStatement(Variant idents){
        return Variant(new GlobalStatement(idents.get!(string[])));
    }

    Variant identifierList(Variant ident, Variant list = null){
        if (isNull(list)) list = new string[0];
        list ~= ident.get!(string);
        return list;
    }

    Variant statementList(Variant stmt, Variant list = null){
        if (isNull(list)) list = new Statement[0];
        list ~= stmt.get!(Statement);
        return list;
    }

    Variant block(Variant stmts = null){
        return Variant(new Block(isNull(stmts) ? null : stmts.get!(Statement[])));
    }

    Variant whileStatement(Variant cond, Variant block){
        return Variant(new WhileStatement(cond.get!(Expression), block.get!(Block)));
    }

    Variant ifStatement(Variant cond, Variant then, Variant elsifs = null, Variant aElse = null){
        return Variant(new IfStatement(cond.get!(Expression),
                                       then.get!(Block),
                                       isNull(elsifs) ? null : elsifs.get!(Elsif[]),
                                       isNull(aElse)  ? null : aElse.get!(Block)));
    }

    Variant ifStatement0elsif(Variant cond, Variant then, Variant aElse){
        return ifStatement(cond, then, Variant(null), aElse);
    }

    Variant elsifList(Variant elsif, Variant list = null){
        if (isNull(list)) list = new Elsif[0];
        list ~= elsif.get!(Elsif);
        return list;
    }

    Variant elsif(Variant cond, Variant block){
        return Variant(new Elsif(cond.get!(Expression), block.get!(Block)));
    }

    Variant forStatement(Variant init, Variant cond, Variant post, Variant block){
        return Variant(new ForStatement(isNull(init) ? null : init.get!(Expression),
                                        isNull(cond) ? null : cond.get!(Expression),
                                        isNull(post) ? null : post.get!(Expression),
                                        block.get!(Block)));
    }

    Variant returnStatement(Variant expr = null){
        return Variant(new ReturnStatement(isNull(expr) ? null : expr.get!(Expression)));
    }

    Variant breakStatement(){ return Variant(new BreakStatement()); }

    Variant continueStatement(){ return Variant(new ContinueStatement()); }

    Variant expressionStatement(Variant expr){ return Variant(new ExpressionStatement(expr.get!Expression)); }

    Variant booleanExpressionTrue(){ return Variant(new BooleanExpression(true)); }

    Variant booleanExpressionFalse(){ return Variant(new BooleanExpression(false)); }

    Variant nullExpression(){ return Variant(new NullExpression()); }

    Variant argumentList(Variant expr, Variant list = null){
        if (isNull(list)) list = new Expression[0];
        list ~= expr.get!(Expression);
        return list;
    }

    Variant functionCallExpression(Variant ident, Variant args = null){
        return Variant(new FunctionCallExpression(ident.get!(string), isNull(args) ? null : args.get!(Expression[])));
    }

    Variant assignExpression(Variant ident, Variant expr){
        return Variant(new AssignExpression(ident.get!(string), expr.get!(Expression)));
    }

    Variant exprFromValue(Value v){
        switch (v.type) {
        case Value.Type.INT:
            return integerExpression(v.value);
        case Value.Type.DOUBLE:
            return doubleExpression(v.value);
        default:
            assert(0);
        }
    }

    Variant minusExpression(Variant expr){
        auto e = expr.get!Expression;
        if (e.isNumberLiteral()) return exprFromValue(interpreter.evalMinusExpression(e));
        return Variant(new MinusExpression(e));
    }

    private Variant arithExpr(ArithmeticOperators op, Variant left, Variant right){
        auto le = left.get!Expression;
        auto re = right.get!Expression;
        if (le.isNumberLiteral() && re.isNumberLiteral()) return exprFromValue(interpreter.evalBinaryExpression(op, le, re));
        return binExpr(op, left, right);
    }

    private Variant binExpr(ArithmeticOperators op, Variant left, Variant right){
        return Variant(new BinaryExpression(op, left.get!Expression, right.get!Expression));
    }

    Variant binaryExpressionLogand(Variant left, Variant right){
        return binExpr(ArithmeticOperators.LOGICAL_AND, left, right);
    }

    Variant binaryExpressionLogor(Variant left, Variant right){
        return binExpr(ArithmeticOperators.LOGICAL_OR, left, right);
    }

    Variant binaryExpressionEq(Variant left, Variant right){
        return binExpr(ArithmeticOperators.EQ, left, right);
    }

    Variant binaryExpressionNe(Variant left, Variant right){
        return binExpr(ArithmeticOperators.NE, left, right);
    }

    Variant binaryExpressionGt(Variant left, Variant right){
        return binExpr(ArithmeticOperators.GT, left, right);
    }

    Variant binaryExpressionGe(Variant left, Variant right){
        return binExpr(ArithmeticOperators.GE, left, right);
    }

    Variant binaryExpressionLt(Variant left, Variant right){
        return binExpr(ArithmeticOperators.LT, left, right);
    }

    Variant binaryExpressionLe(Variant left, Variant right){
        return binExpr(ArithmeticOperators.LE, left, right);
    }

    Variant binaryExpressionAdd(Variant left, Variant right){
        return arithExpr(ArithmeticOperators.ADD, left, right);
    }

    Variant binaryExpressionSub(Variant left, Variant right){
        return arithExpr(ArithmeticOperators.SUB, left, right);
    }

    Variant binaryExpressionMul(Variant left, Variant right){
        return arithExpr(ArithmeticOperators.MUL, left, right);
    }

    Variant binaryExpressionDiv(Variant left, Variant right){
        return arithExpr(ArithmeticOperators.DIV, left, right);
    }

    Variant binaryExpressionMod(Variant left, Variant right){
        return arithExpr(ArithmeticOperators.MOD, left, right);
    }

    Variant identifierExpression(Variant ident){
        return Variant(new IdentifierExpression(ident.get!(string)));
    }

    Variant integerExpression(Variant value){
        return Variant(new IntegerExpression(value.get!(int)));
    }

    Variant doubleExpression(Variant value){
        return Variant(new DoubleExpression(value.get!(double)));
    }

    Variant stringExpression(Variant value){
        return Variant(new StringExpression(value.get!(string)));
    }
}
