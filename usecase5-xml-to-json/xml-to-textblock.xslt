<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <!-- Parameters -->
  <xsl:param name="filename" />

  <xsl:template match="/">
    <xsl:apply-templates select="toolexchange/action"/>
  </xsl:template>

  <xsl:template match="action">
    <xsl:text>Boost.Locker Aktion </xsl:text>
    <xsl:value-of select="eventtype"/>
    <xsl:text>
* Locker-ID          : </xsl:text>
    <xsl:value-of select="substring-before($filename, '_')"/>
    <xsl:text>
* Kostenstelle       : </xsl:text>
    <xsl:choose>
      <xsl:when test="string(cost_center_id_defect)">
        <xsl:value-of select="cost_center_id_defect"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="cost_center_id_replacement"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>
* Hersteller (Defekt): </xsl:text>
    <xsl:value-of select="manufacturer_defect"/>
    <xsl:text>
* Hersteller (Neu)   : </xsl:text>
    <xsl:value-of select="manufacturer_replacement"/>
    <xsl:text>
* Modell (Defekt)    : </xsl:text>
    <xsl:value-of select="model_defect"/>
    <xsl:text>
* Modell (Neu)       : </xsl:text>
    <xsl:value-of select="model_replacement"/>
    <xsl:text>
* Inventarnr.(Defekt): </xsl:text>
    <xsl:value-of select="inventory_id_defect"/>
    <xsl:text>
* Inventarnr.(Neu)   : </xsl:text>
    <xsl:value-of select="inventory_id_replacement"/>
    <xsl:text>
* Ausweis/Karte      : </xsl:text>
    <xsl:value-of select="employee_id_defect"/>
    <xsl:text>
* Zeitpunkt Bewegung : </xsl:text>
    <xsl:value-of select="eventtime"/>
    <xsl:text>
* Replacement-Token  : </xsl:text>
    <xsl:value-of select="replacement_token"/>
    <xsl:text>
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
