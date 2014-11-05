module drowbar.lexer;

import drowbar.parser.parser;
import drowbar.ast;

import std.array;
import std.string;
import std.conv;
import std.ascii;
import std.variant;


class Lexer {
    private string src;
    private uint pos;

    this (string source) {
        src = source;
        pos = 0;
    }

    enum States {
        INITIAL,
        SYMBOL,
        ZERO,
        NUMBER,
        FLOAT,
        STRING,
        STRING_ESC,
        COMMENT,
    }

    LexedValue read(){
        auto state = States.INITIAL;
        Appender!(string) buf;
        char c;

        while (pos < src.length) {
            c = src[pos++];
            final switch (state) {
            case States.INITIAL:
                if (c == '\n') {
                    ;
                } else if (c.isWhite()) {
                    ;
                } else if (c.isAlpha()) {
                    buf.put(c);
                    state = States.SYMBOL;
                } else if (c == '0') {
                    buf.put(c);
                    state = States.ZERO;
                } else if (c.isDigit()) {
                    buf.put(c);
                    state = States.NUMBER;
                } else if (c == '"') {
                    state = States.STRING;
                } else if (c == '#') {
                    state = States.COMMENT;
                } else {
                    switch (c) {
                    case '(': return LexedValue(Token.token_LP);
                    case ')': return LexedValue(Token.token_RP);
                    case '{': return LexedValue(Token.token_LC);
                    case '}': return LexedValue(Token.token_RC);
                    case ';': return LexedValue(Token.token_SEMICOLON);
                    case ',': return LexedValue(Token.token_COMMA);
                    case '+': return LexedValue(Token.token_ADD);
                    case '-': return LexedValue(Token.token_SUB);
                    case '*': return LexedValue(Token.token_MUL);
                    case '/': return LexedValue(Token.token_DIV);
                    case '%': return LexedValue(Token.token_MOD);
                    default:
                        if (pos < src.length) {
                            auto lc = c;
                            c = src[pos++];
                            switch (lc) {
                            case '&':
                                if (c == '&') return LexedValue(Token.token_LOGICAL_AND);
                                break;
                            case '|':
                                if (c == '|') return LexedValue(Token.token_LOGICAL_OR);
                                break;
                            case '!':
                                if (c == '=') return LexedValue(Token.token_NE);
                                break;
                            case '=':
                                if (c == '=') return LexedValue(Token.token_EQ);
                                pos--;
                                return LexedValue(Token.token_ASSIGN);
                            case '>':
                                if (c == '=') return LexedValue(Token.token_GE);
                                pos--;
                                return LexedValue(Token.token_GT);
                            case '<':
                                if (c == '=') return LexedValue(Token.token_LE);
                                pos--;
                                return LexedValue(Token.token_LT);
                            default:
                                break;
                            }
                        }
                        throw new Exception("invalid character - `%c'".format(c));
                    }
                }
                break;
            case States.SYMBOL:
                if (!c.isAlphaNum()) {
                    pos--;
                    switch (buf.data) {
                    case "function": return LexedValue(Token.token_FUNCTION);
                    case "if":       return LexedValue(Token.token_IF);
                    case "else":     return LexedValue(Token.token_ELSE);
                    case "elsif":    return LexedValue(Token.token_ELSIF);
                    case "while":    return LexedValue(Token.token_WHILE);
                    case "for":      return LexedValue(Token.token_FOR);
                    case "return":   return LexedValue(Token.token_RETURN);
                    case "break":    return LexedValue(Token.token_BREAK);
                    case "continue": return LexedValue(Token.token_CONTINUE);
                    case "null":     return LexedValue(Token.token_NULL);
                    case "true":     return LexedValue(Token.token_TRUE);
                    case "false":    return LexedValue(Token.token_FALSE);
                    case "global":   return LexedValue(Token.token_GLOBAL);
                    default:
                        return LexedValue(Token.token_IDENTIFIER, Variant(buf.data));
                    }
                }
                buf.put(c);
                break;
            case States.ZERO:
                if (c != '.') {
                    pos--;
                    return LexedValue(Token.token_INT_LITERAL, Variant(0));
                }
                buf.put(c);
                state = States.FLOAT;
                break;
            case States.NUMBER:
                if (c == '.') {
                    buf.put(c);
                    state = States.FLOAT;
                } else if (c.isDigit()) {
                    buf.put(c);
                } else {
                    pos--;
                    return LexedValue(Token.token_INT_LITERAL, Variant(buf.data.to!int()));
                }
                break;
            case States.FLOAT:
                if (!c.isDigit()) {
                    pos--;
                    return LexedValue(Token.token_DOUBLE_LITERAL, Variant(buf.data.to!double()));
                }
                buf.put(c);
                break;
            case States.STRING:
                switch (c) {
                case '"':
                    return LexedValue(Token.token_STRING_LITERAL, Variant(buf.data));
                case '\\':
                    state = States.STRING_ESC;
                    break;
                default:
                    buf.put(c);
                }
                break;
            case States.STRING_ESC:
                switch (c) {
                case '"':
                case '\\':
                    buf.put(c);
                    break;
                case 'n':
                    buf.put('\n');
                    break;
                case 't':
                    buf.put('\t');
                    break;
                default:
                    buf.put('\\');
                    buf.put(c);
                }
                state = States.STRING;
                break;
            case States.COMMENT:
                if (c == '\n') state = States.INITIAL;
                break;
            }
        }
        return LexedValue(Token.token_eof);
    }
}


struct LexedValue {
    Token token;
    Variant value;
}

