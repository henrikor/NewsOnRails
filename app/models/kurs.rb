# -*- encoding : utf-8 -*-
class Kurs < ActiveRecord::Base

  def self.sfp_program(argumenter)
    Rails.logger.error("\n NOR-- Kjorer SFP-PROGRAM metoden \n")


    t = Time.now
    arkivbane = sfpdir + faar + "/" + tilmnd + "/"
    nyfil = arkivbane + tildag + "_" + navn + "_" + laerer + "_" + t.strftime("%Y-%m-%d-%H-%M-%S") + "PROGRAM" + ".odt"
    FileUtils.mkdir_p(arkivbane) unless File.exists?(arkivbane)
    FileUtils.mkdir_p(sfptmpdir) unless File.exists?(sfptmpdir)
    FileUtils.cp(malfil, nyfil)

    Zip::ZipFile.open(nyfil, Zip::ZipFile::CREATE) {
      |zipfile|
      tekst = zipfile.read("content.xml")
      zipfile.remove("content.xml")
      zipfile.get_output_stream("content.xml") { |f| f.puts tekst }
    }
    FileUtils.chmod(0770, nyfil)
    FileUtils.cp(nyfil, sfptmpdir)
    FileUtils.chmod_R(0770, sfpdir)
  end

  def self.sfp(argumenter)
    Rails.logger.error("\n NOR-- Kjorer SFP methoden \n")

    konferanse = 1 if argumenter["001studieplan"] =~ /\/08030/

    antalldager = argumenter["antalldager"]["first"]

    if konferanse
      timertotalt = 11 * antalldager.to_i - 9
      malfil = "#{Rails.root}/nor/sfp/sfp-mal-m-program.odt"
      antalldager = argumenter["antalldager"]["first"]
      timertotalt = 11 * antalldager.to_i - 9
      timergruppe = timertotalt - antalldager.to_i

      #      dag1 = %{Dag 1</text:p><text:p text:style-name="P11">16.00: Innsjekking</text:p><text:p text:style-name="P11">17.00: Felles samling for alle gruppene - gjennomgang av konferansen </text:p><text:p text:style-name="P11">18:00 Innledning i gruppa: --innledn--</text:p><text:p text:style-name="P11">19.00: <text:span text:style-name="T6">Gruppediskusjon</text:span><text:span text:style-name="T2">/ spørsmål</text:span></text:p><text:p text:style-name="P11">21.00: Mat</text:p><text:p text:style-name="P14">22.30: Sosialt</text:p><text:p text:style-name="P14"/><text:p text:style-name="P16">Antall studietimer i gruppa: 3</text:p><text:p text:style-name="P16">Antall studietimer felles: 1</text:p><text:list xml:id="list1320942645" text:style-name="WW8Num1"><text:list-header><text:p text:style-name="P18"/></text:list-header></text:list><text:p text:style-name="P15">}
      dag1 = %{Dag 1</text:p><text:p text:style-name="P37">16.00: Innsjekking</text:p><text:p text:style-name="P37">17.00: Felles samling for alle gruppene - gjennomgang av konferansen </text:p><text:p text:style-name="P37">18:00 Innledning i gruppa: --innledn--</text:p><text:p text:style-name="P37">19.00: <text:span text:style-name="T31">Gruppediskusjon</text:span><text:span text:style-name="T32">/ spørsmål</text:span></text:p><text:p text:style-name="P37">21.00: Mat</text:p><text:p text:style-name="P40">22.30: Sosialt</text:p><text:p text:style-name="P40"/><text:p text:style-name="P41">Antall studietimer i gruppa: 3</text:p><text:p text:style-name="P41">Antall studietimer felles: 1</text:p><text:list xml:id="list586036146" text:style-name="WW8Num1"><text:list-header><text:p text:style-name="P48"/></text:list-header></text:list><text:p text:style-name="P42">}
      #      dagvanlig = %{Dag --dagvanlig--</text:p><text:p text:style-name="P11">08.00: Frokost</text:p><text:p text:style-name="P11">09.00: Fellestime - hvilke fase er vi i nå? - Vi deler erfaringer</text:p><text:p text:style-name="P11">10:00: Innledning i gruppa: --innledn--</text:p><text:p text:style-name="P11">12.00: <text:span text:style-name="T2">Gruppediskusjon/ spørsmål</text:span></text:p><text:p text:style-name="P11">13.00 Lunsj</text:p><text:p text:style-name="P12"><text:span text:style-name="T5">14.00: Grupped</text:span><text:span text:style-name="T3">iskusjon</text:span><text:span text:style-name="T4">en fortsetter</text:span><text:span text:style-name="T3"> </text:span></text:p><text:p text:style-name="P11">18.00: Middag</text:p><text:p text:style-name="P11">19.00: Grupped<text:span text:style-name="T2">iskusjonen/ oppsumering</text:span></text:p><text:p text:style-name="P11">21.00: Gruppene: oppsummering av dagen</text:p><text:p text:style-name="P11">22.00: Sosialt</text:p><text:p text:style-name="P14"/><text:p text:style-name="P16">Antall studietimer i gruppa: 10</text:p><text:p text:style-name="P16">Antall studietimer felles: 1</text:p><text:p text:style-name="P14"/><text:p text:style-name="P15">}
      dagvanlig = %{Dag --dagvanlig--</text:p><text:p text:style-name="P37">08.00: Frokost</text:p><text:p text:style-name="P37">09.00: Fellestime - hvilke fase er vi i nå? - Vi deler erfaringer</text:p><text:p text:style-name="P37">10:00: Innledning i gruppa: --innledn--</text:p><text:p text:style-name="P37">12.00: <text:span text:style-name="T32">Gruppediskusjon/ spørsmål</text:span></text:p><text:p text:style-name="P37">13.00 Lunsj</text:p><text:p text:style-name="P39"><text:span text:style-name="T25">14.00: Grupped</text:span><text:span text:style-name="T27">iskusjon</text:span><text:span text:style-name="T28">en fortsetter</text:span><text:span text:style-name="T27"> </text:span></text:p><text:p text:style-name="P37">18.00: Middag</text:p><text:p text:style-name="P37">19.00: Grupped<text:span text:style-name="T32">iskusjonen/ oppsumering</text:span></text:p><text:p text:style-name="P37">21.00: Gruppene: oppsummering av dagen</text:p><text:p text:style-name="P37">22.00: Sosialt</text:p><text:p text:style-name="P40"/><text:p text:style-name="P41">Antall studietimer i gruppa: 10</text:p><text:p text:style-name="P41">Antall studietimer felles: 1</text:p><text:p text:style-name="P40"/><text:p text:style-name="P42">}
      #      dagsiste = %{Dag --sistedag--</text:p><text:p text:style-name="P11">08.00: Frokost, Pakke sammen</text:p><text:p text:style-name="P11">09.00: Fellestime: Fra teori til praksis: Hva kan vi gjøre når vi kommer hjem?</text:p><text:p text:style-name="P11">10.00: Innledning i gruppa: --innledn--</text:p><text:p text:style-name="P11">12.00: Grupped<text:span text:style-name="T2">iskusjon/ spørsmål</text:span></text:p><text:p text:style-name="P11">13.00: Lunsj</text:p><text:p text:style-name="P14">14.00: Grupped<text:span text:style-name="T2">iskusjonen fortsetster</text:span></text:p><text:p text:style-name="P11">18.00: <text:span text:style-name="T2">Mat</text:span></text:p><text:p text:style-name="P11">19.00: Gruppene: <text:span text:style-name="T2">Evaluering og oppsummering av konferansa.</text:span></text:p><text:p text:style-name="P11">20.00: Avreise</text:p><text:p text:style-name="P11"/><text:p text:style-name="P16">Antall studietimer i gruppa: 8</text:p><text:p text:style-name="P11"><draw:frame text:anchor-type="paragraph" draw:z-index="4" draw:style-name="gr2" draw:text-style-name="P20" svg:width="7.594cm" svg:height="2.375cm" svg:x="-4.096cm" svg:y="2.408cm"><draw:text-box><text:p text:style-name="P20">Antall dager: --antalldager--</text:p><text:p text:style-name="P20">Antall studietimer i gruppa: --studtimergr--</text:p><text:p text:style-name="P20">Antall studietimer felles: --studtimerf--</text:p><text:p text:style-name="P20">Antall studietimer totalt: --timertotalt-- <text:span text:style-name="T8">}
      dagsiste = %{Dag --sistedag--</text:p><text:p text:style-name="P37">08.00: Frokost, Pakke sammen</text:p><text:p text:style-name="P37">09.00: Fellestime: Fra teori til praksis: Hva kan vi gjøre når vi kommer hjem?</text:p><text:p text:style-name="P37">10.00: Innledning i gruppa: --innledn--</text:p><text:p text:style-name="P37">12.00: Grupped<text:span text:style-name="T32">iskusjon/ spørsmål</text:span></text:p><text:p text:style-name="P37">13.00: Lunsj</text:p><text:p text:style-name="P40">14.00: Grupped<text:span text:style-name="T32">iskusjonen fortsetster</text:span></text:p><text:p text:style-name="P37">18.00: <text:span text:style-name="T32">Mat</text:span></text:p><text:p text:style-name="P37">19.00: Gruppene: <text:span text:style-name="T32">Evaluering og oppsummering av konferansa.</text:span></text:p><text:p text:style-name="P37">20.00: Avreise</text:p><text:p text:style-name="P37"/><text:p text:style-name="P41">Antall studietimer i gruppa: 8</text:p><text:p text:style-name="P38"><draw:frame text:anchor-type="paragraph" draw:z-index="39" draw:style-name="gr4" draw:text-style-name="P53" svg:width="7.594cm" svg:height="2.357cm" svg:x="-4.096cm" svg:y="2.408cm"><draw:text-box><text:p text:style-name="P53">Antall dager: --antalldager--</text:p><text:p text:style-name="P53">Antall studietimer i gruppa: --studtimergr--</text:p><text:p text:style-name="P53">Antall studietimer felles: --studtimerf--</text:p><text:p text:style-name="P53">Antall studietimer totalt: --timertotalt-- <text:span text:style-name="T39">}

      prgforstedag = dag1.gsub(/--innledn--/,argumenter["forste_dag"])
      prgsistedag = dagsiste.gsub(/--innledn--/,argumenter["siste_dag"])
      prgsistedag = prgsistedag.gsub(/--sistedag--/, antalldager )

      dagersort = argumenter["innledning"].sort
      program = ""
      dagersort.each{|x|
        innledn = argumenter["innledning"][x.first]
        program += dagvanlig.gsub(/--innledn--/,innledn)
        #        program += dagvanlig.gsub(/--innledn--/,x.to_s)
        program = program.gsub(/--dagvanlig--/,x.first)
      }
      program = prgforstedag + program + prgsistedag
    else
      malfil = "#{Rails.root}/nor/sfp/sfp-mal.odt"
      timertotalt = sprintf("%.0f",((4.5 * antalldager.to_i).round(0)))
