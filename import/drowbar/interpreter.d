module drowbar.interpreter;

import drowbar.ast;
import std.stdio;
import std.string;
import std.exception;
import std.variant;
import std.algorithm;
import std.array;

class Interpreter : Executer, Evaluater {
    private Statement[] statements;
    private FunctionDefinition[string] functions;
    private Variable[string] variables;

    this () {
        initBuiltin();
    }

    void run(){
        execStatements(statements, null);
    }

    void addStatement(Statement stmt){
        statements ~= stmt;
    }

    void addFunction(FunctionDefinition func){
        functions[func.name] = func;
    }

    void addNativeFunction(string name, NativeFunctionDefinition.Implementation proc){
        addFunction(new NativeFunctionDefinition(name, proc));
    }

    FunctionDefinition lookupFunction(string name){
        return functions.get(name, null);
    }

    Variable lookupGlobalVariable(string name){
        return variables.get(name, null);
    }

    void assignGlobalVariable(string name, Value val){
        auto var = lookupGlobalVariable(name);
        if (var) {
            var.value = val;
        } else {
            variables[name] = new Variable(name, val);
        }
    }

    void dumpTree(File output = std.stdio.stdout){
        output.writeln("--- *TopLevel*");
        foreach(stmt; statements) drowbar.ast.dumpTree(stmt, output);
        if (functions.length == 0) return;
        foreach (func; functions.byValue()){
            if (func.isNative()) continue;
            output.write("\n");
            drowbar.ast.dumpTree(func, output);
        }
    }

    private void initBuiltin(){
        void addf(string var, std.stdio.File f){
            assignGlobalVariable(var, new Value(new NativePointer("drowbar.lang.file", Variant(f))));
        }
        addf("STDIN", std.stdio.stdin);
        addf("STDOUT", std.stdio.stdout);
        addf("STDERR", std.stdio.stderr);

        static void checkArgs(Value[] args, int expected){
            enforce(expected == args.length, "wrong number of argument (%d for %d)".format(args.length, expected));
        }

        static void checkArgsType(Value[] args, Value.Type[] expecteds){
            checkArgs(args, expecteds.length);
            foreach (i, arg; args) {
                enforce(arg.type == expecteds[i], "type mismatch: expect %s but %s".format(expecteds[i], arg.type));
            }
        }

        static NativePointer validateNativePointer(Value npv){
            auto np = npv.value.get!NativePointer;
            enforce(np.info == "drowbar.lang.file", "unexpected native pointer: %s".format(np));
            return np;
        }

        // Alternative for std.stdio.File (because it is struct, value-type)
        class FileReference {
            private File file;

            this (string name, string mode) {
                file = File(name, mode);
            }

            alias file this;
        }

        addNativeFunction("print", (i, args){
                checkArgs(args, 1);
                std.stdio.stdout.write(args[0].toPrint());
                return Value.nullValue();
            });

        addNativeFunction("fopen", (i, args){
                checkArgsType(args, [Value.Type.STRING, Value.Type.STRING]);
                return new Value(new NativePointer("drowbar.lang.file",
                                                   Variant(new FileReference(args[0].value.get!string, args[1].value.get!string))));
            });

        addNativeFunction("fclose", (i, args){
                checkArgsType(args, [Value.Type.NATIVE_POINTER]);
                auto np = validateNativePointer(args[0]);
                np.resource.get!(FileReference).close();
                return Value.nullValue();
            });

        addNativeFunction("fgets", (i, args){
                checkArgsType(args, [Value.Type.NATIVE_POINTER]);
                auto np = validateNativePointer(args[0]);
                return new Value(np.resource.get!(FileReference).readln());
            });

        addNativeFunction("fputs", (i, args){
                checkArgsType(args, [Value.Type.NATIVE_POINTER, Value.Type.STRING]);
                auto np = validateNativePointer(args[0]);
                np.resource.get!(FileReference).writeln(args[1].value.get!string);
                return Value.nullValue();
            });
    }

    Value evalMinusExpression(Expression expr, LocalEnvironment env = null){
        auto val = evalExpression(expr, env);
        switch (val.type) {
        case Value.Type.INT:
            return new Value(-val.value.get!int);
        case Value.Type.DOUBLE:
            return new Value(-val.value.get!double);
        default:
            break;
        }
        assert(0);
        return null;
    }

