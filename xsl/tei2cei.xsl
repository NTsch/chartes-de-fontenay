<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:cei="http://www.monasterium.net/NS/cei"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
     <xsl:strip-space elements="*"/> 
    
    <xsl:template match="*" priority="-1">
        <xsl:message terminate="no">
            Unmatched element: <xsl:value-of select="name()"/>
        </xsl:message>
        <!-- Optionally, copy the element as-is -->
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="TEI">
        <cei:text type='charter'>
            <cei:front>
                <!--<xsl:apply-templates select='teiHeader/sourceDesc'/>-->
                <xsl:apply-templates select='teiHeader/fileDesc/publicationStmt'/>
                <cei:encodingDesc>
                    <xsl:apply-templates select='teiHeader/encodingDesc'/>
                    <xsl:apply-templates select='//editorialDecl'/>
                </cei:encodingDesc>
            </cei:front>
            <cei:body>
                <xsl:call-template name="main-id"/>
                <cei:chDesc>
                    <xsl:apply-templates select='teiHeader/profileDesc'/>
                    <xsl:apply-templates select='teiHeader/fileDesc/sourceDesc'/>
                </cei:chDesc>
                <cei:tenor>
                    <xsl:apply-templates select="text"/>
                </cei:tenor>
            </cei:body>
        </cei:text>
    </xsl:template>
    
    <xsl:template match="publicationStmt">
        <cei:publicationStmt>
            <xsl:apply-templates/>
        </cei:publicationStmt>
    </xsl:template>
    
    <xsl:template match="teiHeader">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="p">
        <cei:p>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="p[parent::abstract] | p[parent::support]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="fileDesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="sourceDesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="listWit">
        <!--if original: witnessOrig-->
        <!--the rest: witListPar-->
        <xsl:apply-templates select="witness[matches(string-join(.//text()), '(Original (\w+ )?en parchemin)')]"/>
        <cei:witListPar>
            <xsl:apply-templates select="witness[not(matches(string-join(.//text()), '(Original (\w+ )?en parchemin)'))]"/>
        </cei:witListPar>
    </xsl:template>
    
    <xsl:template match="witness[matches(string-join(.//text()), '(Original (\w+ )?en parchemin)')]">
        <cei:witnessOrig>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <xsl:apply-templates select="//layoutDesc"/>
            <xsl:call-template name="images">
                <xsl:with-param name="pos" select="position()"/>
            </xsl:call-template>
        </cei:witnessOrig>
    </xsl:template>
    
    <xsl:template match="witness">
        <cei:witness>
            <xsl:copy-of select="@*[name() != 'source']"/>
            <xsl:apply-templates/>
            <xsl:apply-templates select="//layoutDesc"/>
            <xsl:call-template name="images">
                <xsl:with-param name="pos" select="position()"/>
            </xsl:call-template>
        </cei:witness>
    </xsl:template>
    
    <xsl:template match="msDesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="msIdentifier">
        <cei:archIdentifier>
            <xsl:apply-templates/>
        </cei:archIdentifier>
    </xsl:template>
    
    <xsl:template match="settlement">
        <cei:settlement>
            <xsl:apply-templates/>
        </cei:settlement>
    </xsl:template>
    
    <xsl:template match="repository">
        <cei:arch>
            <xsl:apply-templates/>
        </cei:arch>
    </xsl:template>
    
    <xsl:template match="idno">
        <cei:idno>
            <xsl:apply-templates/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template match="physDesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="objectDesc">
        <cei:physicalDesc>
            <xsl:apply-templates select="node()[name() != 'layoutDesc']"/>
        </cei:physicalDesc>
    </xsl:template>
    
    <xsl:template match="supportDesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="support">
        <cei:material>
            <xsl:apply-templates/>
        </cei:material>
    </xsl:template>
    
    <xsl:template match="extent">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="dimensions">
        <cei:dimensions>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:dimensions>
    </xsl:template>
    
    <xsl:template match="height">
        <cei:height>
            <xsl:apply-templates/>
        </cei:height>
    </xsl:template>
    
    <xsl:template match="width">
        <cei:width>
            <xsl:apply-templates/>
        </cei:width>
    </xsl:template>
    
    <xsl:template match="layoutDesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="layout">
        <cei:p type="layout">
            <xsl:value-of
                select="concat('Columns: ', @columns, ', Lines: ', @writtenLines, ' - ', normalize-space(.))"
            />
        </cei:p>
    </xsl:template>
    
    <xsl:template match="handDesc">
        <cei:p type="handDesc">
            <xsl:apply-templates select="normalize-space(.)"/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="scriptDesc">
        <cei:p type="scriptDesc">
            <xsl:apply-templates select="normalize-space(.)"/>
        </cei:p>
    </xsl:template>
    
    <!--<xsl:template match="scriptNote">
        <cei:p type="scriptNote">
            <xsl:apply-templates select="normalize-space(.)"/>
        </cei:p>
    </xsl:template>-->
    
    <xsl:template match="additions">
        <cei:rubrum>
            <xsl:apply-templates/>
        </cei:rubrum>
    </xsl:template>
    
    <xsl:template match="history">
        <cei:p type="history">
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="p[parent::p or parent::history or parent::origin]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match='origin'>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="origPlace">
        <cei:placeName>
            <xsl:apply-templates/>
        </cei:placeName>
    </xsl:template>
    
    <xsl:template match="locus">
        <cei:scope>
            <xsl:apply-templates/>
        </cei:scope>
    </xsl:template>
    
    <xsl:template match="q | quote">
        <cei:quote>
            <xsl:apply-templates/>
        </cei:quote>
    </xsl:template>
    
    <xsl:template match="listBibl">
        <cei:diplomaticAnalysis>
            <cei:listBibl>
                <xsl:apply-templates/>
            </cei:listBibl>
        </cei:diplomaticAnalysis>
    </xsl:template>
    
    <xsl:template match="bibl">
        <cei:bibl>
            <xsl:copy-of select="@*[not(name() = ('xml:id', 'sameAs', 'default'))]"/>
            <xsl:if test="idno/@type='ISBN'">
                <xsl:attribute name="id">
                    <xsl:value-of select="idno"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="parent::witness">
                <xsl:attribute name="n">
                    <xsl:value-of select="parent::witness/@n"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@sameAs">
                <xsl:attribute name="key">
                    <xsl:value-of select="@sameAs"/>
                </xsl:attribute>
                <xsl:call-template name="bibl-key">
                    <xsl:with-param name="key" select="substring(@sameAs/data(), 2)"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:bibl>
    </xsl:template>
    
    <xsl:template match="bibl[ancestor::creation]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="biblScope">
        <cei:scope>
            <xsl:apply-templates/>
        </cei:scope>
    </xsl:template>
    
    <xsl:template match="facsimile">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match='surface'>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="graphic">
        <cei:graphic>
            <xsl:copy-of select="@url"/>
        </cei:graphic>
    </xsl:template>

    <xsl:template match="graphic[parent::facsimile]">
        <cei:figure>
            <cei:graphic
                url="{concat('https://iiif.irht.cnrs.fr/iiif/France/Dijon/AD212315101/DEPOT/', substring-before(substring-after(@url, 'Fontenay/'), '.jpg'), '/full/full/0/default.jpg')}"
            />
        </cei:figure>
    </xsl:template>

    <xsl:template match="graphic[parent::p]">
        <cei:pict type="{@rend}"/>
    </xsl:template>
    
    <xsl:template match="encodingDesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="profileDesc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="creation">
        <cei:issued>
            <xsl:apply-templates/>
        </cei:issued>
    </xsl:template>
    
    <xsl:template match="date[parent::creation]">
        <cei:date>
            <xsl:choose>
                <xsl:when test="@when">
                    <xsl:attribute name="value">
                        <xsl:value-of select="substring(concat(replace(@when, '-', ''), '99999999'), 1, 8)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@notBefore or @notAfter">
                    <xsl:attribute name="value">
                        <xsl:choose>
                            <xsl:when test="@notBefore">
                                <xsl:value-of
                                    select="substring(concat(replace(@notBefore, '-', ''), '99999999'), 1, 8)"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="substring(concat(replace(@notAfter, '-', ''), '99999999'), 1, 8)"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:copy-of select="@notBefore | @notAfter"/>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </cei:date>
    </xsl:template>
    
    <xsl:template match="date | origDate">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="hi">
        <cei:hi>
            <xsl:copy-of select="@*[name() != 'xml:space']"/>
            <xsl:apply-templates/>
        </cei:hi>
    </xsl:template>
    
    <!--can be removed later-->
    <xsl:template match="hi[parent::creation]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="placeName">
        <cei:placeName key="{@key}">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:placeName>
    </xsl:template>
    
    <xsl:template match="persName">
        <cei:persName key="{@key}">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:persName>
    </xsl:template>
    
    <xsl:template match="orgName">
        <cei:orgName key="{@key}">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:orgName>
    </xsl:template>
    
    <xsl:template match="name">
        <cei:name>
            <xsl:apply-templates/>
        </cei:name>
    </xsl:template>
    
    <xsl:template match="forename">
        <cei:forename>
            <xsl:apply-templates/>
        </cei:forename>
    </xsl:template>
    
    <xsl:template match="surname">
        <cei:surname>
            <xsl:apply-templates/>
        </cei:surname>
    </xsl:template>
    
    <xsl:template match="addName">
        <cei:addName>
            <xsl:apply-templates/>
        </cei:addName>
    </xsl:template>
    
    <xsl:template match="roleName">
        <cei:rolename>
            <xsl:apply-templates/>
        </cei:rolename>
    </xsl:template>
    
    <xsl:template match="abstract">
        <cei:abstract>
            <xsl:apply-templates/>
        </cei:abstract>
    </xsl:template>
    
    <xsl:template match="textClass"/>
    
    <xsl:template match="text">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="body">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="p[ancestor::text]">
        <cei:pTenor>
            <xsl:apply-templates/>
        </cei:pTenor>
    </xsl:template>
    
    <xsl:template match="p[parent::note]" priority="5">
        <cei:p>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="choice[sic and corr]">
        <xsl:apply-templates select="sic"/>
        <xsl:text> (!)</xsl:text>
    </xsl:template>
    
    <xsl:template match="choice[expan and abbr]">
        <xsl:apply-templates select="expan"/>
    </xsl:template>
    
    <xsl:template match='corr | expan'>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match='ex'>
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--todo: integrate @corresp in some way-->
    <xsl:template match="lb">
        <cei:lb>
            <xsl:copy-of select="@*[not(name() = 'corresp')]"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="n">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:lb>
    </xsl:template>
    
    <xsl:template match="pb">
        <cei:pb id="{@xml:id}">
            <xsl:copy-of select="@*[not(name() = 'xml:id')]"/>
            <xsl:apply-templates/>
        </cei:pb>
    </xsl:template>
    
    <xsl:template match="note">
        <cei:note>
            <xsl:copy-of select="@*[name() != 'wit' and name() != 'xml:id' and name() != 'rend']"/>
            <xsl:if test="@wit">
                <xsl:attribute name="id">
                    <xsl:value-of select="@wit/data()"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:note>
    </xsl:template>
    
    <xsl:template match="note[ancestor::adminInfo]">
        <cei:p type='adminInfo'>
            <xsl:apply-templates/>
        </cei:p>
    </xsl:template>
    
    <xsl:template match="witDetail">
        <cei:witDetail>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:witDetail>
    </xsl:template>
    
    <xsl:template match="witStart">
        <cei:witStart>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:witStart>
    </xsl:template>
    
    <xsl:template match="witStart[parent::rdg]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="witEnd">
        <cei:witEnd>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:witEnd>
    </xsl:template>
    
    <xsl:template match="lacunaStart">
        <cei:lacunaStart>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:lacunaStart>
    </xsl:template>
    
    <xsl:template match="lacunaEnd">
        <cei:lacunaEnd>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:lacunaEnd>
    </xsl:template>
    
    <xsl:template match="supplied">
        <cei:supplied>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:supplied>
    </xsl:template>
    
    <xsl:template match="supplied[figure]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="damage">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="gap">
        <xsl:choose>
            <xsl:when test="parent::damage">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <cei:space>
                    <xsl:apply-templates/>
                </cei:space>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="figure">
        <cei:figure>
            <xsl:copy-of select="@*[not(name() = 'type')]"/>
            <xsl:if test="@type">
                <cei:figDesc>
                    <xsl:value-of select="@type/data()"/>
                </cei:figDesc>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:figure>
    </xsl:template>
    
    <xsl:template match="figure[ancestor::text]">
        <cei:pict>
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:attribute name="type">
                        <xsl:value-of select="@type"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rend">
                    <xsl:attribute name="type">
                        <xsl:value-of select="@rend"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </cei:pict>
    </xsl:template>
    
    <xsl:template match="term">
        <cei:term>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:term>
    </xsl:template>
    
    <xsl:template match="num">
        <cei:num value="99999999">
            <!--Platzhalter-Attribut, da cei:num ein @value-Attribut braucht-->
            <xsl:apply-templates/>
        </cei:num>
    </xsl:template>
    
    <xsl:template match="w">
        <cei:w>
            <xsl:copy-of select="@*[not(name() = 'xml:id')]"/>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:w>
    </xsl:template>
    
    <xsl:template match="seg">
        <cei:seg id="{@xml:id}">
            <xsl:copy-of select="@*[not(name() = 'xml:id')]"/>
            <xsl:if test="ends-with(@xml:id/data(), '_2')">
                <xsl:text>-</xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="ends-with(@xml:id/data(), '_1')">
                <xsl:text>-</xsl:text>
            </xsl:if>
        </cei:seg>
    </xsl:template>

    <xsl:template match="pc">
        <cei:pc>
            <xsl:copy-of select="@*[not(name() = 'xml:id')]"/>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:pc>
    </xsl:template>
    
    <xsl:template match="g">
        <cei:c>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:c>
    </xsl:template>
    
    <xsl:template match="foreign">
        <cei:foreign lang="{@xml:lang}">
            <xsl:apply-templates/>
        </cei:foreign>
    </xsl:template>
    
    <xsl:template match="geogName">
        <cei:geogName id="{@xml:id}">
            <xsl:apply-templates/>
        </cei:geogName>
    </xsl:template>
    
    <xsl:template match="geogFeat">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="sic">
        <cei:sic>
            <xsl:copy-of select="@*[name() != 'corresp']"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="corr">
                    <xsl:value-of select="@corresp/data()"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:sic>
    </xsl:template>
    
    <xsl:template match="handShift">
        <cei:handShift>
            <xsl:apply-templates/>
        </cei:handShift>
    </xsl:template>
    
    <xsl:template match="subst">
        <xsl:apply-templates select='add'/>
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select='del'/>
        <xsl:text> </xsl:text>
        <cei:hi rend='italic'>ante corr.</cei:hi>
        <xsl:text>) </xsl:text>
    </xsl:template>
    
    <xsl:template match="add">
        <cei:add>
            <xsl:copy-of select="@*[not(name() = ('place', 'corresp'))]"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="n">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@place">
                <xsl:attribute name="type">
                    <xsl:value-of select="@place"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:add>
    </xsl:template>
    
    <xsl:template match="del">
        <cei:del>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:del>
    </xsl:template>
    
    <xsl:template match="metamark">
        <cei:metamark>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:metamark>
    </xsl:template>
    
    <xsl:template match="app">
        <xsl:apply-templates select="lem"/>
        <xsl:apply-templates select="rdg"/>
    </xsl:template>
    
    <xsl:template match="lem">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="rdg[not(ancestor::rdg) and @wit]">
        <cei:note>
            <xsl:value-of select="@wit"/>
            <xsl:text>] </xsl:text>
            <xsl:if test="@rend">
                <xsl:value-of select="@rend/data()"/>
                <xsl:if test="normalize-space()">
                    <xsl:text>: </xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:note>
    </xsl:template>
    
    <xsl:template match="rdg[ancestor::rdg and @wit]">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@wit"/>
        <xsl:text>] </xsl:text>
        <xsl:if test="@rend">
            <xsl:value-of select="@rend/data()"/>
            <xsl:if test="normalize-space()">
                <xsl:text>: </xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="rdg">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!--<xsl:template match="app[rdg/@wit]">
        <xsl:apply-templates select="lem"/>
        <xsl:apply-templates select="rdg"/>
    </xsl:template>
    
    <xsl:template match="app">
        <cei:app>
            <xsl:apply-templates/>
        </cei:app>
    </xsl:template>
    
    <xsl:template match="lem">
        <cei:lem>
            <xsl:apply-templates/>
        </cei:lem>
    </xsl:template>
    
    <xsl:template match="lem[parent::app[rdg/@wit]]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="rdg">
        <cei:rdg>
            <xsl:apply-templates/>
        </cei:rdg>
    </xsl:template>-->
    
    <xsl:template match="desc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="unclear">
        <cei:unclear>
            <xsl:apply-templates/>
        </cei:unclear>
    </xsl:template>
    
    <xsl:template match="editorialDecl">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ab">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="soCalled">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="surplus">
        <cei:surplus>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </cei:surplus>
    </xsl:template>
    
    <xsl:template match="surplus[parent::rdg]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ref | ptr">
        <cei:bibl>
            <cei:ref>
                <xsl:apply-templates/>
            </cei:ref>
        </cei:bibl>
    </xsl:template>
    
    <xsl:template match="additional">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="adminInfo">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="space">
        <cei:space>
            <xsl:copy-of select="@*[not(name() = 'corresp')]"/>
            <xsl:if test="@corresp">
                <xsl:attribute name="n">
                    <xsl:value-of select="@corresp"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:space>
    </xsl:template>
    
    <xsl:template match="monogr | analytic">
        <xsl:apply-templates select="author"/>
        <xsl:apply-templates select="title"/>
        <xsl:text>.</xsl:text>
        <xsl:apply-templates select="imprint"/>
    </xsl:template>
    
    <xsl:template match="title">
        <cei:title>
            <xsl:copy-of select="@type"/>
            <xsl:apply-templates/>
        </cei:title>
    </xsl:template>
    
    <xsl:template match="author[ancestor::biblStruct]">
        <cei:author>
            <cei:persName>
                <xsl:apply-templates select="surname"/>
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="forename"/>
            </cei:persName>
        </cei:author>
        <xsl:text>: </xsl:text>
    </xsl:template>
    
    <xsl:template match="imprint">
        <cei:imprint>
            <xsl:apply-templates/>
        </cei:imprint>
    </xsl:template>
    
    <xsl:template match="publisher">
        <cei:publisher>
            <xsl:apply-templates/>
        </cei:publisher>
    </xsl:template>
    
    <xsl:template match="pubPlace">
        <cei:pubPlace>
            <xsl:apply-templates/>
        </cei:pubPlace>
    </xsl:template>
    
    <xsl:template match="note[ancestor::biblStruct]">
        <cei:note>
            <xsl:copy-of select="@*"/>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </cei:note>
    </xsl:template>
    
    <xsl:template match="note[@type = 'tags']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- ##### custom templates ##### -->
    
    <xsl:template name='main-id'>
        <xsl:variable name='xml-id' select='/TEI/@xml:id/data()'/>
        <cei:idno id='{$xml-id}'>
            <xsl:value-of select="$xml-id"/>
        </cei:idno>
    </xsl:template>
    
    <xsl:template name="images">
        <xsl:param name="pos"/>
        <!--look for the document id, and use it to get the right facsimile entry-->
        <xsl:variable name="id">
            <xsl:analyze-string select="string-join(.//*[name() = 'idno' or name() = 'bibl']//text())" regex="(15\sH\s\d+)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:if test="$id != ''">
            <xsl:choose>
                <!--in case of multiple originals with images and same id, assume the first 2 images are for the first, the next 2 for the 2nd, etc.-->
                <xsl:when test="count(ancestor::TEI/facsimile/graphic[contains(@url/data(), replace($id, ' ', '_'))]) > 2">
                    <xsl:apply-templates select="ancestor::TEI/facsimile/graphic[contains(@url/data(), replace($id, ' ', '_'))][$pos * 2 - 1]"/>
                    <xsl:apply-templates select="ancestor::TEI/facsimile/graphic[contains(@url/data(), replace($id, ' ', '_'))][$pos * 2]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="ancestor::TEI/facsimile/graphic[contains(@url/data(), replace($id, ' ', '_'))]"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="bibl-key">
        <xsl:param name="key" required="yes"/>
        <xsl:variable name="bibl-file" select="doc('../biblio.xml')"/>
        <xsl:apply-templates select="$bibl-file//biblStruct[@xml:id = $key]/analytic"/>
        <xsl:if test="$bibl-file//biblStruct[@xml:id = $key]/analytic">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="$bibl-file//biblStruct[@xml:id = $key]/monogr"/>
        <!--<xsl:if test="$bibl-file//biblStruct[@xml:id = $key]/note">
            <xsl:text>, </xsl:text>
        </xsl:if>-->
        <xsl:apply-templates select="$bibl-file//biblStruct[@xml:id = $key]/note"/>
    </xsl:template>
    
</xsl:stylesheet>