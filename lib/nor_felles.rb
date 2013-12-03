# -*- encoding : utf-8 -*-
#-*- encoding : utf-8 -*-
module NorFelles

  def self.mnd_navn_to_nr(mnd)
    begin
      case mnd.downcase
      when "januar"; "01"
      when "februar"; "02"
      when "mars"; "03"
      when "april"; "04"
      when "mai"; "05"
      when "juni"; "06"
      when "juli"; "07"
      when "august"; "08"
      when "september"; "09"
      when "oktober"; "10"
      when "november"; "11"
      when "desember"; "12"
      else "XX"
      end
    rescue
      Rails.logger.error("\n NOR-- Kjorer SFP-PROGRAM metoden \n")
      return "XX"
    end
  end

  def self.errormelding(tekst)
    tekst2 = %{h2. %{color:red}EN FEIL OPPSTOD: #{tekst}%}
    #    tekst2 = %{h2. EN FEIL OPPSTOD: #{tekst}}
    r = RedCloth.new(tekst2)
    r.hard_breaks = false
    tekst2 = r.to_html
  end

  def is_email?(tekst)
    return true if tekst =~ emailreg
  end

  def emailreg
    emailre = rfc822
  end

  def emailreg2
    #    reg = /[\w._%-]+@[\w.-]+.[a-zA-Z]{2,4}/
    reg = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  end

  def to_iso(txt)
    Iconv.conv('ISO-8859-1', 'utf-8', txt)
  end

  def to_utf(txt)
    Iconv.conv('utf-8', 'ISO-8859-1', txt)
  end

  def roman_num(number)
    set1 = [ 1, 5, 10, 50, 100, 500, 1000 ]
    set2 = [ 'I', 'V', 'X', 'L', 'C', 'D', 'M' ]
    numeral = []
    while number > 0
      if (number/(set1.last)) >= 1
        roman = (number/(set1.last))
        numeral.push((set2.pop)*roman)
        number = (number%(set1.pop))
      else
        set2.pop
        set1.pop
      end
    end
    #    puts 'Old Roman Numeral is ' + numeral.join + '.'
    return numeral.join
  end

  def slettnorske(txt) # Denne metoden brukes ikke pt.
    if txt.inspect =~ /\\346(.*)/
      txt2 = $1.gsub(/\"/,"")
      txt2 = txt2.gsub(/\s/,"")
    else
      txt2 = txt
    end
    return txt2
  end

  def slettnorskeslett(txt) # Denne metoden brukes ikke pt.
    #    utftxt = to_utf(txt)

    txtfil = "/tmp/slettnorske-#{noruser.login}-#{Time.now.to_a}"
    txtfil = "/tmp/slettnorske"
    fil_ny = File.open(txtfil, "w+")
    fil_ny << txt

    fil_ny.close
    #    norsk2 = `/usr/bin/ruby -ne 'puts "TREFF" if $_ =~ /[æøå]/i' #{txtfil}`
    #    norsk2 = `#{Rails.root}/script/chck_encoding.rb #{txtfil}`

    #    if norsk2 =~ /TREFF/
    #    norsk2 = `#{Rails.root}/script/chck_encoding.rb #{txtfil}`

    txt2 = `/usr/bin/ruby -pe 'gsub(/[æøå]/i,"XXX")' #{txtfil}`

    #    unless txt2 =~ /#{emailreg2}/
    #      flash[:notice] = "Ruby sok og erstatt funka ikke"
    #      txt2 = txt
    #    end

    #    if norsk2 =~ /nei/
    #      #    if txt.inspect =~ /p/
    #      flash[:notice] = "Traff kjører søk og erstatt"
    #      txt2 = `/usr/bin/ruby -pe 'gsub(/[æøå]/i,"XXX")' #{txtfil}`
    #    else
    #      flash[:notice] = "IKKE søk og erstatt: #{txt.inspect}"
    #      txt2 = txt
    #    end
    return txt2
  end

  def extract_emails_to_array(txt)
    #    txt2 = slettnorske(txt)
    #    txtfil = "/tmp/emails-#{noruser.login}-#{Time.now.to_a}"
    #    fil_ny = File.open(txtfil, "w+")
    #    fil_ny << txt
    #
    reg = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
    sendarr = []
    #    txt2 = `/usr/bin/perl -wne'while(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/ig){print "$&\n"}' #{txtfil}`
    #    arr = txt.scan(reg).uniq

    #    arr2 = []
    #    txt.each{|x|
    #      arr2 << slettnorske(x)
    #    }
    arr = txt.scan(emailreg2).uniq
    #    arr = arr2.uniq
    arr.each{|s| sendarr << s.to_s+"\n" }
    return sendarr
  end

  def rfc822
    #    EmailAddress = begin
    begin
      qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
      dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
      atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
        '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
      quoted_pair = '\\x5c[\\x00-\\x7f]'
      domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
      quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
      domain_ref = atom
      sub_domain = "(?:#{domain_ref}|#{domain_literal})"
      word = "(?:#{atom}|#{quoted_string})"
      domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
      local_part = "#{word}(?:\\x2e#{word})*"
      addr_spec = "#{local_part}\\x40#{domain}"
      pattern = /\A#{addr_spec}\z/
    end
  end

  def noryml
    fil = YAML::load( File.open( "#{Rails.root}/config/nor.yml") )
  end

end
