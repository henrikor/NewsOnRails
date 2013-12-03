# -*- encoding : utf-8 -*-
require 'minty_rails'

ActionController::Base.send :include, MintyRails::MintCode
ActionController::Base.send :after_filter, :add_mint_code
