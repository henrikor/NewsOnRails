# -*- encoding : utf-8 -*-
class Pressesend < ActionMailer::Base
  Mail.defaults do
    delivery_method :smtp,
    address: "smtp.sendgrid.net",
    port: 2525,
    user_name:            'aktivist01',
    password:             'kA1V9CbdAQjz4lp7XIBo'
  end
  def self.to_iso(tekst)
    #Iconv.conv('ISO-8859-1', 'utf-8', tekst)
    Iconv.conv('utf-8', 'ISO-8859-1', tekst)
  end

  def self.iso_slett_tegn(tekst)
    tekst = tekst.gsub(/”/,"\"")
    tekst = tekst.gsub(/“/,"\"")
    tekst = tekst.gsub(/››/,"»")
    tekst = tekst.gsub(/…/,"...")
    tekst = tekst.gsub(/–/,"-")
    tekst = tekst.gsub(/—/,"-")
    tekst = tekst.gsub(/‘/,"'")
    tekst = tekst.gsub(/’/,"'")
    tekst = tekst.gsub(/‑/,"-")

    #    tekst = Iconv.conv('ISO-8859-1', 'utf-8', tekst)
    #    #@textile = tekst
    #    begin
    #      raise "FEIL, kunne ikke konvertere tekst til ISO-8859-1" if !tekst
    #    rescue
    #      tekst = "FEIL"
    #    end
    #    return tekst
  end

  def self.word_to_isomail(tekst)
    #    tekst = to_iso(tekst)
    tekst = "=?iso-8859-1?#{tekst}?="
    #    tekst = "=?iso-8859-1?Q?#{tekst}?="
  end

  def self.to_isomail(tekst)
    #    if tekst =~ /[æøåÆØÅ]/
    tekst = to_iso(tekst)
    #    tekst = tekst.gsub(/ /, '_') if tekst =~ /[æøåÆØÅ]/
    #    tekst = "=?iso-8859-1?#{tekst}?=" if tekst =~ /[æøåÆØÅ]/
    #    tekst = "=?ISO-8859-1?Q?#{tekst}_?=" if tekst =~ /[æøåÆØÅ]/

    #    tekstarr = tekst.split(/.{30,75}\s/)
    #
    #    tekst = ""
    #
    #    tekstarr.each{|tt|
    #      tt = "=?ISO-8859-1?Q?#{tt}?=" if tt =~ /[æøåÆØÅ]/
    #      tt = tt.gsub(/\s/, '_')
    #      tekst = "#{tekst}\r\s#{tt}"
    #    }
    #    tekst = tekst.gsub(/([æøåÆØÅ].*) /) {
    #      t = $1.gsub(/ /, '_')
    #      t = "=?ISO-8859-1?Q?#{t}?="  } if tekst =~ /[æøåÆØÅ]/

    #    tekstarr = tekst.split
    #    tekst = ""
    #    tekstarr.each{|x|
    #      tekst = "#{tekst} " + word_to_isomail(x)
    #    }

    #    end
    #      if tekst =~ /(.*)(\<.*\>)/
    #        tekst = "=?iso-8859-1?Q? TEST #{$1}?=#{$2}"
    #      else
    #        tekst = "=?iso-8859-1?Q?TEST SUB #{tekst}?="
    #      end
    #      #      tekst = tekst.gsub(/æ/, "=E6")
    #      #      tekst = tekst.gsub(/å/, "=E5")
    #    end
    #   to_iso(tekst)
    return tekst
  end

  def self.testing(tekst)
    return tekst
  end

  def self.send_email(from, to, subject, message)
    # mail(to: to,
    #      body: message,
    #      content_type: "text/html",
    #      subject: subject,
    #      from: from)

    mail = Mail.new do
        from    from
        to      to
        subject subject
        body    message
    end
    mail.deliver
   end
end
