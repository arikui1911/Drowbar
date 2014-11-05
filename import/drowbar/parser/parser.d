module drowbar.parser.parser;

import drowbar.ast;
import std.variant;

enum Token {
	token_eof,
	token_ADD,
	token_ASSIGN,
	token_BREAK,
	token_COMMA,
	token_CONTINUE,
	token_DIV,
	token_DOUBLE_LITERAL,
	token_ELSE,
	token_ELSIF,
	token_EQ,
	token_FALSE,
	token_FOR,
	token_FUNCTION,
	token_GE,
	token_GLOBAL,
	token_GT,
	token_IDENTIFIER,
	token_IF,
	token_INT_LITERAL,
	token_LC,
	token_LE,
	token_LOGICAL_AND,
	token_LOGICAL_OR,
	token_LP,
	token_LT,
	token_MOD,
	token_MUL,
	token_NE,
	token_NULL,
	token_RC,
	token_RETURN,
	token_RP,
	token_SEMICOLON,
	token_STRING_LITERAL,
	token_SUB,
	token_TRUE,
	token_WHILE
}

class Stack(T, int stackSize)
{
	this(){ gap_ = 0; }
	~this(){}

	void reset_tmp()
	{
		gap_ = stack_.length;
		tmp_ = null;
	}

	void commit_tmp()
	{
		stack_ = stack_[0 .. gap_] ~ tmp_;
	}

	bool push(T f)
	{
		if(stackSize != 0 && stackSize <= stack_.length + tmp_.length){
			return false;
		}
		tmp_ ~= f;
		return true;
	}

	void pop(uint n)
	{
		if(tmp_.length < n){
			n -= tmp_.length;
			tmp_ = null;
			gap_ -= n;
		}else{
			tmp_ = tmp_[0 .. $ - n];
		}
	}

	T* top()
	{
		if(tmp_.length > 0){
			return &tmp_[$ - 1];
		}else{
			return &stack_[gap_ - 1];
		}
	}

	T* get_arg(uint base, uint index)
	{
		uint n = tmp_.length;
		if(base - index <= n){
			return &tmp_[n - (base - index)];
		}else{
			return &stack_[gap_ - (base - n) + index];
		}
	}

	void clear()
	{
		stack_ = null;
	}

private:
	T[] stack_;
	T[] tmp_;
	uint gap_;
}

class Parser(Value, SemanticAction, int stackSize = 0)
{
	alias Token TokenType;
	alias Value ValueType;

	this(SemanticAction sa){ sa_ = sa; reset(); }

	void reset()
	{
		error_ = false;
		accepted_ = false;
		stack_ = new typeof(stack_);
		clear_stack();
		reset_tmp_stack();
		ValueType defaultValue;
		if(push_stack(&state_0, &gotof_0, defaultValue)){
			commit_tmp_stack();
		}else{
			sa_.stack_overflow();
			error_ = true;
		}
	}

	bool post(TokenType token, ValueType value)
	{
		assert(!error_);
		reset_tmp_stack();
		while((stack_top().state)(token, value)){ }
		if(!error_){
			commit_tmp_stack();
		}
		return accepted_;
	}

	bool accept(out ValueType v)
	{
		assert(accepted_);
		if(error_){ return false; }
		v = accepted_value_;
		return true;
	}

	bool error(){ return error_; }

private:
	alias typeof(this) self_type;
	alias bool delegate(TokenType, ValueType) state_type;
	alias bool delegate(int, ValueType) gotof_type;

	bool accepted_;
	bool error_;
	ValueType accepted_value_;

	SemanticAction sa_;

	struct stack_frame
	{
		state_type state;
		gotof_type gotof;
		ValueType value;

		static stack_frame opCall(state_type s, gotof_type g, ValueType v)
		{
			stack_frame result;
			result.state = s;
			result.gotof = g;
			result.value = v;
			return result;
		}
	}

	Stack!(stack_frame, stackSize) stack_;

