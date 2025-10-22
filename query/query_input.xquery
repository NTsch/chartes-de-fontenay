xquery version "3.1";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace file = "http://basex.org/modules/file";

for $charter in collection('../input')/TEI
where $charter//subst[add]
return base-uri($charter)