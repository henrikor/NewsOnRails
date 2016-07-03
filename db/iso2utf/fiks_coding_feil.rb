#! /usr/bin/ruby
# -*- coding: utf-8 -*-
require "fileutils"
require "iconv"

db="nor_rku2"

dbiso=db+"-feil.sql"
dbutf=db+"-rett.sql"
dbisobak = dbiso+".bak"

if File.exists?(dbisobak)
  FileUtils.cp(dbisobak, dbiso)
else
  `echo "DROP DATABASE IF EXISTS #{db};" > #{dbiso}`
  `echo "CREATE DATABASE #{db};" >> #{dbiso}`
  `echo "USE #{db};" >> #{dbiso}`
  `mysqldump -u root -p --add-drop-table #{db} >> #{dbiso}`
  `cp #{dbiso} #{dbisobak}`
end

fil = File.open(dbiso,"r")

tekst = fil.read


tekst = tekst.gsub(/Ã¥/,"å")
tekst = tekst.gsub(/Ã¸/,"ø")
tekst = tekst.gsub(/Ã¦/,"æ")

tekst = tekst.gsub(/Ã…/,"Å")
tekst = tekst.gsub(/Ã˜/,"Ø")
tekst = tekst.gsub(/Ã†/,"Æ")

tekst = tekst.gsub(/â€“/,"-")

tekst = tekst.gsub(/Â«/,"\"")
tekst = tekst.gsub(/Â»/,"\"")


fil2 = File.open(dbutf,"w") {|f| f.write(tekst) }



`mysql -u root -p < #{dbutf}`


