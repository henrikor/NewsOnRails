# -*- encoding : utf-8 -*-
class GroupGroup < ActiveRecord::Base
  belongs_to :group
#  has_many :groups,
#           :dependent => :destroy
  validates_uniqueness_of :group_id, :scope => "group_id2"

  def name
    group.name
  end

  def self.hide(groupid) # Er gruppen i "hide" gruppen?
    links = find(:all,
         :conditions => ["group_id = '?' and
                          group_id2 = '30'",groupid])
    if links[0]
      result = 1
    end
  end

  def self.temaer
        find(:all,
      :include => [:group],
      :conditions => [ "group_groups.group_id2 = '2' and LOWER(groups.name) LIKE ?",
        '%' + value.downcase + '%'],
      :order => 'groups.name ASC',
      :limit => 8)
  end

  def self.lag_gruppe?(groupid) # Er gruppen i "lag" gruppen?
    links = find(:all,
         :conditions => ["group_id = '?' and
                          group_id2 = '4'",groupid])
    if links[0]
      result = 1
    end
  end

  def self.auth_lags(user) # Finn alle laggrupper hvor en av brukers roller er medlem.
    sql = find_by_sql(["SELECT DISTINCT gt.* FROM group_groups gt # Distinct for kun unike treff
                        JOIN groups g ON g.id = gt.group_id
                        JOIN group_roles gr ON g.id = gr.group_id
                        JOIN norusers_roles ur ON gr.role_id = ur.role_id
                        WHERE
                        gt.group_id2 = 4 # lag group. Ikke tull med denne
                        AND
                        gr.role_id IN (SELECT role_id FROM norusers_roles WHERE noruser_id = ?)", user])
                       # Role writer_stab

  end

end
