# -*- encoding : utf-8 -*-
class ArticleGroup < ActiveRecord::Base
  #  before_destroy :dont_destroy_meta
  belongs_to :group
  belongs_to :article
  validates_uniqueness_of :article_id, :scope => "group_id"


  def dont_destroy_meta
    fil = noryaml
    systemgroups = fil.select(SYSTEMGROUPS)
    raise "Can't destroy system group: #{self.name}!" if systemgroups.include?(self.id)
    exit!
  end

  def headline
    article.headline
  end
  def ingress
    article.ingress
  end
  def url
    article.url
  end
  def story_text
    article.story_text
  end
  def article_groups
    article.article_groups
  end
  def article_id
    article.id
  end
  def group_name
    group.name
  end
  def self.links(groupid)
    links = find(:all,
      :include => [:group],
      :conditions => ["article_groups.group_id = '?'
        ",groupid]).map {|u| [u.group.name] }

    link = links.first
    #    links = find_by_sql(["select * from article_groups, groups
    #                        where article_groups.group_id = '?'",groupid])
    #.map {|u| [u.group.name] }
    # and
    #                        groups.id != '30'


  end
  def self.articles_from_group(temaid = '10', lagid = '8', fra = '0', til = '1', rand = 'n')

    sql = "
                        SELECT a.* FROM articles a
                        JOIN article_groups ag ON ag.article_id = a.id
                        WHERE
                        a.un_published != '1' AND
                        ag.group_id IN (?, ?)
                        GROUP BY a.id
                        HAVING COUNT(DISTINCT ag.group_id) = 2"

    if rand == 'n'
      sql = sql + "
                        ORDER BY a.pri desc,
                        a.created_on desc limit ?, ? "
      articles = Article.find_by_sql(["#{sql}",
          temaid, lagid, fra, til])


    elsif rand == 'rand'
      sql = sql + "
                        ORDER BY RAND(NOW()) LIMIT ?, ? "
      articles = Article.find_by_sql(["#{sql}",
          temaid, lagid, fra, til])
    end
    
  end
end
