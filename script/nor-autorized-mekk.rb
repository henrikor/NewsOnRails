# -*- encoding : utf-8 -*-
#! /usr/bin/ruby
require "erb"
require "find"
require "fileutils"
require 'yaml'
include FileUtils::Verbose

if File.exists?('config/autorized.yml')
  t = Time.now
  nyfiltmp = "config/autorized.yml.bak.#{t.strftime("%m-%d-%Y")}"
  if File.exists?(nyfiltmp)
    nyfil = nyfiltmp + "-2"
  else
    nyfil = nyfiltmp
  end
  FileUtils.cp "config/autorized.yml", nyfil
end

YMLFIL = "config/autorized.yml"
ymlfil = File.open(YMLFIL)
@yp = YAML::load(ymlfil)
@nyyp = @yp


Find.find("app/controllers") do |files|
  if files =~ /\/.svn/
    Find.prune
  end  
  if File.file?(files)
    files =~ /(.*)\.rb/
    File.open(files) do |file|
      while line = file.gets
        if line =~ /class (\w*)/  # CONTROLLER
          controller = $1
          while line2 = file.gets
            if line2 =~ /def (\w*)/ # ACTION
              action = $1                
              # STARTER MED Å MEKKE YML                
              if !@nyyp.include?(controller)  
                @nyyp[controller] = {action => nil}  # Controller er i yml, men ikke action. Legg til action
              elsif !@nyyp[controller].include?(action)
                @nyyp[controller][action] = nil
              end
            end              
          end
        end
      end        
    end
  end    
end


#puts YAML::dump(@nyyp)
ymlfil_ny = File.open(YMLFIL, "w+")
ymlfil_ny << YAML::dump(@nyyp)
