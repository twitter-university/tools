<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../asciidoc/docbook-xsl/chunked.xsl"/>

  <xsl:param name="chunker.output.standalone" select="'no'"/>
  <xsl:param name="chunker.output.omit-xml-declaration" select="'yes'"/>
  <xsl:param name="chunker.output.standalone" select="'no'"/>
  <xsl:param name="chunker.output.doctype-public" select="''"/>
  <xsl:param name="chunker.output.doctype-system" select="''"/>
  <xsl:param name="chunker.output.method" select="'html'"/>
  <xsl:param name="chunk.tocs.and.lots" select="1"/>
  <xsl:param name="use.id.as.filename" select="1"/>
  <xsl:param name="admon.graphics.path" select="'../images/'"/>
  <xsl:param name="navig.graphics.path" select="'../images/'"/>
  <xsl:param name="callout.graphics.path" select="'../images/callouts/'"/>

  <!-- This is to remove revision history when generating HTML for bookshelf -->
  <xsl:template match="revhistory" mode="titlepage.mode"/>

  <xsl:template name="chunk-element-content">
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <xsl:param name="nav.context"/>
    <xsl:param name="content">
      <xsl:apply-imports/>
    </xsl:param>

    <!--
    <xsl:call-template name="user.preroot"/>

    <html>
      <xsl:call-template name="html.head">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>

      <body>
    -->
        <xsl:call-template name="body.attributes"/>
        <xsl:call-template name="user.header.navigation"/>

        <xsl:call-template name="header.navigation">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
          <xsl:with-param name="nav.context" select="$nav.context"/>
        </xsl:call-template>

        <xsl:call-template name="user.header.content"/>

        <xsl:copy-of select="$content"/>

        <xsl:call-template name="user.footer.content"/>

        <xsl:call-template name="footer.navigation">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
          <xsl:with-param name="nav.context" select="$nav.context"/>
        </xsl:call-template>

        <xsl:call-template name="user.footer.navigation"/>
    <!--
      </body>
    </html>
    -->
    <xsl:value-of select="$chunk.append"/>
  </xsl:template>
</xsl:stylesheet>
