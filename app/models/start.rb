# -*- encoding : utf-8 -*-
class Start < ActiveRecord::Base
  include NorFelles

  def self.advertisement #In upper right corner
    articles = Article.find(:all,
      :conditions => id = '1',
      :limit => 1)
  end

  def self.topplinker(temaid, lagid)
    if !lagid
      if session[:lagid]
        lagid = session[:lagid]
      else
        lagid = 8
      end
    end
    sql = sql_from_only_one_group(temaid, lagid)
    group_id = 5
    topplinker = Article.find_by_sql(["#{sql}
                                           ORDER BY a.pri desc,
                                           a.created_on desc limit 0,1", #"
        lagid, group_id])
    #@no_paginating = 1
    return topplinker
  end

  def self.bunntekst(temaid, lagid)
    if !lagid
      if session[:lagid]
        lagid = session[:lagid]
      else
        lagid = 8
      end
    end
    sql = sql_from_only_one_group(temaid, lagid)
    group_id = 171
    @articles = Article.find_by_sql(["#{sql}
                                           ORDER BY a.pri desc,
                                           a.created_on desc", #"
        lagid, group_id])
  end

  def self.venstre_meny(temaid, lagid)
    if !lagid
      if session[:lagid]
        lagid = session[:lagid]
      else
        lagid = 8
      end
    end
    sql = sql_from_only_one_group(temaid, lagid)
    group_id = 168
    @articles = Article.find_by_sql(["#{sql}
                                           ORDER BY a.pri desc,
                                           a.created_on desc", #"
        lagid, group_id])
    #    @no_paginating = 1
  end

  def self.sql_from_only_one_group(temaid = '10', lagid = '8', page = '0')
    sql = "SELECT a.* FROM articles a
                        JOIN article_groups ag ON ag.article_id = a.id
                        WHERE
                        a.un_published != '1' AND
                        ag.group_id IN (?, ?)
                        GROUP BY a.id
                        HAVING COUNT(DISTINCT ag.group_id) = 2"
    sql2 = "SELECT a.id FROM articles a
                        JOIN article_groups ag ON ag.article_id = a.id
                        WHERE
                        a.un_published != '1' AND
                        ag.group_id IN (?, ?)
                        GROUP BY a.id
                        HAVING COUNT(DISTINCT ag.group_id) = 2"
    csql = Article.find_by_sql([sql2, temaid, lagid])
    @count_condition_sql = "SELECT FOUND_ROWS()"
    #    @article_pages = Paginator.new self, ArticleGroup.count_by_sql(["#{@count_condition_sql}", temaid]), 10, page
    return sql
  end

end