    Value evalBinaryExpression(ArithmeticOperators operator, Expression le, Expression re, LocalEnvironment env = null){
        if (operator == ArithmeticOperators.LOGICAL_OR || operator == ArithmeticOperators.LOGICAL_AND) assert(0);

        auto left = evalExpression(le, env);
        auto right = evalExpression(re, env);

        switch (operator) {
        case ArithmeticOperators.EQ:
        case ArithmeticOperators.NE:
            return evalRelationalExpr(operator, left, right);
        case ArithmeticOperators.GT:
        case ArithmeticOperators.GE:
        case ArithmeticOperators.LT:
        case ArithmeticOperators.LE:
            return evalCompareExpr(operator, left, right);
        case ArithmeticOperators.ADD:
            return evalAddExpr(left, right);
        case ArithmeticOperators.SUB:
        case ArithmeticOperators.MUL:
        case ArithmeticOperators.DIV:
        case ArithmeticOperators.MOD:
            return evalArithExpr(operator, left, right);
        default:
            break;
        }

        assert(0);
        return null;
    }

    private Value evalRelationalExpr(ArithmeticOperators operator, Value left, Value right){
        static bool isTypeMismatch(Value left, Value right){
            if (left.type != right.type) {
                switch (left.type) {
                case Value.Type.INT:
                    if (right.type != Value.Type.DOUBLE) return true;
                    break;
                case Value.Type.DOUBLE:
                    if (right.type != Value.Type.INT) return true;
                    break;
                default:
                    return true;
                }
            }
            return false;
        }

        static bool isEqual(Value left, Value right){
            if (isTypeMismatch(left, right)) return false;
            final switch (left.type) {
            case Value.Type.INT:
                if (right.type == Value.Type.DOUBLE && left.value.get!int == right.value.get!int) return true;
                break;
            case Value.Type.DOUBLE:
                if (right.type == Value.Type.INT && left.value.get!double == right.value.get!double) return true;
                break;
            case Value.Type.NULL:
                return true;
            case Value.Type.BOOLEAN:
            case Value.Type.STRING:
            case Value.Type.NATIVE_POINTER:
                break;
            }
            return left.value == right.value;
        }

        auto result = isEqual(left, right);
        switch (operator) {
        case ArithmeticOperators.EQ:
            break;
        case ArithmeticOperators.NE:
            result = !result;
            break;
        default:
            assert(0);
        }
        return result ? Value.trueValue() : Value.falseValue();
    }

    private Value evalCompareExpr(ArithmeticOperators operator, Value left, Value right){
        switch (left.type) {
        case Value.Type.INT:
            if (right.type == Value.Type.DOUBLE) {
                left = new Value(left.value.get!double);
            } else if (right.type != Value.Type.INT) {
                goto default;
            }
            break;
        case Value.Type.DOUBLE:
            if (right.type == Value.Type.INT) {
                right = new Value(right.value.get!double);
            } else if (right.type != Value.Type.DOUBLE) {
                goto default;
            }
            break;
        case Value.Type.STRING:
            if (right.type != Value.Type.STRING) goto default;
            break;
        default:
            enforce(0, "Types mismatch to compare: %s and %s".format(left.type, right.type));
        }

        bool result;
        switch (operator) {
        case ArithmeticOperators.GT:
            result = (left.value > right.value);
            break;
        case ArithmeticOperators.LT:
            result = (left.value < right.value);
            break;
        case ArithmeticOperators.GE:
            result = (left.value >= right.value);
            break;
        case ArithmeticOperators.LE:
            result = (left.value <= right.value);
            break;
        default:
            assert(0);
        }
        return result ? Value.trueValue() : Value.falseValue();
    }

    private Value evalAddExpr(Value left, Value right){
        if (left.type != Value.Type.STRING) return evalArithExpr(ArithmeticOperators.ADD, left, right);
        return new Value(left.value.get!string ~ right.toPrint());
    }