#      timertotalt = (4.5 * antalldager.to_i).round(0)
    end

    navn = argumenter["Navn"].gsub(/\W/,"-")
    tmpfil = "#{Rails.root}/nor/sfp/tmp.odt"
    sfpdir = "nor/sfp/arkiv/"
    sfptmpdir = sfpdir + "nye/"
    laerer = argumenter["§013-lærer-Fornavn"] + "-"+ argumenter["§014-lærer-Etternavn"]

    if argumenter.include?("§020-etildato")
      tmp = argumenter["§020-etildato"] =~ /(\w*) (\d*),\D*(\d*)/
      taar = $3
      tilmnd = NorFelles.mnd_navn_to_nr($1)
      tildag = $2
    end

    if argumenter.include?("§019-efradato")
      tmp = argumenter["§019-efradato"] =~ /(\w*) (\d*),\D*(\d*)/
      faar = $3
      framnd = NorFelles.mnd_navn_to_nr($1)
      fradag = $2
    end

    argumenter["001studieplan"] =~ /(.*)\/(\d*$)/
    studplantxt = $1 unless $1 == nil
    studplantxt = "?" if $1 == nil
    studplannr = $2 unless $1 == nil
    studplannr = "?" if studplannr == nil

    #    FileUtils.cp(malfil, tmpfil)
    t = Time.now
    arkivbane = sfpdir + faar + "/" + tilmnd + "/"
    nyfil = arkivbane + tildag + "_" + navn + "_" + laerer + "_" + t.strftime("%Y-%m-%d-%H-%M-%S")
    nyfil = nyfil + "-KONFERANSE" if konferanse
    nyfil = nyfil + ".odt"

    FileUtils.mkdir_p(arkivbane) unless File.exists?(arkivbane)
    FileUtils.mkdir_p(sfptmpdir) unless File.exists?(sfptmpdir)
    FileUtils.cp(malfil, nyfil)

    Zip::ZipFile.open(nyfil, Zip::ZipFile::CREATE) {
      |zipfile|
      tekst = zipfile.read("content.xml")
      tekst = tekst.gsub(/--STUDNR--/, studplannr)
      tekst = tekst.gsub(/--STUDPLAN--/, studplantxt)
      tekst = tekst.gsub(/--antalltimer--/,timertotalt.to_s)
      tekst = tekst.gsub(/--antall-motedager--/,antalldager)
      tekst = tekst.gsub(/--fdag--/,fradag)
      tekst = tekst.gsub(/--fmnd--/, framnd)
      tekst = tekst.gsub(/--tdag--/,tildag)
      tekst = tekst.gsub(/--tmnd--/,tilmnd)
      tekst = tekst.gsub(/--taar--/,taar)
      tekst = tekst.gsub(/--faar--/,faar)
      tekst = tekst.gsub(/--adelt--/,argumenter["§003-antall-deltagere"])
      tekst = tekst.gsub(/--davg--/,argumenter["§004-deltageravgift"])
      tekst = tekst.gsub(/--fantall--/,argumenter["§0021-1-antall-parallelle-fra"])
      tekst = tekst.gsub(/--tantall--/,argumenter["§0021-2-antall-parallelle-til"])
      tekst = tekst.gsub(/--sted--/,argumenter["§007-Sted"])
      tekst = tekst.gsub(/--kommune--/,argumenter["§008-Kommune"])
      tekst = tekst.gsub(/--fylke--/,argumenter["§009-Fylke"])
      tekst = tekst.gsub(/--lnavn--/, argumenter["§013-lærer-Fornavn"] + " " + argumenter["§014-lærer-Etternavn"])
      tekst = tekst.gsub(/--ladresse--/,argumenter["§015-lærer-Adresse"])
      tekst = tekst.gsub(/--lpostnr--/,argumenter["§016-lærer-Post-01-nr"])
      tekst = tekst.gsub(/--lpoststed--/,argumenter["§016-lærer-Post-02-sted"])
      tekst = tekst.gsub(/--lepost--/,argumenter["018-lærer-email"])
      if konferanse
        tekst = tekst.gsub(/--dstart--.*--dslutt--/,program)
        #      tekst = tekst.gsub(/--antalltimer--/,argumenter["§0022-2-timer"])
        tekst = tekst.gsub(/--studtimergr--/,timergruppe.to_s)
        tekst = tekst.gsub(/--studtimerf--/,antalldager.to_s)
        tekst = tekst.gsub(/--timertotalt--/,timertotalt.to_s)
        tekst = tekst.gsub(/--antalldager--/,antalldager.to_s)
        tekst = tekst.gsub(/--tema--/,argumenter["tema"])
      end
      zipfile.remove("content.xml")
      zipfile.get_output_stream("content.xml") { |f| f.puts tekst }
    }
    FileUtils.chmod(0770, nyfil)
    FileUtils.cp(nyfil, sfptmpdir)
    FileUtils.chmod_R(0770, sfpdir)
    #    nyfil = lagresfpodp(tmpfil, navn, dir = "nor/sfp/arkiv", endelse = ".odt")
    #    arkivbane = aarbane + mnd + "/"
  end
  def self.felles
    %{ #feil{ background: red;
      border-top: 1px solid rgb(34, 136, 34);
      font-family: "helvetica",sans-serif;
      font-size: 80%;
      border-bottom: 2px solid rgb(34, 136, 34);
      font-weight: normal;
      text-align: Center;
      font-weight: bold;
      padding: 5px 5px 5px 5px;
      }

    #velgdag{ background: grey;
      border-top: 1px solid rgb(34, 136, 34);
      font-family: "helvetica",sans-serif;
      font-size: 80%;
      border-bottom: 2px solid rgb(34, 136, 34);
      font-weight: normal;
      text-align: Center;
      font-weight: bold;
      padding: 5px 5px 5px 15px;
      width: 43%
      }

    #kursdager{ background: yellow;
      }
    #innledninger{ background: white;
      border-bottom: 2px solid rgb(34, 136, 34);
      font-weight: normal;
      text-align: left;
      padding: 5px 3px 5px 3px;
      }

    #TilFra{ background: yellow;
      }
    }

  end
end
