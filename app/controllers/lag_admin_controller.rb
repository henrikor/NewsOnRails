# -*- encoding : utf-8 -*-
class LagAdminController < ApplicationController
  before_filter :nor_authorized?

  # Tilgang til grupper må styres av roller. Alle i rollen "asker" har tilgang til gruppa "asker" osv.
  # Det betyr at vi må ha join tabell mellom roles og groups tabellen. Roles puttes i grupper
  # Alle i Admin og Asker rollen har skrivetilgang til alle artikkler i asker gruppa.
  #
  #
  #
  # Vi kan evt. lage actions for hvert lag, og la skrivetilgang her avgjøre om vi får avkrysningsboks.
  # Dette vil i tilfellet bli en litt dårlig ad-hoc løsning...
  #
  #
  # Vi må videre ha mulighet for å lage kopi av artikelen. For artikelen det ikke lages kopi av må vi
  # ha system for å begrense skrivetilgang (så ikke Molde endrer sida til Asker...). Hver artikkel må
  # ha en eier-rolle
  #
  #
  # Articles tabelle må få et rolle felt, slik at vi kan sette en bestemt rolle som eier av hver
  # artikkel. Hvis du er med i denne gruppa,
  # så kan du skrive på den + endre eier. Hvis ikke kan du kun lage link, evt. lage en kopi som du
  # da selvfølgelig legger til ny eier.
  #
  # Hvilke "lag" avkrysningbokser som vises, avgjøres av hvorvidt du er med i en rolle som er med
  # i den aktulle lag-gruppa.
  #
  # Lag side med alle nyheter fra alle lag. Legg inn avkrysningsbokser for hvilke lag de skal være i,
  # link av nyhet/ kopier nyhet.
  #
  # CSS er variabel. Alle lag kan få forskjellig css ut av denne, akkurat som admin sidene
  # får det pt.

  def au
  end

  def asker
  end
end



