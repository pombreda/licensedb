<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:cc="http://creativecommons.org/ns#"
                xmlns:dc="http://purl.org/dc/terms/"
                xmlns:li="https://licensedb.org/ns#"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:spdx="http://spdx.org/rdf/terms#"
                xmlns:vann="http://purl.org/vocab/vann/"
                xmlns:wdrs="http://www.w3.org/2007/05/powder-s#"
                xmlns:xhv="http://www.w3.org/1999/xhtml/vocab#"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema-datatypes#"
                version="1.0">

<xsl:output method="text" indent="no" />
<xsl:strip-space elements="*" />

<!-- Utility templates.
     ====================================================== -->

<xsl:template name="string-replace">
  <xsl:param name="text" />
  <xsl:param name="replace" />
  <xsl:param name="by" />
  <xsl:choose>
    <xsl:when test="contains($text, $replace)">
      <xsl:value-of select="substring-before($text,$replace)" />
      <xsl:value-of select="$by" />
      <xsl:value-of select="substring-after($text,$replace)" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="pretty-name">
  <xsl:param name="name" />
  <xsl:choose>
    <xsl:when test='contains($name,"https://licensedb.org/ns#")'>
      <xsl:text><![CDATA[<span class="prefix">li:</span>]]></xsl:text>
      <xsl:value-of select='substring-after($name,"https://licensedb.org/ns#")' />
    </xsl:when>
    <xsl:when test='contains($name,"http://www.w3.org/2001/XMLSchema-datatypes#")'>
      <xsl:text><![CDATA[<span class="prefix">xsd:</span>]]></xsl:text>
      <xsl:value-of select='substring-after($name,"http://www.w3.org/2001/XMLSchema-datatypes#")' />
    </xsl:when>
    <xsl:when test='contains($name,"http://www.w3.org/2000/01/rdf-schema#")'>
      <xsl:text><![CDATA[<span class="prefix">rdfs:</span>]]></xsl:text>
      <xsl:value-of select='substring-after($name,"http://www.w3.org/2000/01/rdf-schema#")' />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$name" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Body
     ====================================================== -->

<xsl:template match="owl:Ontology">
  <!-- double titles.  the first line is used as <title> and
   the second as <h1> in the final output. -->
  <xsl:value-of select="dc:title" /><xsl:text>&#xA;</xsl:text>
  <xsl:text># </xsl:text>
  <xsl:value-of select="dc:title" /><xsl:text>&#xA;&#xA;</xsl:text>

  <xsl:text><![CDATA[<dt>Last update:</dt><dd>]]></xsl:text>
  <xsl:value-of select="dc:modified" />
  <xsl:text><![CDATA[</dd>]]>&#xA;&#xA;</xsl:text>

  <xsl:text><![CDATA[<dt>Editor:</dt><dd>]]></xsl:text>
  <xsl:value-of select="dc:creator" />
  <xsl:text><![CDATA[</dd>]]>&#xA;&#xA;</xsl:text>

  <xsl:text><![CDATA[<dt>Download:</dt><dd>]]></xsl:text>
  <xsl:text>[rdf/xml](ns.rdf) | [turtle](ns.ttl)</xsl:text>
  <xsl:text><![CDATA[</dd>]]>&#xA;&#xA;</xsl:text>

  <xsl:value-of select="rdfs:comment" /><xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

<xsl:template match="rdfs:Class">
  <xsl:text>#### </xsl:text>
  <xsl:call-template name="pretty-name">
    <xsl:with-param name="name" select="@rdf:about" />
  </xsl:call-template>
  <xsl:text>&#xA;&#xA;</xsl:text>
  <xsl:value-of select="rdfs:comment" /><xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

<xsl:template match="rdf:Property">
  <xsl:text>#### </xsl:text>
  <xsl:call-template name="pretty-name">
    <xsl:with-param name="name" select="@rdf:about" />
  </xsl:call-template>
  <xsl:text>&#xA;&#xA;</xsl:text>

  <xsl:value-of select="rdfs:comment" />
  <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>


<xsl:template match="/rdf:RDF">
  <!-- 1. document heading with information about the vocabulary. -->
  <xsl:for-each select="owl:Ontology">
    <xsl:apply-templates select="." />
  </xsl:for-each>
  <!-- 2. all classes -->
  <xsl:text>## Classes&#xA;&#xA;</xsl:text>
  <xsl:for-each select="rdfs:Class">
    <xsl:apply-templates select="." />
  </xsl:for-each>
  <!-- 3. properties of the License class. -->
  <xsl:text>## License properties&#xA;&#xA;</xsl:text>
  <xsl:for-each select="rdf:Property">
    <xsl:if test='rdfs:domain/@rdf:resource="https://licensedb.org/ns#License"'>
      <xsl:apply-templates select="." />
    </xsl:if>
  </xsl:for-each>
  <!-- 4. properties of the Notice class. -->
  <xsl:text>## Notice properties&#xA;&#xA;</xsl:text>
  <xsl:for-each select="rdf:Property">
    <xsl:if test='rdfs:domain/@rdf:resource="https://licensedb.org/ns#Notice"'>
      <xsl:apply-templates select="." />
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template match="@*|*|processing-instruction()|comment()">
  <xsl:copy>
    <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
