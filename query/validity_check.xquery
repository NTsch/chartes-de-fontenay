xquery version "3.1";
declare namespace atom = "http://www.w3.org/2005/Atom";
declare namespace cei = "http://www.monasterium.net/NS/cei";

(:validates the given charter(s) against the CEI schema:)
(:if you insert tenors into the example CEI, you can use this query to validate that the tenor is correct:)

<result>{
(:validate single charter:)
(:let $charter := doc(xmldb:encode('/db/mom-data/metadata.charter.saved/tag:www.monasterium.net,2011:#charter#AT-StiAL#LambachOSB#1454_VIII_20.xml'))
:)
(:validate collection:)
for $corpus in doc('fontenay_corpus.xml')
for $charter in $corpus//cei:text[@type='charter']
let $xml := <cei:cei>{$charter}</cei:cei> 
let $schema := doc('cei10.xsd')
let $valrep := validate:xsd-report($corpus, $schema)
return if ($valrep//status = 'invalid') then <validationResult><charterUri>{base-uri($corpus)}</charterUri>{$valrep}</validationResult>
else()
}</result>