<?xml version="1.0" encoding="utf-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://sf.net/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ifn="urn:internal:functions"
	exclude-result-prefixes="saxon xs ifn">
	<xsl:import href="asdoc-util.xslt"/>
	<xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" use-character-maps="disable"/>
	<xsl:param name="outputPath" select="''"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:param name="packages_map_name" select="'packagemap.xml'"/>
	<xsl:variable name="thinsp">
		<xsl:text>&#x2009;</xsl:text>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:for-each select="apiMap//apiItemRef">
			<xsl:sort select="@href" order="ascending"/>
			<xsl:variable name="ditaFileName">
				<xsl:value-of select="concat($ditaFileDir,@href)"/>
			</xsl:variable>
			<xsl:for-each select="document($ditaFileName)/apiPackage">
				<xsl:variable name="name" select="./apiName"/>
				<xsl:variable name="title" select="concat($name,concat(' - ',$title-base))"/>
				<xsl:variable name="isTopLevel">
					<xsl:call-template name="isTopLevel">
						<xsl:with-param name="packageName" select="$name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="classListFile">
					<xsl:value-of select="$outputPath"/>
					<xsl:choose>
						<xsl:when test="$isTopLevel='true'">class-list.html</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="translate($name,'.','/')"/>/class-list.html</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:result-document href="{$classListFile}">
					<xsl:copy-of select="$noLiveDocs"/>
					<xsl:copy-of select="$docType"/>
					<xsl:element name="html">
						<head>
							<title>
								<xsl:value-of select="$title"/>
							</title>
							<base target="classFrame"/>
							<xsl:call-template name="getStyleLink">
								<xsl:with-param name="link" select="/asdoc/link"/>
								<xsl:with-param name="packageName" select="$name"/>
							</xsl:call-template>
						</head>
						<body class="classFrameContent">
							<h3>
								<xsl:choose>
									<xsl:when test="$isTopLevel='true'">
										<a href="package-detail.html" target="classFrame" style="color:black">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<a href="package-detail.html" target="classFrame" style="color:black">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackagePackage']]/entry[2]/p"/>
											<xsl:value-of select="concat(' ',$name)"/>
										</a>
									</xsl:otherwise>
								</xsl:choose>
							</h3>
							<table cellpadding="0" cellspacing="0">
								<xsl:for-each select="apiValue[not(./apiValueDetail/apiValueDef/apiProperty)]">
									<xsl:sort select="apiName" order="ascending" lang="en-US"/>
									<xsl:variable name="name" select="apiName"/>
									<xsl:if test="position()=1">
										<tr>
											<td>
												<a href="package.html#constantSummary" style="color:black">
													<b>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constants']]/entry[2]/p"/>
													</b>
												</a>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<td>
											<a href="package.html#{$name}">
												<xsl:value-of select="$name"/>
											</a>
										</td>
									</tr>
									<xsl:if test="position()=last()">
										<tr>
											<td width="10px">
												<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											</td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="apiValue[./apiValueDetail/apiValueDef/apiProperty]">
									<xsl:sort select="apiName" order="ascending" lang="en-US"/>
									<xsl:variable name="name" select="apiName"/>
									<xsl:if test="position()=1">
										<tr>
											<td>
												<a href="package.html#propertySummary" style="color:black">
													<b>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Properties']]/entry[2]/p"/>
													</b>
												</a>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<td>
											<a href="package.html#{$name}">
												<xsl:value-of select="$name"/>
											</a>
										</td>
									</tr>
									<xsl:if test="position()=last()">
										<tr>
											<td width="10px">
												<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											</td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="apiOperation">
									<xsl:sort select="apiName" order="ascending" lang="en-US"/>
									<xsl:variable name="name" select="apiName"/>
									<xsl:if test="position()=1">
										<tr>
											<td>
												<a href="package.html#methodSummary" style="color:black">
													<b>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Functions']]/entry[2]/p"/>
													</b>
												</a>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<td>
											<a href="package.html#{$name}()">
												<xsl:value-of select="$name"/>
												<xsl:text>()</xsl:text>
											</a>
										</td>
									</tr>
									<xsl:if test="position()=last()">
										<tr>
											<td width="10px">
												<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											</td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select=".//apiClassifier[apiClassifierDetail/apiClassifierDef/apiInterface]">
									<xsl:sort select="apiName" order="ascending" lang="en-US"/>
									<xsl:variable name="name" select="./apiName"/>
									<xsl:variable name="packageName" select="ancestor::apiPackage/apiName"/>
									<xsl:variable name="baseRef">
										<xsl:call-template name="getBaseRef">
											<xsl:with-param name="packageName" select="$packageName"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:if test="position()=1">
										<tr>
											<td>
												<a href="package-detail.html#interfaceSummary" style="color:black">
													<b>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Interfaces']]/entry[2]/p"/>
													</b>
												</a>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<td>
											<a href="{$name}.html">
												<i>
													<xsl:value-of select="$name"/>
												</i>
											</a>
											<xsl:choose>
												<xsl:when test="$prog_language_name='javascript'"/>
												<xsl:otherwise>
													<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
														<xsl:call-template name="insertAIRIcon">
															<xsl:with-param name="baseRef" select="$baseRef"/>
														</xsl:call-template>
														<xsl:value-of select="$nbsp"/>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<xsl:if test="position()=last()">
										<tr>
											<td width="10px">
												<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
											</td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="./apiClassifier[not(./apiClassifierDetail/apiClassifierDef/apiInterface)]">
									<xsl:sort select="apiName" order="ascending" lang="en-US"/>
									<xsl:variable name="name" select="apiName"/>
									<xsl:variable name="packageName" select="ancestor::apiPackage/apiName"/>
									<xsl:variable name="baseRef">
										<xsl:call-template name="getBaseRef">
											<xsl:with-param name="packageName" select="$packageName"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:if test="position()=1">
										<tr>
											<td>
												<a href="package-detail.html#classSummary" style="color:black">
													<b>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Classes']]/entry[2]/p"/>
													</b>
												</a>
											</td>
										</tr>
									</xsl:if>
									<tr>
										<td>
											<a href="{$name}.html">
												<xsl:value-of select="$name"/>
											</a>
											<xsl:choose>
												<xsl:when test="$prog_language_name='javascript'"/>
												<xsl:otherwise>
													<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
														<xsl:call-template name="insertAIRIcon">
															<xsl:with-param name="baseRef" select="$baseRef"/>
														</xsl:call-template>
														<xsl:value-of select="$nbsp"/>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:for-each>
							</table>
						</body>
					</xsl:element>
					<xsl:copy-of select="$copyrightComment"/>
				</xsl:result-document>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
