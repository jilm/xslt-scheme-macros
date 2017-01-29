<?xml version="1.0" encoding="utf-8"?>

<!--

     Stylesheet which render electric distribution board arrangement schema.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svg="http://www.w3.org/2000/svg" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:my="http://wwww.lidinsky.cz"
                version="2.0">

  <!--

      Top level element of the distribution board definition.

      Attributes:

      * width    - width of the box [mm]; required
      * height   - height of the box [mm]; required
      * rows     - how many rows are there inside the box;
                   optional, default 1
      * distance - distance between rows [mm]; optional,
                   default 150mm
      * modules  - how many modules per row; required

  -->

  <xsl:template match="distribution-board">

    <xsl:variable name="width" select="@width * $multiplier * $scale" />
    <xsl:variable name="height" select="@height * $multiplier * $scale" />
    <xsl:variable name="rows" select="my:getAttribute(@rows, 1)" as="xs:integer" />
    <xsl:variable name="distance" select="my:getAttribute(@distance, 150) * $multiplier * $scale" />
    <xsl:variable name="top" select="($height - (($rows - 1) * $distance)) * 0.5" />
    <xsl:variable name="modules" select="@modules" />

    <svg:rect x="0" y="0" class="mid-line">
      <xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
      <xsl:attribute name="height"><xsl:value-of select="$height" /></xsl:attribute>
    </svg:rect>

    <xsl:call-template name="distribution-board-row">
      <xsl:with-param name="counter" select="$rows" />
      <xsl:with-param name="top" select="$top" />
      <xsl:with-param name="distance" select="$distance" />
      <xsl:with-param name="width" select="$width" />
      <xsl:with-param name="modules" select="$modules" />
      <xsl:with-param name="rows" select="$rows" />
    </xsl:call-template>

  </xsl:template>


  <!--

      Render one row of the electric distribution board.

  -->
  
  <xsl:template name="distribution-board-row">

    <xsl:param name="counter" />
    <xsl:param name="top" />
    <xsl:param name="distance" as="xs:double" />
    <xsl:param name="width" as="xs:double" />
    <xsl:param name="modules" as="xs:double" />
    <xsl:param name="rows" />
    <xsl:variable name="module" as="xs:double">18</xsl:variable>
    <xsl:variable name="din-width" select="$module * $modules * $multiplier * $scale" />
    <xsl:variable name="din-height" select="35 * $multiplier * $scale" />
    <xsl:variable name="din-x" select="($width - $din-width) * 0.5" />
    <xsl:variable name="din-y" select="-1 * ($din-height * 0.5)" />
    <xsl:variable name="row-number" select="$rows - $counter + 1" />

    <xsl:if test="$counter > 0" >

      <svg:g>
        <xsl:attribute name="transform" select="concat('translate(', 0, ',', $top, ')')" />

        <svg:line x1="-50" y1="0" y2="0" class="thin-line dash-line">
          <xsl:attribute name="x2"><xsl:value-of select="$width + 50" /></xsl:attribute>
        </svg:line>

        <svg:rect x="0" class="mid-line">
          <xsl:attribute name="x"><xsl:value-of select="$din-x" /></xsl:attribute>
          <xsl:attribute name="y"><xsl:value-of select="$din-y" /></xsl:attribute>
          <xsl:attribute name="width"><xsl:value-of select="$din-width" /></xsl:attribute>
          <xsl:attribute name="height"><xsl:value-of select="$din-height" /></xsl:attribute>
        </svg:rect>

        <svg:g>
          <xsl:attribute name="transform" select="concat('translate(', $din-x, ',0)')" />
          <xsl:apply-templates select="row[$row-number]" />
        </svg:g>

      </svg:g>

      <xsl:call-template name="distribution-board-row">
        <xsl:with-param name="counter" select="$counter - 1" />
        <xsl:with-param name="top" select="$top + $distance" />
        <xsl:with-param name="distance" select="$distance" />
        <xsl:with-param name="width" select="$width" />
        <xsl:with-param name="rows" select="$rows" />
        <xsl:with-param name="modules" select="$modules" />
      </xsl:call-template>

    </xsl:if>
    

  </xsl:template>


  <xsl:template match="row">
    <xsl:variable name="nodes" select="*" />
    <xsl:variable name="firstone" select="$nodes[1]" />
    <xsl:call-template name="distribution-board-place-component">
      <xsl:with-param name="components" select="./*" />
      <xsl:with-param name="x">0</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!--

      Render one component.

  -->

  <xsl:template name="distribution-board-place-component">

    <!-- A set of component nodes that need to be placed in one row. -->
    <xsl:param name="components" />
    <!-- X coordinate of the first component in the set. -->
    <xsl:param name="x" />
    <xsl:param name="min-y" select="-0.5 * 35 * $multiplier * $scale"/>
    <xsl:param name="labels" select="()" />

    
    <xsl:choose>

      <!-- if there are no more components to render, place the labels --> 
      <xsl:when test="empty($components)">
        <svg:g>
          <xsl:attribute name="transform">
            <xsl:value-of select="concat('translate(0, ', $min-y, ')')" />
          </xsl:attribute>
          <xsl:copy-of select="$labels" />
        </svg:g>
      </xsl:when>

      <!-- place one component --> 
      <xsl:otherwise>

        <!-- take component to place -->
        <xsl:variable name="component" select="$components[1]" />

        <!-- find out the width of the component -->
        <xsl:variable name="width">
          <xsl:choose>
            <!-- The width may be either explicitly specified -->
            <xsl:when test="exists($component/@width)" >
              <xsl:value-of select="$component/@width * $scale * $multiplier" />
            </xsl:when>
            <!-- Or it may be in the component database -->
            <xsl:when test="local-name($component) = 'part'">
              <xsl:value-of select="$component-specifications[@id=$component/@href]/dimension/@width * $scale * $multiplier" />
            </xsl:when>
            <!-- Or use default width -->
            <xsl:otherwise>
              <xsl:value-of select="18 * $scale * $multiplier" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <!-- find out the height of the component -->
        <xsl:variable name="height">
          <xsl:choose>
            <xsl:when test="exists($component/@height)" >
              <xsl:value-of select="$component/@height * $scale * $multiplier" />
            </xsl:when>
            <xsl:when test="local-name($component) = 'part'">
              <xsl:value-of select="$component-specifications[@id=$component/@href]/dimension/@height * $scale * $multiplier" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="0 * $scale * $multiplier" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

      <!-- Finally place the component -->
      <xsl:choose>

        <!-- Component is specified just like a box, in such a case, just draw a rectangle -->
        <xsl:when test="local-name($component) = 'box'">
          <xsl:variable name="y" select="-0.5 * $height" />

          <svg:rect class="mid-line" style="fill:white;">
            <xsl:attribute name="x"><xsl:value-of select="$x" /></xsl:attribute>
            <xsl:attribute name="y"><xsl:value-of select="$y" /></xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="$width" /></xsl:attribute>
            <xsl:attribute name="height"><xsl:value-of select="$height" /></xsl:attribute>
          </svg:rect>
        </xsl:when>

        <!-- Or it may be a reference to the component database -->
        <xsl:when test="local-name($component) = 'part'">
          <svg:use y="0">
            <xsl:attribute name="x"><xsl:value-of select="$x" /></xsl:attribute>
            <xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
              <xsl:value-of select="concat('#', $component/@href)" />
            </xsl:attribute>
          </svg:use>
        </xsl:when>

        <!-- Or it may be just placeholder, in such a case, leave the space blank. -->
        <xsl:when test="local-name($component) = 'glue'">
        </xsl:when>

        <!-- Or it is a group of components that share the label, a terminal block is an example. -->
        <xsl:when test="local-name($component) = 'block'">
        </xsl:when>

      </xsl:choose>

      <!-- label -->
      <xsl:variable name="label">
        <xsl:choose>
          <xsl:when test="exists($component/@label)">
            <svg:text y="-30" class="small-text" style="text-anchor:middle;">
              <xsl:attribute name="x" select="$x + 0.5 * $width" />
              <xsl:value-of select="$component/@label" />
            </svg:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="()" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>


      <!-- Place another component. -->
      <xsl:call-template name="distribution-board-place-component">
        <xsl:with-param name="components" select="remove($components, 1)" />
        <xsl:with-param name="x" select="$x + $width" />
        <xsl:with-param name="min-y" select="min(($min-y, -0.5 * $height))" />
        <xsl:with-param name="labels" select="($labels, $label)" />
      </xsl:call-template>


      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>


  <xsl:function name="my:getAttribute">
    <xsl:param name="attr" />
    <xsl:param name="default" />

    <xsl:choose>
      <xsl:when test="not(empty($attr))">
        <xsl:value-of select="$attr" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1" />
      </xsl:otherwise>
    </xsl:choose>    

  </xsl:function>


</xsl:stylesheet>
