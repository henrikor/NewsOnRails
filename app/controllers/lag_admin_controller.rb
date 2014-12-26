# -*- encoding : utf-8 -*-
class LagAdminController < ApplicationController
  before_filter :nor_authorized?

  # Tilgang til grupper m� styres av roller. Alle i rollen "asker" har tilgang til gruppa "asker" osv.
  # Det betyr at vi m� ha join tabell mellom roles og groups tabellen. Roles puttes i grupper
  # Alle i Admin og Asker rollen har skrivetilgang til alle artikkler i asker gruppa.
  #
  #
  #
  # Vi kan evt. lage actions for hvert lag, og la skrivetilgang her avgj�re om vi f�r avkrysningsboks.
  # Dette vil i tilfellet bli en litt d�rlig ad-hoc l�sning...
  #
  #
  # Vi m� videre ha mulighet for � lage kopi av artikelen. For artikelen det ikke lages kopi av m� vi
  # ha system for � begrense skrivetilgang (s� ikke Molde endrer sida til Asker...). Hver artikkel m�
  # ha en eier-rolle
  #
  #
  # Articles tabelle m� f� et rolle felt, slik at vi kan sette en bestemt rolle som eier av hver
  # artikkel. Hvis du er med i denne gruppa,
  # s� kan du skrive p� den + endre eier. Hvis ikke kan du kun lage link, evt. lage en kopi som du
  # da selvf�lgelig legger til ny eier.
  #
  # Hvilke "lag" avkrysningbokser som vises, avgj�res av hvorvidt du er med i en rolle som er med
  # i den aktulle lag-gruppa.
  #
  # Lag side med alle nyheter fra alle lag. Legg inn avkrysningsbokser for hvilke lag de skal v�re i,
  # link av nyhet/ kopier nyhet.
  #
  # CSS er variabel. Alle lag kan f� forskjellig css ut av denne, akkurat som admin sidene
  # f�r det pt.

  def au
  end

  def asker
  end
end



