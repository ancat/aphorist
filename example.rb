require 'treetop'
require_relative 'aphorism_node_classes'
require_relative 'aphorism'
require_relative 'aphorist'

aph = Aphorist.new(default: {
x: 1,
name: "OMAR",
request: "/api/login"
})

puts aph.eval(rule: ARGV[0]).inspect
