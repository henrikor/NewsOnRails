# -*- encoding : utf-8 -*-
require 'version_fu'
ActiveRecord::Base.class_eval { include VersionFu }
