xquery version "3.1";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace file = "http://basex.org/modules/file";

for $charter in collection('../input')/TEI
where not($charter//abstract//normalize-space() != '')
return <result>{base-uri($charter)}</result>