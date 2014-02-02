#encoding: utf-8

# -*- encoding : utf-8 -*-
module ApplicationHelper
  require 'mediacloth'
  include NorAuthorize
  include NorFelles

  def coderay(text)
    text.gsub!(/\<code(?: lang="(.+?)")?\>(.+?)\<\/code\>/m) do
      code = CodeRay.scan($2, $1).div(:css => :class)
      "<notextile>#{code}</notextile>"
    end
    return text.html_safe
  end
  def tex2img(name, text, res = "120x120")
    raise 'TeX graphics must have a name' if name.nil?
    return if text.empty?

    FileUtils.mkdir("#{Rails.root}/public/tex2img") unless File.exists?("#{Rails.root}/public/tex2img")
    defaults = "/tex2img"
    path = defaults
    type = "png"
    bg   = "white"
    fg   = "black"

    imgfil = "#{name}.#{type}"
    #    imgfil = "formel-#{rand(0001-9999)}.#{type}"
    # fix color escaping
    fg = fg =~ %r/^[a-zA-Z]+$/ ? fg : "\"#{fg}\""
    bg = bg =~ %r/^[a-zA-Z]+$/ ? bg : "\"#{bg}\""

    # generate the image filename based on the path, graph name, and type
    # of image to generate

    image_fn = "#{defaults}/#{imgfil}"

    # generate the image using convert -- but first ensure that the
    # path exists
    out_dir = "#{Rails.root}/public/tex2img"
    out_file = "#{Rails.root}/public/tex2img/#{imgfil}"

    unless File.exists?(out_file) && (File.mtime(out_file).to_i > @article.updated_on.to_i)
      #    unless File.exists?(out_file)

      tex = "\\nonstopmode\n\\documentclass{article}\n\\usepackage[utf8]{inputenc}\\usepackage[T1]{fontenc}\n\\usepackage{amsmath,amsfonts,amssymb,wasysym,latexsym,marvosym,txfonts}\n\\usepackage[pdftex]{color}\n\\pagestyle{empty}\n\\begin{document}\n\\fontsize{12}{24}\n\\selectfont\n\\color{black}\n\\pagecolor{white}\n\\[\n#{text}\n\\]\n\\end{document}\n"
      tex.gsub!(%r/\n\s+/, "\n")

      # make a temporarty directory to store all the TeX files
      pwd = "#{Rails.root}/public"
      FileUtils.mkdir("#{Rails.root}/public/tex2img_XXXXXX")
      tmpdir = "#{Rails.root}/public/tex2img_XXXXXX"

      begin
        Dir.chdir(tmpdir)
        File.open('out.tex', 'w') {|fd| fd.puts tex}
        dev_null = test(?e, "/dev/null") ? "/dev/null" : "NUL:"

        %x[export SP_ENCODING=XML; pdflatex -interaction=batchmode out.tex &> #{dev_null}]

        convert =  "-density #{res} out.pdf -trim +repage #{out_file}"
        %x[convert #{convert} &> #{dev_null}]
        FileUtils.cp "out.pdf", "#{out_file}.pdf"
      ensure
        Dir.chdir(pwd)
        FileUtils.rm_rf(tmpdir) if File.exists?(tmpdir)
      end

    end

#    out = "<img src=\"#{image_fn}\"/>"
    out = '<img src="#{image_fn}"/>'
    return out
  end

  def hentbilde(idnr, str, imagelink = "nei", crop = 1, plassering = "senter")
    begin
      image = Image.find(idnr)
      raise "Bildet finnes ikke (er det blitt slettet ved en feil?)" if !image
    rescue
      "Bildet finnes ikke (er det blitt slettet ved en feil?)"
    end
    filepath = Image.cropresize(image.id, str, plassering) if crop == 1
    filepath = Image.resize(image.id, "view") if crop != 1
    fullpath = Image.full_path(image.id)
    fullpath = Image.rensurl(fullpath)

    if image.description =~ /\w/
      alttekst = image.description
    else
      alttekst = image.name
    end
#    imagetag = raw("<img alt=\"" + alttekst + "\" src=\"" + filepath + "\" title=\"" + alttekst + "\" />")
    imagetag = raw('<img alt="' + alttekst + '" src="' + filepath + '" title="' + alttekst + '" />')
  end

  def mk_link(article, del, deltxt, link = 0, tag = 0, textile = "j")
    if link == 0 || link =~ /#{del}/
      if article.url && article.url =~ /\w/
        deltxt = %{ <a href="#{article.url}">#{deltxt}</a> }.html_safe
      else
        deltxt = link_to deltxt, :controller => @lag, :action => 'view', :id => article.id
      end
    else
      deltxt = deltxt.strip
    end

    # Hvis tag har html eller bekledningskode, så sett på dette:
    if textile == "j"
      if tag =~ /#{del}:(.*?) \| (.*?),/
        deltxt = textilize($1 + deltxt + $2, article.cloth)
      elsif tag =~ /#{del}:(.*?),/
        deltxt = textilize($1 + deltxt, article.cloth)
      end
    else
      if tag =~ /#{del}:(.*?) \| (.*?),/
        deltxt = $1 + deltxt + $2
      elsif tag =~ /#{del}:(.*?),/
        deltxt = $1 + deltxt
      end
    end
    return deltxt
  end

  def mk_temalinker(article)
    nr = 0
    tekst = %{<div class="temalinker"> <ul>}

    if article.url && article.url =~ /\w/
      link = %{ <a href="#{article.url}">Les mer</a> }
    else
      link = link_to "Les hele saken", :controller => @lag, :action => 'view', :id => article.id
    end


    tekst = tekst + "<li>" + link + "</li>"

    for tema in article.article_groups
      if GroupGroup.hide(tema.group_id) == 1
        next
      end
      nr = nr + 1
      group_name = Group.find_by_sql(["select name from groups where id = ?", tema.group_id])
      if !GroupGroup.lag_gruppe?(tema.group_id)
        tekst2 = link_to group_name.first.name, :controller => 'lag', :action => @action, :id => tema.group_id, :lag => @lag
        tekst = tekst + %{<li class="temalink#{nr}">} + tekst2 + "</li>"
      end
    end

    if authorized_to?(:controller => 'articles', :action => 'edit')
      linktekst = link_to "Edit", :controller => 'articles', :action => 'edit', :id => article.id
      tekst = tekst + "<li>" + linktekst + "</li>"
    end

    tekst = tekst + "</ul></div>"
    return tekst
  end


  def inkluder_articles(tag, article, textile = "j")
    bildeli = "nei"
    bildest = "nei"
    divstyle = "nei"
    divclass = "nei"
    kilde = 1 if tag =~ /kilde/
    headline = 1 if tag =~ /headline/
    url = 1 if tag =~ /url/
    ingress = 1 if tag =~ /ingress/
    story_text = 1 if tag =~ /story_text/
    link = $1 if tag =~ /link=\|(.*)\|/
    link = 0 unless tag =~ /link=\|(.*)\|/

    bildeli = $1 if tag =~ /bilde-li\:(\w*)/
    bildest = $1 if tag =~ /bilde-st\:(\w*)/
    temalinker = 1 if tag =~ /temalinker/
    divclass = $1 if tag =~ /\((.*)\)/
    divstyle = $1 if tag =~ /\{(.*)\}/

    tekst = ""

    if divclass != "nei" && divstyle != "nei"
      tekst = tekst + %{<div class="#{divclass}" style="#{divstyle}">}
    elsif divclass != "nei" && divstyle == "nei"
      tekst = tekst + %{<div class="#{divclass}">}
    elsif divclass == "nei" && divstyle != "nei"
      tekst = tekst + %{<div style="#{divstyle}">}
    end


    tekst = tekst + %{<div class="link-#{@par_odd}">} if @par_odd

    bildeid = nil

    if defined?(bildeli) && bildeli != "nei"
      #      if article.ingress =~ /\[\[bilde-li\:(\w*)/
      if article.ingress =~ /\[\[bilde-li\:(.*)\]\]/
        bildeid = $1
      elsif article.ingress =~ /\[\[image\:(\w*)/
        bildeid = $1
      end
      unless bildeid == nil
        if bildeid =~ /(\d*)\|(\w*)\|/
          bilde = hentbilde($1, bildeli, "nei", 1, $2).html_safe
        else
          bilde = hentbilde(bildeid, bildeli).html_safe
        end

        tekst = tekst + '<div class="inkludert-bilde">' +
          mk_link(article, "bilde", bilde, link) +
          "</div>"
      end
    end

    bildeid = nil

    if defined?(bildest) && bildest != "nei"
      if article.ingress =~ /\[\[bilde-st\:(.*)\]\]/
        bildeid = $1.html_safe
      elsif article.ingress =~ /\[\[image\:(\w*)/
        bildeid = $1.html_safe
      end
      unless bildeid == nil
        #        bilde = hentbilde(bildeid, bildest)
        if bildeid =~ /(\d*)\|(\w*)\|/
          bilde = hentbilde($1, bildest, "nei", 1, $2).html_safe
        else
          bilde = hentbilde(bildeid, bildest).html_safe
        end
        tekst = tekst + "<div class=\"inkludert-bilde\">" +
          mk_link(article, "bilde", bilde, link) +
          "</div>"
      end
    end

    article.ingress = article.ingress.gsub(/\[\[image\:.*\]\]/,"")

    if kilde
      tekst = tekst + "<div class=\"inkludert-kilde\">" +
        text2html(article.source, article.cloth) +
        "</div>"
    end

    if headline
      if textile == "n"
        ntekst = text2html(mk_link(article, "headline", article.headline, link, tag, "n"), "n")
      else
        ntekst = text2html(mk_link(article, "headline", article.headline, link, tag), article.cloth)
      end
      ikkelink = 1
      tekst = tekst + raw(ntekst)
    end
    if url
      tekst = tekst + "<div class=\"inkludert-url\">" + mk_link(article, "url", article.url, link) + "</div>"
    end
    if ingress
      tekst = tekst + "<div class=\"inkludert-ingress\">" +
        text2html(article.ingress, article.cloth, "inkludert", article.id, article.url) +
        "</div>"
    end
    if story_text
      regx = Regexp.new('\<css-include\>(.*)\<\/css-include\>', Regexp::MULTILINE)
      article.story_text = article.story_text.gsub(/#{regx}/, '')

      tekst = tekst + "<div class=\"inkludert-story_text\">" +
        text2html(mk_link(article, "story_text", article.story_text, link), article.cloth, "inkludert", article.id, article.url) +
        "</div>"
    end
    if link =~ /\"(.*)\"/
      linkt = $1
      if article.url =~ /\w/
        ntekst = "<a href=\"" + article.url + "\">" + linkt + "</a>"
      else
        ntekst = link_to linkt, :controller => @lag, :action => 'view', :id => article.id
      end
      tekst = tekst + "<div class=\"inkludert-link\">" + ntekst + "</div>"
    end

    if temalinker == 1
      tekst = tekst + mk_temalinker(article)
    end

    #####################################
    # TIL SLUTT SENDER VI FERDIG TEKST:

    #    tekst = tekst.gsub(/\[\[bilde.*\]\]/,"")
    if @par_odd
      tekst = tekst + "</div>"
    end
    if divclass != "nei" || divstyle != "nei"
      tekst = tekst + "</div>"
    end
    #logger.debug "Problembarn tekst: \n #{tekst} \n\n"
    return tekst

  end

  def tema_tags(tag)
    if tag =~ /lagid=(.*)/ then @lagid = $1.strip.to_i
    end
    if tag =~ /fra=([0-9]*)/ then @fra = $1.strip.to_i
    end
    if tag =~ /antall=([0-9]*)/ then @antall = $1.strip.to_i
    end

    if !@lagid
      @lagid = 10
    end
    if !@fra
      @fra = 0
    end
    if !@antall
      @antall = 1
    end
  end

  ###################################################################################################################

  def text2html(text2, cloth = nil, sted = "temaside", articleid = nil, articleurl = nil)
    if defined?(@article)
      articleid = @article.id if articleid == nil
      articleurl = @article.url if articleurl == nil
      articleurl = nil unless articleurl =~ /\w/
    end


    # Kalender
    #    text2 = text2.html_safe
    #text2 = text2.html_safe
    text2 = text2.gsub(/\[\[kalender:(.*)\]\]/) {
      @kalendercss = 1
      arg = $1
      if arg =~ /navn=\"(.*)\"/
        navn = $1
        calendar_date_select_tag navn, nil, :embedded => true, :year_range => 0.years.ago..1.years.from_now
      elsif arg =~ /arg=\|(.*)\|/
        args = $1
        calendar_date_select_tag args
      end

    }
    #    text2 = text2.gsub(/\[\[kalender\]\]/) {
    #     calendar_date_select_tag "test", nil, :embedded => true, :year_range => 0.years.ago..1.years.from_now
    #calendar_date_select_tag "e_date", nil, :year_range => 10.years.ago..0.years.from_now
    #    }


    # referanser

    refnr = 0
    referanser = Array.new
    refgrupper = Hash.new
    stederref = Hash.new

    # Skjul kommentert tekst
    regx = Regexp.new('\/\*.*?\*\/', Regexp::MULTILINE)
    text2 = text2.gsub(/#{regx}/, '')

    # Fiks referanser (<ref></ref> osv.)
    text2 = text2.gsub(/\<ref(.*?)\>(.*?)\<\/ref\>/) {
      refnr = refnr + 1
      reftekst = $2
      rparam = $1
      if rparam =~ /name=\"(.*)\"/
        if refgrupper.has_key?($1)
          return textilize("h2. %{color:red}EN FEIL OPPSTOD: Referansenavnet: \"#{$1}\" er allerde brukt%")
        end
        refgrupper[$1] = refnr
      end
      #      refgrupper = { $1 => refnr } if reftekst =~ /name=\"(.*)\"/
      if rparam =~ /name=\"(.*)\"/
        referanser << %{<li id="referanse_note-#{$1}_#{refnr}-0"><a href="#referanse_ref-#{$1}_#{refnr}-0" title="">^</a>#{reftekst}</li>}
        %{ <notextile><sup id="referanse_ref-#{$1}_#{refnr}-0" class="referanse"><a href="#referanse_note-#{$1}_#{refnr}-0" title="">[#{refnr}]</a></sup></notextile> }
      else
        referanser << %{<li id="referanse_note-#{refnr}"><a href="#referanse_ref-#{refnr}" title="">^</a>#{reftekst}</li>}
        %{ <notextile><sup id="referanse_ref-#{refnr}" class="referanse"><a href="#referanse_note-#{refnr}" title="">[#{refnr}]</a></sup></notextile> }
      end
    }
    text2 = text2.gsub(/\<ref name=\"(.*)\"\s*\/\>/) {
      refgruppe = $1 # Sluttnotegruppens navn
      unless refgrupper.has_key?($1)
        return textilize("h2. %{color:red}EN FEIL OPPSTOD: Referansenavnet: \"#{$1}\" finnes ikke%")
      end

      if stederref.has_key?(refgruppe)
        antall = stederref[refgruppe]
      else
        antall = 0
      end
      antall = antall + 1  # Løpenummer på antall henvisninger til sluttnote
      stederref[refgruppe] = antall # hash med navn på alle grupper. Verdi er antallet henvisninger til sluttnote
      lrefnr = refgrupper[refgruppe] # sluttnote nr.
      %{ <notextile><sup id="referanse_ref-#{refgruppe}_#{lrefnr}-#{antall}" class="referanse"><a href="#referanse_note-#{refgruppe}_#{lrefnr}-0" title="">[#{lrefnr}]</a></sup></notextile> }
    }

    text2 = text2.gsub(/\{\{reflist\|?(.*)\}\}/) {
      tekst = %{<ol class="references">}
      referanser.each{|x|
        if x =~ /referanse_note-(.*?)_(.*?)-/
          gruppenavn = $1
          gruppenr = $2
          henvisninger = ""
          if refgrupper.has_key?(gruppenavn)
            antall = stederref[gruppenavn]
            i = 1
            unless antall == nil
              while antall >= i
                henvisninger = henvisninger + %{ <a href="#referanse_ref-#{gruppenavn}_#{refgrupper[gruppenavn]}-#{i}" title="">#{roman_num(i)}</a>}
                i = i + 1
              end
            end
            x = x.sub(/\^\<\/a\>/, %{^</a><sup>#{henvisninger}</sup> })
          end
          tekst = tekst + x
        end

      }
      tekst = tekst + "</ol>"
    }

    # WebTeX To HTML
    texnr = 0
    #    text2 = text2.gsub(/\<matte\>(.*)\<\/matte\>/) {

    regx = Regexp.new('\<matte\>(.*?)\<\/matte\>', Regexp::MULTILINE)
    text2 = text2.gsub(/#{regx}/) {
      tex = $1.gsub(/\|str=(.*)/,'')
      if defined?($1)
        str = $1
      else
        str = "120x120"
      end
      texnr = texnr + 1
      tex2img("artikkel-#{@article.id}-#{texnr}", tex, str)
    }

    text = norsk2html(text2)#.sanitize
    # [[:image=id]] konverteres til bilde url.
    text = text.gsub(/\[\[les mer:?(.*)*\]\]/) {
      if sted == "view"
        nil
      else
        if articleid != nil
          if $1
            linktxt = $1
            link_to linktxt, :controller => @lag, :action => 'view', :id => articleid
          else
            link_to "Les mer", :controller => @lag, :action => 'view', :id => articleid
          end
        end
      end
    }

    text = text.gsub(/\[\[image:(.*)\]\]/) {
      begin
        image = Image.find($1.strip)
        raise "Bildet finnes ikke (er det blitt slettet ved en feil?)" if !image
      rescue
        "Bildet finnes ikke (er det blitt slettet ved en feil?)"
      end

      if image
        tags = $1
        if $1 =~ /(\d*)px/
          filepath = Image.resize(image.id, "ikke", $1)
        else
          filepath = Image.resize(image.id, sted)
        end
        fullpath = Image.full_path(image.id)
        fullpath = Image.rensurl(fullpath)
        if image.description =~ /\w/
          alttekst = image.description
        else
          alttekst = image.name
        end

        imagetag = raw("<img alt=\"" + alttekst + "\" src=\"" + filepath + "\" title=\"" + alttekst + "\" />")

        if tags =~ /=/; plassering = "s"
        elsif tags =~ /\>/; plassering = "h"
        elsif tags =~ /\</; plassering = "v"
        end
        imagelinktagstart = "<div class=\"bilde"
        imagelinktagstart = imagelinktagstart + " bilde-#{plassering}" if plassering
        imagelinktagstart = imagelinktagstart + "\"><a href=\"" + fullpath + "\">"

        imagelinktagslutt = "</a></div>"
        if tags =~ /.*nolink.*/
          fullpath = imagetag
        else
          fullpath = imagelinktagstart + imagetag + imagelinktagslutt
        end

      else
        "Bilde er  slettet"
      end
    }

    # Link til seg sjøl
    if text =~ /\[\[hoyrekolonne\]\]/
      @right_column = 1
      text = text.gsub(/\[\[hoyrekolonne\]\]/,'')
    end
    text = text.gsub(/\[\[link:?(.*)*\]\]/) {
      if $1 then
          linkt = $1.gsub(/\"/,"")
      else linkt = "Les mer"
      end
      if  articleurl != nil
        #ntekst = "<a href=\"" + articleurl + "\">" + linkt + "</a>" if articleurl =~ /\w/
        ntekst = '<a href="#{articleurl}_test">#{linkt}</a>' if articleurl =~ /\w/
      elsif articleid != nil
        ntekst = link_to linkt, :controller => @lag, :action => 'view', :id => articleid
      end
      ntekst = "<div class=\"inkludert-link\">" + ntekst + "</div>" if defined?(ntekst) && ntekst != nil

    }
    # Link til artikkel
    # Først hvis [[id]]:
    text = text.gsub(/\[\[(\d+)(.*)\]\]/) {
      id = $1
      tk = $2
      article = Article.find(id)
      if tk =~ /\w/
        linktekst = tk.gsub(/|./, '').strip
      else
        linktekst = article.headline
      end
      #      link = %{ <div class="link-intern">#{ link_to text2html(linktekst, article.cloth), :controller => @lag, :action => 'view', :id => article.id} </div>}
      link = %{ #{ link_to text2html(linktekst, article.cloth), :controller => @lag, :action => 'view', :id => article.id} }
    }

    # Hent ut css blokk
    regx = Regexp.new('\<css-include\>(.*)\<\/css-include\>', Regexp::MULTILINE)
    text = text.gsub(/#{regx}/, '')
    @cssblokk = $1.strip.html_safe if $1

    text = text.gsub(/\[\[article:(.*)\]\]/) {
      tags = $1
      tag = tags.sub(/([0-9]*).*/, $1)
      id = $1.strip
      article = Article.find(id)
      #      link = %{ <div class="link-intern">#{ link_to text2html(article.headline, article.cloth), :controller => @lag, :action => 'view', :id => article.id} </div>}
      link = %{ #{ link_to text2html(article.headline, article.cloth), :controller => @lag, :action => 'view', :id => article.id} }
    }


    # Link til vedlegg
    text = text.gsub(/\[\[vedlegg:([0-9]*)(.*)\]\]/) {
      tags = $2
      id = $1.strip

      begin
        vedlegg = Image.find(id)
        raise "Vedlegget finnes ikke (er det blitt slettet ved en feil?)" if !vedlegg
      rescue
        "Vedlegget finnes ikke (er det blitt slettet ved en feil?)"
      end
      if vedlegg
        if tags =~ /tekst=\|(.*)\|/ then tekst = $1
        else
          tekst = vedlegg.name
        end

        link = %{ <a href="/uploaded_images/#{vedlegg.id.to_s}-full.#{vedlegg.extension}">#{tekst}</a>}
      end
    }

    # Link til temaside
    text = text.gsub(/\[\[tema:(.*)\]\]/) {
      article = Group.find($1.strip)
      link_to text2html(article.name, "r"), :controller => 'lag', :action => @action, :id => article.id, :lag => @lag
    }

    # Hent inn andre artikler
    text = text.gsub(/\[\[article=(.*)\]\]/) {
      article = Article.find($1.strip)
      nytekst = inkluder_articles($1, article)
      #      sendtext = %{<div class="inkluder-alt"><div id="inkluder-artikkel#{article.id}">} + nytekst + %{ </div></div> }
    }

   #######################################
   # Hent inn fra temaer - problembarnet vårt...
   #######################################
    text88 = text
    #text = text.gsub(/\[\[tema=(.*)\]\]/) {
    #  tags = $1.chomp
    #  tema_tags(tags)
    #  tag = $1.sub(/([0-9]*).*/, $1)
    #  tagid = $1.strip
    #  return "test: " + tagid
    #}
=begin
    text = text.gsub(/\[\[tema=(.*)\]\]/) {
      tags = $1.chomp
      tema_tags(tags)
      tag = $1.sub(/([0-9]*).*/, $1)
      tagid = $1.strip
      #      articles = ArticleGroup.articles_from_group(tagid, @lagid, @fra, @antall)
      if tag =~ /, rand/
        articles = ArticleGroup.articles_from_group(tagid, @lagid, @fra, @antall, "rand")
      else
        articles = ArticleGroup.articles_from_group(tagid, @lagid, @fra, @antall)
      end

      test = [%{<div class="inkluder-alt"><div id="inkluder-tema#{tagid}">}]
      #test = ""
      @par_odd = "odd"
      @par_odd += " #{$1}" if tags =~ /class=\"(.*)\"/
      articles.each { |a|
        #        test << inkluder_articles(tags, a, "n")
        test << inkluder_articles(tags, a)
        if @par_odd =~ /^odd/
          @par_odd = "par"
          @par_odd += " #{$1}" if tags =~ /class=\"(.*)\"/
        else
          @par_odd = "odd"
          @par_odd += " #{$1}" if tags =~ /class=\"(.*)\"/
        end
      }

      #      if tags =~ /class=\"(.*)\"/
      #        @par_odd = "#{@par_odd} #{$1}"
      #      end
#      test.each{ |x| x}
    }
    #    text = textilize(text)
    text = text.gsub(/\[\[bilde.*\]\]/,"")

    if cloth == 'ikkecloth'
      text2 = textilize(text, "r").html_safe
    else
      text2 = textilize(text, cloth).html_safe
    end
    #return text88
=end
    #return tags




# Hent inn fra temaer -- fra rails 2.2
      sendtekst = ""

    text = text.gsub(/\[\[tema=(.*)\]\]/) {
      tags = $1.chomp
      tema_tags(tags)
      tag = $1.sub(/([0-9]*).*/, $1)
      tagid = $1.strip
      #      articles = ArticleGroup.articles_from_group(tagid, @lagid, @fra, @antall)
      if tag =~ /, rand/
        articles = ArticleGroup.articles_from_group(tagid, @lagid, @fra, @antall, "rand")
      else
        articles = ArticleGroup.articles_from_group(tagid, @lagid, @fra, @antall)
      end

      #     test = [%{<div class="inkluder-alt"><div id="inkluder-tema#{tagid}">}]
      @par_odd = "odd"
      @par_odd += " #{$1}" if tags =~ /class=\"(.*)\"/
      test = Array.new
      articles.each { |a|
        #        test << inkluder_articles(tags, a, "n")
        #test << inkluder_articles(tags, a)
        test << inkluder_articles(tags, a)
        if @par_odd =~ /^odd/
          @par_odd = "par"
          #@par_odd += " #{$1}" if tags =~ /class=\"(.*)\"/
          @par_odd += $1 if tags =~ /class=\"(.*)\"/
        else
          @par_odd = "odd"
          #@par_odd += " #{$1}" if tags =~ /class=\"(.*)\"/
          @par_odd += $1 if tags =~ /class=\"(.*)\"/
        end
      }

           # if tags =~ /class=\"(.*)\"/
           #   @par_odd = "#{@par_odd} #{$1}"
           # end
      # test.each{ |x| 
      #   sendtekst = sendtekst + x.to_s
      # }
      test.join
     #return sendtekst      

    }




##    text = textilize(text)
    text = text.gsub(/\[\[bilde.*\]\]/,"")
    #text2 = text2.gsub(/\[\"/,"")

    if cloth == 'ikkecloth'
      text2 = textilize(text, "r")
      #      return text
    else
      text2 = textilize(text, cloth)
      #      text
    end
    logger.debug "Problembarn01 tekst: \n #{text2} \n\n"
    return text2
    #text2 = text2.gsub(/\[\"/,"")
    #text2 = text2.gsub(/\"\]/,"")

  end



  ##############################################################
  def name_from_id(id)
    user = Noruser.find(1)
    name = Noruser.login
  end

  def text2a_name(text)
    text = text.gsub(/\s/, '_')
    text = norsk2html(text, "r")
  end

  def markdown(text)
    BlueCloth::new(text).to_html
  end
  def AkpMl(text)
    text = text.gsub(/(\w*?\(m-?l\))/i) {
      t = "<notextile>#{$1}</notextile>"
    }    
  end

  def textilize(text, cloth = "r")
    require_library_or_gem "redcloth" unless Object.const_defined?(:RedCloth)
    if text.blank?
      ""
    else
      if cloth == 'b'
        text2 =  markdown(text)
      elsif cloth == 'r'
        #text = text.gsub(/\<F8\>/, 'XXXXXoXXXXXX')
        text = AkpMl(text)
        r = RedCloth.new(text)
        r.hard_breaks = false
        text2 = r.to_html
        #text2 = text2.gsub(/&#8220;/, '&laquo;')
        #text2 = text2.gsub(/&#8221;/, '&raquo;')
        #text2 = text2.gsub(/name=&#8220;(.*)&#8221;/){
        #  %{name="#{$1}"}
        #}

      elsif cloth == 'm'
        text2 =  MediaCloth::wiki_to_html(text)
      else
        text2 = text
      end
    end
  end # def textilize

  def norsk2html(tekst, cloth = 0)
    #        tekst = tekst.gsub(/ "/, '«')
    #        tekst = tekst.gsub(/"[\s\n\r<]/, '»')

    #    tekst = tekst.gsub(/æ/, 'XXaeXX')
    #    tekst = tekst.gsub(/ø/, 'XXoXX')
    #    tekst = tekst.gsub(/å/, 'XXaXX')
    #
    #    tekst = tekst.gsub(/Æ/, 'XXAEXX')
    #    tekst = tekst.gsub(/Ø/, 'XXOXX;')
    #    tekst = tekst.gsub(/Å/, 'XXAXX')

    #    if cloth == 1
    #      textilize(tekst)
    #    end

    if cloth == 1
      textilize(tekst)
    else
      tekst
    end
  end


end
