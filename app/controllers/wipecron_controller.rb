# -*- encoding : utf-8 -*-
class ArticlesController < ApplicationController
  before_filter :nor_authorized?
  before_filter :left_column

#  cache_sweeper :article_sweeper,
#                :only => [ :create,
#                           :update,
#                           :destroy,
#                           :publish,
#                           :un_publish ]

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

end

