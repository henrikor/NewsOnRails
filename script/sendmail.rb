# -*- encoding : utf-8 -*-
#! /usr/bin/ruby


30.times{
  `echo "test" >> /tmp/tmp`
  sleep 2
}
#fra = ARGV[1]
#temafelt = ARGV[2]
#tekstfil = ARGV[3]
#adresserbane = ARGV[4]
#
#adresserfil = File.open(adresserbane)
#
#`cat /tmp/eposttekst$USER | mutt -e "my_hdr From: #{fra}" -s "#{temafelt}"`
