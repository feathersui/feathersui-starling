<?xml version="1.0" encoding="UTF-8"?>
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
	<xsl:output encoding="UTF-8" method="html" use-character-maps="disable"/>
	<xsl:param name="localTitle" select="$localTitle"/>
	<xsl:variable name="title" select="concat($asdoc_terms/row[entry[1][p/text() = $localTitle]]/entry[2]/p,' - ',$title-base)"/>
	<xsl:param name="overviewsFile" select="'overviews.xml'"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:param name="packages_map_name" select="packagemap.xml"/>
	<xsl:param name="filter" select="$filter"/>
	<xsl:param name="outfile" select="'class-summary'"/>
	<xsl:variable name="useFilter">
		<xsl:if test="contains($filter,'*')">
			<xsl:value-of select="substring-before($filter,'*')"/>
		</xsl:if>
		<xsl:if test="not(contains($filter,'*'))">
			<xsl:value-of select="$filter"/>
		</xsl:if>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:copy-of select="$noLiveDocs"/>
		<xsl:copy-of select="$docType"/>
		<xsl:element name="html">
			<head>
				<title>
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = $localTitle]]/entry[2]/p"/>
					<xsl:call-template name="getPageTitlePostFix"/>
				</title>
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<xsl:call-template name="getStyleLink">
					<xsl:with-param name="link" select="asdoc/link"/>
				</xsl:call-template>
			</head>
			<xsl:element name="body">
				<xsl:if test="$isEclipse">
					<xsl:attribute name="class">
						<xsl:text>eclipseBody</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="getTitleScript">
					<xsl:with-param name="title" select="$title"/>
				</xsl:call-template>
				<xsl:call-template name="getLinks2">
					<xsl:with-param name="subTitle">
						<xsl:call-template name="search-and-replace">
							<xsl:with-param name="input" select="$asdoc_terms/row[entry[1][p/text() = $localTitle]]/entry[2]/p"/>
							<xsl:with-param name="search-string" select="' '"/>
							<xsl:with-param name="replace-string" select="$nbsp"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="fileName" select="$outfile"/>
					<xsl:with-param name="showProperties" select="false()"/>
					<xsl:with-param name="showMethods" select="false()"/>
					<xsl:with-param name="showAllClasses" select="false()"/>
				</xsl:call-template>
				<div class="MainContent">
					<br/>
					<xsl:variable name="overviews" select="document($overviewsFile)/overviews"/>
					<p>
						<xsl:choose>
							<xsl:when test="starts-with($useFilter,'mx.')">
								<xsl:value-of disable-output-escaping="yes" select="$overviews/mx-classes/description/."/>
							</xsl:when>
							<xsl:when test="starts-with($useFilter,'flash.')">
								<xsl:value-of disable-output-escaping="yes" select="$overviews/flash-classes/description/."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of disable-output-escaping="yes" select="$overviews/all-classes/description/."/>
							</xsl:otherwise>
						</xsl:choose>
					</p>
					<xsl:for-each select="$overviews/all-classes">
						<xsl:call-template name="sees">
							<xsl:with-param name="xrefId" select="'all-classes'"/>
						</xsl:call-template>
					</xsl:for-each>
					<br/>
					<table cellpadding="3" cellspacing="0" class="summaryTable">
						<tr>
							<th>
								<xsl:value-of select="$nbsp"/>
							</th>
							<th width="20%">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassClass']]/entry[2]/p"/>
							</th>
							<th width="20%">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackagePackage']]/entry[2]/p"/>
							</th>
							<th width="60%">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Description']]/entry[2]/p"/>
							</th>
						</tr>
						<xsl:for-each select="allClasses/apiPackage//apiClassifier[starts-with(../apiName,$useFilter) or ($useFilter='flash.' and ../apiName='__Global__')]">
							<xsl:sort select="./apiName" order="ascending" data-type="text" lang="en-US"/>
							<xsl:variable name="name" select="./apiName"/>
							<xsl:variable name="packageName" select="../apiName"/>
							<xsl:variable name="classPath">
								<xsl:choose>
									<xsl:when test="$packageName='__Global__'">
										<xsl:value-of select="'.'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="translate($packageName,'.','/') "/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<tr class="prow{position() mod 2}">
								<td class="summaryTablePaddingCol">
									<xsl:value-of select="$nbsp"/>
								</td>
								<td class="summaryTableSecondCol">
									<xsl:choose>
										<xsl:when test="$classPath">
											<a href="{$classPath}/{$name}.html">
												<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface">
													<i>
														<xsl:value-of select="$name"/>
														<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
															<xsl:value-of select="$nbsp"/>
															<img src="images/AirIcon12x12.gif" width="12" height="12" hspace="0" vspace="0"/>
														</xsl:if>
													</i>
												</xsl:if>
												<xsl:if test="not(./apiClassifierDetail/apiClassifierDef/apiInterface)">
													<xsl:value-of select="$name"/>
													<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
														<xsl:value-of select="$nbsp"/>
														<img src="images/AirIcon12x12.gif" width="12" height="12" hspace="0" vspace="0"/>
													</xsl:if>
												</xsl:if>
											</a>
											<br/>
										</xsl:when>
										<xsl:otherwise>
											<a href="{$classPath}/{$name}.html">
												<xsl:if test="apiClassifier[./apiClassifierDetail/apiClassifierDef/apiInterface]">
													<i>
														<xsl:value-of select="$name"/>
														<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
															<xsl:value-of select="$nbsp"/>
															<img src="images/AirIcon12x12.gif" width="12" height="12" hspace="0" vspace="0"/>
														</xsl:if>
													</i>
												</xsl:if>
												<xsl:if test="apiClassifier[not(./apiClassifierDetail/apiClassifierDef/apiInterface)]">
													<xsl:value-of select="$name"/>
													<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
														<xsl:value-of select="$nbsp"/>
														<img src="images/AirIcon12x12.gif" width="12" height="12" hspace="0" vspace="0"/>
													</xsl:if>
												</xsl:if>
											</a>
											<br/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="summaryTableCol">
									<xsl:if test="$classPath and string-length(normalize-space($classPath)) &gt; 0 and not($classPath='.')">
										<a href="{$classPath}/package-detail.html" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
											<xsl:value-of select="$packageName"/>
										</a>
									</xsl:if>
									<xsl:if test="not($classPath) or string-length(normalize-space($classPath)) = 0 or $classPath='.'">
										<a href="package-detail.html" onclick="javascript:loadClassListFrame('class-list.html');">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
										</a>
									</xsl:if>
								</td>
								<td class="summaryTableLastCol">
									<xsl:if test="deprecated">
										<xsl:apply-templates select="deprecated"/>
									</xsl:if>
									<xsl:if test="not(deprecated)">
										<xsl:if test="string-length(normalize-space(./shortdesc)) &gt; 0">
											<xsl:value-of select="./shortdesc" disable-output-escaping="yes"/>
										</xsl:if>
										<xsl:if test="not(string-length(normalize-space(./shortdesc)) &gt; 0)">
											<xsl:value-of select="$nbsp"/>
										</xsl:if>
									</xsl:if>
								</td>
							</tr>
						</xsl:for-each>
					</table>
					<p/>
					<center class="copyright">
						<xsl:copy-of select="$copyright"/>
					</center>
				</div>
			</xsl:element>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>
</xsl:stylesheet>
