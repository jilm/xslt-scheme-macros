<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svg="http://www.w3.org/2000/svg" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">


  <xsl:variable name="scale" select="/schema/@scale" as="xs:double" />

  <xsl:variable name="paper" select="/schema/@template" />

  <xsl:variable name="paper-width" as="xs:double">
    <xsl:choose>
      <xsl:when test="$paper='A3P'">297</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="paper-height" as="xs:double">
    <xsl:choose>
      <xsl:when test="$paper='A3P'">420</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="multiplier" as="xs:double">10</xsl:variable>
  <xsl:variable name="paper-margin" as="xs:double">5</xsl:variable>
  <xsl:variable name="paper-margin-left" as="xs:double">10</xsl:variable>
  <xsl:variable name="frame-width" as="xs:double">5</xsl:variable>
  
  <xsl:variable name="content-width"
                as="xs:double"
                select="$paper-width - $paper-margin-left - $paper-margin - 2 * $frame-width" />

  <xsl:variable name="content-height"
                as="xs:double"
                select="$paper-height - 2 * $paper-margin - 2 * $frame-width" />

  <xsl:variable name="component-specifications"
                select="doc('comp.xml')/list/*" />


  <xsl:include href="makeA3P.xsl" />
  <xsl:include href="makeDistributionBoard.xsl" />

</xsl:stylesheet>