#!/usr/bin/env ruby
# encoding: utf-8
# Version = '20201125-061006'

# bit operator
# & | ^ ~

# node list
# initial states
nodes = [0,0,0]

# link and operations matrix
# from colum to row, this is simple
# & only
# -1: ~, 
m = [ [-1, 0, 0],
      [1,  0, 0],
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
    nodes[i] = row.each_with_index.inject(1) do |s, pair|
      element, index = pair
      case element
      when 1
        s &= pnodes[index]
      when -1
        s &= ~pnodes[index]
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

print_headers.()
10.times do |t|
  one_step.()
  print_nodes.(t)
end
