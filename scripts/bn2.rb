#!/usr/bin/env ruby
# encoding: utf-8
# Version = '20210707-150457'

# bit operator
# & | ^ ~

# node list
# initial states
nodes = [0,0,0]

# link and operations matrix
# from colum to row, this is simple
# 1: &
# 2: |
# -: ~, 
m = [ [-1, 0, 0],
      [2,  0, 0],
      [0,  1, 0]
]
# example
# one_step =->() do
#   pnodes = nodes.clone
#   nodes[0] = (~pnodes[0]) & 1
#   nodes[1] = pnodes[0] & 1
#   nodes[2] = pnodes[1] & 1
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
        s &= ~pnodes[index]
      when 2
        s |= pnodes[index]
      when -2
        s |= ~pnodes[index]
      end
      s
    end
  end
end


print_headers =->() do
  puts "step|nodes"
  puts "-"*4 + "+" + "-"*20
end

print_nodes =->(t) do
  puts ("%3d: " % t) + nodes.join(", ")
end

print_network =->() do
  puts "Boolean function matrix"
  puts Array.new(3){|i| i}.map{|i| "%2d" % i}.unshift("  |").join
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


puts
print_initial_nodes.()
puts
print_network.()
puts
print_boolean_functions.()
puts

print_headers.()
10.times do |t|
  print_nodes.(t)
  one_step.()
end
print_nodes.(10)
