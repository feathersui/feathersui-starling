<?xml version="1.0" encoding="UTF-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://sf.net/saxon" xmlns:str="http://exslt.org/strings" xmlns:ifn="urn:internal:functions"
	exclude-result-prefixes="saxon str ifn">
	<xsl:import href="asdoc-util.xslt"/>
	<xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" saxon:indent="3" use-character-maps="disable" indent="yes"/>
	<xsl:variable name="title" select="concat($asdoc_terms/row[entry[1][p/text() = 'allClasses']]/entry[2]/p, ' - ',$title-base)"/>
	<xsl:param name="packages_map_name" select="'packagemap.xml'"/>
	<xsl:param name="jslr" select="'flashclasses.xml'"/>
	<xsl:param name="prog_language_name" select="''"/>
	<xsl:template match="/">
		<xsl:copy-of select="$noLiveDocs"/>
		<xsl:copy-of select="$docType"/>
		<xsl:element name="html">
			<head>
				<title>
					<xsl:choose>
						<xsl:when test="$prog_language_name='javascript'" />
						<xsl:otherwise>
							<xsl:value-of select="$title"/>
						</xsl:otherwise>
					</xsl:choose>
				</title>
				<base target="classFrame"/>
				<xsl:call-template name="getStyleLink">
					<xsl:with-param name="link" select="asdoc/link"/>
				</xsl:call-template>
			</head>
			<body class="classFrameContent">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<h3>
							<a href="class-summary.html" target="classFrame" style="color:black">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'allClasses']]/entry[2]/p"/>
							</a>
						</h3>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<table cellpadding="0" cellspacing="0">
							<xsl:apply-templates select="//apiClassifier">
								<xsl:sort select="apiName" order="ascending" lang="en-US"/>
							</xsl:apply-templates>
						</table>
					</xsl:otherwise>
				</xsl:choose>
			</body>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>
	<xsl:template match="apiClassifier">
		<xsl:variable name="name" select="./apiName"/>
		<xsl:variable name="packageName" select="../apiName"/>
		<xsl:variable name="isTopLevel">
			<xsl:call-template name="isTopLevel">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="classPath" select="translate($packageName,'.','/')"/>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="$isTopLevel='false'">
						<a href="{$classPath}/{$name}.html"  title="{$packageName}.{$name}">
							<xsl:choose>
								<xsl:when test="./apiClassifierDetail/apiClassifierDef/apiInterface">
									<i>
										<xsl:value-of select="$name"/>
									</i>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$name"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="targetValue" select="concat('./',$name,'.html')"/>
						<a href="{$targetValue}">
							<xsl:choose>
								<xsl:when test="./apiClassifierDetail/apiClassifierDef/apiInterface!=null">
									<i>
										<xsl:value-of select="$name"/>
									</i>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$name"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
							<xsl:value-of select="$nbsp"/>
							<img src="images/AirIcon12x12.gif" width="12" height="12" hspace="0" vspace="0"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
