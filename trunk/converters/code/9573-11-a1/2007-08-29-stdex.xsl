<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:src="http://purl.oclc.org/dsdl/9573-11amd1/ns/structure/1.0"
  xmlns="http://www.w3.org/1999/xhtml">
  <xsl:import href="stdex_front.xsl" />
  <xsl:import href="stdex_toc.xsl" />
  <xsl:import href="stdex_back.xsl" />
  <xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.0//EN" encoding="UTF-8" />
  <!-- XSLT stylesheet for ISO/IEC stdex.rnc -->
  <!-- version.0.51 -->
  <xsl:template match="/">
    <!-- contents: { document } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="/src:document">
    <!-- contents: { head, body } -->
    <html>
      <head>
        <title>ISO/IEC IT --- Ver.0.50 ---</title>
      </head>
      <link rel="stylesheet" href="stdex.css" type="text/css"  />
      <body>
        <xsl:call-template name="frontm" />
        <hr />
        <xsl:call-template name="toc" />
        <hr />
        <xsl:apply-templates />
        <xsl:call-template name="backm" />
      </body>
    </html>
  </xsl:template>
  <xsl:template match="src:head">
    <!-- contents: { organization & ... } -->
  </xsl:template>
  <xsl:template match="src:foreword">
    <!-- contents: { block*, part-list? } -->
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="/src:document/src:head/src:document-language='E'">
          <xsl:text>Foreword</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Avant-propos</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h1>
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc">foreword</xsl:with-param>
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </h1>
    <xsl:apply-templates />
    <hr />
  </xsl:template>
  <xsl:template match="src:part-list">
    <!-- contents: { part+ } -->
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>
  <xsl:template match="src:part">
    <!-- contents: { number, title } -->
    <li>
      <span class="italic">
        <xsl:text>-&#160;Part&#160;</xsl:text>
        <xsl:apply-templates select="src:number"/>
        <xsl:text>:&#160;</xsl:text>
        <xsl:apply-templates select="src:title"/>
      </span>
    </li>
  </xsl:template>
  <xsl:template match="src:part/src:number">
    <!-- contents: { positive-integer } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:part/src:title">
    <!-- contents: { text } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:introduction">
    <!-- contents: { block } -->
    <h1>
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc">introduction</xsl:with-param>
        <xsl:with-param name="text">Introduction</xsl:with-param>
      </xsl:call-template>
    </h1>
    <xsl:apply-templates />
    <hr />
  </xsl:template>
  <xsl:template name="anchor-text">
    <xsl:param name="anc" />
    <xsl:param name="text" />
    <span id="{$anc}">
      <xsl:value-of select="$text" />
    </span>
  </xsl:template>
  <xsl:template match="src:warning">
    <!-- contents: { attlist.warning, p* } -->
    <xsl:text>WARNING-</xsl:text>
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:scope">
    <!-- contents: { block } -->
    <xsl:variable name="nth">
      <xsl:number level="multiple" count="src:scope|src:conf|src:normative-references|src:terms-and-definitions|src:clause" />
    </xsl:variable>
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="/src:document/src:head/src:document-language='E'">
          <xsl:text>Scope</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Domaine d'application</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h1>
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', $text)" />
      </xsl:call-template>
    </h1>
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:conf">
    <!-- contents: { titled-clause } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:normative-references">
    <!-- contents: { block*, referenced-document+ } -->
    <xsl:variable name="nth">
      <xsl:number level="multiple" count="src:scope|src:conf|src:normative-references|src:terms-and-definitions|src:clause" />
    </xsl:variable>
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="/src:document/src:head/src:document-language='E'">
          <xsl:text>Normative references</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>R&#233;f&#233;rences normatives</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h1>
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', $text)" />
      </xsl:call-template>
    </h1>
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:referenced-document">
    <!-- contents: { id, abbrev, title, field*, url } -->
    <dl>
      <dd>
        <xsl:apply-templates />
      </dd>
    </dl>
  </xsl:template>
  <xsl:template match="src:abbrev">
    <xsl:apply-templates />
    <xsl:text>, </xsl:text>
  </xsl:template>
  <xsl:template match="src:referenced-document/src:title">
    <span class="italic">
      <xsl:apply-templates />
    </span>
  </xsl:template>
  <xsl:template match="src:terms-and-definitions">
    <!-- contents: { terms-and-definitions-content } -->
    <xsl:variable name="nth">
      <xsl:number level="multiple" count="src:scope|src:conf|src:normative-references|src:terms-and-definitions|src:clause" />
    </xsl:variable>
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="/src:document/src:head/src:document-language='E'">
          <xsl:text>Terms and definitions</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Termes, d&#233;finitions et symboles</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h1>
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', $text)" />
      </xsl:call-template>
    </h1>
    <dl>
      <xsl:apply-templates />
    </dl>
  </xsl:template>
  <xsl:template match="src:term-and-definition">
    <!-- contents: { term, term*, definition, (example, note, warning)* } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:term-and-definition/src:term">
    <!-- contents: { text } -->
    <dt>
      <xsl:apply-templates />
    </dt>
  </xsl:template>
  <xsl:template match="src:term-and-definition/src:definition">
    <!-- contents: { inline } -->
    <dd>
      <xsl:apply-templates />
    </dd>
  </xsl:template>
  <xsl:template match="src:clause">
    <!-- contents: { id, title, clause-content } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:clause/src:title">
    <!-- contents: { text | code } -->
    <xsl:variable name="level" select="count(ancestor::src:clause|ancestor::src:annex)"  />
    <xsl:variable name="nth">
      <xsl:choose>
        <xsl:when test="ancestor::src:annex">
          <xsl:number level="multiple" count="src:annex|src:annex//src:clause" format="A.1" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:number level="multiple" count="src:scope|src:conf|src:normative-references|src:terms-and-definitions|src:clause" format="1.1" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="h{$level}">
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', .)" />
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
  <xsl:template match="src:annex">
    <!-- contents: { id, @normative, title, clause-content } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:annex/src:title">
    <!-- contents: { text | code } -->
    <xsl:variable name="nth">
      <xsl:number level="multiple" count="src:annex" format="A" />
    </xsl:variable>
    <h1 class="annex">
      <xsl:text>Annex </xsl:text>
      <xsl:value-of select="$nth" />
      <br />
      <xsl:choose>
        <xsl:when test="../@normative = 'true'">
          <xsl:text>(normative)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>(informative)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <br />
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </h1>
  </xsl:template>
  <xsl:template match="src:bibliography">
    <!-- contents: { referenced-document+ } -->
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="/src:document/src:head/src:document-language='E'">
          <xsl:text>Bibliography</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Bibliographie</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <h1>
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc">bibliography</xsl:with-param>
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </h1>
    <ol>
      <xsl:apply-templates />
    </ol>
  </xsl:template>
  <xsl:template match="src:bibliography/src:referenced-document">
    <li>
      <xsl:number format="[1] " />
      <xsl:apply-templates />
    </li>
  </xsl:template>
  <xsl:template match="src:index">
    <!-- contents: { attlist.index, text } -->
    <h1>
      <xsl:call-template name="anchor-text">
        <xsl:with-param name="anc">index</xsl:with-param>
        <xsl:with-param name="text">Index</xsl:with-param>
      </xsl:call-template>
    </h1>
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:p">
    <!-- contents: { inline } -->
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  <xsl:template match="src:ol">
    <!-- contents: { li } -->
    <ol>
      <xsl:apply-templates />
    </ol>
  </xsl:template>
  <xsl:template match="src:ol/src:li">
    <!-- contents: { id, block+ } -->
    <xsl:variable name="level" select="count(ancestor::src:ol) mod 3" />
    <xsl:variable name="format">
      <xsl:choose>
        <xsl:when test="$level=1">
          <xsl:text>a) </xsl:text>
        </xsl:when>
        <xsl:when test="$level=2">
          <xsl:text>1) </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>i) </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <xsl:number format="{$format}" />
      <xsl:apply-templates />
    </li>
  </xsl:template>
  <xsl:template match="src:ul">
    <!-- contents: { li } -->
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>
  <xsl:template match="src:ul/src:li">
    <!-- contents: { block+ } -->
    <xsl:variable name="level" select="count(ancestor::src:ul)" />
    <xsl:choose>
      <xsl:when test="$level=2">
        <li>&#183; <xsl:apply-templates /></li>
      </xsl:when>
      <xsl:otherwise>
        <li>- <xsl:apply-templates /></li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="src:notation-list">
    <!-- contents: { notation-item+ } -->
    <dl compact="1">
      <xsl:apply-templates />
    </dl>
  </xsl:template>
  <xsl:template match="src:notation-item">
    <!-- contents: { notation, notation-definition } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:notation">
    <!-- contents: { inline } -->
    <dt>
      <xsl:apply-templates />
    </dt>
  </xsl:template>
  <xsl:template match="src:notation-definition">
    <!-- contents: { p, (p | note)* } -->
    <dd>
      <xsl:apply-templates />
    </dd>
  </xsl:template>
  <xsl:template match="src:example">
    <!-- contents: { p+ } -->
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="/src:document/src:head/src:document-language='E'">
          <xsl:text>EXAMPLE</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>EXEMPLE</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p>
      <xsl:value-of select="$text" />
      <xsl:text> </xsl:text>
      <xsl:if test="count(../src:xmp) &gt; 1">
        <xsl:number level="single" count="src:xmp" format="1 " />
      </xsl:if>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  <xsl:template match="src:note">
    <!-- contents: { p+ } -->
    <p class="note">
      <xsl:text>NOTE&#160;&#160;</xsl:text>
      <xsl:if test="count(../src:note) &gt; 1">
        <xsl:number level="single" count="src:note" format="1 " />
      </xsl:if>
      <xsl:apply-templates />
    </p>
  </xsl:template>
  <xsl:template match="src:code">
    <!-- contents: { text } -->
    <code>
      <xsl:apply-templates />
    </code>
  </xsl:template>
  <xsl:template match="src:b">
    <!-- contents: { text } -->
    <b>
      <xsl:apply-templates />
    </b>
  </xsl:template>
  <xsl:template match="src:i">
    <!-- contents: { text } -->
    <span class="italic">
      <xsl:apply-templates />
    </span>
  </xsl:template>
  <xsl:template match="src:u">
    <!-- contents: { text } -->
    <u>
      <xsl:apply-templates />
    </u>
  </xsl:template>
  <xsl:template match="src:sup">
    <!-- contents: { text } -->
    <sup>
      <xsl:apply-templates />
    </sup>
  </xsl:template>
  <xsl:template match="src:sub">
    <!-- contents: { text } -->
    <sub>
      <xsl:apply-templates />
    </sub>
  </xsl:template>
  <xsl:template match="src:var">
    <!-- contents: { text } -->
    <var>
      <xsl:apply-templates />
    </var>
  </xsl:template>
  <xsl:template match="src:This | src:this">
    <!-- contents: { empty } -->
    <!-- F: la pr&#233;sente Norme internationale -->
    <xsl:choose>
      <xsl:when test="/src:document/src:head/src:part-number">
        <xsl:choose>
          <xsl:when test="/src:document/src:head/src:document-language='E'">
            <xsl:value-of select="local-name()"/>
            <xsl:text> part of </xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:value-of select="/src:document/src:head/src:organization"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="/src:document/src:head/src:document-number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="/src:document/src:head/src:document-language='E'">
            <xsl:value-of select="local-name()"/>
            <xsl:value-of select="/src:document/src:head/src:document-type"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="local-name()='This'">
                <xsl:text>La</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>la</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> pr&#233;sente </xsl:text>
            <xsl:choose>
              <xsl:when test="/src:document/src:head/src:document-type='International Standard'">
                <xsl:text>Norme internationale</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="src:Xref | src:xref">
    <xsl:variable name="to" select="@to" />
    <xsl:for-each select="//src:*[@id=$to]">
      <xsl:call-template name="xref-one" />
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="xref-one">
    <xsl:choose>
      <xsl:when test="self::src:figure">
        <xsl:choose>
          <xsl:when test="ancestor::src:annex">
            <xsl:number level="multiple" count="src:annex|src:figure" format="A.1 " />
          </xsl:when>
          <xsl:otherwise>
            <xsl:number level="any" count="src:figure" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="self::src:table">
        <xsl:choose>
          <xsl:when test="ancestor::src:annex">
            <xsl:number level="multiple" count="src:annex|src:table" format="A.1 " />
          </xsl:when>
          <xsl:otherwise>
            <xsl:number level="any" count="src:table" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="self::src:li">
        <xsl:variable name="level" select="count(ancestor::src:ol) mod 3" />
        <xsl:variable name="format">
          <xsl:choose>
            <xsl:when test="$level=1">
              <xsl:text>a) </xsl:text>
            </xsl:when>
            <xsl:when test="$level=2">
              <xsl:text>1) </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>i) </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:number format="{$format}" />
      </xsl:when>
      <xsl:when test="ancestor::src:clause">
        <xsl:number level="multiple" count="src:scope|src:conf|src:normative-references|src:terms-and-definitions|src:clause" format="1.1 " />
      </xsl:when>
      <xsl:when test="self::src:referenced-document">
        <xsl:value-of select="src:abbrev" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:number level="multiple" count="src:annex" format="A.1 " />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="src:firstterm">
    <!-- contents: { text } -->
      <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:strong">
    <!-- contents: { text } -->
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>
  <xsl:template match="src:artwork">
    <!-- contents: { attlist.artwork } -->
    <img src="{@entity}.jpg" />
  </xsl:template>
  <xsl:template match="src:footnote">
    <!-- contents: { id, (text | p)+ } -->
    <xsl:element name="a">
      <xsl:attribute name="onClick">
        <xsl:text>alert('</xsl:text>
        <xsl:call-template name="fn-mark" />
        <xsl:apply-templates />
        <xsl:text>')</xsl:text>
      </xsl:attribute>
      <sup>
        <xsl:call-template name="fn-mark" />
      </sup>
    </xsl:element>
  </xsl:template>
  <xsl:template name="fn-mark">
    <xsl:choose>
      <xsl:when test="ancestor::src:figure">
        <xsl:number level="single" count="src:fn" format="a) " />
      </xsl:when>
      <xsl:when test="ancestor::src:table">
        <xsl:number level="single" count="src:fn" format="a) " />
      </xsl:when>
      <xsl:otherwise>
        <xsl:number value="count(preceding::src:fn)-count(preceding::src:fn[ancestor::src:figure or
          ancestor::src:table])+1" format="1) " />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="src:table">
    <!-- contents: { @pgwide, title?, block+ } -->
    <div align="center">
      <xsl:apply-templates />
      <br />
    </div>
  </xsl:template>
  <xsl:template match="src:table/src:title">
    <xsl:variable name="ref">
      <xsl:choose>
        <xsl:when test="ancestor::src:annex">
          <xsl:number level="multiple" count="src:annex|src:table" format="A.1 " />
        </xsl:when>
        <xsl:otherwise>
          <xsl:number level="any" count="src:table" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="/src:document/src:head/src:document-language='E'">
          <xsl:text>Table</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Tableau</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- caption -->
      <b>
        <span id="tab{$ref}">
          <xsl:value-of select="concat($text, ' ', $ref)" /> &#8211; <xsl:value-of select="." />
        </span>
      </b>
    <!-- /caption -->
  </xsl:template>
  <xsl:template match="src:figure">
    <!-- contents: { @pgwide, title?, block+ } -->
    <div align="center">
      <xsl:apply-templates select="*[not(self::src:title)]"/>
      <xsl:apply-templates select="src:title"/>
    </div>
  </xsl:template>
  <xsl:template match="src:figure/src:title">
    <xsl:variable name="ref">
      <xsl:choose>
        <xsl:when test="ancestor::src:annex">
          <xsl:number level="multiple" count="src:annex|src:figure" format="A.1 " />
        </xsl:when>
        <xsl:otherwise>
          <xsl:number level="any" count="src:figure" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div align="center">
      <b>
        <span id="fig{$ref}">
          <xsl:text>Figure </xsl:text>
          <xsl:value-of select="$ref" /> &#8211; <xsl:value-of select="." />
        </span>
      </b>
    </div>
  </xsl:template>
  <xsl:template match="src:tabular">
    <table>
      <xsl:choose>
        <xsl:when test="@frame=&quot;none&quot;" />
        <xsl:otherwise>
          <xsl:attribute name="border" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates />
    </table>
  </xsl:template>
  <xsl:template match="src:tgroup">
    <xsl:apply-templates select="src:colspec" />
    <xsl:apply-templates select="src:thead" />
    <xsl:apply-templates select="src:tbody" />
    <xsl:apply-templates select="src:tfoot" />
    <tr>
      <td colspan="100">
        <xsl:apply-templates select=".//src:note" />
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="src:colspec" />
  <xsl:template match="src:thead">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:tbody">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:tfoot">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:row">
    <tr>
      <xsl:choose>
        <xsl:when test="parent::src:thead or parent::src:tfoot">
          <xsl:attribute name="bgcolor">#d0d0d0</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="@valign">
          <xsl:attribute name="valign">
            <xsl:value-of select="@valign" />
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="parent::src:*[@valign]">
          <xsl:attribute name="valign">
            <xsl:value-of select="parent::src:*[@valign]/@valign" />
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="parent::src:thead">
          <xsl:attribute name="valign">bottom</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="valign">top</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="@align">
          <xsl:attribute name="align">
            <xsl:value-of select="@align" />
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="ancestor::src:*[@align]">
          <xsl:attribute name="align">
            <xsl:value-of select="ancestor::src:*[@align]/@align" />
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates />
    </tr>
  </xsl:template>
  <xsl:template match="src:entry">
    <xsl:choose>
      <xsl:when test="ancestor::src:thead">
        <xsl:call-template name="ent">
          <xsl:with-param name="tag">th</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="ent">
          <xsl:with-param name="tag">td</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="ent">
    <xsl:param name="tag" />
    <xsl:element name="{$tag}">
      <xsl:if test="@valign">
        <xsl:attribute name="valign">
          <xsl:value-of select="@valign" />
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@align">
          <xsl:attribute name="align">
            <xsl:value-of select="@align" />
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="ancestor::src:*[@align]">
          <xsl:attribute name="align">
            <xsl:value-of select="ancestor::src:*[@align]/@align" />
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="@morerows">
        <xsl:attribute name="rowspan">
          <xsl:value-of select="@morerows + 1" />
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@namest and @nameend">
        <xsl:call-template name="colspan">
          <xsl:with-param name="namest" select="@namest" />
          <xsl:with-param name="nameend" select="@nameend" />
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>
  <xsl:template name="colspan">
    <xsl:param name="namest" />
    <xsl:param name="nameend" />
    <xsl:call-template name="colspan-sub">
      <xsl:with-param name="numst">
        <xsl:choose>
          <xsl:when test="parent::src:row/preceding-sibling::src:colspec[@colname=$namest]">
            <xsl:value-of
              select="count(parent::src:row/preceding-sibling::src:colspec[@colname=$namest]/preceding-sibling::src:colspec)"
             />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="count(ancestor::src:tgroup/child::src:colspec[@colname=$namest]/preceding-sibling::src:colspec)"
             />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="numend">
        <xsl:choose>
          <xsl:when test="parent::src:row/preceding-sibling::src:colspec[@colname=$nameend]">
            <xsl:value-of
              select="count(parent::src:row/preceding-sibling::src:colspec[@colname=$nameend]/preceding-sibling::src:colspec)"
             />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of
              select="count(ancestor::src:tgroup/child::src:colspec[@colname=$nameend]/preceding-sibling::src:colspec)"
             />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="colspan-sub">
    <xsl:param name="numst" />
    <xsl:param name="numend" />
    <xsl:attribute name="colspan">
      <xsl:value-of select="$numend - $numst + 1" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:if test="normalize-space(.)!=' '">
      <xsl:value-of select="." />
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>