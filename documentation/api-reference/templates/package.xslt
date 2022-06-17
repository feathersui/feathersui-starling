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
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:param name="packageOverviewFile" select="'overviews.xml'"/>
	<xsl:param name="packages_map_name" select="'packagemap.xml'"/>
	<xsl:template match="/">
		<xsl:for-each select="apiMap//apiItemRef">
			<xsl:sort select="@href" order="ascending"/>
			<xsl:variable name="ditaFileName">
				<xsl:value-of select="concat($ditaFileDir,@href)"/>
			</xsl:variable>
			<xsl:for-each select="document($ditaFileName)/apiPackage">
				<xsl:sort select="./apiName" order="ascending" lang="en-US"/>
				<xsl:variable name="name" select="./apiName"/>
				<xsl:variable name="interfaces">
					<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
						<xsl:call-template name="createBaseInterfaceList"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="isTopLevel">
					<xsl:call-template name="isTopLevel">
						<xsl:with-param name="packageName" select="$name"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="packageFile">
					<xsl:value-of select="$outputPath"/>
					<xsl:choose>
						<xsl:when test="$isTopLevel='true'">package.html</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="translate($name,'.','/')"/>/package.html</xsl:otherwise>
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
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackagePackage']]/entry[2]/p"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="$name"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="xrefPackageName">
					<xsl:choose>
						<xsl:when test="$isTopLevel='true'">__Global__</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$name"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="title">
					<xsl:if test="$isTopLevel='true'">
						<xsl:value-of select="concat($asdoc_terms/row[entry[1][p/text() = 'TopLevelConstantsFunctions']]/entry[2]/p,' - ',$title-base)"/>
					</xsl:if>
					<xsl:if test="not($isTopLevel='true')">
						<xsl:value-of select="concat($name,' ', $asdoc_terms/row[entry[1][p/text() = 'Package']]/entry[2]/p, ' - ',$title-base)"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="baseRef">
					<xsl:call-template name="getBaseRef">
						<xsl:with-param name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="hasConstants" select="count(apiValue[not(./apiValueDetail/apiValueDef/apiProperty)]) &gt; 0"/>
				<xsl:variable name="hasFields" select="count(apiValue/apiValueDetail/apiValueDef/apiProperty) &gt; 0"/>
				<xsl:variable name="hasFunctions" select="count(./apiOperation) &gt; 0"/>
				<xsl:if test="$hasConstants or $hasFields or $hasFunctions">
					<!-- TODO move this to asdoc-util -->
					<xsl:variable name="pname" select="$name"/>
					<xsl:result-document href="{$packageFile}">
						<xsl:copy-of select="$docType"/>
						<xsl:if test="$config/options[@livedocs='true']">
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
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Details']]/entry[2]/p"/>
									<xsl:call-template name="getPageTitlePostFix"/>
								</title>
								<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
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
												<xsl:apply-templates select="$asdoc_terms/row[entry[1][p/text() = 'PackagePackage']]/entry[2]/p" mode="terms">
													<xsl:with-param name="package" select="$name"/>
												</xsl:apply-templates>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="fileName" select="'package'"/>
									<xsl:with-param name="fileName2" select="$classListFile"/>
									<xsl:with-param name="packageName" select="$name"/>
									<xsl:with-param name="showProperties" select="false()"/>
									<xsl:with-param name="showMethods" select="false()"/>
									<xsl:with-param name="showPackageConstants" select="boolean(number($hasConstants))"/>
									<xsl:with-param name="showPackageProperties" select="boolean(number($hasFields))"/>
									<xsl:with-param name="showPackageFunctions" select="boolean(number($hasFunctions))"/>
								</xsl:call-template>
								<div class="MainContent">
									<xsl:apply-templates mode="annotate" select="$config/annotate/item[@type='package' and @name=$name and string-length($name) and tokenize($name,',')[starts-with($pname,.)]]"/>
									<br/>
									<xsl:if test="$hasFields">
										<a name="propertySummary"/>
										<xsl:if test="not($config/overviews/package)">
											<xsl:variable name="packageComments" select="document($packageOverviewFile)/overviews/packages/package[@name=$pname]"/>
											<xsl:call-template name="deTilda">
												<xsl:with-param name="inText" select="$packageComments/propertiesDescription"/>
											</xsl:call-template>
											<xsl:for-each select="$packageComments/propertiesDescription">
												<xsl:call-template name="sees">
													<xsl:with-param name="xrefId" select="concat($xrefPackageName,'#propertySummary')"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:if>
										<xsl:if test="$config/overviews/package">
											<xsl:for-each select="$config/overviews/package">
												<xsl:variable name="packageOverview" select="document(.)/overviews/packages/package[@name=$pname]"/>
												<xsl:if test="$packageOverview/propertiesDescription">
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="$packageOverview/propertiesDescription"/>
													</xsl:call-template>
													<xsl:for-each select="$packageOverview/propertiesDescription">
														<xsl:call-template name="sees">
															<xsl:with-param name="xrefId" select="concat($xrefPackageName,'#propertySummary')"/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<xsl:call-template name="fieldSummary">
											<xsl:with-param name="isGlobal" select="$isTopLevel='true'"/>
											<xsl:with-param name="showAnchor" select="false()"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
										<xsl:if test="boolean(number($hasFunctions)) or boolean(number($hasConstants))">
											<br/>
											<br/>
										</xsl:if>
									</xsl:if>
									<xsl:if test="$hasFunctions">
										<a name="methodSummary"/>
										<xsl:variable name="packageComments" select="document($packageOverviewFile)/overviews/packages/package[@name=$pname]"/>
										<xsl:if test="not($config/overviews/package)">
											<xsl:call-template name="deTilda">
												<xsl:with-param name="inText" select="$packageComments/functionsDescription"/>
											</xsl:call-template>
											<xsl:for-each select="$packageComments/functionsDescription">
												<xsl:call-template name="sees">
													<xsl:with-param name="xrefId" select="concat($xrefPackageName,'#methodSummary')"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:if>
										<xsl:if test="$config/overviews/package">
											<xsl:for-each select="$config/overviews/package">
												<xsl:variable name="packageOverview" select="document(.)/overviews/packages/package[@name=$pname]"/>
												<xsl:if test="$packageOverview/functionsDescription">
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="$packageOverview/functionsDescription"/>
													</xsl:call-template>
													<xsl:for-each select="$packageOverview/functionsDescription">
														<xsl:call-template name="sees">
															<xsl:with-param name="xrefId" select="concat($xrefPackageName,'#methodSummary')"/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<xsl:call-template name="methodSummary">
											<xsl:with-param name="className" select="'package'"/>
											<xsl:with-param name="title" select="$asdoc_terms/row[entry[1][p/text() = 'Functions']]/entry[2]/p"/>
											<xsl:with-param name="isGlobal" select="$isTopLevel='true'"/>
											<xsl:with-param name="showAnchor" select="false()"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
										<xsl:if test="boolean(number($hasConstants))">
											<br/>
											<br/>
										</xsl:if>
									</xsl:if>
									<xsl:if test="$hasConstants">
										<a name="constantSummary"/>
										<xsl:if test="not($config/overviews/package)">
											<xsl:variable name="packageComments" select="document($packageOverviewFile)/overviews/packages/package[@name=$pname]"/>
											<xsl:call-template name="deTilda">
												<xsl:with-param name="inText" select="$packageComments/constantsDescription"/>
											</xsl:call-template>
											<xsl:for-each select="$packageComments/constantsDescription">
												<xsl:call-template name="sees">
													<xsl:with-param name="xrefId" select="concat($xrefPackageName,'#constantSummary')"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:if>
										<xsl:if test="$config/overviews/package">
											<xsl:for-each select="$config/overviews/package">
												<xsl:variable name="packageOverview" select="document(.)/overviews/packages/package[@name=$pname]"/>
												<xsl:if test="$packageOverview/constantsDescription">
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="$packageOverview/constantsDescription"/>
													</xsl:call-template>
													<xsl:for-each select="$packageOverview/constantsDescription">
														<xsl:call-template name="sees">
															<xsl:with-param name="xrefId" select="concat($xrefPackageName,'#constantSummary')"/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<xsl:call-template name="fieldSummary">
											<xsl:with-param name="isConst" select="'true'"/>
											<xsl:with-param name="isGlobal" select="$isTopLevel='true'"/>
											<xsl:with-param name="showAnchor" select="false()"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
									</xsl:if>
									<!--<xsl:apply-templates select="apiValue" mode="detail"/>-->
									<!-- CONSTANT DETAILS FOR PACKAGES-->
									<xsl:if test="boolean(number($hasConstants))">
										<div class="detailSectionHeader">
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">ConstantDetail</xsl:with-param>
											</xsl:call-template>
										</div>
									</xsl:if>
									<xsl:apply-templates select="apiValue[not(apiValueDetail/apiValueDef/apiProperty)]" mode="detail">
										<xsl:with-param name="isConst" select="'true'"/>
									</xsl:apply-templates>
									<!--END OF CONSTANT DETAILS-->
									<!--FUNCTION DETAILS -->
									<xsl:call-template name="methodsDetails">
										<xsl:with-param name="className" select="'package'"/>
										<xsl:with-param name="title">
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">FunctionDetail</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>
										<xsl:with-param name="baseRef" select="$baseRef"/>
									</xsl:call-template>
									<!--END OF FUNCTION DETAILS -->
									<!--PROPERTIES DETAILS -->
									<xsl:if test="boolean(number($hasFields))">
										<div class="detailSectionHeader">
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">PropertyDetail</xsl:with-param>
											</xsl:call-template>
										</div>
									</xsl:if>
									<xsl:apply-templates select="apiValue[apiValueDetail/apiValueDef/apiProperty]" mode="detail">
										<xsl:with-param name="className" select="'package'"/>
										<xsl:with-param name="title">
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">PropertyDetail</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:apply-templates>
									<!--END OF PROPERTIES DETAILS -->
									<p/>
									<xsl:call-template name="getFeedbackLink">
										<xsl:with-param name="topic" select="$packageName"/>
										<xsl:with-param name="filename">
											<xsl:if test="$isTopLevel='true'">package.html</xsl:if>
											<xsl:if test="$isTopLevel!='true'">
												<xsl:value-of select="translate($name,'.','/')"/>
												<xsl:text>/package.html</xsl:text>
											</xsl:if>
										</xsl:with-param>
										<xsl:with-param name="filename2">
											<xsl:if test="$isTopLevel='true'">class-list.html</xsl:if>
											<xsl:if test="$isTopLevel!='true'">
												<xsl:value-of select="translate($name,'.','/')"/>
												<xsl:text>/class-list.html</xsl:text>
											</xsl:if>
										</xsl:with-param>
									</xsl:call-template>
									<center class="copyright">
										<xsl:copy-of select="$copyright"/>
									</center>
									<xsl:call-template name="addKeywords">
										<xsl:with-param name="keyword">
											<xsl:if test="$isTopLevel='true'">
												<xsl:value-of select="'Top Level'"/>
											</xsl:if>
											<xsl:if test="$isTopLevel!='true'">
												<xsl:value-of select="$name"/>
											</xsl:if>
										</xsl:with-param>
									</xsl:call-template>
								</div>
								<xsl:if test="$config/options[@livedocs='true']">
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
					</xsl:result-document>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