    private Value evalArithExpr(ArithmeticOperators operator, Value left, Value right){
        static Value doArith(T)(ArithmeticOperators operator, Value left, Value right){
            T x = left.value.get!(T), y = right.value.get!(T), r;
            switch (operator) {
            case ArithmeticOperators.ADD:
                r = x + y;
                break;
            case ArithmeticOperators.SUB:
                r = x - y;
                break;
            case ArithmeticOperators.MUL:
                r = x * y;
                break;
            case ArithmeticOperators.DIV:
                r = x / y;
                break;
            case ArithmeticOperators.MOD:
                r = x % y;
                break;
            default:
                assert(0);
            }
            return new Value(r);
        }

        switch (left.type) {
        case Value.Type.INT:
            if (right.type == Value.Type.INT) return doArith!int(operator, left, right);
            if (right.type != Value.Type.DOUBLE) goto default;
            break;
        case Value.Type.DOUBLE:
            if (right.type != Value.Type.INT && right.type != Value.Type.DOUBLE) goto default;
            break;
        default:
            enforce(0, "Types mismatch to compare: %s and %s".format(left.type, right.type));
        }
        return doArith!double(operator, left, right);
    }

    private Value evalLogicalExpr(ArithmeticOperators operator, Expression left, Expression right, LocalEnvironment env){
        auto ret = evalExpression(left, env);
        enforce((ret.type == Value.Type.BOOLEAN), "expression not returns boolean");

        auto cont = ret.test();
        switch (operator) {
        case ArithmeticOperators.LOGICAL_AND:
            break;
        case ArithmeticOperators.LOGICAL_OR:
            cont = !cont;
            break;
        default:
            assert(0);
        }
        if (!cont) return ret;

        ret = evalExpression(right, env);
        enforce((ret.type == Value.Type.BOOLEAN), "expression not returns boolean");
        return ret;
    }

    StatementResult execStatement(Statement stmt, LocalEnvironment env = null){
        return stmt.accept(this, env);
    }

    StatementResult execStatements(Statement[] stmts, LocalEnvironment env = null){
        auto result = StatementResult(StatementResult.Status.NORMAL);
        foreach (s; stmts) {
            result = execStatement(s, env);
            if (result.status != StatementResult.Status.NORMAL) break;
        }
        return result;
    }

    Value evalExpression(Expression expr, LocalEnvironment env = null){
        return expr.accept(this, env);
    }

    StatementResult visit(ExpressionStatement stmt, LocalEnvironment env){
        evalExpression(stmt.expression, env);
        return StatementResult(StatementResult.Status.NORMAL);
    }

    StatementResult visit(GlobalStatement stmt, LocalEnvironment env){
        enforce(env, "toplevel global statement is invalid");
        foreach (name; stmt.identifiers){
            auto var = enforce(lookupGlobalVariable(name), "undefined global variable - %s".format(name));
            env.addGlobalVariableReference(name, var);
        }
        return StatementResult(StatementResult.Status.NORMAL);
    }

    private bool test(Expression expr, LocalEnvironment env){
        auto cond = evalExpression(expr, env);
        enforce((cond.type == Value.Type.BOOLEAN), "expression not returns boolean");
        return cond.test();
    }

    StatementResult visit(IfStatement stmt, LocalEnvironment env){
        if (test(stmt.condition, env)) return execStatements(stmt.then_block.statements, env);

        StatementResult result;
        bool goElse = true;
        foreach (eif; stmt.elsifs) {
            if (!test(eif.condition, env)) continue;
            result = execStatements(eif.block.statements, env);
            goElse = false;
            if (result.status != StatementResult.Status.NORMAL) break;
        }
        if (!goElse) return result;

        if (stmt.else_block && goElse) return execStatements(stmt.else_block.statements, env);
        return StatementResult(StatementResult.Status.NORMAL);
    }

    StatementResult visit(WhileStatement stmt, LocalEnvironment env){
        auto result = StatementResult(StatementResult.Status.NORMAL);

        LOOP: for (;;) {
            if (!test(stmt.condition, env)) break;
            result = execStatements(stmt.block.statements, env);
            final switch (result.status) {
            case StatementResult.Status.NORMAL:
                break;
            case StatementResult.Status.RETURN:
                break LOOP;
            case StatementResult.Status.BREAK:
                result.status = StatementResult.Status.NORMAL;
                break LOOP;
            case StatementResult.Status.CONTINUE:
                result.status = StatementResult.Status.NORMAL;
                break;
            }
        }

        return result;
    }

