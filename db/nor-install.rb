# -*- encoding : utf-8 -*-
#!/usr/bin/ruby
require "mysql"
require 'rubygems'
require 'highline/import'
require 'fileutils'
include FileUtils::Verbose


def get_password(prompt="Enter Password")
  ask(prompt) {|q| q.echo = false}
end

puts "\nBruker - (h)enrik / (s)os: "
bruker = gets.chomp
bruker = "henrik" if bruker == "h"
bruker = "sos" if bruker == "s"

puts "\nDomenenavn: "
dget = gets.chomp

if dget =~ /(\w*?)\.(\w*?)\.(\w*)/
  www = $1
  domene = $2
  no = $3
elsif dget =~ /(\w*?)\.(\w*)/
  www = "www"
  domene = $1
  no = $2
  puts "Kort domenebetegnelse. Tolket til: www.#{domene}.#{no} \n\n"
else
  puts "Domenet: #{dget} godtas ikke: form: www.domene.no e.l. Scriptet dør"
  exit 1
end

######## KONFIG ##########
dbpass = `apg -M NLC -n 1 -m8 -x 8`
docroot = "/var/www/sites/#{bruker}/#{domene}.#{no}/subdomains/#{www}/trunk"
###########################

mkdir_p docroot unless File.exists?(docroot)

puts "\nMysql passord (for root): "
mysqlpass = get_password()
#mysqlpass = gets.chomp

begin
  # connect to the MySQL server
  dbh = Mysql.real_connect("localhost", "root", mysqlpass, "nor_mal")
  # get server version string and display it
  puts "Server version: " + dbh.get_server_info
rescue Mysql::Error => e
  puts "Feilmelding: #{e.errno}"
  puts "Error message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  # disconnect from server
  dbh.close if dbh
end



db = domene.gsub(/\..*/,'')
dbuser = db[0..15] unless db[0..15] == nil

puts "Domenenavn (forslag \"#{db}\" - trykk enter eller \"j\", eller skriv eget forslag :"
svar = gets.chomp
unless svar == "j" || svar == "J"
  db = svar if svar =~ /\w/
end

puts "Oppretter databasen #{db}. Vennligst vent.\n"
`mysqladmin -u root -p#{mysqlpass} create #{db}`
`mysqldump -u root -p#{mysqlpass} --opt nor_mal | mysql -u root -p#{mysqlpass} #{db}`

begin
  # Lag databasebruker:
  dbh = Mysql.real_connect("localhost", "root", mysqlpass, db)
  sql = dbh.query("GRANT ALL PRIVILEGES ON #{db}.* TO '#{dbuser}'@'localhost' IDENTIFIED BY '#{dbpass}'")
end

dbyml = "development:
  adapter: mysql
  database: #{db}
  username: #{dbuser}
  password: #{dbpass}
  socket: /var/run/mysqld/mysqld.sock
"

# Kopier over mal filer:

files = Dir.glob("/var/nor/nor2.2.prod/trunk/*")
files.each { |x|
  cp_r x, docroot unless x =~ /app/ || x =~ /lib/ || x =~ /vendor/
}
ln_s "/var/nor/nor2.2.prod/trunk/app", docroot
ln_s "/var/nor/nor2.2.prod/trunk/lib", docroot
ln_s "/var/nor/nor2.2.prod/trunk/vendor", docroot

dbymlfil = File.open("#{docroot}/config/database.yml", "w+")
dbymlfil.puts dbyml
