#! /usr/bin/ruby
# -*- coding: utf-8 -*-
require "fileutils"
require "iconv"

db="nor_rku2"

dbiso=db+"-latin.sql"
dbutf=db+"-utf8.sql"
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
tekst = tekst.gsub(/”/,"\"")
tekst = tekst.gsub(/“/,"\"")
#tekst = tekst.gsub(/››/,"»")
tekst = tekst.gsub(/…/,"...")
tekst = tekst.gsub(/–/,"-")
tekst = tekst.gsub(/—/,"-")
#tekst = tekst.gsub(/‘/,"'")
#tekst = tekst.gsub(/’/,"'")
tekst = tekst.gsub(/‑/,"-")

tekst = tekst.gsub(/Å/,"\&Aring;")
tekst = tekst.gsub(/Ø/,"\&Oslash;")
tekst = tekst.gsub(/Ö/,"\&Ouml;")
tekst = tekst.gsub(/Æ/,"\&AElig;")

tekst = tekst.gsub(/CHARSET=latin1/,"CHARSET=utf8")
tekst = Iconv.conv('utf-8', 'ISO-8859-1', tekst)

#tekst = tekst.gsub(/\&Aring;/,"Å")
#tekst = tekst.gsub(/\&Oslash;/,"Ø")
#tekst = tekst.gsub(/\&AElig;/,"Æ")

#fil2 = File.open(dbiso,"w") {|f| f.write(tekst) }
fil2 = File.open(dbutf,"w") {|f| f.write(tekst) }

#`perl -pi -w -e 's/Å/\&Aring;/g;' #{dbiso}`
#`perl -pi -w -e 's/Ø/\&Oslash;/g;' #{dbiso}`
#`perl -pi -w -e 's/Æ/\&AElig;/g;' #{dbiso}`
#
#`perl -pi -w -e 's/”/\"/g;' #{dbiso}`
#`perl -pi -w -e 's/“/\"/g;' #{dbiso}`
#
#`perl -pi -w -e 's/…/.../g;' #{dbiso}`
#`perl -pi -w -e 's/–/-/g;' #{dbiso}`
#`perl -pi -w -e 's/—/-/g;' #{dbiso}`
##`perl -pi -w -e "s/‘/'/g;" #{dbiso}`
##`perl -pi -w -e "s/’/'/g;" #{dbiso}`
#`perl -pi -w -e 's/‑/-/g;' #{dbiso}`

#`iconv -f ISO_8859-1 -t UTF-8 #{dbiso} > #{dbutf}`

#`perl -pi -w -e 's/CHARSET=latin1/CHARSET=utf8/g;' #{dbutf}`
#`perl -pi -w -e 's/---oe--/Ø/g;' #{dbutf}`

`mysql -u root -p < #{dbutf}`


