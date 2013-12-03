# -*- encoding : utf-8 -*-
class KursController < ApplicationController
  before_filter :felles

  def felles
    @kalendercss = 1
  end
  def index
    redirect_to :action => 'sirkel'
#    redirect_to(:controller => 'start',
#      :lag => 'sentralt-ressurser',
#      :action => 'view',
#      :id => '13423')
  end

  def sirkel
    session[:Fra] = nil if session[:Fra]
    session[:Til] = nil if session[:Til]
    @article = Article.find(13423)
    session[:sirkel] = 1
    session[:Konferanse] = nil if session[:Konferanse]
    @cssblokk = Kurs.felles
  end

  def konferanse
    session[:Fra] = nil if session[:Fra]
    session[:Til] = nil if session[:Til]
    session[:Sirkel] = nil if session[:Sirkel]
    session[:Konferanse] = 1
    @cssblokk = Kurs.felles
  end

  def dager
    inn = request.raw_post || request.query_string

    tilfra = "Til" if inn =~ /til/
    tilfra = "Fra" if inn =~ /fra/

    ndato = inn.gsub(/%20|%2C|til|fra/," ")
    ndato = ndato.gsub(/Mai/,"May")
    ndato = ndato.gsub(/Oktober/,"October")
    ndato = ndato.gsub(/Desember/,"December")
#    ndato = inn
    rtime = Time.parse(ndato)
    @datoer = "#{tilfra} #{rtime}"

    if tilfra == "Fra"
      session[:Fra] = rtime
    end

    if tilfra == "Til"
      session[:Til] = rtime
    end

    if session[:Til] && session[:Fra]
#      @select = [1, 2, 3, 4, 5, 6]
      fra = session[:Fra]
      til = session[:Til]
#      fra = Time.parse(session[:Fra])
#      til = Time.parse(session[:Til])
      diff_sekunder = til - fra
      @dager_totalt = diff_sekunder.ceil/86400 + 1
      @antalldager = [@dager_totalt]
      session[:antalldager] = @dager_totalt
      @select = (1..@dager_totalt).to_a if @dager_totalt
    end
    render(:layout => false)
  end

  def innledninger
    inn = params[:alledager] if params[:alledager]
    inn = request.raw_post || request.query_string || params[:id] unless params[:alledager]
    @inn = inn.to_i
    @vis_innledning = 1 if session[:Konferanse]
  end


end
