<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:src="http://purl.oclc.org/dsdl/9573-11amd1/ns/structure/1.0"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template name="backm">
    <!-- back matter -->
    <hr />
    <xsl:apply-templates select="src:head" mode="backm" />
  </xsl:template>
  <xsl:template match="src:head" mode="backm">
    <div class="backm">
      <xsl:text>ICS </xsl:text>
      <!-- *** xsl:for-each select="classifn">
        <xsl:call-template name="listel">
          <xsl:with-param name="delimchar">:</xsl:with-param>
          <xsl:with-param name="termchar" />
        </xsl:call-template>
      </xsl:for-each *** -->
    </div>
    <br />
    <xsl:if test="src:keyword">
      <div class="keyword">
        <b>
          <xsl:text>Descripters: </xsl:text>
        </b>
        <xsl:for-each select="src:keyword">
          <xsl:call-template name="listel">
            <xsl:with-param name="delimchar">, </xsl:with-param>
            <xsl:with-param name="termchar">.</xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </div>
    </xsl:if>
    <hr />
  </xsl:template>
  <xsl:template name="listel">
    <xsl:param name="delimchar" />
    <xsl:param name="termchar" />
    <xsl:apply-templates />
    <xsl:choose>
      <xsl:when test="position()=last()">
        <xsl:value-of select="$termchar" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$delimchar" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
