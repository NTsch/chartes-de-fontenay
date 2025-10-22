xquery version "3.1";
declare namespace cei = "http://www.monasterium.net/NS/cei";
(:
for $charter in collection('../output')//cei:text[@type='charter']:)
let $charters := collection('../output')//cei:text[@type='charter']
let $attrs := $charters//*/@reg
let $grouped := 
  for $attr in $attrs
  group by $name := name($attr), $value := string($attr)
  return 
    if (count($attr) > 1) then
      <repeated name="{$name}" value="{$value}" count="{count($attr)}"/>
    else ()
return $grouped