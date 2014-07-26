# -*- encoding : utf-8 -*-
class Group < ActiveRecord::Base
  has_and_belongs_to_many :stylesheets

  before_destroy :dont_destroy_meta
  has_many :group_roles,
    :dependent => :destroy
  #           :dependent => true
  has_many :article_groups,
    :dependent => :destroy
  has_many :group_groups,
    :dependent => :destroy


  validates_uniqueness_of :name, :on => :create
  validates_presence_of :name


  private
  def dont_destroy_meta
    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
    systemgroups = fil['SYSTEMGROUPS']
    raise "Can't destroy system group: #{self.name}! Gruppe: #{systemgroups.first}" if systemgroups.include?(self.id)
  end

  def self.groups(id = 1)

    groups = GroupGroup.find(:all,
      :include => [:group],
      :conditions => ["group_groups.group_id2 = '#{id}'"], # System group
      :order => "groups.name")
  end

  def self.temaer(id = 1)
    alt = groups(id)#.map {|u| [u.group_name, u.group_id] }
    ny = Array.new
    alt.each{|x|
      navn = Group.find(x.group_id)
      ny << {label: navn.name, value: navn.id} #unless ny.include(x.group_id2)
    }

    return ny #.map {|elem| elem.map {|k,v| {:name => k, :value => v}}}
  end

  def self.move(fra, til)
    #    Article.Group.find_by_sql(["SELECT * FROM article_groups WHERE group_id = ? AND article_id IN (SELECT article_id from article_groups where group_id = ?)", til, fra]).destroy
    #    slett = find_by_sql(["SELECT id FROM article_groups WHERE group_id = ? AND article_id IN (SELECT article_id from article_groups where group_id = ?)", til, fra])

    tilids = find_by_sql(["SELECT id, article_id FROM article_groups WHERE group_id = ?", til])
    fraids = find_by_sql(["SELECT id, article_id FROM article_groups WHERE group_id = ?", fra])

    begge = Array.new
    tilids.each {|x|
      fraids.each{|y|
        begge << x.id if y["article_id"] == x["article_id"]
      }
    }
    ArticleGroup.destroy(begge)
    sql = "UPDATE article_groups SET group_id = #{til} where group_id = #{fra}"
    ActiveRecord::Base.connection.execute(sql)
    find(fra).destroy

    #    filh = File.open("/tmp/test.sql", "w")
    #    filh << sql
  end

  def perform(jobb)
    ActiveRecord::Base.connection.execute(jobb)
    #    emails.each { |e| NewsletterMailer.deliver_text_to_email(text, e) }
  end

  def self.laggroup?(id)
    laggroup = 4
    #    fil = noryaml
    #    laggroup = fil.select(LAGGROUP)

    group = GroupGroup.find(:all,
      :conditions => ["group_id2 = ?
                       and group_id = ? ", laggroup, id])
    if !group || group.empty?
      return false
    else
      return true
    end
  end


  def self.stylesheets
    stylesheet = Stylesheet.find(:all,
      :order => "name")
  end

  def self.group_from_name(name)
    # group = Group.find(:first,
    #   :conditions => "name = '#{name}'")
    group = Group.where("name = ?", name)

  end

  def self.to_stylesheets(stylesheet, group)
    stylesheets.push_with_attributes(stylesheet, :group_id => group)
  end
end