    StatementResult visit(ForStatement stmt, LocalEnvironment env){
        void init(){ if (stmt.init) evalExpression(stmt.init, env); }
        bool cond(){ return stmt.condition ? test(stmt.condition, env) : true; }
        void post(){ if (stmt.post) evalExpression(stmt.post, env); }

        auto result = StatementResult(StatementResult.Status.NORMAL);

        LOOP: for (init(); cond(); post()) {
            result = execStatements(stmt.block.statements, env);
            final switch (result.status) {
            case StatementResult.Status.NORMAL:
                break;
            case StatementResult.Status.RETURN:
                break LOOP;
            case StatementResult.Status.BREAK:
                result.status = StatementResult.Status.NORMAL;
                break LOOP;
            case StatementResult.Status.CONTINUE:
                result.status = StatementResult.Status.NORMAL;
                break;
            }
        }

        return result;
    }

    StatementResult visit(ReturnStatement stmt, LocalEnvironment env){
        return StatementResult(StatementResult.Status.RETURN,
                               stmt.returnValue ? evalExpression(stmt.returnValue, env) : Value.nullValue());
    }

    StatementResult visit(BreakStatement stmt, LocalEnvironment env){
        return StatementResult(StatementResult.Status.BREAK);
    }

    StatementResult visit(ContinueStatement stmt, LocalEnvironment env){
        return StatementResult(StatementResult.Status.CONTINUE);
    }

    Value visit(FunctionCallExpression expr, LocalEnvironment env){
        static void checkParamsAndArgs(string[] params, Expression[] args){
            enforce(params.length == args.length,
                    "wrong number of argument (%d for %d)".format(args.length, params.length));
        }

        auto fdef = enforce(lookupFunction(expr.identifier), "undefined function - %s()".format(expr.identifier));

        if (fdef.isNative()) {
            auto func = enforce(cast(NativeFunctionDefinition)fdef);
            return func.call(this, expr.argument.map!(e => evalExpression(e, env)).array());
        }

        auto func = enforce(cast(InterpreteredFunctionDefinition)fdef);
        checkParamsAndArgs(func.parameters, expr.argument);
        auto fenv = new LocalEnvironment;
        foreach (i, p; func.parameters) {
            fenv.assignVariable(p, evalExpression(expr.argument[i], fenv));
        }
        auto result = execStatements(func.block.statements, fenv);
        if (result.status == StatementResult.Status.RETURN) return result.returnValue;
        return Value.nullValue();
    }

    Value visit(MinusExpression expr, LocalEnvironment env){
        return evalMinusExpression(expr.expression, env);
    }

    Value visit(BinaryExpression expr, LocalEnvironment env){
        if (expr.operator == ArithmeticOperators.LOGICAL_OR || expr.operator == ArithmeticOperators.LOGICAL_AND) {
            return evalLogicalExpr(expr.operator, expr.left, expr.right, env);
        }
        return evalBinaryExpression(expr.operator, expr.left, expr.right, env);
    }

    Value visit(AssignExpression expr, LocalEnvironment env){
        auto val = evalExpression(expr.operand, env);
        if (env) {
            env.assignVariable(expr.variable, val);
        } else {
            assignGlobalVariable(expr.variable, val);
        }
        return val;
    }

    Value visit(IdentifierExpression expr, LocalEnvironment env){
        auto var = env ? env.lookupVariable(expr.name) : lookupGlobalVariable(expr.name);
        enforce(var, "undefined variable - %s".format(expr.name));
        return var.value;
    }

    Value visit(IntegerExpression expr, LocalEnvironment env){
        return new Value(expr.value);
    }

    Value visit(DoubleExpression expr, LocalEnvironment env){
        return new Value(expr.value);
    }

    Value visit(StringExpression expr, LocalEnvironment env){
        return new Value(expr.value);
    }

    Value visit(BooleanExpression expr, LocalEnvironment env){
        return expr.value ? Value.trueValue() : Value.falseValue();
    }

