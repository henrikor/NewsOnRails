# -*- encoding : utf-8 -*-
#---
# Excerpted from "Rails Recipes"
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/fr_rr for more book information.
#---
#require 'rubygems'

#require 'RMagick'
# require 'gcloud/storage'
# require 'highline/import'

#require 'google/api_client'

class Image < ActiveRecord::Base
  
  DIRECTORY = "public/uploaded_images"
  TMPDIRECTORY = "public/tmp_images"
#  DIRECTORY = "#{Rails.root}/public/uploaded_images"
#  TMPDIRECTORY = "#{Rails.root}/public/tmp_images"
  THUMB_MAX_SIZE = '150x75'
  STAND_SIZE = '500'
  after_save :process
#  before_save :process
  after_destroy :cleanup


  PROJECT = ENV["PUBSUB_PROJECT"] || "august-strata-94307"
  KEYFILE = ENV["PUBSUB_KEYFILE"] || "#{Rails.root}/client_secrets.json"

  STORAGE = Gcloud.storage PROJECT, KEYFILE

  def gcloud
    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
    if gcloud = fil['GCLOUD']
      @bucket = find_gcloud_bucket(gcloud)      
      return true
    else
      return false
    end    
  end
  def find_gcloud_bucket(var)
    begin
        bucket = STORAGE.find_bucket var
        if bucket.nil?
          Rails.logger.fatal { "Sorry, but #{bucket_name} does not exist. - Cannot access Google Cloud storage" }
        else
          return bucket
            # bucket.files.each { |file| say file.name }
        end
      rescue Gcloud::Storage::Error => e
        Rails.logger.fatal { "Unable to load bucket #{bucket_name}. Recieved the error: #{e}" }
        return false
    end    
  end


  def gcloud_test
    #avatar_files = bucket.files prefix: "avatars/"
    # Last opp fil
    @bucket.create_file "testfiler/test01.txt", #Fil lokalt
                       "testfiler/test04.txt"         #Her lastes fil opp
    #file = bucket.file "avatars/heidi/400x400.png"
    #file.download "/var/todo-app/avatars/heidi/400x400.png"    
  end
  
  def self.bildetyper
    bildetyper = ["jpg", "gif", "png"]
  end
  
  def bilde?
    bildetyper = Image.bildetyper
    bildetyper.include?(extension)
  end
  
  def file_data=(file_data)
    if file_data && file_data.size > 1
      @file_data = file_data
      write_attribute 'extension',
        file_data.original_filename.split('.').last.downcase
    end
  end
  
  def self.rensurl(path)
    path.sub(/^public/,'')
  end
  
  def url
    Image.rensurl(path)
  end
  
  def thumbnail_url
    thumbnail_path.sub(/^public/,'')
  end
  
  def path
    File.join(DIRECTORY, "#{self.id}-full.#{extension}")
  end
  
  def thumbnail_path
    File.join(DIRECTORY, "#{self.id}-thumb.#{extension}")
  end
  
  def self.full_path(id)
    dbfil = self.find(id)
    File.join(DIRECTORY, "#{id}-full.#{dbfil.extension}")
  end
  
  def self.resized_path(id, size)
    if !File.exists?(TMPDIRECTORY)
      Dir.mkdir(TMPDIRECTORY)
    end
    dbfil = self.find(id)
    File.join(TMPDIRECTORY, "#{id}-#{size}.#{dbfil.extension}")
  end
  
  #######
  
  def self.files_in_dir(current_dir = DIRECTORY)
    if current_dir != DIRECTORY
      current_dir = "#{DIRECTORY}/#{current_dir}"
    end
    dir = Array.new()
