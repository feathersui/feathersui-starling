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
	<xsl:import href="class-files.xslt"/>
	<xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" use-character-maps="disable"/>
	<xsl:param name="outputPath" select="''"/>
	<xsl:param name="packageOverviewFile" select="'overviews.xml'"/>
	<xsl:param name="packages_map_name" select="'packagemap.xml'"/>
	<xsl:variable name="thinsp">
		<xsl:text>&#x2009;</xsl:text>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$prog_language_name='javascript'"/>
			<xsl:otherwise>
				<xsl:for-each select="apiMap//apiItemRef">
					<xsl:sort select="@href" order="ascending" lang="en-US"/>
					<xsl:variable name="ditaFileName">
						<xsl:value-of select="concat($ditaFileDir,@href)"/>
					</xsl:variable>
					<xsl:for-each select="document($ditaFileName)/apiPackage">
						<xsl:variable name="name" select="./apiName"/>
						<xsl:variable name="isTopLevel">
							<xsl:call-template name="isTopLevel">
								<xsl:with-param name="packageName" select="$name"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="shortPackageName" select="$name"/>
						<xsl:variable name="packageFile">
							<xsl:value-of select="$outputPath"/>
							<xsl:choose>
								<xsl:when test="$isTopLevel='true'">package-detail.html</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="translate($name,'.','/')"/>/package-detail.html</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="classListFile">
							<xsl:choose>
								<xsl:when test="$isTopLevel='true'">class-list.html</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="translate($name,'.','/')"/>/class-list.html</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="packageName">
							<xsl:choose>
								<xsl:when test="$isTopLevel='true'">
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="$asdoc_terms/row[entry[1][p/text() = 'PackagePackage']]/entry[2]/p" mode="terms">
										<xsl:with-param name="package" select="$name"/>
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="title">
							<xsl:if test="$isTopLevel='true'">
								<xsl:value-of select="concat($asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p,' - ',$title-base)"/>
							</xsl:if>
							<xsl:if test="$isTopLevel != 'true'">
								<xsl:value-of select="concat($name,' ',$asdoc_terms/row[entry[1][p/text() = 'Package']]/entry[2]/p,' - ',$title-base)"/>
							</xsl:if>
						</xsl:variable>
						<xsl:result-document href="{$packageFile}" method="html">
							<xsl:copy-of select="$noLiveDocs"/>
							<xsl:copy-of select="$docType"/>
							<xsl:value-of select="$markOfTheWeb"/>
							<xsl:if test="$config/options[@ion='true']">
								<xsl:comment>#config errmsg=""</xsl:comment>
							</xsl:if>
							<xsl:element name="html">
								<head>
									<xsl:call-template name="getStyleLink">
										<xsl:with-param name="link" select="/asdoc/link"/>
										<xsl:with-param name="packageName" select="$name"/>
									</xsl:call-template>
									<title>
										<xsl:if test="$isTopLevel='true'">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevelConstantsFunctions']]/entry[2]/p"/>
										</xsl:if>
										<xsl:if test="$isTopLevel='false'">
											<xsl:value-of select="$name"/>
										</xsl:if>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Summary']]/entry[2]/p"/>
										<xsl:call-template name="getPageTitlePostFix"/>
									</title>
								</head>
								<xsl:element name="body">
									<xsl:if test="$isEclipse">
										<xsl:attribute name="class">
											<xsl:text>eclipseBody</xsl:text>
										</xsl:attribute>
									</xsl:if>
									<xsl:call-template name="getTitleScript">
										<xsl:with-param name="title" select="$title"/>
										<xsl:with-param name="packageName" select="$name"/>
									</xsl:call-template>
									<xsl:call-template name="getLinks2">
										<xsl:with-param name="subTitle">
											<xsl:choose>
												<xsl:when test="$isTopLevel='true'">
													<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates select="$shortPackageName"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
										<xsl:with-param name="fileName" select="'package-detail'"/>
										<xsl:with-param name="fileName2" select="$classListFile"/>
										<xsl:with-param name="packageName" select="$name"/>
										<xsl:with-param name="showProperties" select="false()"/>
										<xsl:with-param name="showMethods" select="false()"/>
										<xsl:with-param name="showPackageConstants" select="boolean(count(apiValue[not(apiValueDetail/apiValueDef/apiProperty)]))"/>
										<xsl:with-param name="showPackageProperties" select="boolean(count(apiValue[apiValueDetail/apiValueDef/apiProperty]))"/>
										<xsl:with-param name="showPackageFunctions" select="boolean(count(apiOperation))"/>
										<xsl:with-param name="showInterfaces" select="boolean(count(apiClassifier[apiClassifierDetail/apiClassifierDef/apiInterface]))"/>
										<xsl:with-param name="showClasses" select="boolean(count(apiClassifier[not(apiClassifierDetail/apiClassifierDef/apiInterface)]))"/>
										<xsl:with-param name="showPackageUse" select="false()"/>
									</xsl:call-template>
									<xsl:variable name="id" select="@id"/>
									<div class="MainContent">
										<xsl:variable name="annot" select="$id"/>
										<xsl:variable name="pack" select="translate($annot,':','.')"/>
										<xsl:apply-templates mode="annotate" select="$config/annotate/item[@type='package' and @name[starts-with($pack,.)]]"/>
										<br/>
										<xsl:if test="not($config/overviews/package)">
											<xsl:variable name="packageComments" select="document($packageOverviewFile)/overviews/packages/package[@name=current()/apiName]"/>
											<xsl:for-each select="$packageComments/description">
												<p>
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="."/>
													</xsl:call-template>
												</p>
												<xsl:for-each select="$packageComments">
													<xsl:call-template name="sees"/>
												</xsl:for-each>
											</xsl:for-each>
										</xsl:if>
										<xsl:if test="$config/overviews/package">
											<xsl:variable name="pname" select="@name"/>
											<xsl:for-each select="$config/overviews/package">
												<xsl:variable name="packageOverview" select="document(.)/overviews/packages/package[@name=$pname]"/>
												<xsl:if test="$packageOverview/longDescription">
													<p>
														<xsl:call-template name="deTilda">
															<xsl:with-param name="inText" select="$packageOverview/description"/>
														</xsl:call-template>
													</p>
													<xsl:for-each select="$packageOverview">
														<xsl:call-template name="sees">
															<xsl:with-param name="xrefId">
																<xsl:if test="$isTopLevel='true'">
																	<xsl:text>global</xsl:text>
																</xsl:if>
																<xsl:if test="not($isTopLevel='true')">
																	<xsl:value-of select="$pname"/>
																</xsl:if>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
										<br/>
										<hr/>
										<xsl:if test="apiValue/apiValueDetail/apiValueDef[apiProperty]">
											<a name="fieldSummary"/>
											<div class="summaryTableTitle">
												<xsl:choose>
													<xsl:when test="$isTopLevel='true'">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalProperties']]/entry[2]/p"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Property']]/entry[2]/p"/>
													</xsl:otherwise>
												</xsl:choose>
											</div>
											<table cellpadding="3" cellspacing="0" class="summaryTable">
												<tr>
													<th>
														<xsl:value-of select="$nbsp"/>
													</th>
													<th width="30%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Property']]/entry[2]/p"/>
													</th>
													<th width="70%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Description']]/entry[2]/p"/>
													</th>
												</tr>
												<xsl:for-each select="apiValue/apiValueDetail/apiValueDef[apiProperty]">
													<xsl:sort select="apiName" order="ascending" lang="en-US"/>
													<xsl:variable name="name" select="apiName"/>
													<tr class="prow{position() mod 2}">
														<td class="summaryTablePaddingCol">
															<xsl:value-of select="$nbsp"/>
														</td>
														<td class="summaryTableSecondCol">
															<a href="package.html#{$name}">
																<xsl:value-of select="$name"/>
															</a>
														</td>
														<td class="summaryTableLastCol">
															<xsl:call-template name="shortDescription"/>
															<xsl:if test="not(string-length(normalize-space(shortDescription/.)))">
																<xsl:value-of select="$nbsp"/>
															</xsl:if>
														</td>
													</tr>
												</xsl:for-each>
											</table>
										</xsl:if>
										<xsl:if test="apiOperation">
											<a name="methodSummary"/>
											<div class="summaryTableTitle">
												<xsl:choose>
													<xsl:when test="$isTopLevel='true'">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalFunctions']]/entry[2]/p"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Functions']]/entry[2]/p"/>
													</xsl:otherwise>
												</xsl:choose>
											</div>
											<table cellpadding="3" cellspacing="0" class="summaryTable">
												<tr>
													<th>
														<xsl:value-of select="$nbsp"/>
													</th>
													<th width="30%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'FunctionFunction']]/entry[2]/p"/>
													</th>
													<th width="70%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Description']]/entry[2]/p"/>
													</th>
												</tr>
												<xsl:for-each select="apiOperation">
													<xsl:sort select="apiName" order="ascending" lang="en-US"/>
													<xsl:variable name="name" select="apiName"/>
													<tr class="prow{position() mod 2}">
														<td class="summaryTablePaddingCol">
															<xsl:value-of select="$nbsp"/>
														</td>
														<td class="summaryTableSecondCol">
															<a href="package.html#{$name}()">
																<xsl:value-of select="$name"/>
															</a>
														</td>
														<td class="summaryTableLastCol">
															<xsl:call-template name="shortDescriptionReview"/>
															<xsl:call-template name="shortDescription"/>
															<xsl:if test="not(string-length(normalize-space(./shortdesc/.)))">
																<xsl:value-of select="$nbsp"/>
															</xsl:if>
														</td>
													</tr>
												</xsl:for-each>
											</table>
										</xsl:if>
										<xsl:if test="apiValue[not(apiValueDetail/apiValueDef/apiProperty)]">
											<a name="constantSummary"/>
											<div class="summaryTableTitle">
												<xsl:choose>
													<xsl:when test="$isTopLevel='true'">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalConstants']]/entry[2]/p"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constants']]/entry[2]/p"/>
													</xsl:otherwise>
												</xsl:choose>
											</div>
											<table cellpadding="3" cellspacing="0" class="summaryTable">
												<tr>
													<th>
														<xsl:value-of select="$nbsp"/>
													</th>
													<th width="30%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constant']]/entry[2]/p"/>
													</th>
													<th width="70%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Description']]/entry[2]/p"/>
													</th>
												</tr>
												<xsl:for-each select="apiValue[not(apiValueDetail/apiValueDef/apiProperty)]">
													<xsl:sort select="apiName" order="ascending" lang="en-US"/>
													<xsl:variable name="name" select="apiName"/>
													<tr class="prow{position() mod 2}">
														<td class="summaryTablePaddingCol">
															<xsl:value-of select="$nbsp"/>
														</td>
														<td class="summaryTableSecondCol">
															<a href="package.html#{$name}">
																<xsl:value-of select="$name"/>
															</a>
														</td>
														<td class="summaryTableLastCol">
															<xsl:call-template name="shortDescription"/>
															<xsl:if test="not(string-length(normalize-space(./shortdesc/.)))">
																<xsl:value-of select="$nbsp"/>
															</xsl:if>
														</td>
													</tr>
												</xsl:for-each>
											</table>
										</xsl:if>
										<xsl:if test="apiClassifier[apiClassifierDetail/apiClassifierDef/apiInterface]">
											<a name="interfaceSummary"/>
											<div class="summaryTableTitle">
												<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Interfaces']]/entry[2]/p"/>
											</div>
											<table cellpadding="3" cellspacing="0" class="summaryTable">
												<tr>
													<th>
														<xsl:value-of select="$nbsp"/>
													</th>
													<th width="30%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Interface']]/entry[2]/p"/>
													</th>
													<th width="70%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Description']]/entry[2]/p"/>
													</th>
												</tr>
												<xsl:for-each select="apiClassifier[apiClassifierDetail/apiClassifierDef/apiInterface]">
													<xsl:sort select="apiName" order="ascending" lang="en-US"/>
													<xsl:variable name="name" select="apiName"/>
													<xsl:variable name="packageName" select="ancestor::apiPackage/apiName"/>
													<xsl:variable name="baseRef">
														<xsl:call-template name="getBaseRef">
															<xsl:with-param name="packageName" select="$packageName"/>
														</xsl:call-template>
													</xsl:variable>
													<tr class="prow{position() mod 2}">
														<td class="summaryTablePaddingCol">
															<xsl:value-of select="$nbsp"/>
														</td>
														<td class="summaryTableSecondCol">
															<i>
																<a href="{$name}.html">
																	<xsl:value-of select="$name"/>
																</a>
															</i>
															<xsl:choose>
																<xsl:when test="$prog_language_name='javascript'"/>
																<xsl:otherwise>
																	<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
																		<xsl:value-of select="$nbsp"/>
																		<xsl:call-template name="insertAIRIcon">
																			<xsl:with-param name="baseRef" select="$baseRef"/>
																		</xsl:call-template>
																	</xsl:if>
																</xsl:otherwise>
															</xsl:choose>
														</td>
														<td class="summaryTableLastCol">
															<xsl:if test="deprecated">
																<xsl:apply-templates select="deprecated"/>
															</xsl:if>
															<xsl:if test="not(deprecated)">
																<xsl:call-template name="shortDescription"/>
																<xsl:if test="not(string-length(normalize-space(./shortdesc/.)))">
																	<xsl:value-of select="$nbsp"/>
																</xsl:if>
															</xsl:if>
														</td>
													</tr>
												</xsl:for-each>
											</table>
										</xsl:if>
										<xsl:if test="apiClassifier[not(apiClassifierDetail/apiClassifierDef/apiInterface)]">
											<a name="classSummary"/>
											<div class="summaryTableTitle">
												<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Classes']]/entry[2]/p"/>
											</div>
											<table cellpadding="3" cellspacing="0" class="summaryTable">
												<tr>
													<th>
														<xsl:value-of select="$nbsp"/>
													</th>
													<th width="30%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassClass']]/entry[2]/p"/>
													</th>
													<th width="70%">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Description']]/entry[2]/p"/>
													</th>
												</tr>
												<xsl:for-each select="apiClassifier[not(apiClassifierDetail/apiClassifierDef/apiInterface)]">
													<xsl:sort select="apiName" order="ascending" lang="en-US"/>
													<xsl:variable name="name" select="apiName"/>
													<xsl:variable name="packageName" select="ancestor::apiPackage/apiName"/>
													<xsl:variable name="baseRef">
														<xsl:call-template name="getBaseRef">
															<xsl:with-param name="packageName" select="$packageName"/>
														</xsl:call-template>
													</xsl:variable>
													<tr class="prow{position() mod 2}">
														<td class="summaryTablePaddingCol">
															<xsl:value-of select="$nbsp"/>
														</td>
														<td class="summaryTableSecondCol">
															<a href="{$name}.html">
																<xsl:value-of select="$name"/>
															</a>
															<xsl:choose>
																<xsl:when test="$prog_language_name='javascript'"/>
																<xsl:otherwise>
																	<xsl:if test="prolog/asMetadata/apiVersion/apiPlatform[@name='AIR'] and not (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
																		<xsl:value-of select="$nbsp"/>
																		<xsl:call-template name="insertAIRIcon">
																			<xsl:with-param name="baseRef" select="$baseRef"/>
																		</xsl:call-template>
																	</xsl:if>
																</xsl:otherwise>
															</xsl:choose>
														</td>
														<td class="summaryTableLastCol">
															<xsl:if test="deprecated">
																<xsl:apply-templates select="deprecated"/>
															</xsl:if>
															<xsl:if test="not(deprecated)">
																<xsl:call-template name="shortDescription"/>
																<xsl:if test="not(string-length(normalize-space(./shortdesc)))">
																	<xsl:value-of select="$nbsp"/>
																</xsl:if>
															</xsl:if>
														</td>
													</tr>
												</xsl:for-each>
											</table>
										</xsl:if>
										<p/>
										<xsl:variable name="packageName" select="$name"/>
										<xsl:variable name="baseRef">
											<xsl:call-template name="getBaseRef">
												<xsl:with-param name="packageName" select="$packageName"/>
											</xsl:call-template>
										</xsl:variable>
										<div>
											<p/>
											<xsl:if test="$isTopLevel='true'">
												<xsl:call-template name="getFeedbackLink">
													<xsl:with-param name="topic" select="'Top Level'"/>
													<xsl:with-param name="baseRef" select="$baseRef"/>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$isTopLevel!='true'">
												<xsl:call-template name="getFeedbackLink">
													<xsl:with-param name="topic" select="$name"/>
													<xsl:with-param name="baseRef" select="$baseRef"/>
												</xsl:call-template>
											</xsl:if>
											<center class="copyright">
												<xsl:copy-of select="$copyright"/>
											</center>
										</div>
									</div>
									<xsl:variable name="packageName" select="ancestor::apiPackage/apiName"/>
									<xsl:variable name="baseRef">
										<xsl:call-template name="getBaseRef">
											<xsl:with-param name="packageName" select="$name"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:if test="$config/options[@ion='true']">
										<div class="separator">&#160;</div>
										<xsl:comment>BEGIN IONCOMMENTS</xsl:comment>
										<div id="ionComHere"> </div>
										<xsl:comment>END IONCOMMENTS</xsl:comment>
										<xsl:comment>#include virtual="ionComments.ssi"</xsl:comment>
										<p id="creativecommons" class="creativecommons">
											<a href="http://creativecommons.org/licenses/by-nc-sa/3.0/">
												<img id="creativecommons_img" src="{$baseRef}images/CC.png"/>
											</a>
										</p>
										<xsl:comment>#include virtual="/livedocs/googleAnalytics.ssi"</xsl:comment>
										<xsl:comment>#include virtual="/ubi/analytics/analytics_ssi.html"</xsl:comment>
									</xsl:if>
								</xsl:element>
							</xsl:element>
							<xsl:copy-of select="$copyrightComment"/>
						</xsl:result-document>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