    Value visit(NullExpression expr, LocalEnvironment env){
        return Value.nullValue();
    }
}

interface Executer {
    StatementResult visit(ExpressionStatement stmt, LocalEnvironment env);
    StatementResult visit(GlobalStatement stmt, LocalEnvironment env);
    StatementResult visit(IfStatement stmt, LocalEnvironment env);
    StatementResult visit(WhileStatement stmt, LocalEnvironment env);
    StatementResult visit(ForStatement stmt, LocalEnvironment env);
    StatementResult visit(ReturnStatement stmt, LocalEnvironment env);
    StatementResult visit(BreakStatement stmt, LocalEnvironment env);
    StatementResult visit(ContinueStatement stmt, LocalEnvironment env);
}

interface Evaluater {
    Value visit(FunctionCallExpression expr, LocalEnvironment env);
    Value visit(MinusExpression expr, LocalEnvironment env);
    Value visit(BinaryExpression expr, LocalEnvironment env);
    Value visit(AssignExpression expr, LocalEnvironment env);
    Value visit(IdentifierExpression expr, LocalEnvironment env);
    Value visit(IntegerExpression expr, LocalEnvironment env);
    Value visit(DoubleExpression expr, LocalEnvironment env);
    Value visit(StringExpression expr, LocalEnvironment env);
    Value visit(BooleanExpression expr, LocalEnvironment env);
    Value visit(NullExpression expr, LocalEnvironment env);
}

class NativePointer {
    private string _info;
    private Variant _resource;

    this (string info, Variant resource) {
        _info = info;
        _resource = resource;
    }

    @property string info(){ return _info; }
    @property Variant resource(){ return _resource; }
}

class Value {
    static Value nullValue(){ return new Value(); }
    static Value trueValue(){ return new Value(true); }
    static Value falseValue(){ return new Value(false); }

    enum Type {
        NULL,
        BOOLEAN,
        INT,
        DOUBLE,
        STRING,
        NATIVE_POINTER,
    }

    private Type _type;
    private Variant _value;

    @property Type type(){ return _type; }
    @property Variant value(){ return _value; }

    this () {
        _type = Type.NULL;
        _value = null;
    }

    this (bool value) {
        _type = Type.BOOLEAN;
        _value = value;
    }

    this (int value){
        _type = Type.INT;
        _value = value;
    }

    this (double value){
        _type = Type.DOUBLE;
        _value = value;
    }

    this (string value){
        _type = Type.STRING;
        _value = value;
    }

    this (NativePointer np){
        _type = Type.NATIVE_POINTER;
        _value = np;
    }

    bool test(){
        enforce(_type == Type.BOOLEAN);
        return _value.get!(bool);
    }

    string toPrint(){
        final switch (_type) {
        case Value.Type.INT:
            return "%d".format(_value.get!int);
        case Value.Type.DOUBLE:
            return "%f".format(_value.get!double);
        case Value.Type.NULL:
            return "null";
        case Value.Type.BOOLEAN:
            return _value.get!bool ? "true" : "false";
        case Value.Type.STRING:
            return _value.get!string;
        case Value.Type.NATIVE_POINTER:
            auto np = _value.get!NativePointer;
            return "(%s:%s)".format(np.info, np.resource);
        }
    }
}

class Variable {
    private string _name;
    Value value;

    this (string name, Value val) {
        _name = name;
        value = val;
    }

    @property string name(){ return _name; }
}

class LocalEnvironment {
    private Variable[string] variables;
    private Variable[string] globalVariables;

    void addGlobalVariableReference(string name, Variable var){
        if (name !in globalVariables) globalVariables[name] = var;
    }

    Variable lookupVariable(string name){
        return variables.get(name, globalVariables.get(name, null));
    }

    void assignVariable(string name, Value val){
        auto var = lookupVariable(name);
        if (var) {
            var.value = val;
        } else {
            variables[name] = new Variable(name, val);
        }
    }
}

struct StatementResult {
    enum Status {
        NORMAL,
        RETURN,
        BREAK,
        CONTINUE,
    }

    Status status;
    Value returnValue;
}
