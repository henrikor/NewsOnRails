#-*- encoding : utf-8 -*-
module ArticlesHelper
  include ApplicationHelper
  def norsyntax
    cloth = "r"
    tekst = '
<div class="articlesyntaxmeny">

h2. NewsOnRails syntax:


<table>
<tr><td>  [[tema:37]] </td><td> -> </td><td> Link til tema med id 37 (Hverdagsrasisme). </td></tr>
<tr><td>  [[hoyrekolonne]] </td><td> -> </td><td> Viser høyrekolonna på sida. </td></tr>
<tr><td>  [[article:10045]] </td><td> -> </td><td> Link til artikkel med id 10045. </td></tr>
<tr><td>  [[article=10037,headline, link=|Mer|]]  </td><td> -> </td><td> Overskriften fra artikkelen med id nummer 10037, Link: "Mer"<sup><a href="#fn1">1</a></sup> </td></tr>
<tr><td>  <notextile> &lt;css-include&gt; css kode &lt;/css-include&gt; </notextile> </td><td> -> </td><td> CSS koden legges inn på denne artikkelen </td></tr>
<tr><td> [[les mer]] </td><td> -> </td><td> Lager "Les mer" link til seg sjøl. </td></tr>
<tr><td> [[les mer: "mere tekst her"]] </td><td> -> </td><td> Lager link til seg sjøl med teksten "mere tekst her". </td></tr>
</table>

h3. Taggen [[tema=]]

Dette er en tag som kan gjøre mye:

