#!/usr/bin/env ruby
# frozen_string_literal: true

# Home-cooked algorithm:
# * keep a stack of "un-folded" values, operators and opening parentesis.
# * when encountering a number; pop of the operator and lhs and evaluate, put value back in stack.
# * when encoutinging a closing paren, same as above + handle cases when multiple nested parens are used."
#
# Should have used Reverse Polish Notation if I had remembered. I knew it was something with a stack...

OP_ADD = '+'
OP_MUL = '*'
EXPR_PAREN_OPEN = '('
EXPR_PAREN_CLOSE = ')'

def evaluate(exprs)
  stack = []
  i = 0
  while i < exprs.length
    cur_char = exprs[i]
    case cur_char
    when /\d/
      cur_digit = cur_char.to_i
      if stack.empty?
        stack << cur_digit
      else
        op = stack.pop
        case op
        when OP_ADD
          lhs = stack.pop
          stack << lhs + cur_digit
        when OP_MUL
          lhs = stack.pop
          stack << lhs * cur_digit
        when EXPR_PAREN_OPEN
          stack << op << cur_digit
        end
      end
    when EXPR_PAREN_CLOSE
      rhs = stack.pop
      _open_paren = stack.pop
      op = stack.pop
      if op.nil?
        stack << rhs
      elsif op == EXPR_PAREN_OPEN
        stack << op
        stack << rhs
      else
        lhs = stack.pop
        stack << case op
                 when OP_ADD then lhs + rhs
                 when OP_MUL then lhs * rhs
                 end
      end
    when ' ' then nil
    else
      stack << exprs[i]
    end
    i += 1
  end
  stack.pop
end

sum = ARGF.each_line.sum do |line|
  evaluate(line.chomp)
end

puts sum
