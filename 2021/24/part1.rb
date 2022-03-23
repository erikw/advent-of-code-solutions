#!/usr/bin/env ruby

require 'stringio'
require 'thread'

class ALU
  def initialize
    reset
  end

  def reset
    @mem = {'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0}
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
    @mem[a] = @mem[a] + value_from_arg(b)
  end

  def mul(a, b)
    @mem[a] = @mem[a] * value_from_arg(b)
  end

  def div(a, b)
    @mem[a] = @mem[a] / value_from_arg(b)
  end

  def mod(a, b)
    @mem[a] = @mem[a] % value_from_arg(b)
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
      #puts "Before inst \"#{instline}\" alu is #{@alu}"
      case instline
        in ["inp", String => a]
          @alu.inp(a)
        in ["add", String => a, String => b]
          @alu.add(a, b)
        in ["mul", String => a, String => b]
          @alu.mul(a, b)
        in ["div", String => a, String => b]
          @alu.div(a, b)
        in ["mod", String => a, String => b]
          @alu.mod(a, b)
        in ["eql", String => a, String => b]
          @alu.eql(a, b)
      else
        raise "Instruction not recongized!"
      end
    end
  end
end


#computer = Computer.new
#program = ARGF.readlines.map {|line| line.chomp.split}

#input0 = StringIO.new([2,].join("\n"))
#input1 = StringIO.new([1, 3].join("\n"))
#input2 = StringIO.new([8].join("\n"))
#computer.execute(program, input2)
#puts computer.state('x')

def monad_search(program, model_no)
  computer = Computer.new
  loop do
    break if model_no.to_s.length < 14
    unless model_no.to_s.include? '0'
      puts "[#{Thread.current.name}] Trying input #{model_no}"
      input = StringIO.new(model_no.to_s.chars.join('\n')+ "abc")
      computer.execute(program, input)
      break if computer.state('z') == 0
    end

    model_no -= 9
  end
  model_no.to_s.length ==14 ? model_no : nil
end

program = ARGF.readlines.map {|line| line.chomp.split}
threads = []
model_no = 99999999999999
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
threads.each {|thr| thr.join}
puts solutions.max