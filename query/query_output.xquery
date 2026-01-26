xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";
(:
for $charter in collection('../output')//cei:text[@type='charter']:)
let $charters := collection('../output')//cei:text[@type='charter']
for $charter in $charters
return $charter//cei:bibl