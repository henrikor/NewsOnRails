# -*- encoding : utf-8 -*-
#! /usr/bin/ruby
require "erb"
require "find"
require "fileutils"
require 'yaml'
require 'rubygems'
require 'net/smtp'
require 'tmail'
require "/local/lib/daemonize.rb"
require "/local/lib/maillib.rb"
include FileUtils::Verbose
include MailLib

# START DAEMONEN:
class PresseSend < Daemon::Base
  def self.start
    loop do
      massemail
      sleep 30
    end
  end

  def self.stop
    File.open('result', 'w') {|f| f.puts "Slutt"}
  end
end
Pressesend.daemonize


#################################################
# CONFIG:
mailprdomene = 15
pause = 15
#################################################

def noryml
  fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
end

def massemail
  sti = "/var/log/nor/presse/"
  ymlfiler = sti + "presse-.*"

  unless File.exists?(sti)
    puts "Alarm! /var/log/nor/presse finnes ikke!"
  end


  #####################################################
  # START !
  #####################################################

  Find.find(sti) do |files|
    if files =~ /presse-.*\.yml/
      ymlfila = files
      tekstfil = `cat #{ymlfila}`
      nytekst = tekstfil.gsub(/!map:HashWithIndifferentAccess/,"")
      ymlfil = File.open(ymlfila,"w") {|f| f.write(nytekst) }

      ymlfil = File.open(ymlfila,"r")
      yp = YAML::load(ymlfil)
      #    puts "Bruker: #{yp['user']}"

      sortert = Hash.new()
      adresser = yp['adresser']
      subject = yp['temafelt']

      adresser2 = []
      adresser3 = adresser.to_s
      adresser = extract_emails_to_array(adresser3)

      adresser.each {|x|
        next unless x =~ emailreg2
        x = x.chomp
        adresser2 << x
        #      puts "adr: |#{x}|" if is_email?(x)
      }

      adresser2.each {|x|
        next unless x =~ /(.*)@(.*)/
        domene = $2.chomp
        if sortert.has_key?(domene)
          sortert[domene] << x if is_email?(x)
        else
          sortert[domene] = [x] if is_email?(x)
        end
        sortert[domene] = sortert[domene].uniq unless sortert[domene] == nil
      }

      antall = 0
      totalt = 0
      sortert.each{|key, val|
        totalt = totalt + val.size
      }
      while sortert.size > 0
        sortert.each{|key, val|
    
          if val.size < mailprdomene
            val.each{|x|
              antall = antall + 1
              puts "#{key} -- #{x}"
              sortert.delete(key)
            }
    
          else
            nr = 0
            val.each{|x|
              if nr < mailprdomene
                antall = antall + 1
                puts "#{key} -- #{x}"
                val.delete(x)
                nr = nr + 1
                if sortert[key].empty?
                  sortert.delete(key)
                end
              end
            }
          end
        }
        puts "\n\n ----------------- \n\n"
        avsenderm = "Antall sendt er: #{antall} av totalt: #{totalt} \n"
        puts avsenderm
        #          send_email(yp['fra'], yp['fra'], "Rapport paa massesending av e-post", avsenderm) #if is_email?(x.chomp)
        #          sleep pause
      end
      ymlfil.close_read

      # Lag arkivfil:
      subject = subject.gsub(/\s/,"_")
      subject = subject.gsub(/\W/,"X")
      subject =~ /(.{0,35})/
      subject = $1


      t = Time.now
      aar = t.strftime("%Y")
      mnd = t.strftime("%m")
      aarbane = sti + aar + "/"
      arkivbane = aarbane + mnd + "/"
      arkivfil = arkivbane + t.strftime("%Y-%m-%d-%H-%M") + "-" + subject + ".yml"
      mkdir(aarbane) unless File.exists?(aarbane)
      mkdir(arkivbane) unless File.exists?(arkivbane)
      puts arkivfil
      mv(ymlfila, arkivfil)

    end
  end
end
