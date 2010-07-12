<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:src="http://purl.oclc.org/dsdl/9573-11amd1/ns/structure/1.0"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="toc">
    <h1>Contents</h1>
    <ul>
      <xsl:apply-templates
        select="src:foreword|src:introduction|src:scope|src:conf|src:normative-references|src:terms-and-definitions|//src:clause|src:annex|src:bibliography|src:index" mode="toc" />
    </ul>
  </xsl:template>
  <xsl:template match="src:foreword" mode="toc">
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
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc">foreword</xsl:with-param>
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </li>
  </xsl:template>
  <xsl:template match="src:introduction" mode="toc">
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc">introduction</xsl:with-param>
        <xsl:with-param name="text">Introduction</xsl:with-param>
      </xsl:call-template>
    </li>
  </xsl:template>
  <xsl:template name="link-text">
    <xsl:param name="anc" />
    <xsl:param name="text" />
    <a href="#{$anc}">
      <xsl:value-of select="$text" />
    </a>
  </xsl:template>
  <xsl:template match="src:scope" mode="toc">
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
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', $text)" />
      </xsl:call-template>
    </li>
  </xsl:template>
  <xsl:template match="src:conf">
    <!-- contents: { titled-clause } -->
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="src:normative-references" mode="toc">
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
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', $text)" />
      </xsl:call-template>
    </li>
  </xsl:template>
  <xsl:template match="src:terms-and-definitions" mode="toc">
    <xsl:variable name="nth">
      <xsl:number level="multiple" count="src:scope|src:conf|src:normative-references|src:terms-and-definitions|clause" />
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
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', $text)" />
      </xsl:call-template>
    </li>
  </xsl:template>
  <xsl:template match="src:clause" mode="toc">
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
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', src:title)" />
      </xsl:call-template>
    </li>
  </xsl:template>
  <xsl:template match="src:annex" mode="toc">
    <xsl:variable name="nth">
      <xsl:number level="multiple" count="src:annex" format="A" />
    </xsl:variable>
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc" select="$nth" />
        <xsl:with-param name="text" select="concat($nth, ' ', src:title)" />
      </xsl:call-template>
    </li>
  </xsl:template>
  <xsl:template match="src:bibliography" mode="toc">
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
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc">bibliography</xsl:with-param>
        <xsl:with-param name="text" select="$text" />
      </xsl:call-template>
    </li>
  </xsl:template>
  <xsl:template match="src:index" mode="toc">
    <li>
      <xsl:call-template name="link-text">
        <xsl:with-param name="anc">index</xsl:with-param>
        <xsl:with-param name="text">Index</xsl:with-param>
      </xsl:call-template>
    </li>
  </xsl:template>
</xsl:stylesheet>
