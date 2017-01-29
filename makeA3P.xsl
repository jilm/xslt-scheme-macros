<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svg="http://www.w3.org/2000/svg" 
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:my="http://www.lidinsky.cz"
                version="2.0">


  <xsl:template match="schema">

    
      <xsl:call-template name="make-schema-frame" >
      </xsl:call-template>    


  </xsl:template>


  
  <!--

        It creates the schema frame

  -->
  <xsl:template name="make-schema-frame">

    <xsl:param    name="paper-margin" />
    <xsl:param    name="paper-left-margin" />
    <xsl:param    name="paper-right-margin" />
    <xsl:param    name="paper-top-margin" />
    <xsl:param    name="paper-bottom-margin" />

    <xsl:variable name="width" select="$paper-width * $multiplier" />
    <xsl:variable name="height" select="$paper-height * $multiplier" />

    <xsl:variable name="left-margin"
      select="($paper-left-margin, $paper-margin, 10)[string-length() gt 0][1] * $multiplier" />
    <xsl:variable name="right-margin"
      select="($paper-right-margin, $paper-margin, 5)[string-length() gt 0][1] * $multiplier" />    
    <xsl:variable name="top-margin"
      select="($paper-top-margin, $paper-margin, 5)[string-length() gt 0][1] * $multiplier" />    
    <xsl:variable name="bottom-margin"
      select="($paper-bottom-margin, $paper-margin, 5)[string-length() gt 0][1] * $multiplier" />

    <!-- outer frame coordinates -->
    <xsl:variable name="outer-frame-x" select="$left-margin" />
    <xsl:variable name="outer-frame-y" select="$top-margin" />
    <xsl:variable name="outer-frame-width"
                  select="$width - $left-margin - $right-margin" />
    <xsl:variable name="outer-frame-height"
                  select="$height - $top-margin - $bottom-margin" />

    <!-- frame width -->
    <xsl:variable name="paper-frame-width">5</xsl:variable>
    <xsl:variable name="frame-width"
                  select="$paper-frame-width * $multiplier" />

    <!-- inner frame coordinates -->
    <xsl:variable name="inner-frame-x"
                  select="$outer-frame-x + $frame-width" />
    <xsl:variable name="inner-frame-y"
                  select="$outer-frame-y + $frame-width" />
    <xsl:variable name="inner-frame-width"
                  select="$outer-frame-width - $frame-width - $frame-width" />
    <xsl:variable name="inner-frame-height"
                  select="$outer-frame-height - $frame-width - $frame-width" />
    
    