	bool push_stack(state_type s, gotof_type g, ValueType v)
	{
		bool f = stack_.push(stack_frame(s, g, v));
		assert(!error_);
		if(!f){
			error_ = true;
			sa_.stack_overflow();
		}
		return f;
	}

	void pop_stack(uint n)
	{
		stack_.pop(n);
	}

	stack_frame* stack_top()
	{
		return stack_.top();
	}

	ValueType* get_arg(uint base, uint index)
	{
		return &stack_.get_arg(base, index).value;
	}

	void clear_stack()
	{
		stack_.clear();
	}

	void reset_tmp_stack()
	{
		stack_.reset_tmp();
	}

	void commit_tmp_stack()
	{
		stack_.commit_tmp();
	}

	bool gotof_0(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 19: return push_stack(&state_1, &gotof_1, v);
		case 3: return push_stack(&state_2, &gotof_2, v);
		case 17: return push_stack(&state_12, &gotof_12, v);
		case 10: return push_stack(&state_23, &gotof_23, v);
		case 7: return push_stack(&state_18, &gotof_18, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_0(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_BREAK:
			// shift
			push_stack(&state_42, &gotof_42, value);
			return false;
		case Token.token_CONTINUE:
			// shift
			push_stack(&state_44, &gotof_44, value);
			return false;
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_FOR:
			// shift
			push_stack(&state_29, &gotof_29, value);
			return false;
		case Token.token_FUNCTION:
			// shift
			push_stack(&state_4, &gotof_4, value);
			return false;
		case Token.token_GLOBAL:
			// shift
			push_stack(&state_20, &gotof_20, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_IF:
			// shift
			push_stack(&state_46, &gotof_46, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_RETURN:
			// shift
			push_stack(&state_38, &gotof_38, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		case Token.token_WHILE:
			// shift
			push_stack(&state_24, &gotof_24, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_1(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 3: return push_stack(&state_3, &gotof_3, v);
		case 17: return push_stack(&state_12, &gotof_12, v);
		case 10: return push_stack(&state_23, &gotof_23, v);
		case 7: return push_stack(&state_18, &gotof_18, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_1(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// accept
			// run_semantic_action();
			accepted_ = true;
			accepted_value_ = *get_arg(1, 0);
			return false;
		case Token.token_BREAK:
			// shift
			push_stack(&state_42, &gotof_42, value);
			return false;
		case Token.token_CONTINUE:
			// shift
			push_stack(&state_44, &gotof_44, value);
			return false;
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_FOR:
			// shift
			push_stack(&state_29, &gotof_29, value);
			return false;
		case Token.token_FUNCTION:
			// shift
			push_stack(&state_4, &gotof_4, value);
			return false;
		case Token.token_GLOBAL:
			// shift
			push_stack(&state_20, &gotof_20, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_IF:
			// shift
			push_stack(&state_46, &gotof_46, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_RETURN:
			// shift
			push_stack(&state_38, &gotof_38, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		case Token.token_WHILE:
			// shift
			push_stack(&state_24, &gotof_24, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_2(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_2(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(19, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_3(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_3(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(19, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_4(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_4(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_5, &gotof_5, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_5(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_5(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LP:
			// shift
			push_stack(&state_6, &gotof_6, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_6(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 14: return push_stack(&state_7, &gotof_7, v);
		default: assert(0);
		}
	}

	bool state_6(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_13, &gotof_13, value);
			return false;
		case Token.token_RP:
			// shift
			push_stack(&state_10, &gotof_10, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_7(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_7(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// shift
			push_stack(&state_14, &gotof_14, value);
			return false;
		case Token.token_RP:
			// shift
			push_stack(&state_8, &gotof_8, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_8(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 2: return push_stack(&state_9, &gotof_9, v);
		default: assert(0);
		}
	}

	bool state_8(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LC:
			// shift
			push_stack(&state_16, &gotof_16, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_9(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_9(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 5));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 3));
				Variant r = sa_.functionDefine(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(3, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_10(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 2: return push_stack(&state_11, &gotof_11, v);
		default: assert(0);
		}
	}

	bool state_10(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LC:
			// shift
			push_stack(&state_16, &gotof_16, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_11(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_11(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.functionDefine(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(3, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_12(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_12(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.toplevelStatementAdd(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(3, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_13(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_13(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.parameterList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(14, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.parameterList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(14, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_14(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_14(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_15, &gotof_15, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_15(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_15(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 0));
				Variant r = sa_.parameterList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(14, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 0));
				Variant r = sa_.parameterList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(14, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_16(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 17: return push_stack(&state_68, &gotof_68, v);
		case 10: return push_stack(&state_23, &gotof_23, v);
		case 18: return push_stack(&state_17, &gotof_17, v);
		case 7: return push_stack(&state_18, &gotof_18, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_16(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_BREAK:
			// shift
			push_stack(&state_42, &gotof_42, value);
			return false;
		case Token.token_CONTINUE:
			// shift
			push_stack(&state_44, &gotof_44, value);
			return false;
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_FOR:
			// shift
			push_stack(&state_29, &gotof_29, value);
			return false;
		case Token.token_GLOBAL:
			// shift
			push_stack(&state_20, &gotof_20, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_IF:
			// shift
			push_stack(&state_46, &gotof_46, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_RC:
			// shift
			push_stack(&state_64, &gotof_64, value);
			return false;
		case Token.token_RETURN:
			// shift
			push_stack(&state_38, &gotof_38, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		case Token.token_WHILE:
			// shift
			push_stack(&state_24, &gotof_24, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_17(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 17: return push_stack(&state_69, &gotof_69, v);
		case 10: return push_stack(&state_23, &gotof_23, v);
		case 7: return push_stack(&state_18, &gotof_18, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_17(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_BREAK:
			// shift
			push_stack(&state_42, &gotof_42, value);
			return false;
		case Token.token_CONTINUE:
			// shift
			push_stack(&state_44, &gotof_44, value);
			return false;
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_FOR:
			// shift
			push_stack(&state_29, &gotof_29, value);
			return false;
		case Token.token_GLOBAL:
			// shift
			push_stack(&state_20, &gotof_20, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_IF:
			// shift
			push_stack(&state_46, &gotof_46, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_RC:
			// shift
			push_stack(&state_63, &gotof_63, value);
			return false;
		case Token.token_RETURN:
			// shift
			push_stack(&state_38, &gotof_38, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		case Token.token_WHILE:
			// shift
			push_stack(&state_24, &gotof_24, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_18(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_18(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_SEMICOLON:
			// shift
			push_stack(&state_19, &gotof_19, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_19(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_19(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 0));
				Variant r = sa_.expressionStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_20(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 9: return push_stack(&state_21, &gotof_21, v);
		default: assert(0);
		}
	}

	bool state_20(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_65, &gotof_65, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_21(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_21(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// shift
			push_stack(&state_66, &gotof_66, value);
			return false;
		case Token.token_SEMICOLON:
			// shift
			push_stack(&state_22, &gotof_22, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_22(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_22(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.globalStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_23(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_23(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_24(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_24(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LP:
			// shift
			push_stack(&state_25, &gotof_25, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_25(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 7: return push_stack(&state_26, &gotof_26, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_25(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_26(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_26(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_RP:
			// shift
			push_stack(&state_27, &gotof_27, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_27(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 2: return push_stack(&state_28, &gotof_28, v);
		default: assert(0);
		}
	}

	bool state_27(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LC:
			// shift
			push_stack(&state_16, &gotof_16, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_28(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_28(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.whileStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_29(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_29(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LP:
			// shift
			push_stack(&state_30, &gotof_30, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_30(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 8: return push_stack(&state_31, &gotof_31, v);
		case 7: return push_stack(&state_70, &gotof_70, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_30(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(0);
				return (stack_top().gotof)(8, v);
			}
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_31(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_31(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_SEMICOLON:
			// shift
			push_stack(&state_32, &gotof_32, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_32(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 8: return push_stack(&state_33, &gotof_33, v);
		case 7: return push_stack(&state_70, &gotof_70, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_32(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(0);
				return (stack_top().gotof)(8, v);
			}
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_33(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_33(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_SEMICOLON:
			// shift
			push_stack(&state_34, &gotof_34, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_34(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 8: return push_stack(&state_35, &gotof_35, v);
		case 7: return push_stack(&state_70, &gotof_70, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_34(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_RP:
			// reduce
			{
				Variant r = sa_.doNothing();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(0);
				return (stack_top().gotof)(8, v);
			}
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_35(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_35(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_RP:
			// shift
			push_stack(&state_36, &gotof_36, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_36(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 2: return push_stack(&state_37, &gotof_37, v);
		default: assert(0);
		}
	}

	bool state_36(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LC:
			// shift
			push_stack(&state_16, &gotof_16, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_37(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_37(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(9, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(9, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(9, 6));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(9, 8));
				Variant r = sa_.forStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(9);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_38(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 7: return push_stack(&state_39, &gotof_39, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_38(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_SEMICOLON:
			// shift
			push_stack(&state_41, &gotof_41, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_39(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_39(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_SEMICOLON:
			// shift
			push_stack(&state_40, &gotof_40, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_40(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_40(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.returnStatement(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_41(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_41(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant r = sa_.returnStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_42(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_42(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_SEMICOLON:
			// shift
			push_stack(&state_43, &gotof_43, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_43(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_43(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant r = sa_.breakStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_44(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_44(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_SEMICOLON:
			// shift
			push_stack(&state_45, &gotof_45, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_45(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_45(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant r = sa_.continueStatement();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(17, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_46(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_46(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LP:
			// shift
			push_stack(&state_47, &gotof_47, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_47(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 7: return push_stack(&state_48, &gotof_48, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_47(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_48(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_48(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_RP:
			// shift
			push_stack(&state_49, &gotof_49, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_49(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 2: return push_stack(&state_50, &gotof_50, v);
		default: assert(0);
		}
	}

	bool state_49(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LC:
			// shift
			push_stack(&state_16, &gotof_16, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_50(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 5: return push_stack(&state_53, &gotof_53, v);
		case 4: return push_stack(&state_56, &gotof_56, v);
		default: assert(0);
		}
	}

	bool state_50(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_ELSE:
			// shift
			push_stack(&state_51, &gotof_51, value);
			return false;
		case Token.token_ELSIF:
			// shift
			push_stack(&state_58, &gotof_58, value);
			return false;
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.ifStatement(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(10, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_51(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 2: return push_stack(&state_52, &gotof_52, v);
		default: assert(0);
		}
	}

	bool state_51(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LC:
			// shift
			push_stack(&state_16, &gotof_16, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_52(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_52(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(7, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(7, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(7, 6));
				Variant r = sa_.ifStatement0elsif(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(7);
				return (stack_top().gotof)(10, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_53(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 4: return push_stack(&state_57, &gotof_57, v);
		default: assert(0);
		}
	}

	bool state_53(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_ELSE:
			// shift
			push_stack(&state_54, &gotof_54, value);
			return false;
		case Token.token_ELSIF:
			// shift
			push_stack(&state_58, &gotof_58, value);
			return false;
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(6, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(6, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(6, 5));
				Variant r = sa_.ifStatement(arg0, arg1, arg2);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(6);
				return (stack_top().gotof)(10, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_54(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 2: return push_stack(&state_55, &gotof_55, v);
		default: assert(0);
		}
	}

	bool state_54(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LC:
			// shift
			push_stack(&state_16, &gotof_16, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_55(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_55(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(8, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(8, 4));
				Variant arg2;
				sa_.downcast(arg2, *get_arg(8, 5));
				Variant arg3;
				sa_.downcast(arg3, *get_arg(8, 7));
				Variant r = sa_.ifStatement(arg0, arg1, arg2, arg3);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(8);
				return (stack_top().gotof)(10, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_56(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_56(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_ELSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_ELSIF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.elsifList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(5, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_57(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_57(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_ELSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_ELSIF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.elsifList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(5, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_58(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_58(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LP:
			// shift
			push_stack(&state_59, &gotof_59, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_59(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 7: return push_stack(&state_60, &gotof_60, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_59(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_60(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_60(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_RP:
			// shift
			push_stack(&state_61, &gotof_61, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_61(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 2: return push_stack(&state_62, &gotof_62, v);
		default: assert(0);
		}
	}

	bool state_61(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_LC:
			// shift
			push_stack(&state_16, &gotof_16, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_62(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_62(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_ELSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_ELSIF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(5, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(5, 4));
				Variant r = sa_.elsif(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(5);
				return (stack_top().gotof)(4, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_63(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_63(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_ELSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_ELSIF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.block(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(2, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_64(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_64(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_eof:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_BREAK:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_ELSE:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_ELSIF:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_FUNCTION:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant r = sa_.block();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(2, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_65(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_65(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(9, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(9, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_66(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_66(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_67, &gotof_67, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_67(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_67(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 0));
				Variant r = sa_.identifierList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(9, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 0));
				Variant r = sa_.identifierList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(9, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_68(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_68(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.statementList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(18, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_69(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_69(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_BREAK:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_CONTINUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_DOUBLE_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_FALSE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_FOR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_GLOBAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_IDENTIFIER:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_IF:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_INT_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_LP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_NULL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_RC:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_RETURN:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_STRING_LITERAL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_TRUE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		case Token.token_WHILE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(2, 0));
				Variant r = sa_.statementList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(18, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_70(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_70(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(8, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(8, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_71(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 7: return push_stack(&state_77, &gotof_77, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_71(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_72(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 7: return push_stack(&state_113, &gotof_113, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_72(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_73(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 7: return push_stack(&state_125, &gotof_125, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		case 1: return push_stack(&state_122, &gotof_122, v);
		default: assert(0);
		}
	}

	bool state_73(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_RP:
			// shift
			push_stack(&state_124, &gotof_124, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_74(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 7: return push_stack(&state_126, &gotof_126, v);
		case 12: return push_stack(&state_75, &gotof_75, v);
		case 11: return push_stack(&state_78, &gotof_78, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_74(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_76, &gotof_76, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_75(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_75(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(7, v);
			}
		case Token.token_LOGICAL_OR:
			// shift
			push_stack(&state_79, &gotof_79, value);
			return false;
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(7, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(7, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_76(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_76(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_ASSIGN:
			// shift
			push_stack(&state_71, &gotof_71, value);
			return false;
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LP:
			// shift
			push_stack(&state_73, &gotof_73, value);
			return false;
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_77(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_77(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.assignExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(7, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.assignExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(7, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.assignExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(7, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_78(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_78(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(12, v);
			}
		case Token.token_LOGICAL_AND:
			// shift
			push_stack(&state_82, &gotof_82, value);
			return false;
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(12, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(12, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(12, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_79(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 11: return push_stack(&state_80, &gotof_80, v);
		case 6: return push_stack(&state_81, &gotof_81, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_79(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_80(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_80(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogor(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(12, v);
			}
		case Token.token_LOGICAL_AND:
			// shift
			push_stack(&state_82, &gotof_82, value);
			return false;
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogor(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(12, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogor(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(12, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogor(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(12, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_81(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_81(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(11, v);
			}
		case Token.token_EQ:
			// shift
			push_stack(&state_85, &gotof_85, value);
			return false;
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(11, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(11, v);
			}
		case Token.token_NE:
			// shift
			push_stack(&state_87, &gotof_87, value);
			return false;
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(11, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(11, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_82(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 6: return push_stack(&state_83, &gotof_83, v);
		case 16: return push_stack(&state_84, &gotof_84, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_82(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_83(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_83(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogand(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(11, v);
			}
		case Token.token_EQ:
			// shift
			push_stack(&state_85, &gotof_85, value);
			return false;
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogand(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(11, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogand(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(11, v);
			}
		case Token.token_NE:
			// shift
			push_stack(&state_87, &gotof_87, value);
			return false;
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogand(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(11, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLogand(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(11, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_84(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_84(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_GE:
			// shift
			push_stack(&state_92, &gotof_92, value);
			return false;
		case Token.token_GT:
			// shift
			push_stack(&state_90, &gotof_90, value);
			return false;
		case Token.token_LE:
			// shift
			push_stack(&state_96, &gotof_96, value);
			return false;
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_LT:
			// shift
			push_stack(&state_94, &gotof_94, value);
			return false;
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(6, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_85(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 16: return push_stack(&state_86, &gotof_86, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_85(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_86(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_86(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionEq(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionEq(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_GE:
			// shift
			push_stack(&state_92, &gotof_92, value);
			return false;
		case Token.token_GT:
			// shift
			push_stack(&state_90, &gotof_90, value);
			return false;
		case Token.token_LE:
			// shift
			push_stack(&state_96, &gotof_96, value);
			return false;
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionEq(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionEq(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_LT:
			// shift
			push_stack(&state_94, &gotof_94, value);
			return false;
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionEq(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionEq(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionEq(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_87(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 16: return push_stack(&state_88, &gotof_88, v);
		case 0: return push_stack(&state_89, &gotof_89, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_87(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_88(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_88(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionNe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionNe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_GE:
			// shift
			push_stack(&state_92, &gotof_92, value);
			return false;
		case Token.token_GT:
			// shift
			push_stack(&state_90, &gotof_90, value);
			return false;
		case Token.token_LE:
			// shift
			push_stack(&state_96, &gotof_96, value);
			return false;
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionNe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionNe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_LT:
			// shift
			push_stack(&state_94, &gotof_94, value);
			return false;
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionNe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionNe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionNe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(6, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_89(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_89(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// shift
			push_stack(&state_99, &gotof_99, value);
			return false;
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SUB:
			// shift
			push_stack(&state_101, &gotof_101, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_90(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 0: return push_stack(&state_91, &gotof_91, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_90(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_91(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_91(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// shift
			push_stack(&state_99, &gotof_99, value);
			return false;
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SUB:
			// shift
			push_stack(&state_101, &gotof_101, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_92(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 0: return push_stack(&state_93, &gotof_93, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_92(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_93(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_93(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// shift
			push_stack(&state_99, &gotof_99, value);
			return false;
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionGe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SUB:
			// shift
			push_stack(&state_101, &gotof_101, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_94(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 0: return push_stack(&state_95, &gotof_95, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_94(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_95(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_95(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// shift
			push_stack(&state_99, &gotof_99, value);
			return false;
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLt(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SUB:
			// shift
			push_stack(&state_101, &gotof_101, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_96(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 0: return push_stack(&state_97, &gotof_97, v);
		case 13: return push_stack(&state_98, &gotof_98, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_96(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_97(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_97(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// shift
			push_stack(&state_99, &gotof_99, value);
			return false;
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionLe(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(16, v);
			}
		case Token.token_SUB:
			// shift
			push_stack(&state_101, &gotof_101, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_98(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_98(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_DIV:
			// shift
			push_stack(&state_106, &gotof_106, value);
			return false;
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_MOD:
			// shift
			push_stack(&state_108, &gotof_108, value);
			return false;
		case Token.token_MUL:
			// shift
			push_stack(&state_104, &gotof_104, value);
			return false;
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(0, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_99(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 13: return push_stack(&state_100, &gotof_100, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_99(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_100(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_100(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_DIV:
			// shift
			push_stack(&state_106, &gotof_106, value);
			return false;
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_MOD:
			// shift
			push_stack(&state_108, &gotof_108, value);
			return false;
		case Token.token_MUL:
			// shift
			push_stack(&state_104, &gotof_104, value);
			return false;
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionAdd(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_101(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 13: return push_stack(&state_102, &gotof_102, v);
		case 20: return push_stack(&state_103, &gotof_103, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_101(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_102(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_102(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_DIV:
			// shift
			push_stack(&state_106, &gotof_106, value);
			return false;
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_MOD:
			// shift
			push_stack(&state_108, &gotof_108, value);
			return false;
		case Token.token_MUL:
			// shift
			push_stack(&state_104, &gotof_104, value);
			return false;
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionSub(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(0, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_103(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_103(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(13, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_104(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 20: return push_stack(&state_105, &gotof_105, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_104(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_105(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_105(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMul(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_106(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 20: return push_stack(&state_107, &gotof_107, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_106(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_107(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_107(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionDiv(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_108(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 20: return push_stack(&state_109, &gotof_109, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_108(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_109(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_109(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 2));
				Variant r = sa_.binaryExpressionMod(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(13, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_110(int nonterminal_index, ValueType v)
	{
		switch(nonterminal_index){
		case 20: return push_stack(&state_112, &gotof_112, v);
		case 15: return push_stack(&state_111, &gotof_111, v);
		default: assert(0);
		}
	}

	bool state_110(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_DOUBLE_LITERAL:
			// shift
			push_stack(&state_117, &gotof_117, value);
			return false;
		case Token.token_FALSE:
			// shift
			push_stack(&state_120, &gotof_120, value);
			return false;
		case Token.token_IDENTIFIER:
			// shift
			push_stack(&state_115, &gotof_115, value);
			return false;
		case Token.token_INT_LITERAL:
			// shift
			push_stack(&state_116, &gotof_116, value);
			return false;
		case Token.token_LP:
			// shift
			push_stack(&state_72, &gotof_72, value);
			return false;
		case Token.token_NULL:
			// shift
			push_stack(&state_121, &gotof_121, value);
			return false;
		case Token.token_STRING_LITERAL:
			// shift
			push_stack(&state_118, &gotof_118, value);
			return false;
		case Token.token_SUB:
			// shift
			push_stack(&state_110, &gotof_110, value);
			return false;
		case Token.token_TRUE:
			// shift
			push_stack(&state_119, &gotof_119, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_111(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_111(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(20, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_112(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_112(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(2, 1));
				Variant r = sa_.minusExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(2);
				return (stack_top().gotof)(20, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_113(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_113(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_RP:
			// shift
			push_stack(&state_114, &gotof_114, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_114(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_114(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 1));
				Variant r = sa_.return1st(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_115(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_115(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LP:
			// shift
			push_stack(&state_73, &gotof_73, value);
			return false;
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.identifierExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_116(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_116(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.integerExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_117(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_117(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.doubleExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_118(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_118(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.stringExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_119(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_119(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.booleanExpressionTrue();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_120(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_120(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.booleanExpressionFalse();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_121(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_121(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant r = sa_.nullExpression();
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_122(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_122(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// shift
			push_stack(&state_74, &gotof_74, value);
			return false;
		case Token.token_RP:
			// shift
			push_stack(&state_123, &gotof_123, value);
			return false;
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_123(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_123(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(4, 0));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(4, 2));
				Variant r = sa_.functionCallExpression(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(4);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_124(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_124(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_ADD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_DIV:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_EQ:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_GT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_AND:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LOGICAL_OR:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_LT:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MOD:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_MUL:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_NE:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SEMICOLON:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		case Token.token_SUB:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 0));
				Variant r = sa_.functionCallExpression(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(15, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_125(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_125(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.argumentList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(1, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(1, 0));
				Variant r = sa_.argumentList(arg0);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(1);
				return (stack_top().gotof)(1, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

	bool gotof_126(int nonterminal_index, ValueType v)
	{
		assert(false);
	}

	bool state_126(TokenType token, ValueType value)
	{
		switch(token) {
		case Token.token_COMMA:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 0));
				Variant r = sa_.argumentList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(1, v);
			}
		case Token.token_RP:
			// reduce
			{
				Variant arg0;
				sa_.downcast(arg0, *get_arg(3, 2));
				Variant arg1;
				sa_.downcast(arg1, *get_arg(3, 0));
				Variant r = sa_.argumentList(arg0, arg1);
				ValueType v;
				sa_.upcast(v, r);
				pop_stack(3);
				return (stack_top().gotof)(1, v);
			}
		default:
			sa_.syntax_error();
			error_ = true;
			return false;
		}
	}

}