#    ls = `ls #{current_dir}`
#    ls.each{ |x|
    Dir.foreach(current_dir){ |x|
      if File.directory?("#{current_dir}/#{x}".strip)
        dir << x
        #        dir.push("#{current_dir}/#{x}")
      end
    }
    return dir
  end
  
  #########
  # For hente url fra image database id
  #########
  def self.image_url(id)
    url = find_by_sql(
      ["SELECT bane FROM images
                          WHERE id = ? ", id])
  end
 
  def self.setsize(sted, maxsize = STAND_SIZE)
    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
    bilder = fil['BILDER']
    raise "Can't find BILDER in yaml file!" if !fil['BILDER']
    
    if maxsize != STAND_SIZE then maxsize = maxsize
    elsif sted == "view" then maxsize = bilder["view"]
    elsif sted == "bilde-li" then maxsize = bilder["bilde-li"]
    elsif sted == "bilde-st" then maxsize = bilder["bilde-st"]
    elsif sted == "temaside" then maxsize = bilder["temaside"]
    elsif sted == "right_column" then maxsize = bilder["right_column"]
    end
    #    return maxsize
  end

  def self.resize(id, sted, maxsize = STAND_SIZE)
    maxsize = setsize(sted, maxsize)
    fil = self.find(id)
    path = full_path(id)
    filepath = resized_path(id, maxsize)
    unless File.exists?(path)
      return "Finner ikke bilde"
    end
    unless File.exists?(filepath)
      img = Magick::Image.read(path).first
      newimg = img.change_geometry!(maxsize) { |cols, rows, img|
        img.resize!(cols, rows)
      }
      newimg.write filepath
    end
    return rensurl(filepath)
  end
  
  #  def self.cropresize(id, maxsize = "standsize")
  def self.cropresize(id, maxsize, posisjon = "senter")
    maxsize = setsize(maxsize) if maxsize == "bilde-li" || maxsize == "bilde-st"
    fil = self.find(id)
    path = full_path(id)
    filepath = resized_path(id, "#{maxsize}-crop-#{posisjon}")
#    filepath = resized_path(id, "#{maxsize}-crop")
    if !File.exists?(filepath)
      begin
        img = Magick::Image.read(path).first
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::CenterGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "senter"
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::NorthGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "nord"
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::SouthGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "sor"
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::WestGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "vest"
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::EastGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "ost"
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::NorthWestGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "nv"
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::NorthEastGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "no"
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::SouthWestGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "sv"
        newimg = img.crop_resized!($1.to_i, $2.to_i, gravity=Magick::SouthEastGravity) if maxsize =~ /(\d*)x(\d*)/ && posisjon == "so"
        newimg.write filepath
      rescue
#        raise "Bilde med id: #{id} finnes ikke"
        return ("Teknisk feil: bilde med id: #{id} mangler. Kontakt systemansvarlig")

      end

    end
    return rensurl(filepath)
  end
  
  #######
  private
  #######
  def process
    if @file_data
      create_directory
      cleanup
      save_fullsize
      if bilde?
        create_thumbnail
      end
      @file_data = nil
    end
  end
  
  def save_fullsize
#    File.open(path,'w') do |file|
#      file.puts @file_data.read
#    end
#    logger.info "\n\n\n\n--------------------------------------------\nHenrik_fil #{@tempfile}\n\n"
#    logger.info "\n\n\n\n--------------------------------------------\nHenrik_fil #{params[:image][:file_data]}\n\n"

    if gcloud?      
      @bucket.create_file @file_data.read, #Fil lokalt
                         path         #Her lastes fil opp
            
    else
      File.open(path, 'wb') do |f|
        f.write(@file_data.read)
          end          
    end
  end
  
  def create_thumbnail
    img = Magick::Image.read(path).first # FEILEN ER: Filen lagres faktisk ikke som jpeg!
    #    thumbnail = img.thumbnail(*THUMB_MAX_SIZE)
    #thumbnail = img.resize_to_fit(*THUMB_MAX_SIZE)
    thumbnail = img.change_geometry!(THUMB_MAX_SIZE) { |cols, rows, img|
      img.resize!(cols, rows)
    }
    thumbnail.write thumbnail_path
  end
  
  def folders_this_dir(current_dir = ".")
    Dir[FileUtils.join(DIRECTORY, current_dir)]
  end
  
  def create_directory
    FileUtils.mkdir_p DIRECTORY
  end
  
  def cleanup
    Dir[File.join(DIRECTORY, "#{self.id}-*")].each do |filename|
      File.unlink(filename) rescue nil
    end
  end
  
end
