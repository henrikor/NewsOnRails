# -*- encoding : utf-8 -*-
require 'RMagick'

class Article < ActiveRecord::Base
  include NorFelles
  #  is_indexed :fields => ['headline', 'ingress', 'story_text']
  before_destroy :dont_destroy_meta
  has_many :article_groups,
  :dependent => :destroy
  has_many :article_shows,
  :dependent => :destroy
  validates_presence_of :headline, :ingress, :source
  has_paper_trail
#  acts_as_versioned
#  acts_as_versioned :table_name => :article_versions
  #  version_fu

  # Versjonering uten Plugins/Gems:
#  has_many :article_versions
#  before_save :check_for_new_version

  DIRECTORY = 'public/uploaded_images'
  THUMB_MAX_SIZE = [125,125]

  after_save :process
  after_destroy :cleanup

  # Versjonering uten Plugins/Gems:

  def check_for_new_version
    instantiate_revision if create_new_version?
    true # Never halt save
  end

  def instantiate_revision
    new_version = versions.build
    versioned_columns.each do |attribute|
      new_version.__send__ "#{attribute}=", __send__(attribute)
    end
    version_number = new_record? ? 1 : version + 1
    new_version.version = version_number
    self.version = version_number
  end

  def versioned_columns
    %w(article of columns)
  end

  def create_new_version?
    versioned_columns.detect {|a| __send__ "#{a}_changed?"}
  end

  def article_changed?
    return true
  end

  # Versjonering uten Plugins/Gems -- SLUTT:


  # Henrik

  #  def to_param
  #    "#{id}-#{headline}"
  #  end
  #
  def self.find_version(id, versjon)
    find_by_sql(["SELECT * FROM article_versions
      WHERE article_id = ?
      AND version = ?", id, versjon]).first
    end

    def article_id
      id
    end

    def self.index_list
      find(:all,
      :conditions => "un_published != '1'",
      :order     => "created_on desc")

    end
    def self.group_list(groupid)
      find(:all,
      :conditions => ["group_id = ? and un_published != '1'"],
      :order     => "created_on desc")
    end

    #######
    private
    #######



    def self.innholdsliste(article, del_article = 3)
      liste = Array.new

      #    if article =~ /(\<h\d.*?>)(.*)(\<\/h.*?>)/
      #      article = "<h1> TREFF </h1>"
      #      article = article + " \n 1: #{$1} 2: #{$2} 3: #{$3}"
      #    end
      #
      #    article = article.gsub(/\nh(\d)\. (.*?)\n/) {

      #  if article =~ /(\<h\d.*?>)(.*)(\<\/h.*?>)/

      article = article.gsub(/(\<h\d.*?>)(.*)(\<\/h\d>)/) {
        tagstart = $1
        tagslutt = $3
        tekst = $2
        bokmerke = tekst.gsub(/<\w.*?>/,'') #if tekst =~ /<.*?>/
        bokmerke = bokmerke.gsub(/<\/w.*?>/,'') #if tekst =~ /<.*?>/
        # bokmerke = tekst.gsub(/<span.*?>/,'') #if tekst =~ /<.*?>/
        # bokmerke = bokmerke.gsub(/<\/span>/,'') #if tekst =~ /<.*?>/

        otmp = tagstart =~ /\<h(\d).*/
        onr = $1.to_i
        tekst = tekst + NorFelles.errormelding(%{Du har hovedoverskrift ("h1." eller "&lt;h1&gt;" i teksten. Dette er ikke lov i en vanlig artikkel som bruker innholdsliste taggen)}) if onr == 1
        hh = [onr => bokmerke] if bokmerke
        liste << hh
        #      tekst = "\<a name=\"#{$2.strip}\"\>\<\/a\><h#$1\>#{$2}\<\/h#$1\>"

        tekst = "\<a name=\"#{bokmerke}\"\>\<\/a\>#{tagstart} #{tekst} #{tagslutt}"
      }
      #  end   
  #    tekst = "<h1>test</h1>"
      ul = 0
      eul = 0
      article = article.gsub(/\[\[innholdsliste\]\]/) {
        @li = ""
        y = 1
        nr = 0
        liste.each{|x|
          key = x.first.keys.first if x 
          y = 0 if y == nil
          if key && y != nil
            logger.debug "Key = #{key} ---> y = #{y}"
            if key > y
              diff = key - y
              @li = @li.sub(/(<\/li>)$(.*)/, "<ul>#{$2}")
              ul = ul + 1
              if diff > 1
                diff2 = diff - 1
                diff2.times{@li = "#{@li}<ul>"}
                ul = ul +1
              end
              slettet = 1
            elsif key < y
              diff = y - key
              diff.times{@li = "#{@li}</ul></li>"}
              eul = eul + 1
            end
          end
#          @li = "#{@li}<li><a href=\"\##{x.first["#{key}"].strip}\">#{x.first["#{key}"]}</a></li>" if x && x.first["#{key}"] != nil
          @li = "#{@li}<li><a href=\"\##{x.first[key]}\">#{x.first[key]}</a></li>" #if x && x.first["#{key}"] != nil
          y = key
        }
        htmlliste = "<ul>#{@li}</ul>"
        if ul > eul
          htmlliste = "#{htmlliste}</ul>"
        end
      }

      if del_article != 0
        #      article.match(/(\<h1\>.*\<\/h1\>)(\n)(.*)/) #[0]
        #      article = $2
        #      article = article[/.*/, 0]
        #      article = article.scan(/\<h1.*\>.*/)
        #      article = article[2]
        #      article = $2

        #      article2 = ""
        #       article.each("<h1>"){
        #        article2 = "#{article2}treff #{article}"
        #       }
        #      article = article2
        #
        #      return article2
      end

      return article
    end



    def dont_destroy_meta
      fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
      systemarticles = fil['SYSTEMARTICLES']
      raise "Can't destroy article with id: #{self.id}!" if systemarticles.include?(self.id)
    end


    # Slutt Henrik

    #  def file_data=(file_data)
    #    @file_data = file_data
    #    write_attribute 'extension',
    #                    file_data.original_filename.split('.').last.downcase
    #  end

    #  def url
    #    path.sub(/^public/,'')
    #  end

    #  def thumbnail_url
    #    thumbnail_path.sub(/^public/,'')
    #  end

    #  def path
    #    File.join(DIRECTORY, "#{self.id}-full.#{extension}")
    #  end

    #  def thumbnail_path
    #    File.join(DIRECTORY, "#{self.id}-thumb.#{extension}")
    #  end


    def process
      if @file_data
        create_directory
        cleanup
        save_fullsize
        create_thumbnail
        @file_data = nil
      end
      # RSS ping til Twingly:
      yml = noryml
      endpoint_url = "http://rpc.twingly.com/"
      blog_name = yml["ORGANIZATION"]
      blog_url = "http://#{yml["DOMENE"]}"
      begin
        server = XMLRPC::Client.new2(URI.parse(endpoint_url).to_s)

        begin
          result = server.call("weblogUpdates.ping", blog_name,
          blog_url)
        rescue XMLRPC::FaultException => e
          logger.error(e)
        end

      rescue Exception => e
        logger.error(e)
      end
    end

    def save_fullsize
      File.open(path,'w') do |file|
        file.puts @file_data.read
      end
    end

    def create_thumbnail
      img = Magick::Image.read(path).first
      thumbnail = img.thumbnail(*THUMB_MAX_SIZE)
      thumbnail.write thumbnail_path
    end

    def create_directory
      FileUtils.mkdir_p DIRECTORY
    end

    def cleanup
      Dir[File.join(DIRECTORY, "#{self.id}-*")].each do |filename|
        File.unlink(filename) rescue nil
      end
    end


  # Flyttet til start Model
  # def sql_from_only_one_group(temaid = '10', lagid = '8', page = '0')
  #   @sql = "SELECT a.* FROM articles a
  #                       JOIN article_groups ag ON ag.article_id = a.id
  #                       WHERE
  #                       a.un_published != '1' AND
  #                       ag.group_id IN (?, ?)
  #                       GROUP BY a.id
  #                       HAVING COUNT(DISTINCT ag.group_id) = 2"
  #   # sql2 = "SELECT a.id FROM articles a
  #   #                     JOIN article_groups ag ON ag.article_id = a.id
  #   #                     WHERE
  #   #                     a.un_published != '1' AND
  #   #                     ag.group_id IN (?, ?)
  #   #                     GROUP BY a.id
  #   #                     HAVING COUNT(DISTINCT ag.group_id) = 2"
  #   # csql = Article.find_by_sql([sql2, temaid, lagid])
  #   # @count_condition_sql = "SELECT FOUND_ROWS()"
  #   # @article_pages = Paginator.new self, ArticleGroup.count_by_sql(["#{@count_condition_sql}", temaid]), 10, page
  # end

  end
