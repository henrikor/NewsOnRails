# -*- encoding : utf-8 -*-
#! /usr/bin/ruby

if ARGV.empty?
  puts "\n"
  puts "-----------------------------------------------------------"
  puts "Scriptet krever bane. \n"
  puts "-----------------------------------------------------------"

end

bane = ARGV.first

txtfil = "/tmp/slettnorske"
fil = File.open(txtfil, "r")
treff = "nei"

while txt = fil.gets
  #  if txt.inspect =~ /\\346/i
  if treff == 0
    treff = "treff"
    #     puts "Traff"
    #  else
    #    puts "null treff \n"
    #    puts txt
  end
end
puts treff