<xsl:processing-instruction name="xml-stylesheet">type="text/css" href="schema.css"</xsl:processing-instruction>


    <svg:svg>


      <xsl:attribute name="width">
        <xsl:value-of select="concat(string($paper-width), 'mm')" />
      </xsl:attribute>

      <xsl:attribute name="height">
        <xsl:value-of select="concat(string($paper-height), 'mm')" />
      </xsl:attribute>

      <xsl:attribute name="viewBox">
        <xsl:value-of select="concat('0 0 ', $width, ' ', $height)" />
      </xsl:attribute>


      <xsl:copy-of select="doc('symbolGF0_5.svg')/svg:defs" />

      <!-- Paper frame -->      
      <svg:rect x="0" y="0" class="mid-line">
        <xsl:attribute name="width" select="$width" />
        <xsl:attribute name="height" select="$height" />
      </svg:rect>

      <!-- Cut marks -->
      <svg:path d="M0,0 100,0 100,50 50,50 50,50 50,100 0,100z"
                id="_cut_mark_"
                style="stroke:none;fill:#000000;" />
      <svg:use xlink:href="#_cut_mark_">
        <xsl:attribute name="transform"
          select="my:rotate-translate(90, $width, 0)" />
      </svg:use>
      <svg:use xlink:href="#_cut_mark_">
        <xsl:attribute name="transform"
          select="my:rotate-translate(270, 0, $height)" />
      </svg:use>
      <svg:use xlink:href="#_cut_mark_">
        <xsl:attribute name="transform"
          select="my:rotate-translate(180, $width, $height)" />
      </svg:use>
      

      <!-- Outer frame -->
      <svg:rect class="mid-line">
        <xsl:attribute name="x" select="$outer-frame-x" />
        <xsl:attribute name="y" select="$outer-frame-y" />
        <xsl:attribute name="width" select="$outer-frame-width" />
        <xsl:attribute name="height" select="$outer-frame-height" />
      </svg:rect>

      <!-- Inner frame -->
      <svg:rect class="bold-line">
        <xsl:attribute name="x" select="$inner-frame-x" />
        <xsl:attribute name="y" select="$inner-frame-y" />
        <xsl:attribute name="width" select="$inner-frame-width" />
        <xsl:attribute name="height" select="$inner-frame-height" />
      </svg:rect>

      <!-- Center marks -->
      <svg:path class="bold-line">
        <xsl:attribute name="d" 
          select="concat('M', 0.5 * $inner-frame-width + $inner-frame-x, ',', $outer-frame-y, ' l0,100')" />
      </svg:path>
      <svg:path class="bold-line">
        <xsl:attribute name="d" 
          select="concat('M', 0.5 * $inner-frame-width + $inner-frame-x, ',', $outer-frame-y + $outer-frame-height, ' l0,-100')" />
      </svg:path>
      <svg:path class="bold-line">
        <xsl:attribute name="d" 
          select="concat('M', $outer-frame-x, ',', 0.5 * $inner-frame-height + $inner-frame-y, ' l100,0')" />
      </svg:path>
      <svg:path class="bold-line">
        <xsl:attribute name="d" 
          select="concat('M', $outer-frame-x + $outer-frame-width, ',', 0.5 * $inner-frame-height + $inner-frame-y, ' l-100,0')" />
      </svg:path>

    <!-- Orientacni stredove znacky -->
    <svg:g >
      <xsl:attribute name="transform" select="my:rotate-translate(180, $inner-frame-x + $inner-frame-width, $inner-frame-y + 0.5 * $inner-frame-height)" />
      <svg:path id="_triangle_mark_" d="M0,0 L60,34.62 L60,-34.62z" class="mid-line" transform="translate(-25,0)" />
    </svg:g>
    <svg:use xlink:href="#_triangle_mark_" transform="translate(2175,2900)rotate(270)" >
      <xsl:attribute name="transform" select="my:rotate-translate(270, $inner-frame-x + 0.5 * $inner-frame-width, $inner-frame-y + $inner-frame-height)" />
    </svg:use>

      <!-- Coordinates -->
      <svg:g>
        <xsl:attribute name="transform"
          select="concat('translate(', $inner-frame-x, ',', $outer-frame-y, ')')" /> 
        <xsl:call-template name="make-schema-frame-horizontal-coord">
          <xsl:with-param name="inner-width" select="$inner-frame-width" />
        </xsl:call-template>
      </svg:g>
      <svg:g>
        <xsl:attribute name="transform"
          select="my:translate($inner-frame-x, $outer-frame-height)"/>
        <xsl:call-template name="make-schema-frame-horizontal-coord">
          <xsl:with-param name="inner-width" select="$inner-frame-width" />
        </xsl:call-template>
      </svg:g>
      <svg:g>
        <xsl:attribute name="transform"
          select="my:translate($outer-frame-x, $inner-frame-y)"/>
        <xsl:call-template name="make-schema-frame-vertical-coord">
          <xsl:with-param name="inner-height" select="$inner-frame-height" />
        </xsl:call-template>
      </svg:g>
      <svg:g>
        <xsl:attribute name="transform"
          select="my:translate($inner-frame-x + $inner-frame-width, $inner-frame-y)"/>
        <xsl:call-template name="make-schema-frame-vertical-coord">
          <xsl:with-param name="inner-height" select="$inner-frame-height" />
        </xsl:call-template>
      </svg:g>

      <!-- Schema content -->
      <svg:g>
        <xsl:attribute name="transform">
          <xsl:value-of select="concat('translate(', $inner-frame-x, ',', $inner-frame-y, ')')" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svg:g>

    </svg:svg>

  </xsl:template>


  <xsl:template name="make-schema-frame-head">
    <xsl:param name="paper-width" />
    <xsl:param name="paper-height" />
    <xsl:param name="width" />
    <xsl:param name="height" />


  </xsl:template>


  <xsl:template name="make-frame">
    <xsl:param name="width" />
    <xsl:param name="height" />
    <svg:rect x="0" y="0">
      <xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
      <xsl:attribute name="height"><xsl:value-of select="$height" /></xsl:attribute>
    </svg:rect>
  </xsl:template>

  <xsl:template name="make-schema-frame-horizontal-coord">
    <xsl:param name="inner-width" as="xs:double" />
    <xsl:variable name="cell-size" select="50 * $multiplier" as="xs:double" />
    <xsl:variable name="cells" as="xs:integer"
         select="my:calculate-cells($inner-width, $cell-size)" />
    <xsl:variable name="x"
         select="($inner-width - $cells * $cell-size) * 0.5" />
    <xsl:for-each select="0 to ($cells)">
      <svg:line y1="0" class="mid-line" >
        <xsl:attribute name="y2" select="$frame-width * $multiplier" />
        <xsl:attribute name="x1" select="$x + . * $cell-size" />
        <xsl:attribute name="x2" select="$x + . * $cell-size" />
      </svg:line>
      <svg:text y="40" style="text-anchor:middle;" class="small-text">
        <xsl:attribute name="x" select="$x + (. - 0.5) * $cell-size" />
        <xsl:value-of select=". + 1" />
      </svg:text>
    </xsl:for-each>
    <svg:text y="40" style="text-anchor:middle;" class="small-text">
      <xsl:attribute name="x" select="$x + ($cells + 0.5) * $cell-size" />
      <xsl:value-of select="$cells + 2" />
    </svg:text>
  </xsl:template>

  <xsl:template name="make-schema-frame-vertical-coord">
    <xsl:param name="inner-height" as="xs:double" />
    <xsl:variable name="cell-size" select="50 * $multiplier" as="xs:double" />
    <xsl:variable name="cells" as="xs:integer"
         select="my:calculate-cells($inner-height, $cell-size)" />
    <xsl:variable name="y"
         select="($inner-height - $cells * $cell-size) * 0.5" />
    <xsl:for-each select="0 to $cells">
      <svg:line x1="0" class="mid-line" >
        <xsl:attribute name="x2" select="$frame-width * $multiplier" />
        <xsl:attribute name="y1" select="$y + . * $cell-size" />
        <xsl:attribute name="y2" select="$y + . * $cell-size" />
      </svg:line>
      <svg:text x="25" style="text-anchor:middle;" class="small-text">
        <xsl:attribute name="y" select="$y + (. - 0.5) * $cell-size" />
        <xsl:value-of select="my:int-to-char(.)" />
      </svg:text>
    </xsl:for-each>
    <svg:text x="25" style="text-anchor:middle;" class="small-text">
      <xsl:attribute name="y" select="$y + ($cells + 0.5) * $cell-size" />
      <xsl:value-of select="my:int-to-char($cells + 1)" />
    </svg:text>
  </xsl:template>
 
  <xsl:function name="my:translate" >
    <xsl:param name="x" />
    <xsl:param name="y" />
    <xsl:value-of select="concat('translate(', $x, ',', $y, ')')" />
  </xsl:function>

  <xsl:function name="my:rotate-translate" >
    <xsl:param name="angle" />
    <xsl:param name="x" />
    <xsl:param name="y" />
    <xsl:value-of
      select="concat(my:translate($x, $y), 'rotate(', $angle, ')')" />
  </xsl:function>

  <xsl:function name="my:int-to-char" >
    <xsl:param name="number" as="xs:integer" />
    <xsl:value-of select="codepoints-to-string(string-to-codepoints('A') + $number)" />
  </xsl:function>

  <xsl:function name="my:calculate-cells" as="xs:integer">
    <xsl:param name="size" as="xs:double" />
    <xsl:param name="cell-size" as="xs:double" />
    <xsl:variable name="cells" as="xs:integer"
      select="floor(0.5 * $size div $cell-size) cast as xs:integer" />
    <xsl:variable name="tail" as="xs:double"
      select="0.5 * $size - ($cells * $cell-size)" />
    <xsl:variable name="corrected-cells"  select="if ($tail le (0.6 * $cell-size)) then ($cells - 1) * 2 else $cells * 2" as="xs:integer" />
    <xsl:value-of select="$corrected-cells" />
  </xsl:function>

</xsl:stylesheet>
