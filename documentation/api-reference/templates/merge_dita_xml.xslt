<?xml version="1.0" encoding="UTF-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="ditaFileDir" select="''"/>
    <xsl:template match="/">
                <allClasses>
                    <xsl:apply-templates select="//apiItemRef">
                        <xsl:sort select="@href" order="ascending"/>
                    </xsl:apply-templates>
                </allClasses>
    </xsl:template>
    <xsl:template match="apiItemRef">
        <xsl:variable name="ditaFileName">
            <xsl:value-of select="concat($ditaFileDir,@href)"/>
        </xsl:variable>
        <xsl:for-each select="document($ditaFileName)/apiPackage">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
