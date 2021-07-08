#!/usr/bin/env ruby
# encoding: utf-8
# Version = '20210708-051622'
# bn3.rb: generalized, random init

N = 3
G = 10
S = rand(1000)
srand(S)
puts "rseed = #{S}"
class Integer
  def to_2(digit)
    ("%0#{digit}d" % self.to_s(2)).split('').map(&:to_i)
  end
end
class String
  def to_10
    self.to_i(2)
  end
end

# bit operator
# & | ^ ~

# node list
# initial states
#nodes = [0,0,0]
init_value = 1
#nodes = Array.new(N){0}
nodes = init_value.to_2(N)
# link and operations matrix
# from colum to row, this is simple
# 1: &
# 2: |
# -: ~, 
#m = [ [-1, 0, 0],
#      [2,  0, 0],
#      [0,  1, 0]
#]
m = Array.new(N){Array.new(N)}
# random init
N.times do |i|
  N.times do |j|
    m[i][j] = 0
  end
end

N.times do |i|
  until m[i].sum != 0
    N.times do |j|
      m[i][j] = rand(5) - 2
    end
  end 
end

# image, column_i=input, row_j=output
#     column i
#         |
# row j <-+
#
# example
# one_step =->() do
#   pnodes = nodes.clone
#   nodes[0] = 1 & (~pnodes[0])
#   nodes[1] = 0 | pnodes[0]
#   nodes[2] = 1 & pnodes[1]
# end

one_step =->() do
  pnodes = nodes.clone
  m.each_with_index do |row, i|
    initial_value = if v0 = row.find{|x| x!=0}
                      case v0.abs
                      when 1
                        1
                      when 2
                        0 
                      end
                    end
    nodes[i] = row.each_with_index.inject(initial_value) do |s, pair|
      element, index = pair
      case element
      when 1
        s &= pnodes[index]
      when -1
        s &= (pnodes[index]+1)%2
      when 2
        s |= pnodes[index]
      when -2
        s |= (pnodes[index]+1)%2
      end
      s
    end
  end
end


print_headers =->() do
  puts "step|nodes (decimal)"
  puts "-"*4 + "+" + "-"*20
end

print_nodes =->(t) do
  puts ("%3d: " % t) + nodes.join(", ") + " (#{nodes.join.to_10})"
end

print_network =->() do
  puts "Boolean function matrix"
  puts Array.new(N){|i| i}.map{|i| "%2d" % i}.unshift("  |").join
  puts "-"*(3*2+3)
  m.each_with_index do |row, i|
    print "%2d|" % i
    puts row.map{|v| "%2d" % v}.join
  end
end

node_boolean_functions = []
print_boolean_functions =-> () do
  m.each_with_index do |row, i|
    initial_value = if v0 = row.find{|x| x!=0}
                      case v0.abs
                      when 1
                        "1"
                      when 2
                        "0" 
                      end
                    end

    node_boolean_functions[i] = row.each_with_index.inject(initial_value) do |s, pair|
      element, index = pair
      case element
      when 1
        s += " & node[#{index}]"
      when -1
        s += " & ~node[#{index}]"
      when 2
        s += " | node[#{index}]"
      when -2
        s += " | ~node[#{index}]"
      end
      s
    end
  end
  node_boolean_functions.each_with_index do |func, i|
    puts "node[%d] = #{func}" % i
  end
end

print_initial_nodes =-> () do
  print "nodes = "
  p nodes
end

# main

puts
puts "init value = #{init_value} (#{init_value.to_2(N).join})"
print_initial_nodes.()
puts
print_network.()
puts
print_boolean_functions.()
puts
print <<EOS
# image, column_i=input, row_j=output
#     column i
#         |
# row j <-+
#
EOS
puts

print_headers.()
G.times do |t|
  print_nodes.(t)
  one_step.()
end
print_nodes.(G)

