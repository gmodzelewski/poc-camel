<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <!-- Parameters -->
  <xsl:param name="textblock"/>
  <xsl:param name="filename"/>

  <!-- Main template -->
  <xsl:template match="/">
    <xsl:apply-templates select="toolexchange/action"/>
  </xsl:template>

  <xsl:template match="action">
{
    "RETURN": "SMRS/RETURN/CREJOB/BoostLocker",
    "COSTCENTER": "<xsl:choose>
                      <xsl:when test='string(cost_center_id_defect)'>
                          <xsl:value-of select='cost_center_id_defect'/>
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:value-of select='cost_center_id_replacement'/>
                      </xsl:otherwise>
                  </xsl:choose>",
    "REQUESTOR": "Boost.<xsl:value-of select='substring-before($filename, "_")'/>",
    "JOBTEXT": "<xsl:value-of select='$textblock'/>",
    "POSTEXT": "<xsl:value-of select='$textblock'/>",
    "ACCOUNT": "<xsl:choose>
                      <xsl:when test='string(cost_center_id_defect)'>
                          <xsl:value-of select='cost_center_id_defect'/>
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:value-of select='cost_center_id_replacement'/>
                      </xsl:otherwise>
                  </xsl:choose>",
    "COSTTYPE": null,
    "COSTCATEGORY": null,
    "WORKGROUP": "IH4-SR-5-M",
    "INVENTORY_NUMBER": "<xsl:choose>
                              <xsl:when test='string(inventory_id_defect)'>
                                  <xsl:value-of select='inventory_id_defect'/>
                              </xsl:when>
                              <xsl:otherwise>
                                  <xsl:value-of select='inventory_id_replacement'/>
                              </xsl:otherwise>
                          </xsl:choose>",
    "JOBSTART": null,
    "STATUS": "EROF"
}
  </xsl:template>

</xsl:stylesheet>
