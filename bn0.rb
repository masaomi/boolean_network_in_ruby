#!/usr/bin/env ruby
# encoding: utf-8
# Version = '20200228-053723'

# bit operator
# & | ^ ~

nodes = [0,0,0]
mat = []

one_step =->() do
  pnodes = nodes.clone
  nodes[0] = (~pnodes[0]) & 1
  nodes[1] = pnodes[0] & 1
  nodes[2] = pnodes[1] & 1
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