<table>
<tr><td>  [[tema=37,headline, antall=10, link=|headline|]] </td><td> -> </td><td> Overskriften fra de 10 siste nyhetene, gjøre overskriften til en link.<sup><a href="#fn1">1</a></sup> </td></tr>
<tr><td>  [[tema=37, kilde, headline, ingress, story_text, url, lagid=32, fra=5, antall=10, link=|Les Mer|]]  </td><td> -> </td><td> Kilde + overskrift + ingress + hoveddtekst + url for 10 nyheter, fra lag med id=32 (Asker) etter de 5 første. Under teksten: "Les mer"<sup><a href="#fn1">1</a></sup> </td></tr>
</table>
<br/>
Noen flere ting som kan puttes inn i [[tema=]]:
<table>
<tr><td>  link=|headline,url,kilde,ingress, bilde "LES MER"|  </td><td> -> </td><td> Her blir det link på: overskrift, kilde, ingress, bilde + en for en linktekst med teksten "LES MER"</td></tr>
<tr><td>  temalinker  </td><td> -> </td><td> Vi får linker til temaer som artikelen er medlem av</td></tr>
<tr><td>  headline:h2. ,  </td><td> -> </td><td> Her vil overskriften pakkes i overskrift 2. <b>NB!</b> Merk mellomrom + komma etter sjølve koden!</td></tr>
<tr><td>  headline:* | *,  </td><td> -> </td><td> Her vil overskriften bli kvernet av "strong" i redcloth. kode før " |" (merk space) kommer før overskriften, og koden etter "| " og fram til første komma (merk space) kommer etter. En kan også ha html kode her <b>NB!</b> merk bruken av "space" her!</td></tr>
<tr><td>  <notextile>class="klassenavn"</notextile>  </td><td> -> </td><td> putter et klassenavn inn i "par/odd" css classen (som gjør at en kan sette annen farge osv. på annenhver nyhet som importeres</td></tr>
<tr><td>  [[tema=10, ingress, rand]]  </td><td> -> </td><td> Her blir ingressen fra en (og bare en) <i>tilfeldig</i> artikkel hentet ut, </td></tr>

</table>



fn1. Dersom du i link attributtet skriver noe annet enn
"headline" så vil dette og ikke overskriften bli linka opp.

h3. Bilder

<table>
<tr><td><notextile>  [[bilde-st:3]][[bilde-li:3]]</notextile></td><td> -> </td><td> <b>NB! Bør brukes!!</b> Bilder for forsida (o.l.) forside. Henter ut bilde med id = 3. "bilde-li" er liggende bilde, og "bilde-st" er stående</td></tr>
<tr><td><notextile>  [[bilde-st:3|nord|]][[bilde-li:3|sor|]]</notextile></td><td> -> </td><td> Samme som over, men her fokuseres det første eksempel på øvre del av bildet, i andre på nedre.</td></tr>
<tr><td><notextile>  [[bilde-st:3|vest|]][[bilde-li:3|ost|]]</notextile></td><td> -> </td><td> Samme som over, men her fokuseres det første eksempel på venstre del av bildet, i andre på høyre.</td></tr>
<tr><td><notextile>  [[bilde-st:3|nv|]][[bilde-li:3|no|]]</notextile></td><td> -> </td><td> Her fokuseres NordØst (no) og NordVest (nv)</td></tr>
<tr><td><notextile>  [[bilde-st:3|sv|]][[bilde-li:3|so|]]</notextile></td><td> -> </td><td> Her fokuseres SørØst (so) og SørVest (sv)</td></tr>
<tr><td><notextile>  [[image:3]]</notextile></td><td> -> </td><td> Legg inn bilde med id = 3. (standard størrelse blir valgt)</td></tr>
<tr><td><notextile>  [[image:3=]]</notextile></td><td> -> </td><td> Sentrer bildet</td></tr>
<tr><td><notextile>  [[image:3>]]</notextile></td><td> -> </td><td> Plasser bildet til høyre</td></tr>
<tr><td><notextile>  [[image:3<]]</notextile></td><td> -> </td><td> Plasser bildet til venstre</td></tr>
<tr><td><notextile>  [[image:3 |300px|]]</notextile></td><td> -> </td><td> Legg inn bilde i maksstørrelsen 300px </td></tr>
<tr><td><notextile>  [[image:3 |nolink|]]</notextile></td><td> -> </td><td> Legg inn bilde, men ikke lag link på bildet til bildet i maksstørrelse </td></tr>
</table>

h3. Former

<notextile>
Former gjøres på vanlig html måte, men vi har definert e-postgrupper i /sendpost/admin. Eksempel for å sende
til gruppen "ledelsen":
<br /> 
<b> &lt;input name="epostg" value="ledelsen" type="hidden"></b>
<br /><br />
Legg inn et felt for å hindre spamboter i å sende spam på skjemaet:
<br />
<b>&lt;input name="reklame" type="text" class="reklame"></b>
</notextile>

h3. Vedlegg

<table>
<tr><td><notextile>   [[vedlegg:27, tekst=|Se vedlegg|]] </notextile> </td><td> -> </td><td> <a href="/uploaded_images/27.jpg">Se vedlegg</a> </td></tr>
<tr><td><notextile>   [[vedlegg:27]]</notextile> </td><td> -> </td><td> <a href="/uploaded_images/27.jpg">Rosenlund</a><sup><a href="#fn2">2</a></sup> </td></tr>
</table>
fn2. Henter navn fra databasa.

h3. Link til meg selv

<table>
<tr><td><notextile>   [[les mer]] </notextile> </td><td> -> </td><td> <a href="/Sentralt">les mer</a> </td></tr>
<tr><td><notextile>   [[les mer: Tekst som linker til seg selv]] </notextile> </td><td> -> </td><td> <a href="/Sentralt">Tekst som linker til seg selv</a> </td></tr>
</table>

h3. Matematiske formler o.l.

Du kan legge inn "LaTeX":http://www.linuxguiden.no/index.php/LaTeX kode for å genrerere bilder av formler mellom taggene: "@<matte>@" og "@</matte>@".
Du kan også legge inn størrelse med "|str=[størrelse]" rett før "@</matte>@". Som vist i følgende eksempel:
<br/>
<br/>
@<matte>b^2|str=350x350</matte>@
<br/>
<br/>
Du kan se eksempler på disse sidene (NB! Noen av disse sidene vil ikke vises skikkelig i annet enn firefox eller nyere Opera)
* "Ritex: mange eksempler (TeX)":http://masanjin.net/ritex/report.xml
* "LaTeX eksempler":http://www-cdf.fnal.gov/~cplager/latex/#snippet
* "Wikipedia (no) om LaTeX":http://no.wikipedia.org/wiki/LaTeX
* "Webtex":http://stuff.mit.edu/afs/athena/software/webeq/currenthome/docs/webtex/toc.html
* "LaTeX Tutorial":http://frodo.elon.edu/tutorial/tutorial/

h3. Referanser

Referanser (fotnoter og sluttnoter) skriver du rett inn mellom taggene: "@<ref>@" og "@</ref>@"
<br/><br/>

<table>
<tr><td>Roman om flukt &lt;ref&gt; Vi skal bare ut å reise, av Eli Sol Vallersnes &lt;/ref&gt; </td><td> -> </td><td> Roman om flukt<sup id="referanse_ref-1" class="referanse"><a href="#referanse_note-1" title="">[1]</a></sup> </td></tr>
</table>

<br/><br/>
Dersom du skal ha flere henvisninger til samme referanse:
<br/><br/>

<table>
<tr><td>Roman om flukt <notextile> &lt;ref name="eli"&gt; </notextile> Vi skal bare ut å reise, av Eli Sol Vallersnes &lt;/ref&gt; </td><td> -> </td><td> Roman om flukt<sup id="referanse_ref-1" class="referanse"><a href="#referanse_note-1" title="">[1]</a></sup> </td></tr>
<tr><td>Flukten er hard &lt;ref name=<notextile>"eli"</notextile> /&gt;</td><td> -> </td><td> Flukten er hard<sup id="referanse_ref-1" class="referanse"><a href="#referanse_note-1" title="">[1]</a></sup> </td></tr>
</table>

<br/><br/>

Du må skrive inn: {{reflist}} der du vil ha referansene (sluttnotene/ fotnotene).
Vi "hermer" etter "mediawiki (wikipedia) sin måte":http://en.wikipedia.org/wiki/Wikipedia:Footnotes å gjøre dette på. Enkel beskrivelse finner du "her":http://en.wikipedia.org/wiki/Help:Footnotes

h3. Kommenter ut tekst

Tekst som skrives mellom: "/*" og "*/" vises ikke.

h3. Kalender

<table>
<tr><td><notextile>   [[kalender:name="dato"]] </notextile> </td><td> -> </td><td> En kalender med formfelt navn "dato" </td></tr>
<tr><td><notextile>   [[kalender:arg=|"e_date", nil, :year_range => 10.years.ago..0.years.from_now|]]</notextile> </td><td> -> </td><td> En annen kalender </td></tr>
</table>

For full oversikt over muilge ting i "arg" se calenderdateselect "demoen":http://electronicholas.com/calendar "wikien":http://code.google.com/p/calendardateselect/w/list eller "hovedsiden":http://code.google.com/p/calendardateselect/

    '

    #    r = RedCloth.new(tekst)
#    tekst2 = r.to_html

    norsk2html(tekst, 1).html_safe
  end
  def clothsyntax(cloth)
    if (cloth == "b")
      cloth = '

<h2>Syntax Cheatsheet:</h2>

<h3>Phrase Emphasis</h3>

<pre><notextile>*italic*   **bold**
_italic_   __bold__
</notextile></pre>

<h3>Links</h3>

<p>Inline:</p>

<pre><notextile>An [example](http://url.com/ "Title")
</notextile></pre>

<p>Reference-style labels (titles are optional):</p>

<pre><notextile>An [example][id]. Then, anywhere
else in the doc, define the link:

  [id]: http://example.com/  "Title"
</notextile></pre>

<h3>Images</h3>

<p>Inline (titles are optional):</p>

<pre><notextile>![alt text](/path/img.jpg "Title")
</notextile></pre>

<p>Reference-style:</p>

<pre><notextile>![alt text][id]

[id]: /url/to/img.jpg "Title"
</notextile></pre>

<h3>Headers</h3>

<p>Setext-style:</p>

<pre><notextile>Header 1
========

Header 2
--------

</notextile></pre>

<p>atx-style (closing #\'s are optional):</p>

<pre><notextile># Header 1 #

## Header 2 ##

###### Header 6
</notextile></pre>

<h3>Lists</h3>

<p>Ordered, without paragraphs:</p>

<pre><notextile>1.  Foo
2.  Bar
</notextile></pre>

<p>Unordered, with paragraphs:</p>

<pre><notextile>*   A list item.

    With multiple paragraphs.

*   Bar
</notextile></pre>

<p>You can nest them:</p>

<pre><notextile>*   Abacus
    * answer
*   Bubbles
    1.  bunk
    2.  bupkis
        * BELITTLER
    3. burper
*   Cunning
</notextile></pre>

<h3>Blockquotes</h3>

<pre><notextile>&gt; Email-style angle brackets

&gt; are used for blockquotes.

&gt; &gt; And, they can be nested.

&gt; #### Headers in blockquotes
&gt;
&gt; * You can quote a list.
&gt; * Etc.
</notextile></pre>

<h3>Code Spans</h3>

<pre><notextile>`&lt;code&gt;` spans are delimited
by backticks.

You can include literal backticks
like `` `this` ``.
</notextile></pre>

<h3>Preformatted Code Blocks</h3>

<p>Indent every line of a code block by at least 4 spaces or 1 tab.</p>

<pre><notextile>This is a normal paragraph.

    This is a preformatted
    code block.
</notextile></pre>

<h3>Horizontal Rules</h3>

<p>Three or more dashes or asterisks:</p>

<pre><notextile>---

* * *

- - - -
</notextile></pre>

<h3>Manual Line Breaks</h3>

<p>End a line with two or more spaces:</p>

<pre><notextile>Roses are red,
Violets are blue.

</div>
      '.html_safe



################################################################
# MEDIACLOTH
################################################################



    elsif (cloth == "m")
      cloth = '

<h3>Mediacloth</h3>
<p> (i skrivende stund versjon 0.0.2, mao. ikke ferdig (men virker lovende)...</p>
<table><tbody>
<tr><td>= Overskrift1 =</td><td class="arrow">-></td><td><h1>Overskrift1</h1></td></tr>
<tr><td>==Overskrift2==</td><td class="arrow">-></td><td><h2>Overskrift2</h2></td></tr>

<tr><td>\'\'din tekst\'\'</td><td class="arrow">-></td><td><em>din tekst</em></td></tr>
<tr><td>\'\'\'din tekst\'\'\'</td><td class="arrow">-></td><td><strong>din tekst</strong></td></tr>
<tr><td>\'\'\'\'\'din tekst\'\'\'\'\'</td><td class="arrow">-></td><td><em><strong>din tekst</strong></em></td></tr>

  <tr><td>* Punktliste<br>* Andre punkt</td><td class="arrow">-></td><td><ul><li>Punktliste</li><li>Andre punkt</li></ul></td></tr>

  <tr><td># Nummerliste<br># Andre punkt</td><td class="arrow">-></td><td>1. Nummerliste<br>2. Andre punkt</td></tr>
  <tr><td>[URL linknavn]</td><td class="arrow">-></td><td><a href="URL">linknavn</a></td></tr>
</tbody></table></div>'.html_safe



################################################################
# REDCLOTH
################################################################

  elsif (cloth == "r")
      cloth = '

<h3>Redcloth (Textile) formateringstips (<a href="http://redcloth.org/textile/" onclick="quickRedReference(); return false;">Avansert</a>)</h3>

<table><tbody>
<tr><td>h1. Overskrift1</td><td class="arrow"> -> </td><td><h1>Overskrift1</h1></td></tr>
<tr><td>h2. Overskrift2</td><td class="arrow"> -> </td><td><h2>Overskrift2</h2></td></tr>
<tr><td>_din tekst_</td><td class="arrow"> -> </td><td><em>din tekst</em></td></tr>

  <tr><td>*din tekst*</td><td class="arrow">-></td><td><strong>din tekst</strong></td></tr>
  <tr><td>%{color:red}hallo%</td><td class="arrow">-></td><td><span style="color: red;">hallo</span></td></tr>
  <tr><td>* Punktliste<br>* Andre punkt</td><td class="arrow">-></td><td><ul><li>Punktliste</li><li>Andre punkt</li></ul></td></tr>

  <tr><td># Nummerliste<br># Andre punkt</td><td class="arrow">-></td><td>1. Nummerliste<br>2. Andre punkt</td></tr>
  <tr><td>"linknavn":URL</td><td class="arrow">-></td><td><a href="URL">linknavn</a></td></tr>
  <tr><td>|a|tabell|row|<br>|b|tabell|row|</td><td class="arrow">-></td><td>Tabell</td></tr>

  <tr><td>http://url<br>epost@adresse.no</td><td class="arrow">-></td><td>Automatisk link</td></tr>
  <tr><td>!bildeURL!</td><td class="arrow">-></td><td>Bilde</td></tr>
</tbody></table></div>
      '.html_safe




################################################################
# INGEN / HTML
################################################################
#  elsif (cloth == "i")
  else
      cloth = '

<h3>Ingen/ HTML</h3>
<p>&nbsp;Du kan velge bekledningsystem i &oslash;verste
rullegardin til venstre (der det st&aring;r "ingen").
Bekledningssystemene gj&oslash;r det enkelt &aring; formatere
teksten. Med dette valget ("ingen") m&aring; du bruke html, dersom
du vil lage overskrifter o.l.). Under f&oslash;lger en veldig enkel
oversikt over de vanligste html taggene.
</p>
<table><tbody>
<tr><td>&lt;h1&gt;Overskrift1&lt;/h1&gt;</td><td class="arrow">-></td><td><h1>Overskrift1</h1></td></tr>
<tr><td>&lt;h2&gt;Overskrift2&lt;/h2&gt;</td><td class="arrow">-></td><td><h2>Overskrift2</h2></td></tr>
<tr><td>&lt;h3&gt;Overskrift3&lt;/h3&gt;</td><td class="arrow">-></td><td><h3>Overskrift3</h3></td></tr>
<tr><td>&lt;em&gt;Din tekst&lt;/em&gt;</td><td class="arrow">-></td><td><em>din tekst</em></td></tr>

  <tr><td>&lt;strong&gt;Din tekst&lt;/strong&gt;</td><td class="arrow">-></td><td><strong>din tekst</strong></td></tr>
  <tr><td>&lt;a href="URL"&gt;linknavn&lt;/a&gt;</td><td class="arrow">-></td><td><a href="URL">linknavn</a></td></tr>
</tbody></table></div>'.html_safe


    end
    nor = norsyntax
    tekst = nor + cloth
  end


end
