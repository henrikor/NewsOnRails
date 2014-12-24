# -*- encoding : utf-8 -*-
class Pressesend < ActionMailer::Base
  
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
    # fil = "#{Rails.root/log/mail}"
    # File.open(fil, 'w') {|f| f.write(message) }
    # `mutt -s "#{subject}" -c #{to} < #{fil}`

    mail = Mail.new do
        from    from
        to      to
        subject subject
        body    message
    # to = to
    # from = to_isomail(from)
    # #    from = from
    # subject = to_iso(subject)
    # subject = to_isomail(subject)
    # body = message

#    date = Time.now

#    mime_version = '1.0'

 #   set_content_type 'text', 'plain', {'charset'=>'iso-8859-1'}

    # msg = mail.to_s

    # Net::SMTP.start('localhost') do |smtp|
    #   smtp.send_message msg, from, to
    end 
#    mail.delivery_method :sendmail 
#    mail.delivery_method :sendmail, :location => "/usr/sbin/sendmail -t -i"
    mail.delivery_method :smtp, address: "127.0.0.1", port: 25, :openssl_verify_mode  => 'none'
#    mail.delivery_method :smtp, address: "mx.node3301.gplhost.com", port: 25
#    mail.delivery_method :smtp, address: "localhost", port: 25
    mail.deliver
#    Mail.defaults do
#      delivery_method :smtp, address: "127.0.0.1", port: 25
#    end

   end
  
end
