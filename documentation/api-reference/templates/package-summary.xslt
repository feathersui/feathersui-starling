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
	<xsl:output encoding="UTF-8" method="html" use-character-maps="disable"/>
	<xsl:param name="localTitle" select="$localTitle"/>
	<xsl:variable name="title" select="concat($asdoc_terms/row[entry[1][p/text() = $localTitle]]/entry[2]/p,' - ',$title-base)"/>
	<xsl:param name="overviewsFile" select="'overviews.xml'"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:param name="filter" select="'*'"/>
	<xsl:param name="outfile" select="'package-summary'"/>
	<xsl:param name="packages_map_name" select="'packagemap.xml'"/>
	<xsl:param name="jslr" select="'flashclasses.xml'"/>
	<xsl:param name="prog_language_name" select="''"/>
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
		<xsl:value-of select="$markOfTheWeb"/>
		<xsl:if test="$config/options[@livedocs='true']">
			<xsl:comment>#config errmsg=""</xsl:comment>
		</xsl:if>
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
					<xsl:with-param name="showPackages" select="false()"/>
				</xsl:call-template>
				<div class="MainContent">
					<br/>
					<xsl:variable name="overviews" select="document($overviewsFile)/overviews"/>
					<p>
						<xsl:choose>
							<xsl:when test="starts-with($useFilter,'mx.')">
								<xsl:value-of disable-output-escaping="yes" select="$overviews/mx-packages/description/."/>
							</xsl:when>
							<xsl:when test="starts-with($useFilter,'flash.')">
								<xsl:value-of disable-output-escaping="yes" select="$overviews/flash-packages/description/."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of disable-output-escaping="yes" select="$overviews/all-packages/description/."/>
							</xsl:otherwise>
						</xsl:choose>
					</p>
					<xsl:for-each select="$overviews/all-packages">
						<xsl:call-template name="sees">
							<xsl:with-param name="xrefId" select="'all-packages'"/>
						</xsl:call-template>
					</xsl:for-each>
					<br/>
					<table cellpadding="3" cellspacing="0" class="summaryTable">
						<tr>
							<th>
								<xsl:value-of select="$nbsp"/>
							</th>
							<th width="30%">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Package']]/entry[2]/p"/>
							</th>
							<th width="70%">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Description']]/entry[2]/p"/>
							</th>
						</tr>
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>

							<xsl:otherwise>
								<xsl:for-each select="apiMap//apiItemRef">
									<xsl:sort select="substring(@href, 0, string-length(@href)-4)" order="ascending"/>
									<xsl:variable name="ditaFileName">
										<xsl:value-of select="concat($ditaFileDir,@href)"/>
									</xsl:variable>
									<xsl:variable name="rowNumber" select="concat('prow',position() mod 2)"/>
									<xsl:for-each select="document($ditaFileName)/apiPackage[starts-with(apiName,$useFilter) or ($useFilter='flash.' and apiName='__Global__')]">
										<xsl:sort select="apiName" order="ascending"/>
										<xsl:variable name="name" select="apiName"/>
										<xsl:variable name="isTopLevel">
											<xsl:call-template name="isTopLevel">
												<xsl:with-param name="packageName" select="$name"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:variable name="packageFile">
											<xsl:if test="$isTopLevel='false'">
												<xsl:value-of select="translate($name,'.','/')"/>
												<xsl:text>/</xsl:text>
											</xsl:if>
											<xsl:text>package-detail.html</xsl:text>
										</xsl:variable>
										<xsl:variable name="classListFile">
											<xsl:if test="$isTopLevel='false'">
												<xsl:value-of select="translate($name,'.','/')"/>
												<xsl:text>/</xsl:text>
											</xsl:if>
											<xsl:text>class-list.html</xsl:text>
										</xsl:variable>
										<xsl:if test="./apiClassifier or ./apiOperation or ./apiValue/apiProperty">
											<xsl:variable name="name" select="apiName"/>
											<tr class="{$rowNumber}">
												<td class="summaryTablePaddingCol">
													<xsl:value-of select="$nbsp"/>
												</td>
												<td class="summaryTableSecondCol">
													<a href="{$packageFile}" onclick="javascript:loadClassListFrame('{$classListFile}');">
														<xsl:if test="$isTopLevel='true'">
															<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
														</xsl:if>
														<xsl:if test="$isTopLevel='false'">
															<xsl:value-of select="$name"/>
														</xsl:if>
													</a>
												</td>
												<td class="summaryTableLastCol">
													<xsl:if test="not($config/overviews/package)">
														<xsl:variable name="overview" select="document($overviewsFile)/overviews/packages/package[@name=current()/apiName]"/>
														<xsl:for-each select="$overview/shortDescription">
															<xsl:call-template name="deTilda">
																<xsl:with-param name="inText" select="."/>
															</xsl:call-template>
														</xsl:for-each>
														<xsl:if test="string-length(string-join($overview/shortDescription/., ' '))">
															<xsl:value-of select="$nbsp"/>
														</xsl:if>
													</xsl:if>
													<xsl:if test="$config/overviews/package">
														<xsl:variable name="pname" select="ancestor-or-self::apiPackage/apiName"/>
														<xsl:for-each select="$config/overviews/package">
															<xsl:variable name="packageOverview" select="normalize-space(document(.)/overviews/packages/package[@name=$pname]/shortDescription/.)"/>
															<xsl:if test="string-length($packageOverview)">
																<xsl:call-template name="deTilda">
																	<xsl:with-param name="inText" select="$packageOverview"/>
																</xsl:call-template>
															</xsl:if>
														</xsl:for-each>
														<xsl:value-of select="$nbsp"/>
													</xsl:if>
												</td>
											</tr>
										</xsl:if>
									</xsl:for-each>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</table>
					<p/>
					<center class="copyright">
						<xsl:copy-of select="$copyright"/>
					</center>
				</div>
				<xsl:if test="$config/options[@livedocs='true']">
					<div class="separator">&#160;</div>
					<xsl:comment>BEGIN IONCOMMENTS</xsl:comment>
					<div id="ionComHere"> </div>
					<xsl:comment>END IONCOMMENTS</xsl:comment>
					<xsl:comment>#include virtual="ionComments.ssi"</xsl:comment>
					<p id="creativecommons" class="creativecommons">
						<a href="http://creativecommons.org/licenses/by-nc-sa/3.0/">
							<img id="creativecommons_img" src="images/CC.png"/>
						</a>
					</p>
					<xsl:comment>#include virtual="/livedocs/googleAnalytics.ssi"</xsl:comment>
					<xsl:comment>#include virtual="/ubi/analytics/analytics_ssi.html"</xsl:comment>
				</xsl:if>
			</xsl:element>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>
</xsl:stylesheet>
