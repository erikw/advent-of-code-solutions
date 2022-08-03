#!/usr/bin/env ruby
# frozen_string_literal: true
# Brute-forcing 9^14 = 23 trillion posible solutions is not going to work...

require 'stringio'

MODNUM_LEN = 14

class ALU
  def initialize
    reset
  end

  def reset
    @io = nil
    @mem = { 'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0 }
  end

  def feed(input_io)
    @io = input_io
  end

  def to_s
    @mem.to_s
  end

  def state(var)
    @mem[var]
  end

  def inp(a)
    @mem[a] = @io.gets.to_i
  end

  def add(a, b)
    @mem[a] += value_from_arg(b)
  end

  def mul(a, b)
    @mem[a] *= value_from_arg(b)
  end

  def div(a, b)
    @mem[a] /= value_from_arg(b)
  end

  def mod(a, b)
    @mem[a] %= value_from_arg(b)
  end

  def eql(a, b)
    @mem[a] = @mem[a] == value_from_arg(b) ? 1 : 0
  end

  private

  def value_from_arg(arg)
    @mem.key?(arg) ? @mem[arg] : arg.to_i
  end
end

class Computer
  def initialize
    @alu = ALU.new
  end

  def to_s
    @alu.to_s
  end

  def state(var)
    @alu.state(var)
  end

  def execute(program, input)
    @alu.reset
    @alu.feed(input)

    program.each do |instline|
      case instline
      in ['inp', String => a]
        @alu.inp(a)
      in ['add', String => a, String => b]
        @alu.add(a, b)
      in ['mul', String => a, String => b]
        @alu.mul(a, b)
      in ['div', String => a, String => b]
        @alu.div(a, b)
      in ['mod', String => a, String => b]
        @alu.mod(a, b)
      in ['eql', String => a, String => b]
        @alu.eql(a, b)
      else
        raise 'Instruction not recongized!'
      end
    end
  end
end

def monad_search(program, model_no)
  computer = Computer.new
  while model_no.to_s.length >= MODNUM_LEN
    model_no_str = model_no.to_s
    unless model_no_str.include?('0')
      puts "[#{Thread.current.name}] Trying input #{model_no}"
      input = StringIO.new(model_no_str.chars.join('\n'))
      computer.execute(program, input)
      break if computer.state('z') == 0
    end

    model_no -= 9
  end
  model_no.to_s.length == MODNUM_LEN ? model_no : nil
end

program = ARGF.readlines.map { |line| line.chomp.split }
threads = []
model_no = 99_999_999_999_999
mutex = Mutex.new
solutions = []
(0...9).each do |i|
  threads << Thread.new do
    Thread.current.name = "Thread#{i}"
    model_no = monad_search(program, model_no - i)
    unless model_no.nil?
      mutex.synchronize do
        solutions << model_no
      end
      puts "[#{Thread.current.name}] found solution #{model_no}"
    end
  end
end
threads.each { |thr| thr.join }
puts solutions.max
