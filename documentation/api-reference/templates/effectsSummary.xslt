<?xml version="1.0" encoding="UTF-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
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
			<apiPackage id="{@id}">
				<apiName>
					<xsl:value-of select="./apiName"/>
				</apiName>
				<xsl:apply-templates select="apiClassifier"/>
			</apiPackage>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="apiClassifier">
		<apiClassifier id="{@id}">
			<apiName>
				<xsl:value-of select="./apiName"/>
			</apiName>
			<xsl:apply-templates select="apiClassifierDetail"/>
			<xsl:apply-templates select="prolog/asMetadata"/>
		</apiClassifier>
	</xsl:template>
	<xsl:template match="prolog/asMetadata">
		<prolog>
			<asMetadata>
				<xsl:apply-templates select="effects"/>
			</asMetadata>
		</prolog>
	</xsl:template>
	<xsl:template match="effects">
		<effects>
			<xsl:apply-templates select="node()"/>
		</effects>
	</xsl:template>
	<xsl:template match="apiClassifierDetail">
		<apiClassifierDetail>
			<xsl:apply-templates select="apiClassifierDef"/>
		</apiClassifierDetail>
	</xsl:template>
	<xsl:template match="apiClassifierDef">
		<apiClassifierDef>
			<xsl:apply-templates select="node()"/>
		</apiClassifierDef>
	</xsl:template>
	<xsl:template match="node()">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
