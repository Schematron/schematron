<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:src="http://purl.oclc.org/dsdl/9573-11amd1/ns/structure/1.0"
  xmlns="http://www.w3.org/1999/xhtml">
  <xsl:template name="frontm">
    <!-- front matter -->
    <xsl:apply-templates select="src:head" mode="frontm" />
  </xsl:template>
  <xsl:template match="src:head" mode="frontm">
    <!-- head for front matter -->
    <xsl:variable name="lang" select="src:document-language/text()" />
    <div class="title">
      <xsl:variable name="title">
        <xsl:choose>
          <xsl:when test="src:document-type='International Standard'">
            <xsl:choose>
              <xsl:when test="src:document-language='E'">
                <xsl:value-of select="src:document-type"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Norme Internationale</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="capitalize">
        <xsl:with-param name="str" select="$title" />
      </xsl:call-template>
      <div align="right">
        <xsl:value-of select="src:organization" />
        <xsl:value-of select="src:document-number" />
        <xsl:if test="src:part-number">
          <xsl:text>-</xsl:text>
          <xsl:value-of select="src:part-number" />
        </xsl:if>
        <br />
        <!-- div class="edition">
          <xsl:value-of select="src:edition" />
          <xsl:text> edition</xsl:text>
        </div *** -->
        <br />
        <div class="date">
          <xsl:value-of select="src:date" />
        </div>
      </div>
      <xsl:apply-templates select="src:title[@langcode=$lang]" mode="frontm" />
    </div>
    <br />
    <div class="subtitle">
      <xsl:apply-templates select="src:title[@langcode!=$lang]" mode="frontm" />
    </div>
    <br />
    <br />
    <div align="right">
      <div class="refnum">
        <xsl:choose>
          <xsl:when test="/src:document/src:head/src:document-language='E'">
            <xsl:text>Reference number</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Num&#233;ro de r&#233;f&#233;rence</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <br />
        <xsl:call-template name="refnum" />
      </div>
    </div>
  </xsl:template>
  <xsl:template name="capitalize">
    <xsl:param name="str"/>
    <xsl:value-of select="translate($str, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
  </xsl:template>
  <xsl:template match="src:title" mode="frontm">
    <xsl:apply-templates mode="frontm" />
  </xsl:template>
  <xsl:template match="src:introductory" mode="frontm">
    <xsl:apply-templates />
    <br />
  </xsl:template>
  <xsl:template match="src:main" mode="frontm">
    <xsl:apply-templates />
    <br />
  </xsl:template>
  <xsl:template match="src:complementary" mode="frontm">
    <xsl:call-template name="part">
      <xsl:with-param name="lang" select="../@langcode" />
    </xsl:call-template>
    <xsl:value-of select="../../src:part-number" />
    <xsl:text>:</xsl:text>
    <br />
    <xsl:apply-templates />
    <br />
  </xsl:template>
  <xsl:template name="part">
    <xsl:param name="lang" />
    <xsl:choose>
      <xsl:when test="$lang='E'">
        <xsl:text>Part</xsl:text>
      </xsl:when>
      <xsl:when test="$lang='F'">
        <xsl:text>Partie</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="refnum">
    <xsl:value-of select="src:organization" />
    <xsl:value-of select="src:document-number" />
    <xsl:if test="src:part-number">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="src:part-number" />
    </xsl:if>
    <xsl:text>:</xsl:text>
    <xsl:variable name="date" select="src:date" />
    <xsl:value-of select="substring($date, 0, 5)" />
    <xsl:text>(</xsl:text>
    <xsl:value-of select="src:document-language" />
    <xsl:text>)</xsl:text>
  </xsl:template>
</xsl:stylesheet>
