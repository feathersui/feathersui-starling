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
	<xsl:import href="class-parts.xslt"/>
	<xsl:character-map name="disable">
		<xsl:output-character character="&amp;" string="&amp;"/>
		<xsl:output-character character="&lt;" string="&lt;"/>
		<xsl:output-character character="&gt;" string="&gt;"/>
		<xsl:output-character character="&#145;" string="&amp;lsquo;"/>
		<xsl:output-character character="&#146;" string="&amp;apos;"/>
		<xsl:output-character character="&#151;" string="&amp;mdash;"/>
		<xsl:output-character character="&#x2014;" string="&amp;mdash;"/>
		<xsl:output-character character="&#x2009;" string="&amp;thinsp;"/>
		<xsl:output-character character="&#xAE;" string="&amp;reg;"/>
		<xsl:output-character character="&#xB0;" string="&amp;deg;"/>
		<xsl:output-character character="&#x2122;" string="&amp;trade;"/>
	</xsl:character-map>
	<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes" use-character-maps="disable" saxon:character-representation="native;decimal"/>
	<xsl:param name="outputPath" select="''"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:param name="showExamples">true</xsl:param>
	<xsl:param name="showIncludeExamples">true</xsl:param>
	<xsl:param name="showSWFs">
		<xsl:if test="$config/options/@showSWFs='false'">
			<xsl:text>false</xsl:text>
		</xsl:if>
		<xsl:if test="not($config/options/@showSWFs='false')">
			<xsl:text>true</xsl:text>
		</xsl:if>
	</xsl:param>
	<xsl:param name="tabSpaces" select="'    '"/>
	<xsl:param name="classFileName" select="'ClassHeader.xml'"/>
	<xsl:variable name="classHeader_map" select="document($classFileName)//apiPackage"/>
	<xsl:variable name="field_map" select="document('fieldSummary.xml')/allClasses/apiPackage"/>
	<xsl:variable name="method_map" select="document('methodSummary.xml')/allClasses/apiPackage"/>
	<xsl:variable name="event_map" select="document('eventsGeneratedSummary.xml')/allClasses/apiPackage"/>
	<xsl:variable name="style_map" select="document('stylesSummary.xml')/allClasses/apiPackage"/>
	<xsl:variable name="effect_map" select="document('effectsSummary.xml')/allClasses/apiPackage"/>
	<xsl:variable name="thinsp">
		<xsl:text>&#x2009;</xsl:text>
	</xsl:variable>
	<xsl:variable name="tab">
		<xsl:text>	</xsl:text>
	</xsl:variable>
	<xsl:param name="prog_language_name" select="''"/>
	<xsl:param name="jslr" select="'flashclasses.xml'"/>
	<xsl:key name="class_id" match="//apiClassifier" use="@id"/>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$prog_language_name='javascript'"/>
			<!-- ActionScript -->
			<xsl:otherwise>
				<xsl:for-each select="apiMap//apiItemRef">
					<xsl:sort select="@href" order="ascending" lang="en-US"/>
					<xsl:variable name="ditaFileName">
						<xsl:value-of select="concat($ditaFileDir,@href)"/>
					</xsl:variable>
					<xsl:for-each select="document($ditaFileName)/apiPackage//apiClassifier">
						<xsl:sort select="apiName" order="ascending" lang="en-US"/>
						<xsl:variable name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
						<xsl:variable name="name" select="apiName"/>
						<xsl:variable name="ID" select="@id"/>
						<xsl:variable name="classNode" select="."/>
						<xsl:variable name="isTopLevel">
							<xsl:call-template name="isTopLevel">
								<xsl:with-param name="packageName" select="$packageName"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="isInnerClass" select="ancestor::apiClassifier"/>
						<xsl:variable name="packagePath" select="translate($packageName, '.', '/')"/>
						<xsl:variable name="classFile">
							<xsl:value-of select="$outputPath"/>
							<xsl:if test="$isTopLevel='false'">
								<xsl:value-of select="$packagePath"/>
								<xsl:text>/</xsl:text>
							</xsl:if>
							<xsl:value-of select="$name"/>
							<xsl:text>.html</xsl:text>
						</xsl:variable>
						<xsl:variable name="title">
							<xsl:value-of select="concat(concat($name,' - '),$title-base)"/>
						</xsl:variable>
						<xsl:variable name="classDeprecated">
							<xsl:if test="deprecated">
								<xsl:value-of select="'true'"/>
							</xsl:if>
							<xsl:if test="not(deprecated)">
								<xsl:value-of select="'false'"/>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="baseRef">
							<xsl:call-template name="getBaseRef">
								<xsl:with-param name="packageName" select="$packageName"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:result-document href="{$classFile}" method="html">
							<!--xsl:message select="$classFile"/-->
							<xsl:copy-of select="$docType"/>
							<xsl:if test="$config/options[@ion='true']">
								<xsl:comment>#config errmsg=""</xsl:comment>
							</xsl:if>
							<xsl:element name="html">
								<head>
									<xsl:call-template name="getStyleLink">
										<xsl:with-param name="link" select="/asdoc/link"/>
										<xsl:with-param name="packageName" select="$packageName"/>
									</xsl:call-template>
									<xsl:for-each select="$classHeader_map/apiClassifier[@id=$ID]">
										<xsl:copy-of select="./meta"/>
									</xsl:for-each>
									<title>
										<xsl:if test="$isTopLevel='false'">
											<xsl:value-of select="$packageName"/>
											<xsl:text>.</xsl:text>
										</xsl:if>
										<xsl:value-of select="$name"/>
										<xsl:call-template name="getPageTitlePostFix"/>
									</title>
									<xsl:if test="$showIncludeExamples='true' and apiClassifierDetail/example/codeblock">
										<script src="{$baseRef}AC_OETags.js" type="text/javascript"/>
									</xsl:if>
								</head>
								<xsl:element name="body">
									<xsl:if test="$isEclipse">
										<xsl:attribute name="class">
											<xsl:text>eclipseBody</xsl:text>
										</xsl:attribute>
									</xsl:if>
									<xsl:call-template name="getTitleScript">
										<xsl:with-param name="title" select="$title"/>
										<xsl:with-param name="packageName" select="$packageName"/>
									</xsl:call-template>
									<xsl:for-each select="$classHeader_map/apiClassifier[@id=$ID]">
										<xsl:call-template name="classHeader">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="classNode" select="$classNode"/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="$field_map//apiClassifier[@id=$ID]">
										<!-- list of interfaces that this interface extends-->
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<!--  PUBLIC PROPERTY SUMMARY-->
										<xsl:call-template name="fieldSummary">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
											<xsl:with-param name="isConst" select="'false'"/>
										</xsl:call-template>
										<!--  PROTECTED PROPERTY SUMMARY-->
										<xsl:call-template name="fieldSummary">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="accessLevel" select="'protected'" as="xs:string"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
											<xsl:with-param name="isConst" select="'false'"/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="$method_map//apiClassifier[@id=$ID]">
										<!-- list of interfaces that this interface extends-->
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<!--  METHOD SUMMARY-->
										<xsl:call-template name="methodSummary">
											<xsl:with-param name="className" select="$name"/>
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
										<!--  PROTECTED METHOD SUMMARY-->
										<xsl:call-template name="methodSummary">
											<xsl:with-param name="className" select="$name"/>
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="accessLevel" select="'protected'"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="$event_map//apiClassifier[@id=$ID]">
										<!-- list of interfaces that this interface extends-->
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<!--  EVENT SUMMARY-->
										<xsl:call-template name="eventsGeneratedSummary">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="$style_map//apiClassifier[@id=$ID]">
										<!-- list of interfaces that this interface extends-->
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<!-- STYLE SUMMARY-->
										<xsl:call-template name="stylesSummary">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
									</xsl:for-each>

									  <!-- SKIN PART SUMMARY -->
									  <xsl:for-each select="$classHeader_map//apiClassifier[@id=$ID]">
									    <xsl:variable name="interfaces">
									      <xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
										<xsl:call-template name="createBaseInterfaceList"/>
									      </xsl:if>
									    </xsl:variable>
									    <xsl:call-template name="SkinPartSummary">
									      <xsl:with-param name="classDeprecated" select="$classDeprecated"/>
									      <xsl:with-param name="baseRef" select="$baseRef"/>
									      <xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
									    </xsl:call-template>
									  </xsl:for-each> 
									  <!-- SKIN STATE SUMMARY -->
									  <xsl:for-each select="$classHeader_map//apiClassifier[@id=$ID]">
									    <xsl:variable name="interfaces">
									      <xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
										<xsl:call-template name="createBaseInterfaceList"/>
									      </xsl:if>
									    </xsl:variable>
									    <xsl:call-template name="SkinStateSummary">
									      <xsl:with-param name="classDeprecated" select="$classDeprecated"/>
									      <xsl:with-param name="baseRef" select="$baseRef"/>
									      <xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
									    </xsl:call-template>
									  </xsl:for-each> 

                  									
									<xsl:for-each select="$effect_map//apiClassifier[@id=$ID]">
										<!-- list of interfaces that this interface extends-->
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<!-- EFFECT SUMMARY-->
										<xsl:call-template name="effectsSummary">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
									</xsl:for-each>
									<xsl:for-each select="$field_map//apiClassifier[@id=$ID]">
										<!-- list of interfaces that this interface extends-->
										<xsl:variable name="interfaces">
											<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
												<xsl:call-template name="createBaseInterfaceList"/>
											</xsl:if>
										</xsl:variable>
										<!--  PUBLIC CONSTANT SUMMARY-->
										<xsl:call-template name="fieldSummary">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="isConst" select="'true'" as="xs:string"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
										<!--  PROTECTED CONSTANT SUMMARY-->
										<xsl:call-template name="fieldSummary">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="isConst" select="'true'" as="xs:string"/>
											<xsl:with-param name="accessLevel" select="'protected'" as="xs:string"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="interfaces" select="$interfaces" tunnel="yes"/>
										</xsl:call-template>
									</xsl:for-each>
									<script language="javascript" type="text/javascript">
										<xsl:comment>
											<xsl:text>
										</xsl:text>
											<xsl:text>showHideInherited();</xsl:text>
											<xsl:text>
										</xsl:text>
										</xsl:comment>
									</script>
									<div class="MainContent">
										<!--  PROPERTY DETAIL -->
										<xsl:for-each select="$field_map//apiClassifier[@id=$ID]">
											<xsl:call-template name="propertyDetails">
												<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
											</xsl:call-template>
										</xsl:for-each>
										<!-- CONSTRUCTOR DETAIL-->
										<xsl:if test="not(./apiClassifierDetail/apiClassifierDef/apiInterface) and count(apiConstructor) &gt; 0">
											<a name="constructorDetail"/>
											<div class="detailSectionHeader">
												<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ConstructorDetail']]/entry[2]/p"/>
											</div>
											<xsl:variable name="className" select="$name"/>
											<xsl:apply-templates select="apiConstructor[./apiName = $className]" mode="detail">
												<xsl:with-param name="isConstructor">true</xsl:with-param>
												<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
												<xsl:with-param name="constructCall" select="'false'"/>
											</xsl:apply-templates>
										</xsl:if>
										<!-- METHOD DETAIL -->
										<xsl:for-each select="$method_map//apiClassifier[@id=$ID]">
											<xsl:call-template name="methodsDetails">
												<xsl:with-param name="className" select="$name"/>
												<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
												<xsl:with-param name="constructCall" select="'false'"/>
											</xsl:call-template>
										</xsl:for-each>
										<!--  EVENT DETAIL-->
										<xsl:call-template name="eventDetails">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
										</xsl:call-template>
										<!-- STYLE DETAIL -->
										<xsl:call-template name="styleDetails">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
										</xsl:call-template>
										<!--  CONSTANT DETAIL -->
										<xsl:call-template name="constantDetails">
											<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
											<xsl:with-param name="isConst" select="'true'"/>
										</xsl:call-template>
										<!-- INCLUDE EXAMPLES-->
										<xsl:if test="./*/example/codeblock">
											<xsl:variable name="createExampleInstructionLink">
												<xsl:choose>
													<xsl:when test="$config/exampleFile">true</xsl:when>
													<xsl:otherwise>false</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:call-template name="includeExamples">
												<xsl:with-param name="createExampleLink" select="'true'"/>
												<xsl:with-param name="createExampleInstructionLink" select="$createExampleInstructionLink"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
										<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
										<hr/>
										<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
										<xsl:call-template name="getPageLinks">
											<xsl:with-param name="copyNum" select="'2'"/>
										</xsl:call-template>
										<p/>
										<xsl:if test="$config/options[@ion!='true']">
											<xsl:call-template name="getFeedbackLink">
												<xsl:with-param name="topic">
													<xsl:if test="$isTopLevel='false'">
														<xsl:value-of select="$packageName"/>
														<xsl:text>.</xsl:text>
													</xsl:if>
													<xsl:value-of select="$name"/>
												</xsl:with-param>
												<xsl:with-param name="filename">
													<xsl:if test="$isTopLevel='false'">
														<xsl:value-of select="$packagePath"/>
														<xsl:text>/</xsl:text>
													</xsl:if>
													<xsl:value-of select="$name"/>
													<xsl:text>.html</xsl:text>
												</xsl:with-param>
												<xsl:with-param name="filename2">
													<xsl:if test="$isTopLevel='true'">class-list.html</xsl:if>
													<xsl:if test="$isTopLevel!='true'">
														<xsl:value-of select="$packagePath"/>
														<xsl:text>/class-list.html</xsl:text>
													</xsl:if>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$config/options[@ion='true']">
											<script src="{$baseRef}currentpage.js" type="text/javascript" language="Javascript" charset="UTF-8"/>
										</xsl:if>
										<center class="copyright">
											<xsl:copy-of select="$copyright"/>
										</center>
										<xsl:call-template name="addKeywords">
											<xsl:with-param name="keyword" select="$name"/>
										</xsl:call-template>
										<xsl:if test="$isTopLevel='false'">
											<xsl:call-template name="addKeywords">
												<xsl:with-param name="keyword">
													<xsl:value-of select="$packageName"/>
													<xsl:text>.</xsl:text>
													<xsl:value-of select="$name"/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</div>
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
	<!-- INNER CLASSES -->
	<xsl:template name="innerClassSummary">
		<xsl:param name="hasInherited" select="false"/>
		<xsl:param name="classDeprecated" select="false"/>
		<xsl:if test="count(.//apiClassifier) &gt; 0 or boolean($hasInherited)">
			<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			<a name="innerClassSummary"/>
			<table cellspacing="0" cellpadding="3" width="100%" class="withBorder">
				<tr>
					<td colspan="2" bgcolor="#CCCCCC" class="SummaryTableHeader">
						<font size="+1">
							<b>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'InnerClassSummary']]/entry[2]/p"/>
							</b>
						</font>
					</td>
				</tr>
				<xsl:for-each select="//apiClassifier">
					<xsl:sort select="./apiName" order="ascending" lang="en-US"/>
					<tr class="row{position() mod 2}">
						<td width="50px" valign="top">
							<code>
								<font size="1" style="font-weight:bold">
									<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiFinal">
										<xsl:text>final </xsl:text>
									</xsl:if>
									<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiDynamic">
										<xsl:text>dynamic </xsl:text>
									</xsl:if>
								</font>
							</code>
						</td>
						<td valign="top">
							<code>
								<a href="{./apiName}.html">
									<b>
										<xsl:value-of select="./apiName"/>
									</b>
								</a>
							</code>
							<xsl:if test="deprecated">
								<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
							</xsl:if>
							<xsl:apply-templates select="deprecated"/>
							<xsl:if test="not(deprecated)">
								<xsl:call-template name="shortDescription">
									<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
								</xsl:call-template>
							</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- FIELDS -->
	<xsl:template name="fieldSummary">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="isConst" select="'false'"/>
		<xsl:param name="accessLevel" select="'public'"/>
		<xsl:param name="baseRef" select="''"/>
		<xsl:param name="isGlobal" select="false()"/>
		<xsl:param name="showAnchor" select="true()"/>
		<xsl:param name="getProp"/>
		<xsl:param name="interfaces" tunnel="yes"/>
		<xsl:variable name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="ID" select="@id"/>
		<xsl:variable name="hasFields">
			<xsl:if test="$isConst='true'">
				<xsl:value-of
					select="count(apiValue/apiValueDetail/apiValueDef[not(apiProperty) and (apiAccess/@value=$accessLevel or apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]) &gt; 0"/>
			</xsl:if>
			<xsl:if test="$isConst='false'">
				<xsl:value-of
					select="count(apiValue/apiValueDetail/apiValueDef[apiProperty and (apiAccess/@value=$accessLevel or apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]) &gt; 0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="ancestorexcludes">
			<excludes>
				<xsl:for-each select="$classHeader_map//apiClassifier[@id = $ID]//Excludes/Exclude[@kind='property']">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</excludes>
		</xsl:variable>
		<xsl:variable name="propertyList">
			<xsl:if test="$isConst='true'">
				<xsl:for-each
					select="apiValue[not(./apiValueDetail/apiValueDef/apiProperty) and (./apiValueDetail/apiValueDef/apiAccess/@value=$accessLevel or ./apiValueDetail/apiValueDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]">
					<xsl:text> </xsl:text>
					<xsl:value-of select="./apiName"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:for-each select="$ancestorexcludes/excludes/Exclude">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="$isConst='false'">
				<xsl:for-each
					select="apiValue[./apiValueDetail/apiValueDef/apiProperty and (./apiValueDetail/apiValueDef/apiAccess/@value=$accessLevel or ./apiValueDetail/apiValueDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]">
					<xsl:text> </xsl:text>
					<xsl:value-of select="./apiName"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:for-each select="$ancestorexcludes/excludes/Exclude">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="ancestorNode">
			<ancestors>
				<xsl:call-template name="getAncestorProperty">
					<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
					<xsl:with-param name="accessLevel" select="$accessLevel"/>
					<xsl:with-param name="isConst" select="$isConst"/>
					<xsl:with-param name="propertyList" select="$propertyList"/>
				</xsl:call-template>
				<xsl:for-each select="$interfaces/interface">
					<xsl:call-template name="getAncestorProperty">
						<xsl:with-param name="baseClass" select="."/>
						<xsl:with-param name="accessLevel" select="$accessLevel"/>
						<xsl:with-param name="isConst" select="$isConst"/>
						<xsl:with-param name="propertyList" select="$propertyList"/>
						<xsl:with-param name="processParentClass" select="false()"/>
					</xsl:call-template>
				</xsl:for-each>
			</ancestors>
		</xsl:variable>
		<xsl:variable name="hasInherited" select="count($ancestorNode/ancestors/apiValue) &gt; 0"/>
		<xsl:if test="$hasFields='true' or $hasInherited">
			<xsl:if test="$showAnchor">
				<xsl:variable name="hasPublic">
					<xsl:if test="$accessLevel='protected'">
						<xsl:value-of
							select="count(apiValue[not(apiValueDetail/apiValueDef/apiProperty)!=($isConst) and (apiValueDetail/apiValueDef/apiAccess/@value='public' or apiValueDetail/apiValueDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay='public']/.)]) &gt; 0 or $hasInherited"
						/>
					</xsl:if>
					<xsl:if test="not($accessLevel='protected')">
						<xsl:value-of select="false()"/>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="$isConst='true'">
					<xsl:if test="$accessLevel='public'">
						<a name="constantSummary"/>
					</xsl:if>
					<xsl:if test="$accessLevel='protected'">
						<xsl:if test="$hasPublic='false'">
							<a name="constantSummary"/>
						</xsl:if>
						<a name="protectedConstantSummary"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$isConst='false'">
					<xsl:if test="$accessLevel='public'">
						<a name="propertySummary"/>
					</xsl:if>
					<xsl:if test="$accessLevel='protected'">
						<xsl:if test="$hasPublic='false'">
							<a name="propertySummary"/>
						</xsl:if>
						<a name="protectedPropertySummary"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<div class="summarySection">
				<div class="summaryTableTitle">
					<xsl:choose>
						<xsl:when test="$isGlobal and $isConst='true'">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalConstants']]/entry[2]/p"/>
						</xsl:when>
						<xsl:when test="$isGlobal and $isConst='false'">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalProperties']]/entry[2]/p"/>
						</xsl:when>
						<xsl:when test="$accessLevel='public' and $isConst='true'">
							<xsl:choose>
								<xsl:when test="$prog_language_name='javascript'"/>
								<xsl:otherwise>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PublicConstants']]/entry[2]/p"/>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:when>
						<xsl:when test="$accessLevel='public' and $isConst='false'">
							<xsl:choose>
								<xsl:when test="$prog_language_name='javascript'"/>
								<xsl:otherwise>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PublicProperties']]/entry[2]/p"/>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:when>
						<xsl:when test="$accessLevel='protected' and $isConst='true'">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ProtectedConstants']]/entry[2]/p"/>
						</xsl:when>
						<xsl:when test="$accessLevel='protected' and $isConst='false'">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ProtectedProperties']]/entry[2]/p"/>
						</xsl:when>
					</xsl:choose>
				</div>
				<xsl:if test="$hasInherited">
					<div class="showHideLinks">
						<xsl:if test="$isConst='true' and $accessLevel!='protected'">
							<div id="hideInheritedConstant" class="hideInheritedConstant">
								<a class="showHideLink" href="#constantSummary" onclick="javascript:setInheritedVisible(false,'Constant');">
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedPublicConstants']]/entry[2]/p"/>
										</xsl:otherwise>
									</xsl:choose>
								</a>
							</div>
							<div id="showInheritedConstant" class="showInheritedConstant">
								<a class="showHideLink" href="#constantSummary" onclick="javascript:setInheritedVisible(true,'Constant');">
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedPublicConstants']]/entry[2]/p"/>
										</xsl:otherwise>
									</xsl:choose>
								</a>
							</div>
						</xsl:if>
						<xsl:if test="$isConst='true' and $accessLevel='protected'">
							<div id="hideInheritedProtectedConstant" class="hideInheritedProtectedConstant">
								<a class="showHideLink" href="#protectedConstantSummary" onclick="javascript:setInheritedVisible(false,'ProtectedConstant');">
									<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedProtectedConstants']]/entry[2]/p"/>
								</a>
							</div>
							<div id="showInheritedProtectedConstant" class="showInheritedProtectedConstant">
								<a class="showHideLink" href="#protectedConstantSummary" onclick="javascript:setInheritedVisible(true,'ProtectedConstant');">
									<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedProtectedConstants']]/entry[2]/p"/>
								</a>
							</div>
						</xsl:if>
						<xsl:if test="$isConst='false' and $accessLevel!='protected'">
							<div id="hideInheritedProperty" class="hideInheritedProperty">
								<a class="showHideLink" href="#propertySummary" onclick="javascript:setInheritedVisible(false,'Property');">
									<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedPublicProperties']]/entry[2]/p"/>
								</a>
							</div>
							<div id="showInheritedProperty" class="showInheritedProperty">
								<a class="showHideLink" href="#propertySummary" onclick="javascript:setInheritedVisible(true,'Property');">
									<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedPublicProperties']]/entry[2]/p"/>
										</xsl:otherwise>
									</xsl:choose>
								</a>
							</div>
						</xsl:if>
						<xsl:if test="$isConst='false' and $accessLevel='protected'">
							<div id="hideInheritedProtectedProperty" class="hideInheritedProtectedProperty">
								<a class="showHideLink" href="#protectedPropertySummary" onclick="javascript:setInheritedVisible(false,'ProtectedProperty');">
									<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedProtectedProperties']]/entry[2]/p"/>
								</a>
							</div>
							<div id="showInheritedProtectedProperty" class="showInheritedProtectedProperty">
								<a class="showHideLink" href="#protectedPropertySummary" onclick="javascript:setInheritedVisible(true,'ProtectedProperty');">
									<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedProtectedProperties']]/entry[2]/p"/>
								</a>
							</div>
						</xsl:if>
					</div>
				</xsl:if>
				<xsl:variable name="tableStyle">
					<xsl:if test="$hasInherited and $hasFields='false'">
						<xsl:text>hideInherited</xsl:text>
						<xsl:if test="$accessLevel='protected'">
							<xsl:text>Protected</xsl:text>
						</xsl:if>
						<xsl:if test="$isConst='true'">
							<xsl:text>Constant</xsl:text>
						</xsl:if>
						<xsl:if test="$isConst='false'">
							<xsl:text>Property</xsl:text>
						</xsl:if>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="tableId">
					<xsl:text>summaryTable</xsl:text>
					<xsl:if test="$accessLevel='protected'">
						<xsl:text>Protected</xsl:text>
					</xsl:if>
					<xsl:if test="$isConst='true'">
						<xsl:text>Constant</xsl:text>
					</xsl:if>
					<xsl:if test="$isConst='false'">
						<xsl:text>Property</xsl:text>
					</xsl:if>
				</xsl:variable>
				<table cellspacing="0" cellpadding="3" class="summaryTable {$tableStyle}" id="{$tableId}">
					<tr>
						<th>
							<xsl:value-of select="$nbsp"/>
						</th>
						<th colspan="2">
							<xsl:if test="$isConst='false'">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PropertyProperty']]/entry[2]/p"/>
							</xsl:if>
							<xsl:if test="$isConst='true'">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constant']]/entry[2]/p"/>
							</xsl:if>
						</th>
						<xsl:if test="not($config/options/@docversion='2')">
							<th class="summaryTableOwnerCol">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefinedBy']]/entry[2]/p"/>
							</th>
						</xsl:if>
					</tr>
					<xsl:for-each
						select="apiValue[(not(apiValueDetail/apiValueDef/apiProperty)=($isConst='true') or apiValueDetail/apiValueDef/apiProperty='false') and (apiValueDetail/apiValueDef/apiAccess/@value = $accessLevel or apiValueDetail/apiValueDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)] | $ancestorNode/ancestors/apiValue[( not(apiValueDetail/apiValueDef/apiProperty)=($isConst='true') or apiValueDetail/apiValueDef/apiProperty='false') and (apiValueDetail/apiValueDef/apiAccess/@value = $accessLevel or apiValueDetail/apiValueDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]">
						<xsl:sort select="translate(apiName,'_','')" order="ascending" data-type="text" lang="en-US"/>
						<xsl:variable name="name" select="./apiName"/>
						<xsl:variable name="rowStyle">
							<xsl:if test="ancestor::ancestors">
								<xsl:text>hideInherited</xsl:text>
								<xsl:if test="$accessLevel='protected'">
									<xsl:text>Protected</xsl:text>
								</xsl:if>
								<xsl:if test="$isConst='true'">
									<xsl:text>Constant</xsl:text>
								</xsl:if>
								<xsl:if test="$isConst='false'">
									<xsl:text>Property</xsl:text>
								</xsl:if>
							</xsl:if>
						</xsl:variable>
						<tr class="{$rowStyle}">
							<td class="summaryTablePaddingCol">
								<xsl:value-of select="$nbsp"/>
							</td>
							<td class="summaryTableInheritanceCol">
								<xsl:if test="ancestor::ancestors">
									<img src="{$baseRef}images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage"/>
								</xsl:if>
								<xsl:if test="not(ancestor::ancestors)">
									<xsl:value-of select="$nbsp"/>
								</xsl:if>
							</td>
							<td class="summaryTableSignatureCol">
								<xsl:choose>
									<xsl:when test="ancestor::ancestors">
										<xsl:variable name="hLink">
											<xsl:variable name="memberName" select="./apiName"/>
											<xsl:variable name="id" select="./@id"/>
											<xsl:variable name="classNameText" select="substring-after($id,':')"/>
											<xsl:variable name="packageNameText" select="substring-before($id,':')"/>
											<xsl:variable name="packageName">
												<xsl:choose>
													<xsl:when test="not(contains($packageNameText,'.')) and string-length($packageNameText) = 0">
														<xsl:value-of select="''"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$packageNameText"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="className">
												<xsl:choose>
													<xsl:when test="contains($packageName,'.')">
														<xsl:if test="contains($classNameText,':')">
															<xsl:value-of select="substring-before($classNameText,':')"/>
														</xsl:if>
														<xsl:if test="not(contains($classNameText,':'))">
															<xsl:value-of select="$classNameText"/>
														</xsl:if>
													</xsl:when>
													<xsl:otherwise>
														<xsl:if test="contains($classNameText,':')">
															<xsl:value-of select="substring-before($classNameText,':')"/>
														</xsl:if>
														<xsl:if test="not(contains($classNameText,':'))">
															<xsl:value-of select="$classNameText"/>
														</xsl:if>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="methodName">
												<xsl:choose>
													<xsl:when test="$memberName != ''">
														<xsl:value-of select="$memberName"/>
													</xsl:when>
													<xsl:when test="contains($packageName,'.')">
														<xsl:if test="contains($classNameText,':')">
															<xsl:value-of select="substring-after($classNameText,':')"/>
														</xsl:if>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring-after($id,':')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="destination" select="concat($packageName,':',$className)"/>
											<xsl:variable name="h1" select="substring-before($destination,':')"/>
											<xsl:variable name="h2" select="substring-after($destination,':')"/>
											<xsl:variable name="file" select="concat($baseRef,translate($h1,'.','/'),'/',$h2,'.html')"/>
											<xsl:variable name="gfile" select="concat($baseRef,$h2,'.html')"/>
											<xsl:variable name="completeHLink">
												<xsl:if test="string-length($methodName) &gt; 0">
													<xsl:choose>
														<xsl:when test="contains($methodName,':')">
															<xsl:value-of select="concat('#',substring-before($methodName,':'))"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="concat('#',$methodName)"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:variable>
											<xsl:if test="contains($destination,'.') or string-length($packageNameText) &gt; 0">
												<xsl:choose>
													<xsl:when test="$prog_language_name='javascript'"/>
													<xsl:otherwise>
														<xsl:value-of select="$file"/>
														<xsl:value-of select="$completeHLink"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
											<xsl:if test="not(contains($destination,'.')) and string-length($packageNameText) = 0">
												<xsl:choose>
													<xsl:when test="$prog_language_name='javascript'"/>
													<xsl:otherwise>
														<xsl:value-of select="$gfile"/>
														<xsl:value-of select="$completeHLink"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:variable>
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
										<xsl:if test="$hLink!=''">
											<a href="{$hLink}" class="signatureLink">
												<xsl:value-of select="./apiName"/>
											</a>
										</xsl:if>
										<xsl:if test="$hLink=''">
											<xsl:value-of select="./apiName"/>
										</xsl:if>
									</xsl:when>
									<xsl:when test="ancestor::apiClassifier or ancestor-or-self::apiPackage">
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
										<a href="#{$name}" class="signatureLink">
											<xsl:value-of select="$name"/>
										</a>
									</xsl:when>
								</xsl:choose>
								<xsl:if test="./apiValueDetail/apiValueDef/apiValueClassifier | ./apiValueDetail/apiValueDef/apiType ">
									<xsl:text> : </xsl:text>
									<xsl:choose>
										<xsl:when test="./apiValueDetail/apiValueDef/apiValueClassifier">
											<xsl:variable name="destination" select="./apiValueDetail/apiValueDef/apiValueClassifier"/>
											<xsl:variable name="h1" select="substring-after($destination,':')"/>
											<xsl:variable name="h2" select="substring-before($destination,':')"/>
											<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
											<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
											<xsl:variable name="hyperLink">
												<xsl:if test="contains($destination,':')">
													<xsl:if test="$prog_language_name!='javascript'">
														<xsl:value-of select="$file"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(contains($destination,':'))">
													<xsl:choose>
														<xsl:when test="$prog_language_name='javascript'"/>
														<xsl:otherwise>
															<xsl:value-of select="$gfile"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:variable>
											<xsl:if test="$hyperLink = ''">
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="./apiValueDetail/apiValueDef/apiValueClassifier"/>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$hyperLink != ''">
												<a href="{$hyperLink}">
													<xsl:call-template name="getSimpleClassName">
														<xsl:with-param name="fullClassName" select="./apiValueDetail/apiValueDef/apiValueClassifier"/>
													</xsl:call-template>
												</a>
											</xsl:if>
										</xsl:when>
										<xsl:when test="./apiValueDetail/apiValueDef/apiValueClassifier='' or apiValueDetail/apiValueDef/apiValueClassifier='*'">
											<xsl:call-template name="getSpecialTypeLink">
												<xsl:with-param name="type" select="'*'"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="./apiValueDetail/apiValueDef/apiType/@value='' or apiValueDetail/apiValueDef/apiType/@value='*' or apiValueDetail/apiValueDef/apiType/@value='any'">
											<xsl:call-template name="getSpecialTypeLink">
												<xsl:with-param name="type" select="'*'"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="./apiValueDetail/apiValueDef/apiType">
											<xsl:call-template name="getSimpleClassName">
												<xsl:with-param name="fullClassName" select="./apiValueDetail/apiValueDef/apiType/@value"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="getSimpleClassName">
												<xsl:with-param name="fullClassName" select="./apiValueDetail/apiValueDef/apiValueClassifier"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="(string-length(./apiValueDetail/apiValueDef/apiData) or ./apiValueDetail/apiValueDef/apiValueClassifier='String') and ./apiValueDetail/apiValueDef/apiData!='unknown'">
									<xsl:text> = </xsl:text>
									<xsl:if test="./apiValueDetail/apiValueDef/apiType/@value='String'">
										<xsl:text>"</xsl:text>
									</xsl:if>
									<xsl:value-of select="./apiValueDetail/apiValueDef/apiData"/>
									<xsl:if test="apiValueDetail/apiValueDef/apiType/@value='String'">
										<xsl:text>"</xsl:text>
									</xsl:if>
								</xsl:if>
								<xsl:if test="./apiValueDetail/apiValueDef/apiValueClassifier='Number' and ./apiValueDetail/apiValueDef/apiData='unknown'">
									<xsl:text> = NaN</xsl:text>
								</xsl:if>
								<xsl:if test="./apiValueDetail/apiValueDef/apiValueClassifier='String' and ./apiValueDetail/apiValueDef/apiData='unknown'">
									<xsl:text> = "</xsl:text>
									<xsl:value-of select="./apiValueDetail/apiValueDef/apiData"/>
									<xsl:text>"</xsl:text>
								</xsl:if>
								<div class="summaryTableDescription">
									<xsl:apply-templates select="apiValueDetail/apiValueDef/apiDeprecated"/>
									<xsl:apply-templates select="deprecated"/>

									  <xsl:if test="./apiValueDetail/apiValueDef/apiIsOverride">
										<xsl:text>[</xsl:text>
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Override']]/entry[2]/p"/>
										<xsl:text>] </xsl:text>
									  </xsl:if>
									<xsl:if test="not(deprecated)">
										<xsl:if test="./apiValueDetail/apiValueDef/apiStatic">
											<xsl:text>[</xsl:text>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'static']]/entry[2]/p"/>
											<xsl:text>] </xsl:text>
										</xsl:if>
										<xsl:if test="./apiValueDetail/apiValueDef/apiValueAccess/@value and not(./apiValueDetail/apiValueDef/apiValueAccess/@value='readwrite')">
											<xsl:text>[</xsl:text>
											<xsl:variable name="value" select="./apiValueDetail/apiValueDef/apiValueAccess/@value"/>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = $value]]/entry[2]/p"/>
											<xsl:text>-</xsl:text>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'only']]/entry[2]/p"/>
											<xsl:text>] </xsl:text>
										</xsl:if>
										<xsl:if test="./shortdesc or $classDeprecated='true'">
											<xsl:call-template name="shortDescriptionReview"/>
											<xsl:if test="$classDeprecated='true'">
												<xsl:copy-of select="$deprecatedLabel"/>
												<xsl:text>. </xsl:text>
											</xsl:if>
										</xsl:if>
										<xsl:if test="not(string-length(./shortdesc/@conref) &gt; 0)">
											<xsl:for-each select="./shortdesc">
												<xsl:call-template name="processTags"/>
											</xsl:for-each>
										</xsl:if>
									</xsl:if>
								</div>
							</td>
							<xsl:if test="not($config/options/@docversion='2')">
								<td class="summaryTableOwnerCol">
									<xsl:choose>
										<xsl:when test="ancestor::ancestors">
											<xsl:variable name="classLink">
												<xsl:variable name="id" select="./@id"/>
												<xsl:variable name="classNameText" select="substring-after($id,':')"/>
												<xsl:variable name="packageNameText" select="substring-before($id,':')"/>
												<xsl:variable name="packageName">
													<xsl:choose>
														<xsl:when test="not(contains($packageNameText,'.')) and string-length($packageNameText) = 0">
															<xsl:value-of select="''"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$packageNameText"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<xsl:variable name="className">
													<xsl:choose>
														<xsl:when test="contains($packageName,'.')">
															<xsl:if test="contains($classNameText,':')">
																<xsl:value-of select="substring-before($classNameText,':')"/>
															</xsl:if>
															<xsl:if test="not(contains($classNameText,':'))">
																<xsl:value-of select="$classNameText"/>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="contains($classNameText,':')">
																<xsl:value-of select="substring-before($classNameText,':')"/>
															</xsl:if>
															<xsl:if test="not(contains($classNameText,':'))">
																<xsl:value-of select="$classNameText"/>
															</xsl:if>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<xsl:variable name="destination" select="concat($packageName,':',$className)"/>
												<xsl:variable name="h1" select="substring-before($destination,':')"/>
												<xsl:variable name="h2" select="substring-after($destination,':')"/>
												<xsl:variable name="file" select="concat($baseRef,translate($h1,'.','/'),'/',$h2,'.html')"/>
												<xsl:variable name="gfile" select="concat($baseRef,$h2,'.html')"/>
												<xsl:if test="contains($id,'.') or string-length($packageNameText) &gt; 0">
													<xsl:choose>
														<xsl:when test="$prog_language_name='javascript'"/>
														<xsl:otherwise>
															<xsl:value-of select="$file"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
												<xsl:if test="not(contains($id,'.')) and string-length($packageNameText) = 0">
													<xsl:choose>
														<xsl:when test="$prog_language_name='javascript'"/>
														<xsl:otherwise>
															<xsl:value-of select="$gfile"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:variable>
											<xsl:variable name="className">
												<xsl:call-template name="getClassNameFromId">
													<xsl:with-param name="id" select="./@id"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="$classLink!=''">
													<a href="{$classLink}">
														<xsl:value-of select="$className"/>
													</a>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$className"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:when test="ancestor::apiClassifier">
											<xsl:value-of select="ancestor::apiClassifier/apiName"/>
										</xsl:when>
										<xsl:when test="ancestor-or-self::apiPackage">
											<xsl:if test="ancestor-or-self::apiPackage/apiName='__Global__'">
												<xsl:value-of select="concat('Top',$nbsp,'Level')"/>
											</xsl:if>
											<xsl:if test="ancestor-or-self::apiPackage/apiName!='__Global__'">
												<xsl:value-of select="ancestor-or-self::apiPackage/apiName"/>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</td>
							</xsl:if>
						</tr>
					</xsl:for-each>
				</table>
				<!-- AS2 INHERITED PROPERTIES -->
				<xsl:if test="$config/options/@docversion='2'">
					<xsl:for-each select="asAncestors/asAncestor">
						<xsl:call-template name="inherited">
							<xsl:with-param name="lowerType">properties</xsl:with-param>
							<xsl:with-param name="upperType">Properties</xsl:with-param>
							<xsl:with-param name="inheritedItems" select="@properties"/>
							<xsl:with-param name="staticItems" select="@staticProperties"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="apiValue" mode="detail">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="isConst" select="'false'"/>
		<xsl:param name="baseRef"/>
		<xsl:variable name="cntPropOrConst">
			<xsl:if test="$isConst='true'">
				<xsl:value-of select="count(../apiValue/apiValueDetail/apiValueDef[not(apiProperty)])"/>
			</xsl:if>
			<xsl:if test="$isConst='false'">
				<xsl:value-of select="count(apiValueDetail/apiValueDef/apiProperty)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="$cntPropOrConst &gt; 0">
			<xsl:if test="$isConst='true'">
				<a name="constantDetail"/>
			</xsl:if>
			<xsl:if test="not($isConst='true')">
				<a name="propertyDetail"/>
			</xsl:if>
			<xsl:if test="$cntPropOrConst &gt; 0">
				<xsl:for-each select="./apiName">
					<xsl:sort select="translate(./apiName,'_','')" order="ascending" lang="en-US"/>
				</xsl:for-each>
				<xsl:variable name="name" select="./apiName"/>
				<a name="{$name}"/>
				<table class="detailHeader" cellpadding="0" cellspacing="0">
					<tr>
						<td class="detailHeaderName">
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
							<xsl:value-of select="$name"/>
						</td>
						<td class="detailHeaderType">
							<xsl:if test="not(apiValueDetail/apiValueDef/apiProperty)">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constant']]/entry[2]/p"/>
							</xsl:if>
							<xsl:if test="apiValueDetail/apiValueDef/apiProperty">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Property']]/entry[2]/p"/>
							</xsl:if>
						</td>
						<xsl:if test="position()!=1">
							<td class="detailHeaderRule">
								<xsl:value-of select="$nbsp"/>
							</td>
						</xsl:if>
					</tr>
				</table>
				<div class="detailBody">
					<code>
						<xsl:if test="string-length(apiValueDetail/apiValueDef/apiValueAccess/@value)">
							<xsl:value-of select="$name"/>
						</xsl:if>
						<xsl:if test="not(string-length(apiValueDetail/apiValueDef/apiValueAccess/@value))">
							<xsl:call-template name="getNamespaceLink">
								<xsl:with-param name="accessLevel" select="apiValueDetail/apiValueDef/apiAccess/@value"/>
								<xsl:with-param name="baseRef" select="$baseRef"/>
							</xsl:call-template>
							<xsl:text> </xsl:text>
							<xsl:if test="apiValueDetail/apiValueDef/apiStatic">
								<xsl:text>static </xsl:text>
							</xsl:if>
							<xsl:if test="$prog_language_name='ActionScript'">
								<xsl:choose>
									<xsl:when test="not(apiValueDetail/apiValueDef/apiProperty) and $config/options/@docversion='3'">
										<xsl:text>const </xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>var </xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:value-of select="$name"/>
						</xsl:if>
						<xsl:if test="apiValueDetail/apiValueDef/apiValueClassifier | apiValueDetail/apiValueDef/apiType">
							<xsl:text>:</xsl:text>
							<xsl:choose>
								<xsl:when test="apiValueDetail/apiValueDef/apiValueClassifier">
									<xsl:variable name="destination" select="./apiValueDetail/apiValueDef/apiValueClassifier"/>
									<xsl:variable name="h1" select="substring-after($destination,':')"/>
									<xsl:variable name="h2" select="substring-before($destination,':')"/>
									<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
									<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
									<xsl:variable name="hyperLink">
										<xsl:if test="contains($destination,':')">
											<xsl:if test="$prog_language_name!='javascript'">
												<xsl:value-of select="$file"/>
											</xsl:if>
										</xsl:if>
										<xsl:if test="not(contains($destination,':'))">
											<xsl:choose>
												<xsl:when test="$prog_language_name='javascript'"/>
												<xsl:otherwise>
													<xsl:value-of select="$gfile"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</xsl:variable>
									<xsl:if test="$hyperLink = ''">
										<xsl:call-template name="getSimpleClassName">
											<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$hyperLink != ''">
										<a href="{$hyperLink}">
											<xsl:call-template name="getSimpleClassName">
												<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
											</xsl:call-template>
										</a>
									</xsl:if>
								</xsl:when>
								<xsl:when
									test="apiValueDetail/apiValueDef/apiValueClassifier='' or apiValueDetail/apiValueDef/apiValueClassifier='*' or apiValueDetail/apiValueDef/apiType/@value='' or apiValueDetail/apiValueDef/apiType/@value='*' or apiValueDetail/apiValueDef/apiType/@value='any'">
									<xsl:call-template name="getSpecialTypeLink">
										<xsl:with-param name="type" select="'*'"/>
										<xsl:with-param name="baseRef" select="$baseRef"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="apiValueDetail/apiValueDef/apiType">
									<xsl:call-template name="getSimpleClassName">
										<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiType/@value"/>
										<xsl:with-param name="baseRef" select="$baseRef"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getSimpleClassName">
										<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="(string-length(apiValueDetail/apiValueDef/apiData) or apiValueDetail/apiValueDef/apiValueClassifier='String') and apiValueDetail/apiValueDef/apiData!='unknown'">
							<xsl:text> = </xsl:text>
							<xsl:if test="apiValueDetail/apiValueDef/apiType/@value='String'">
								<xsl:text>"</xsl:text>
							</xsl:if>
							<xsl:value-of select="apiValueDetail/apiValueDef/apiData"/>
							<xsl:if test="apiValueDetail/apiValueDef/apiType/@value='String'">
								<xsl:text>"</xsl:text>
							</xsl:if>
						</xsl:if>

						<xsl:if test="apiValueDetail/apiValueDef/apiValueClassifier='Number' and apiValueDetail/apiValueDef/apiData='unknown'">
							<xsl:text> = NaN</xsl:text>
						</xsl:if>
						<xsl:if test="apiValueDetail/apiValueDef/apiValueClassifier='String' and apiValueDetail/apiValueDef/apiData='unknown'">
							<xsl:text> = "</xsl:text>
							<xsl:value-of select="apiValueDetail/apiValueDef/apiData"/>
							<xsl:text>"</xsl:text>
						</xsl:if>
					</code>
					<xsl:if test="string-length(apiValueDetail/apiValueDef/apiValueAccess/@value)">
						<xsl:if test="not(apiValueDetail/apiValueDef/apiValueAccess/@value='readwrite')">
							<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;]]>[</xsl:text>
							<xsl:variable name="value" select="apiValueDetail/apiValueDef/apiValueAccess/@value"/>
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = $value]]/entry[2]/p"/>
							<xsl:text>-</xsl:text>
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'only']]/entry[2]/p"/>
							<xsl:text>] </xsl:text>
						</xsl:if>
					</xsl:if>
					  <xsl:if test="apiValueDetail/apiValueDef/apiIsOverride">
						<xsl:text>[</xsl:text>
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Override']]/entry[2]/p"/>
						<xsl:text>] </xsl:text>
					  </xsl:if>
					<xsl:apply-templates select="apiValueDetail/apiValueDef/apiDeprecated"/>
					<xsl:apply-templates select="deprecated"/>
					<xsl:if test="$classDeprecated='true'">
						<xsl:call-template name="description">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="addParagraphTags" select="true()"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:call-template name="version"/>
					<xsl:if test="$classDeprecated!='true'">
						<xsl:call-template name="description">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="addParagraphTags" select="true()"/>
						</xsl:call-template>
						<xsl:for-each select="apiDesc">
							<xsl:call-template name="processTags"/>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="apiValueDetail/apiValueDef/apiDefaultValue">
						<p>
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefaultValueIs']]/entry[2]/p"/>
							<xsl:text> </xsl:text>
							<code>
								<xsl:value-of select="normalize-space(apiValueDetail/apiValueDef/apiDefaultValue/.)"/>
							</code>
							<xsl:text>.</xsl:text>
						</p>
					</xsl:if>
					<xsl:if test="apiValueDetail/apiValueDef/apiProperty/@isBindable='true'">
						<p>
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DataBinding']]/entry[2]/p"/>
						</p>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$prog_language_name='javascript'"/>
						<xsl:otherwise>
							<xsl:if test="string-length(apiValueDetail/apiValueDef/apiValueAccess/@value)">
								<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
								<span class="label">
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">Implementation</xsl:with-param>
									</xsl:call-template>
								</span>
								<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
								<xsl:if test="contains(apiValueDetail/apiValueDef/apiValueAccess/@value,'read')">
									<code>
										<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
										<xsl:call-template name="getNamespaceLink">
											<xsl:with-param name="accessLevel" select="apiValueDetail/apiValueDef/apiAccess/@value"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
										<xsl:if test="apiValueDetail/apiValueDef/apiStatic">
											<xsl:text>static </xsl:text>
										</xsl:if>
										<xsl:text>function get </xsl:text>
										<xsl:value-of select="$name"/>
										<xsl:text>():</xsl:text>
										<xsl:choose>
											<xsl:when test="./apiValueDetail/apiValueDef/apiValueClassifier">
												<xsl:variable name="destination" select="./apiValueDetail/apiValueDef/apiValueClassifier"/>
												<xsl:variable name="h1" select="substring-after($destination,':')"/>
												<xsl:variable name="h2" select="substring-before($destination,':')"/>
												<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
												<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
												<xsl:variable name="hyperLink">
													<xsl:if test="contains($destination,'.')">
														<xsl:value-of select="$file"/>
													</xsl:if>
													<xsl:if test="not(contains($destination,'.'))">
														<xsl:value-of select="$gfile"/>
													</xsl:if>
												</xsl:variable>
												<xsl:if test="$hyperLink = ''">
													<xsl:call-template name="getSimpleClassName">
														<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test="$hyperLink != ''">
													<a href="{$hyperLink}">
														<xsl:call-template name="getSimpleClassName">
															<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
														</xsl:call-template>
													</a>
												</xsl:if>
											</xsl:when>
											<xsl:when
												test="apiValueDetail/apiValueDef/apiValueClassifier='' or apiValueDetail/apiValueDef/apiValueClassifier='*' or apiValueDetail/apiValueDef/apiType/@value='any' or apiValueDetail/apiValueDef/apiType/@value='' or apiValueDetail/apiValueDef/apiType/@value='*'">
												<xsl:call-template name="getSpecialTypeLink">
													<xsl:with-param name="type" select="'*'"/>
													<xsl:with-param name="baseRef" select="$baseRef"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="apiValueDetail/apiValueDef/apiType">
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiType/@value"/>
													<xsl:with-param name="baseRef" select="$baseRef"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</code>
									<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
								</xsl:if>
								<xsl:if test="contains(apiValueDetail/apiValueDef/apiValueAccess/@value,'write')">
									<code>
										<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
										<xsl:call-template name="getNamespaceLink">
											<xsl:with-param name="accessLevel" select="apiValueDetail/apiValueDef/apiAccess/@value"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
										<xsl:if test="apiValueDetail/apiValueDef/apiStatic">
											<xsl:text>static </xsl:text>
										</xsl:if>
										<xsl:text>function set </xsl:text>
										<xsl:value-of select="$name"/>
										<xsl:text>(value:</xsl:text>
										<xsl:choose>
											<xsl:when test="./apiValueDetail/apiValueDef/apiValueClassifier">
												<xsl:variable name="destination" select="./apiValueDetail/apiValueDef/apiValueClassifier"/>
												<xsl:variable name="h1" select="substring-after($destination,':')"/>
												<xsl:variable name="h2" select="substring-before($destination,':')"/>
												<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
												<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
												<xsl:variable name="hyperLink">
													<xsl:if test="contains($destination,'.')">
														<xsl:value-of select="$file"/>
													</xsl:if>
													<xsl:if test="not(contains($destination,'.'))">
														<xsl:value-of select="$gfile"/>
													</xsl:if>
												</xsl:variable>
												<xsl:if test="$hyperLink = ''">
													<xsl:call-template name="getSimpleClassName">
														<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test="$hyperLink != ''">
													<a href="{$hyperLink}">
														<xsl:call-template name="getSimpleClassName">
															<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
														</xsl:call-template>
													</a>
												</xsl:if>
											</xsl:when>
											<xsl:when test="apiValueDetail/apiValueDef/apiValueClassifier='' or apiValueDetail/apiValueDef/apiValueClassifier='*'">
												<xsl:call-template name="getSpecialTypeLink">
													<xsl:with-param name="type" select="'*'"/>
													<xsl:with-param name="baseRef" select="$baseRef"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="apiValueDetail/apiValueDef/apiType">
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiType/@value"/>
													<xsl:with-param name="baseRef" select="$baseRef"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="apiValueDetail/apiValueDef/apiValueClassifier"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:text>):</xsl:text>
										<xsl:call-template name="getSpecialTypeLink">
											<xsl:with-param name="type" select="'void'"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
										</xsl:call-template>
									</code>
									<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="apiValueDetail/apiValueDef/apiException">
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						<span class="label">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">Throws</xsl:with-param>
							</xsl:call-template>
						</span>
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						<table cellpadding="0" cellspacing="0" border="0">
							<xsl:apply-templates select="apiValueDetail/apiValueDef/apiException"/>
						</table>
					</xsl:if>
					<xsl:call-template name="sees"/>
					<xsl:if test="./*/example[codeblock] | includeExamples/includeExample[codepart]">
						<xsl:call-template name="includeExamples">
							<xsl:with-param name="createExampleLink" select="'false'"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="./*/example[not(codeblock)] | includeExamples/includeExample[not(codepart)] ">
						<xsl:for-each select="./*/example | includeExamples/includeExample[not(codepart)]">
							<xsl:if test="count(descendant::*) &gt; 0">
								<xsl:if test="position() = 1">
									<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
									<span class="label">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">Example</xsl:with-param>
										</xsl:call-template>
									</span>
									<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
								</xsl:if>
								<xsl:call-template name="processTags"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- STYLES -->
	<xsl:template name="stylesSummary">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef" select="''"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:param name="interfaces" tunnel="yes"/>
		<xsl:variable name="ancestorexcludes">
			<excludes>
				<xsl:variable name="self" select="@id"/>
				<xsl:for-each select="$classHeader_map//apiClassifier[@id = $self]//Excludes/Exclude[@kind='style']">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</excludes>
		</xsl:variable>
		<!--List of styles to suppress when creating inheritance list.  Includes both the existing styles and any exclusions-->
		<xsl:variable name="stylesList">
			<xsl:for-each select="prolog/asMetadata/styles/style">
				<xsl:value-of select="concat(' ',@name,' ')"/>
			</xsl:for-each>
			<xsl:for-each select="$ancestorexcludes/excludes/Exclude">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="hasStyles" select="count(prolog/asMetadata[styles/style]) &gt; 0"/>
		<xsl:variable name="ancestorNodes">
			<ancestors>
				<xsl:call-template name="getInheritedStyle">
					<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
					<xsl:with-param name="currentPackage" select="$currentPackage"/>
					<xsl:with-param name="stylesList" select="$stylesList"/>
				</xsl:call-template>
			</ancestors>
			<xsl:for-each select="$interfaces/interface">
				<xsl:call-template name="getInheritedStyle">
					<xsl:with-param name="baseClass" select="."/>
					<xsl:with-param name="currentPackage" select="$currentPackage"/>
					<xsl:with-param name="stylesList" select="$stylesList"/>
					<xsl:with-param name="processParentClass" select="false()"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="hasInherited" select="count($ancestorNodes/ancestors/style) &gt; 0"/>
		<xsl:if test="$hasStyles or $hasInherited">
			<a name="styleSummary"/>
			<div class="summarySection">
				<div class="summaryTableTitle">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Styles']]/entry[2]/p"/>
				</div>
				<xsl:if test="$hasInherited">
					<div class="showHideLinks">
						<div id="hideInheritedStyle" class="hideInheritedStyle">
							<a class="showHideLink" href="#styleSummary" onclick="javascript:setInheritedVisible(false,'Style');">
								<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedStyles']]/entry[2]/p"/>
							</a>
						</div>
						<div id="showInheritedStyle" class="showInheritedStyle">
							<a class="showHideLink" href="#styleSummary" onclick="javascript:setInheritedVisible(true,'Style');">
								<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedStyles']]/entry[2]/p"/>
							</a>
						</div>
					</div>
				</xsl:if>
				<xsl:variable name="tableStyle">
					<xsl:if test="$hasInherited and not($hasStyles)">
						<xsl:text>hideInheritedStyle</xsl:text>
					</xsl:if>
				</xsl:variable>
				<table cellspacing="0" cellpadding="3" class="summaryTable {$tableStyle}" id="summaryTableStyle">
					<tr>
						<th>
							<xsl:value-of select="$nbsp"/>
						</th>
						<th colspan="2">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'StyleStyle']]/entry[2]/p"/>
						</th>
						<th class="summaryTableOwnerCol">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefinedBy']]/entry[2]/p"/>
						</th>
					</tr>
					<xsl:for-each select="./prolog/asMetadata/styles/style | $ancestorNodes/ancestors/style">
						<xsl:sort select="@name" order="ascending" data-type="text" lang="en-US"/>
						<xsl:variable name="sequence" select="ancestor::apiClassifierDetail/apiClassifierDef"/>
						<xsl:variable name="apihtml" select="concat(ancestor::apiClassifier/apiName,'.html')"/>
						<xsl:variable name="destination" select="./@owner"/>
						<xsl:variable name="rowStyle">
							<xsl:if test="ancestor::ancestors">
								<xsl:text>hideInheritedStyle</xsl:text>
							</xsl:if>
						</xsl:variable>
						<tr class="{$rowStyle}">
							<td class="summaryTablePaddingCol">
								<xsl:value-of select="$nbsp"/>
							</td>
							<td class="summaryTableInheritanceCol">
								<xsl:if test="ancestor::ancestors">
									<img src="{$baseRef}images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage"/>
								</xsl:if>
								<xsl:if test="not(ancestor::ancestors)">
									<xsl:value-of select="$nbsp"/>
								</xsl:if>
							</td>
							<td class="summaryTableSignatureCol">
								<div class="summarySignature">
									<xsl:choose>
										<xsl:when test="ancestor::ancestors">
											<xsl:variable name="destination" select="./@owner"/>
											<xsl:variable name="h1" select="substring-after($destination,':')"/>
											<xsl:variable name="h2" select="substring-before($destination,':')"/>
											<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
											<xsl:variable name="gfile" select="concat($baseRef,translate($destination,':','/'),'.html')"/>
											<xsl:variable name="hyperLink">
												<xsl:if test="contains($destination,'.')">
													<xsl:value-of select="$file"/>
												</xsl:if>
												<xsl:if test="not(contains($destination,'.'))">
													<xsl:value-of select="$gfile"/>
												</xsl:if>
											</xsl:variable>
											<xsl:if test="$hyperLink = ''">
												<xsl:value-of select="@name"/>
											</xsl:if>
											<xsl:if test="$hyperLink != ''">
												<a href="{$hyperLink}#style:{@name}" class="signatureLink">
													<xsl:value-of select="@name"/>
												</a>
											</xsl:if>
										</xsl:when>
										<xsl:when test="ancestor::apiClassifier">
											<a href="#style:{@name}" class="signatureLink">
												<xsl:value-of select="@name"/>
											</a>
										</xsl:when>
									</xsl:choose>
									<xsl:if test="@type">
										<xsl:text> : </xsl:text>
										<xsl:call-template name="getSimpleClassName">
											<xsl:with-param name="fullClassName" select="@type"/>
										</xsl:call-template>
									</xsl:if>
								</div>

								<div class="summaryTableDescription">
									<xsl:apply-templates select="apiValueDetail/apiValueDef/apiDeprecated"/>
									<xsl:apply-templates select="deprecated"/>

									  <xsl:if test="./apiValueDetail/apiValueDef/apiIsOverride">
										<xsl:text>[</xsl:text>
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Override']]/entry[2]/p"/>
										<xsl:text>] </xsl:text>
									  </xsl:if>
									<xsl:if test="not(deprecated)">
										<xsl:if test="./apiValueDetail/apiValueDef/apiStatic">
											<xsl:text>[</xsl:text>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'static']]/entry[2]/p"/>
											<xsl:text>] </xsl:text>
										</xsl:if>
										<xsl:if test="./apiValueDetail/apiValueDef/apiValueAccess/@value and not(./apiValueDetail/apiValueDef/apiValueAccess/@value='readwrite')">
											<xsl:text>[</xsl:text>
											<xsl:variable name="value" select="./apiValueDetail/apiValueDef/apiValueAccess/@value"/>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = $value]]/entry[2]/p"/>
											<xsl:text>-</xsl:text>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'only']]/entry[2]/p"/>
											<xsl:text>] </xsl:text>
										</xsl:if>
										<xsl:variable name="description">
											<xsl:call-template name="getFirstSentence">
												<xsl:with-param name="inText" select="./description"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:for-each select="$description">
											<xsl:call-template name="processTags"/>
										</xsl:for-each>
									</xsl:if>
								</div>
							</td>
							<td class="summaryTableOwnerCol">
								<xsl:choose>
									<xsl:when test="ancestor::ancestors">
										<xsl:variable name="destination" select="./@owner"/>
										<xsl:variable name="h1" select="substring-after($destination,':')"/>
										<xsl:variable name="h2" select="substring-before($destination,':')"/>
										<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
										<xsl:variable name="gfile" select="concat($baseRef,translate($destination,':','/'),'.html')"/>
										<xsl:variable name="classLink">
											<xsl:if test="contains($destination,'.')">
												<xsl:value-of select="$file"/>
											</xsl:if>
											<xsl:if test="not(contains($destination,'.'))">
												<xsl:value-of select="$gfile"/>
											</xsl:if>
										</xsl:variable>
										<xsl:if test="$classLink = ''">
											<xsl:value-of select="substring-after(./@owner,':')"/>
										</xsl:if>
										<xsl:if test="$classLink != ''">
											<a href="{$classLink}">
												<xsl:value-of select="substring-after(./@owner,':')"/>
											</a>
										</xsl:if>
									</xsl:when>
									<xsl:when test="ancestor::apiClassifier">
										<xsl:value-of select="ancestor::apiClassifier/apiName"/>
									</xsl:when>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</div>
		</xsl:if>
	</xsl:template>
	<!-- SKINSTATE -->
	<xsl:template name="SkinStateSummary">
	<xsl:param name="classDeprecated" select="'false'"/>
	<xsl:param name="baseRef" select="''"/>
	<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
	<xsl:param name="interfaces" tunnel="yes"/>
	<xsl:variable name="SkinStateList">
	<xsl:for-each select="./prolog/asMetadata/skinStates/SkinState">
	<xsl:value-of select="concat(' ',@name,' ')"/>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="hasSkinState" select="count(./prolog/asMetadata[skinStates/SkinState]) &gt; 0"/>
	<xsl:variable name="ancestorNodes">
	<ancestors>
	<xsl:call-template name="getInheritedSkinState">
	  <xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
	  <xsl:with-param name="currentPackage" select="$currentPackage"/>
	  <xsl:with-param name="SkinStateList" select="$SkinStateList"/>
	</xsl:call-template>
	</ancestors>
	<xsl:for-each select="$interfaces/interface">
	<xsl:call-template name="getInheritedSkinState">
	  <xsl:with-param name="baseClass" select="."/>
	  <xsl:with-param name="currentPackage" select="$currentPackage"/>
	  <xsl:with-param name="SkinStateList" select="$SkinStateList"/>
	  <xsl:with-param name="processParentClass" select="false()"/>
	</xsl:call-template>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="hasInherited" select="count($ancestorNodes/ancestors/SkinState) &gt; 0"/>
	<xsl:if test="$hasSkinState or $hasInherited">
	<a name="SkinStateSummary"/>
	<div class="summarySection">
	<div class="summaryTableTitle">
	  <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinStates']]/entry[2]/p"/>
	</div>
	<p><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'skinstateprefixed']]/entry[2]/p"/></p>
	<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
	<!-- Start: Bug#2259590 Shinde Date: 13.03.09 Adding a link to the doc -->
	<xsl:if test="$isSkin!=''">
	  <div class="showHideLinks">
	    <a href="{$isSkin}" target="_blank">
	      <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'howtouseskins']]/entry[2]/p"/>
	    </a>
	  </div>
	</xsl:if>
	<!-- End: Bug#2259590 Shinde Date: 13.03.09 Adding a link to the doc -->
	<xsl:if test="$hasInherited">
	  <div class="showHideLinks">
	    <div id="hideInheritedSkinState" class="hideInheritedSkinState">
	      <a class="showHideLink" href="#SkinStateSummary" onclick="javascript:setInheritedVisible(false,'SkinState');">
		<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
		<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedSkinStates']]/entry[2]/p"/>
	      </a>
	    </div>
	    <div id="showInheritedSkinState" class="showInheritedSkinState">
	      <a class="showHideLink" href="#SkinStateSummary" onclick="javascript:setInheritedVisible(true,'SkinState');">
		<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
		<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedSkinStates']]/entry[2]/p"/>
	      </a>
	    </div>
	  </div>
	</xsl:if>
	<xsl:variable name="tableSkinState">
	  <xsl:if test="$hasInherited and not($hasSkinState)">
	    <xsl:text>hideInheritedSkinState</xsl:text>
	  </xsl:if>
	</xsl:variable>
	<table cellspacing="0" cellpadding="3" class="summaryTable {$tableSkinState}" id="summaryTableSkinState">
	  <tr>
	    <th>
	      <xsl:value-of select="$nbsp"/>
	    </th>
	    <th colspan="2">
	      <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinState']]/entry[2]/p"/>
	    </th>
	    <th>
	      <xsl:call-template name="getLocalizedString">
		<xsl:with-param name="key">Description</xsl:with-param>
	      </xsl:call-template>
	    </th>
	    <th>
	      <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefinedBy']]/entry[2]/p"/>
	    </th>
	  </tr>
	  <xsl:for-each select="./prolog/asMetadata/skinStates/SkinState | $ancestorNodes/ancestors/SkinState">
	    <xsl:sort select="@name" order="ascending" data-type="text" lang="en-US"/>
	    <xsl:variable name="sequence" select="ancestor::apiClassifierDetail/apiClassifierDef"/>
	    <xsl:variable name="apihtml" select="concat(ancestor::apiClassifier/apiName,'.html')"/>
	    <xsl:variable name="destination" select="./@owner"/>
	    <xsl:variable name="rowStyle">
	      <xsl:if test="ancestor::ancestors">
		<xsl:text>hideInheritedskinState</xsl:text>
	      </xsl:if>
	    </xsl:variable>
	    <tr class="{$rowStyle}">
	      <td class="summaryTablePaddingCol">
		<xsl:if test="not(ancestor::ancestors)">
		  <a name="skinstate:{@name}"/>
		</xsl:if>
		<xsl:value-of select="$nbsp"/>
	      </td>
	      <td class="summaryTableInheritanceCol">
		<xsl:if test="ancestor::ancestors">
		  <img src="{$baseRef}images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage"/>
		</xsl:if>
		<xsl:if test="not(ancestor::ancestors)">
		  <xsl:value-of select="$nbsp"/>
		</xsl:if>
	      </td>
	      <td class="summaryTableSignatureCol">
		<div class="summarySignature">
		  <xsl:choose>
		    <xsl:when test="ancestor::ancestors">
		      <xsl:variable name="destination" select="./@owner"/>
		      <xsl:variable name="h1" select="substring-after($destination,':')"/>
		      <xsl:variable name="h2" select="substring-before($destination,':')"/>
		      <xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
		      <xsl:variable name="gfile" select="concat($baseRef,replace($destination, ':', '/'),'.html')"/>
		      <xsl:variable name="hyperLink">
			<xsl:if test="contains($destination,'.')">
			  <xsl:value-of select="$file"/>
			</xsl:if>
			<xsl:if test="not(contains($destination,'.'))">
			  <xsl:value-of select="$gfile"/>
			</xsl:if>
		      </xsl:variable>
		      <xsl:if test="$hyperLink = ''">
			<xsl:value-of select="@name"/>
		      </xsl:if>
		      <xsl:if test="$hyperLink != ''">
			<a href="{$hyperLink}#skinstate:{@name}" class="signatureLink">
			  <xsl:value-of select="@name"/>
			</a>
		      </xsl:if>
		    </xsl:when>
		    <xsl:when test="ancestor::apiClassifier">
		      <span class="signatureLink">
			<xsl:value-of select="@name"/>
		      </span>
		    </xsl:when>
		  </xsl:choose>
		</div>
	      </td>
	      <td class="summaryTableDescription">
		<xsl:if test="not(ancestor::ancestors)">
		  <xsl:call-template name="deTilda">
		    <xsl:with-param name="inText" select="description/."/>
		  </xsl:call-template>
		</xsl:if>
		<xsl:if test="ancestor::ancestors">
		  <xsl:call-template name="deTilda">
		    <xsl:with-param name="inText" select="description/."/>
		  </xsl:call-template>
		</xsl:if>
		<xsl:call-template name="sees">
			<xsl:with-param name="currentPackage" select="$currentPackage"/>
		</xsl:call-template>
	      </td>
	      <td class="summaryTableOwnerCol">
		<xsl:choose>
		  <xsl:when test="ancestor::ancestors">
		    <xsl:variable name="destination" select="./@owner"/>
		    <xsl:variable name="h1" select="substring-after($destination,':')"/>
		    <xsl:variable name="h2" select="substring-before($destination,':')"/>
		    <xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
		    <xsl:variable name="gfile" select="concat($baseRef,replace($destination, ':', '/'),'.html')"/>
		    <xsl:variable name="classLink">
		      <xsl:if test="contains($destination,'.')">
			<xsl:value-of select="$file"/>
		      </xsl:if>
		      <xsl:if test="not(contains($destination,'.'))">
			<xsl:value-of select="$gfile"/>
		      </xsl:if>
		    </xsl:variable>
		    <xsl:if test="$classLink = ''">
		      <xsl:value-of select="substring-after(./@owner,':')"/>
		    </xsl:if>
		    <xsl:if test="$classLink != ''">
		      <a href="{$classLink}">
			<xsl:value-of select="substring-after(./@owner,':')"/>
		      </a>
		    </xsl:if>
		  </xsl:when>
		  <xsl:when test="ancestor::apiClassifier">
		    <xsl:value-of select="ancestor::apiClassifier/apiName"/>
		  </xsl:when>
		</xsl:choose>
	      </td>
	    </tr>
	  </xsl:for-each>
	</table>
	</div>
	</xsl:if>
	</xsl:template>
	<!-- SKIN PART -->
	<xsl:template name="SkinPartSummary">
	<xsl:param name="classDeprecated" select="'false'"/>
	<xsl:param name="baseRef" select="''"/>
	<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
	<xsl:param name="interfaces" tunnel="yes"/>
	<xsl:variable name="SkinPartList">
	<xsl:for-each select="prolog/asMetadata/styles/style">
	<xsl:value-of select="concat(' ',@name,' ')"/>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="hasSkinPart" select="count(./prolog/asMetadata[skinParts/SkinPart]) &gt; 0"/>
	<xsl:variable name="ancestorNodes">
	<ancestors>
	<xsl:call-template name="getInheritedSkinPart">
	  <xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
	  <xsl:with-param name="currentPackage" select="$currentPackage"/>
	  <xsl:with-param name="SkinPartList" select="$SkinPartList"/>
	</xsl:call-template>
	</ancestors>
	<xsl:for-each select="$interfaces/interface">
	<xsl:call-template name="getInheritedSkinPart">
	  <xsl:with-param name="baseClass" select="."/>
	  <xsl:with-param name="currentPackage" select="$currentPackage"/>
	  <xsl:with-param name="SkinPartList" select="$SkinPartList"/>
	  <xsl:with-param name="processParentClass" select="false()"/>
	</xsl:call-template>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="hasInherited" select="count($ancestorNodes/ancestors/SkinPart) &gt; 0"/>
	<xsl:if test="$hasSkinPart or $hasInherited">
	<a name="SkinPartSummary"/>
	<div class="summarySection">
	<div class="summaryTableTitle">
	  <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinParts']]/entry[2]/p"/>
	</div>
	<p><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'skinpartprefixed']]/entry[2]/p"/></p>
	<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
	<!-- Start: Bug#2259590 Shinde Date: 13.03.09 Adding a link to the doc -->
	<xsl:if test="$isSkin!=''">
	  <div class="showHideLinks">
	    <a href="{$isSkin}" target="_blank">
	      <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'howtouseskins']]/entry[2]/p"/>
	    </a>
	  </div>
	</xsl:if>
	<!-- End: Bug#2259590 Shinde Date: 13.03.09 Adding a link to the doc -->
	<xsl:if test="$hasInherited">
	  <div class="showHideLinks">
	    <div id="hideInheritedSkinPart" class="hideInheritedSkinPart">
	      <a class="showHideLink" href="#SkinPartSummary" onclick="javascript:setInheritedVisible(false,'SkinPart');">
		<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
		<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedSkinParts']]/entry[2]/p"/>
	      </a>
	    </div>
	    <div id="showInheritedSkinPart" class="showInheritedSkinPart">
	      <a class="showHideLink" href="#SkinPartSummary" onclick="javascript:setInheritedVisible(true,'SkinPart');">
		<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
		<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedSkinParts']]/entry[2]/p"/>
	      </a>
	    </div>
	  </div>
	</xsl:if>
	<xsl:variable name="tableStyle">
	  <xsl:if test="$hasInherited and not($hasSkinPart)">
	    <xsl:text>hideInheritedSkinPart</xsl:text>
	  </xsl:if>
	</xsl:variable>
	<table cellspacing="0" cellpadding="3" class="summaryTable {$tableStyle}" id="summaryTableSkinPart">
	  <tr>
	    <th>
	      <xsl:value-of select="$nbsp"/>
	    </th>
	    <th colspan="2">
	      <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinPart']]/entry[2]/p"/>
	    </th>
	    <th>
	      <xsl:call-template name="getLocalizedString">
		<xsl:with-param name="key">Description</xsl:with-param>
	      </xsl:call-template>
	    </th>
	    <th>
	      <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefinedBy']]/entry[2]/p"/>
	    </th>
	  </tr>
	  <xsl:for-each select="./prolog/asMetadata/skinParts/SkinPart | $ancestorNodes/ancestors/SkinPart">
	    <xsl:sort select="@name" order="ascending" data-type="text" lang="en-US"/>
	    <xsl:variable name="sequence" select="ancestor::apiClassifierDetail/apiClassifierDef"/>
	    <xsl:variable name="apihtml" select="concat(ancestor::apiClassifier/apiName,'.html')"/>
	    <xsl:variable name="destination" select="./@owner"/>
	    <xsl:variable name="rowStyle">
	      <xsl:if test="ancestor::ancestors">
		<xsl:text>hideInheritedSkinPart</xsl:text>
	      </xsl:if>
	    </xsl:variable>
	    <tr class="{$rowStyle}">
	      <td class="summaryTablePaddingCol">
		<xsl:if test="not(ancestor::ancestors)">
		  <a name="skinpart:{@name}"/>
		</xsl:if>
		<xsl:value-of select="$nbsp"/>
	      </td>
	      <td class="summaryTableInheritanceCol">
		<xsl:if test="ancestor::ancestors">
		  <img src="{$baseRef}images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage"/>
		</xsl:if>
		<xsl:if test="not(ancestor::ancestors)">
		  <xsl:value-of select="$nbsp"/>
		</xsl:if>
	      </td>
	      <td class="summaryTableSignatureCol">
		<div class="summarySignature">
			
		  <xsl:choose>
		    <xsl:when test="ancestor::ancestors">
		      <xsl:variable name="destination" select="./@owner"/>
		      <xsl:variable name="h1" select="substring-after($destination,':')"/>
		      <xsl:variable name="h2" select="substring-before($destination,':')"/>
		      <xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
		      <xsl:variable name="gfile" select="concat($baseRef,replace($destination, ':', '/'),'.html')"/>
		      <xsl:variable name="hyperLink">
			<xsl:if test="contains($destination,'.')">
			  <xsl:value-of select="$file"/>
			</xsl:if>
			<xsl:if test="not(contains($destination,'.'))">
			  <xsl:value-of select="$gfile"/>
			</xsl:if>
		      </xsl:variable>
		      <xsl:if test="$hyperLink = ''">
			<xsl:value-of select="@name"/>
		      </xsl:if>
		      <xsl:if test="$hyperLink != ''">
			<a href="{$hyperLink}#skinpart:{@name}" class="signatureLink">
			  <xsl:value-of select="@name"/>
			</a>
		      </xsl:if>
		    </xsl:when>
		    <xsl:when test="ancestor::apiClassifier">
		      <span class="signatureLink">
			<xsl:value-of select="@name"/>
		      </span>
		    </xsl:when>
		  </xsl:choose>
		  <xsl:if test="@var_type">
		    <xsl:text>:</xsl:text>
		    <xsl:variable name="destination" select="./@var_type"/>
		    <xsl:variable name="h1" select="substring-after($destination,':')"/>
		    <xsl:variable name="h2" select="substring-before($destination,':')"/>
		    <xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
		    <xsl:variable name="gfile" select="replace(concat($baseRef, $destination, '.html'), ':', '/')"/>
		    <xsl:variable name="hyperLink">
		      <xsl:if test="contains($destination,'.')">
			<xsl:value-of select="$file"/>
		      </xsl:if>
		      <xsl:if test="not(contains($destination,'.'))">
			<xsl:value-of select="$gfile"/>
		      </xsl:if>
		    </xsl:variable>

		    <xsl:if test="count($classHeader_map//apiClassifier[@id=$destination] ) &gt; 0">
				<xsl:if test="$hyperLink = ''">
					<xsl:if test="not(contains($destination,':'))">
						<xsl:value-of select="$destination"/>
					</xsl:if>
					<xsl:if test="contains($destination,':')">
						<xsl:value-of select="concat($h2,concat('.',$h1))"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$hyperLink != ''">
					<a href="{$hyperLink}" class="signatureLink">
						<xsl:value-of select="$h1"/>
		      		</a>
				</xsl:if>
		      </xsl:if>
		      <xsl:if test="not(count($classHeader_map//apiClassifier[@id=$destination] ) &gt; 0)">
					<xsl:if test="not(contains($destination,':'))">
						<xsl:value-of select="$destination"/>
					</xsl:if>
					<xsl:if test="contains($destination,':')">
						<xsl:value-of select="concat($h2,concat('.',$h1))"/>
					</xsl:if>
		      </xsl:if>
		  </xsl:if>
		</div>
	      </td>
	      <td class="summaryTableDescription">
		<xsl:if test="string-length(normalize-space(@required)) &gt; 0">
		  <span class="label">
		    <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Required']]/entry[2]/p"/>: </span>
		  <xsl:value-of select="normalize-space(@required)"/>
		</xsl:if>
		<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
		<xsl:if test="not(@type)">
		  <span class="label">
		    <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PartType']]/entry[2]/p"/>: </span>
		  <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Static']]/entry[2]/p"/>
		</xsl:if>
		<xsl:if test="@type!=''">
		  <span class="label">
		    <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PartType']]/entry[2]/p"/>: </span>
		  <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Dynamic']]/entry[2]/p"/>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
		<xsl:if test="not(ancestor::ancestors)">
		  <xsl:call-template name="deTilda">
		    <xsl:with-param name="inText" select="description/."/>
		  </xsl:call-template>
		</xsl:if>
		<xsl:if test="ancestor::ancestors">
		  <xsl:call-template name="deTilda">
		    <xsl:with-param name="inText" select="description/."/>
		  </xsl:call-template>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
		<xsl:if test="@type!=''">
		    <xsl:variable name="hyperlink">
		      <xsl:call-template name="styleTypeHyperlink">
			<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
			<xsl:with-param name="type" select="@type"/>
		      </xsl:call-template>
		    </xsl:variable>
		  <xsl:variable name="propdesc">
		    <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'dynpropdesc']]/entry[2]/p"/>
		  </xsl:variable>
		  <xsl:variable name="destination" select="./@var_type"/>
		  <xsl:variable name="var_type" select="substring-after($destination,':')"/>
		  <xsl:variable name="type.value" select="replace($propdesc,'%type%',$var_type)"/>
		  
		  <xsl:variable name="full.type" select="replace(@type, ':', '.')"/>
		  <xsl:if test="replace(@var_type, ':', '.')!=$full.type">
			  <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			  <xsl:value-of select="$type.value"/><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
			  
			   <xsl:variable name="display.type" >
					<xsl:call-template name="substring-after-last">
						<xsl:with-param name="input" select="$full.type"/>
						<xsl:with-param name="substr" select="'.'"/>
					</xsl:call-template>
				</xsl:variable >
							
				<xsl:if test="count($classHeader_map//apiClassifier[@id=@type] ) &gt; 0">
					<a href="{$hyperlink}">
						<xsl:value-of select="$display.type"/>
					</a>
				</xsl:if>
				<xsl:if test="not(count($classHeader_map//apiClassifier[@id=@type] ) &gt; 0)">
					<xsl:value-of select="$display.type"/>
				</xsl:if>
		  </xsl:if>
		</xsl:if>
			<xsl:call-template name="sees">
				<xsl:with-param name="currentPackage" select="$currentPackage"/>
			</xsl:call-template>
	      </td>
	      <td class="summaryTableOwnerCol">
		<xsl:choose>
		  <xsl:when test="ancestor::ancestors">
		    <xsl:variable name="destination" select="./@owner"/>
		    <xsl:variable name="h1" select="substring-after($destination,':')"/>
		    <xsl:variable name="h2" select="substring-before($destination,':')"/>
		    <xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
		    <xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
		    <xsl:variable name="classLink">
		      <xsl:if test="contains($destination,'.')">
			<xsl:value-of select="$file"/>
		      </xsl:if>
		      <xsl:if test="not(contains($destination,'.'))">
			<xsl:value-of select="$gfile"/>
		      </xsl:if>
		    </xsl:variable>
		    <xsl:if test="$classLink = ''">
		      <xsl:value-of select="substring-after(./@owner,':')"/>
		    </xsl:if>
		    <xsl:if test="$classLink != ''">
		      <a href="{$classLink}">
			<xsl:value-of select="substring-after(./@owner,':')"/>
		      </a>
		    </xsl:if>
		  </xsl:when>
		  <xsl:when test="ancestor::apiClassifier">
		    <xsl:value-of select="ancestor::apiClassifier/apiName"/>
		  </xsl:when>
		</xsl:choose>
	      </td>
	    </tr>
	  </xsl:for-each>
	</table>
	</div>
	</xsl:if>
	</xsl:template>	
	<!-- EFFECTS -->
	<xsl:template name="effectsSummary">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef" select="''"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:param name="interfaces" tunnel="yes"/>
		<xsl:variable name="ancestorexcludes">
			<excludes>
				<xsl:variable name="self" select="@id"/>
				<xsl:for-each select="$classHeader_map//apiClassifier[@id = $self]//Excludes/Exclude[@kind='effect']">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</excludes>
		</xsl:variable>
		<!--List of effects to suppress when creating inheritance list.  Includes both the existing effects and any exclusions-->
		<xsl:variable name="effectsList">
			<xsl:for-each select="prolog/asMetadata/effects/effect">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
			<xsl:for-each select="$ancestorexcludes/excludes/Exclude">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="hasEffects" select="count(prolog/asMetadata/effects/effect) &gt; 0"/>
		<xsl:variable name="ancestorNodes">
			<ancestors>
				<xsl:call-template name="getInheritedEffect">
					<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
					<xsl:with-param name="currentPackage" select="$currentPackage"/>
					<xsl:with-param name="effectsList" select="$effectsList"/>
				</xsl:call-template>
				<xsl:for-each select="$interfaces/interface">
					<xsl:call-template name="getInheritedEffect">
						<xsl:with-param name="baseClass" select="."/>
						<xsl:with-param name="currentPackage" select="$currentPackage"/>
						<xsl:with-param name="effectsList" select="$effectsList"/>
						<xsl:with-param name="processParentClass" select="false()"/>
					</xsl:call-template>
				</xsl:for-each>
			</ancestors>
		</xsl:variable>
		<xsl:variable name="hasInherited" select="count($ancestorNodes/ancestors/effect ) &gt; 0"/>
		<xsl:if test="$hasEffects or $hasInherited">
			<a name="effectSummary"/>
			<div class="summarySection">
				<div class="summaryTableTitle">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Effects']]/entry[2]/p"/>
				</div>
				<xsl:if test="$hasInherited">
					<div class="showHideLinks">
						<div id="hideInheritedEffect" class="hideInheritedEffect">
							<a class="showHideLink" href="#effectSummary" onclick="javascript:setInheritedVisible(false,'Effect');">
								<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedEffects']]/entry[2]/p"/>
							</a>
						</div>
						<div id="showInheritedEffect" class="showInheritedEffect">
							<a class="showHideLink" href="#effectSummary" onclick="javascript:setInheritedVisible(true,'Effect');">
								<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedEffects']]/entry[2]/p"/>
							</a>
						</div>
					</div>
				</xsl:if>
				<xsl:variable name="tableStyle">
					<xsl:if test="$hasInherited and not($hasEffects)">
						<xsl:text>hideInheritedEffect</xsl:text>
					</xsl:if>
				</xsl:variable>
				<table cellspacing="0" cellpadding="3" class="summaryTable {$tableStyle}" id="summaryTableEffect">
					<tr>
						<th>
							<xsl:value-of select="$nbsp"/>
						</th>
						<th colspan="2">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Effect']]/entry[2]/p"/>
						</th>
						<th>
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">Description</xsl:with-param>
							</xsl:call-template>
						</th>
						<th class="summaryTableOwnerCol">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefinedBy']]/entry[2]/p"/>
						</th>
					</tr>
					<xsl:for-each select="prolog/asMetadata/effects/effect | $ancestorNodes/ancestors/effect">
						<xsl:sort select="@name" order="ascending" data-type="text" lang="en-US"/>
						<xsl:variable name="owner" select="@owner"/>
						<xsl:variable name="ancestorPath" select="ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef"/>
						<xsl:variable name="rowStyle">
							<xsl:if test="ancestor::ancestors">
								<xsl:text>hideInheritedEffect</xsl:text>
							</xsl:if>
						</xsl:variable>
						<tr class="{$rowStyle}">
							<td class="summaryTablePaddingCol">
								<xsl:if test="not(ancestor::ancestors)">
									<a name="effect:{@name}"/>
								</xsl:if>
								<xsl:value-of select="$nbsp"/>
							</td>
							<td class="summaryTableInheritanceCol">
								<xsl:if test="ancestor::ancestors">
									<img src="{$baseRef}images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage"/>
								</xsl:if>
								<xsl:if test="not(ancestor::ancestors)">
									<xsl:value-of select="$nbsp"/>
								</xsl:if>
							</td>
							<xsl:variable name="classLink">
								<xsl:variable name="id" select="$owner"/>
								<xsl:variable name="destination" select="$owner"/>
								<xsl:variable name="h1">
									<xsl:if test="contains($destination,'.')">
										<xsl:value-of select="substring-before($destination,':')"/>
									</xsl:if>
									<xsl:if test="not(contains($destination,'.'))">
										<xsl:value-of select="$destination"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="h2">
									<xsl:if test="contains($destination,'.')">
										<xsl:value-of select="substring-after($destination,':')"/>
									</xsl:if>
									<xsl:if test="not(contains($destination,'.'))">
										<xsl:value-of select="$destination"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="file" select="concat($baseRef,translate($h1,'.','/'),'/',$h2,'.html')"/>
								<xsl:variable name="gfile" select="concat($baseRef,$h2,'.html')"/>
								<xsl:if test="contains($id,'.')">
									<xsl:value-of select="$file"/>
								</xsl:if>
								<xsl:if test="not(contains($id,'.'))">
									<xsl:value-of select="$gfile"/>
								</xsl:if>
							</xsl:variable>
							<td class="summaryTableSignatureCol">
								<div class="summarySignature">
									<xsl:choose>
										<xsl:when test="ancestor::ancestors">
											<a href="{$classLink}#effect:{@name}" class="signatureLink">
												<xsl:value-of select="@name"/>
											</a>
										</xsl:when>
										<xsl:when test="ancestor::apiClassifier">
											<span class="signatureLink">
												<xsl:value-of select="@name"/>
											</span>
										</xsl:when>
									</xsl:choose>
								</div>
							</td>
							<td class="summaryTableDescription">
								<xsl:if test="string-length(@event)">
									<span class="label">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TriggeringEvent']]/entry[2]/p"/>: </span>
									<xsl:variable name="event" select="@event"/>
									<xsl:choose>
										<xsl:when test="ancestor::apiClassifier/prolog/asMetadata/apiAdobeEvent/event[@name=$event]">
											<a href="#event:{@event}">
												<xsl:value-of select="@event"/>
											</a>
										</xsl:when>
										<xsl:when test="ancestor::asClass/asAncestors/asAncestor/eventsGenerated/event[@name=$event]">
											<a href="{ancestor::asClass/asAncestors/asAncestor[eventsGenerated/event/@name=$event]/classRef/@relativePath}#event:{@event}">
												<xsl:value-of select="@event"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@event"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
								</xsl:if>
								<xsl:variable name="owner" select="$owner"/>
								<xsl:variable name="baseRef" select="$baseRef"/>
								<xsl:variable name="packageName" select="$currentPackage"/>
								<xsl:if test="@deprecatedReplacement or @deprecatedMessage">
									<span class="label">
										<xsl:choose>
											<xsl:when test="@deprecatedSince!=''">
												<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DeprecatedSince']]/entry[2]/p"/>
												<xsl:text> </xsl:text>
												<xsl:value-of select="@deprecatedSince"/>
												<xsl:if test="@deprecatedReplacement!=''">
													<xsl:text>: </xsl:text>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Deprecated']]/entry[2]/p"/>
												<xsl:if test="@deprecatedReplacement!=''">
													<xsl:text>:</xsl:text>
													<xsl:text> </xsl:text>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</span>
									<xsl:choose>
										<xsl:when test="@deprecatedReplacement!=''">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PleaseUse']]/entry[2]/p"/>
											<xsl:text> </xsl:text>
											<xsl:variable name="hyperlink">
												<xsl:variable name="destination" select="$owner"/>
												<xsl:variable name="h1" select="substring-after($destination,':')"/>
												<xsl:variable name="h2" select="substring-before($destination,':')"/>
												<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
												<xsl:variable name="gfile" select="concat($baseRef,translate($destination,':','/'),'.html')"/>
												<xsl:if test="contains($destination,'.')">
													<xsl:value-of select="$file"/>
												</xsl:if>
												<xsl:if test="not(contains($destination,'.'))">
													<xsl:value-of select="$gfile"/>
												</xsl:if>
											</xsl:variable>
											<xsl:if test="contains(@deprecatedReplacement,',')">
												<xsl:for-each select="tokenize(@deprecatedReplacement,',')">
													<xsl:variable name="spec" select="normalize-space(.)"/>
													<xsl:variable name="tospec">
														<xsl:if test="contains($spec, ':')">
															<xsl:value-of select="substring-after($spec,':')"/>
														</xsl:if>
														<xsl:if test="not(contains($spec, ':'))">
															<xsl:value-of select="$spec"/>
														</xsl:if>
													</xsl:variable>
													<xsl:variable name="linkpath1">
														<xsl:call-template name="getDeprecatedReplacementLink">
															<xsl:with-param name="replacement" select="$tospec"/>
															<xsl:with-param name="currentPackage" select="$packageName"/>
															<!--<xsl:with-param name="ancestorPath" select="$ancestorPath"/>-->
														</xsl:call-template>
													</xsl:variable>
													<A href="{$hyperlink}{$linkpath1}">
														<xsl:value-of select="$spec"/>
													</A>
													<xsl:if test="position() != last()">
														<xsl:text>, </xsl:text>
													</xsl:if>
												</xsl:for-each>
											</xsl:if>
											<xsl:variable name="linkpath">
												<xsl:call-template name="getDeprecatedReplacementLink">
													<xsl:with-param name="replacement" select="@deprecatedReplacement/."/>
													<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
													<xsl:with-param name="anchorPrefix" select="concat(local-name(),':')"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:if test="not(contains(@deprecatedReplacement,','))">
												<xsl:choose>
													<xsl:when test="ancestor::ancestors">
														<A href="{$hyperlink}{$linkpath}">
															<xsl:value-of select="@deprecatedReplacement/."/>
														</A>
													</xsl:when>
													<xsl:otherwise>
														<A href="{$linkpath}">
															<xsl:value-of select="@deprecatedReplacement/."/>
														</A>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:when>
										<xsl:when test="@deprecatedMessage!=''">
											<xsl:variable name="description">
												<apiDesc>
													<xsl:value-of select="@deprecatedMessage/."/>
												</apiDesc>
											</xsl:variable>
											<xsl:for-each select="$description/apiDesc">
												<xsl:call-template name="processTags"/>
											</xsl:for-each>
										</xsl:when>
									</xsl:choose>
									<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
								</xsl:if>
								<xsl:if test="not(ancestor::ancestors)">
									<xsl:call-template name="deTilda">
										<xsl:with-param name="inText" select="description/."/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="ancestor::ancestors">
									<xsl:call-template name="deTilda">
										<xsl:with-param name="inText" select="description/."/>
									</xsl:call-template>
								</xsl:if>
							</td>
							<td class="summaryTableOwnerCol">
								<xsl:choose>
									<xsl:when test="ancestor::ancestors">
										<xsl:variable name="classLink">
											<xsl:variable name="id" select="$owner"/>
											<xsl:variable name="destination" select="$owner"/>
											<xsl:variable name="h1">
												<xsl:if test="contains($destination,'.')">
													<xsl:value-of select="substring-before($destination,':')"/>
												</xsl:if>
												<xsl:if test="not(contains($destination,'.'))">
													<xsl:value-of select="$destination"/>
												</xsl:if>
											</xsl:variable>
											<xsl:variable name="h2">
												<xsl:if test="contains($destination,'.')">
													<xsl:value-of select="substring-after($destination,':')"/>
												</xsl:if>
												<xsl:if test="not(contains($destination,'.'))">
													<xsl:value-of select="$destination"/>
												</xsl:if>
											</xsl:variable>
											<xsl:variable name="file" select="concat($baseRef,translate($h1,'.','/'),'/',$h2,'.html')"/>
											<xsl:variable name="gfile" select="concat($baseRef,$h2,'.html')"/>
											<xsl:if test="contains($id,'.')">
												<xsl:value-of select="$file"/>
											</xsl:if>
											<xsl:if test="not(contains($id,'.'))">
												<xsl:value-of select="$gfile"/>
											</xsl:if>
										</xsl:variable>
										<xsl:variable name="className">
											<xsl:variable name="cn" select="$owner"/>
											<xsl:value-of select="substring-after($cn,':')"/>
										</xsl:variable>
										<a href="{$classLink}">
											<xsl:value-of select="$className"/>
										</a>
									</xsl:when>
									<xsl:when test="ancestor::apiClassifier">
										<xsl:value-of select="ancestor::apiClassifier/apiName"/>
									</xsl:when>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</div>
		</xsl:if>
	</xsl:template>
	<!-- EVENTS -->
	<xsl:template name="eventsGeneratedSummary">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef" select="''"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:param name="interfaces" tunnel="yes"/>
		<xsl:variable name="ancestorexcludes">
			<excludes>
				<xsl:variable name="self" select="@id"/>
				<xsl:for-each select="$classHeader_map//apiClassifier[@id = $self]//Excludes/Exclude[@kind='event']">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</excludes>
		</xsl:variable>
		<!--List of events to suppress when creating inheritance list.  Includes both the existing events and any exclusions-->
		<xsl:variable name="eventsList">
			<xsl:for-each select="adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)]">
				<xsl:text> </xsl:text>
				<xsl:value-of select="./apiName"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
			<xsl:for-each select="$ancestorexcludes/excludes/Exclude">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="hasEvents" select="count(adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)]) &gt; 0"/>
		<xsl:variable name="ancestorNodes">
			<ancestors>
				<xsl:call-template name="getInheritedEvent">
					<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
					<xsl:with-param name="currentPackage" select="$currentPackage"/>
					<xsl:with-param name="eventsList" select="$eventsList"/>
				</xsl:call-template>
			</ancestors>
			<xsl:for-each select="$interfaces/interface">
				<xsl:call-template name="getInheritedEvent">
					<xsl:with-param name="baseClass" select="."/>
					<xsl:with-param name="currentPackage" select="$currentPackage"/>
					<xsl:with-param name="eventsList" select="$eventsList"/>
					<xsl:with-param name="processParentClass" select="false()"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="hasInherited" select="count($ancestorNodes/ancestors/adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)]) &gt; 0"/>
		<xsl:if test="$hasEvents or $hasInherited">
			<a name="eventSummary"/>
			<div class="summarySection">
				<div class="summaryTableTitle">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Events']]/entry[2]/p"/>
				</div>
				<xsl:if test="$hasInherited">
					<div class="showHideLinks">
						<div id="hideInheritedEvent" class="hideInheritedEvent">
							<a class="showHideLink" href="#eventSummary" onclick="javascript:setInheritedVisible(false,'Event');">
								<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedEvents']]/entry[2]/p"/>
							</a>
						</div>
						<div id="showInheritedEvent" class="showInheritedEvent">
							<a class="showHideLink" href="#eventSummary" onclick="javascript:setInheritedVisible(true,'Event');">
								<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedEvents']]/entry[2]/p"/>
							</a>
						</div>
					</div>
				</xsl:if>
				<xsl:variable name="tableStyle">
					<xsl:if test="$hasInherited and not($hasEvents)">
						<xsl:text>hideInheritedEvent</xsl:text>
					</xsl:if>
				</xsl:variable>
				<table cellspacing="0" cellpadding="3" class="summaryTable {$tableStyle}" id="summaryTableEvent">
					<tr>
						<th>
							<xsl:value-of select="$nbsp"/>
						</th>
						<th colspan="2">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Event']]/entry[2]/p"/>
						</th>
						<th>
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">Summary</xsl:with-param>
							</xsl:call-template>
						</th>
						<th class="summaryTableOwnerCol">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefinedBy']]/entry[2]/p"/>
						</th>
					</tr>
					<xsl:for-each select="adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)] | $ancestorNodes/ancestors/adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)] ">
						<xsl:sort select="apiName" order="ascending" data-type="text" lang="en-US"/>
						<xsl:variable name="name" select="./apiName"/>
						<xsl:if test="./adobeApiEventDetail/adobeApiEventDef/apiEventType or ./shortdesc">
							<xsl:variable name="rowStyle">
								<xsl:if test="ancestor::ancestors">
									<xsl:text>hideInheritedEvent</xsl:text>
								</xsl:if>
							</xsl:variable>
							<tr class="{$rowStyle}">
								<td class="summaryTablePaddingCol">
									<xsl:value-of select="$nbsp"/>
								</td>
								<td class="summaryTableInheritanceCol">
									<xsl:if test="ancestor::ancestors">
										<img src="{$baseRef}images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage"/>
									</xsl:if>
									<xsl:if test="not(ancestor::ancestors)">
										<xsl:value-of select="$nbsp"/>
									</xsl:if>
								</td>
								<td class="summaryTableSignatureCol">
									<div class="summarySignature">
										<xsl:choose>
											<xsl:when test="ancestor::ancestors">
												<xsl:variable name="hyperLink">
													<xsl:variable name="id" select="./@id"/>
													<xsl:variable name="text" select="substring-before($id,'_')"/>
													<xsl:variable name="cName" select="substring-after($text,':')"/>
													<xsl:variable name="pName" select="substring-before($text,':')"/>
													<xsl:variable name="destination" select="concat($pName,':',$cName)"/>
													<xsl:variable name="className">
														<xsl:if test="contains($destination,':')">
															<xsl:choose>
																<xsl:when test="$prog_language_name='javascript'"/>
																<xsl:otherwise>
																	<xsl:value-of select="substring-after($destination,':')"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
														<xsl:if test="not(contains($destination,':'))">
															<xsl:if test="not(contains($destination,'.'))">
																<xsl:choose>
																	<xsl:when test="$prog_language_name='javascript'"/>
																	<xsl:otherwise>
																		<xsl:value-of select="$destination"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
														</xsl:if>
													</xsl:variable>
													<xsl:variable name="packageName">
														<xsl:if test="contains($destination,':')">
															<xsl:value-of select="substring-before($destination,':')"/>
														</xsl:if>
														<xsl:if test="not(contains($destination,':'))">
															<xsl:value-of select="$destination"/>
														</xsl:if>
													</xsl:variable>
													<xsl:variable name="file" select="concat($baseRef,translate($packageName,'.','/'),'/',$className,'.html')"/>
													<xsl:variable name="gfile" select="concat($baseRef,$className,'.html')"/>
													<xsl:if test="string-length($packageName) &gt; 0">
														<xsl:choose>
															<xsl:when test="$prog_language_name='javascript'"/>
															<xsl:otherwise>
																<xsl:value-of select="$file"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
													<xsl:if test="not(string-length($packageName) &gt; 0 )">
														<xsl:choose>
															<xsl:when test="$prog_language_name='javascript'"/>
															<xsl:otherwise>
																<xsl:value-of select="$gfile"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</xsl:variable>
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
												<xsl:if test="$hyperLink!=''">
													<a href="{$hyperLink}#event:{apiName}" class="signatureLink">
														<xsl:value-of select="apiName"/>
													</a>
												</xsl:if>
												<xsl:if test="$hyperLink=''">
													<xsl:value-of select="apiName"/>
												</xsl:if>
											</xsl:when>
											<xsl:when test="ancestor::apiClassifier">
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
												<a href="#event:{$name}" class="signatureLink">
													<xsl:value-of select="$name"/>
												</a>
											</xsl:when>
										</xsl:choose>
										<!-- TODO add param classRefs for AS2 -->
										<xsl:if test="$config/options/@docversion='2'">
											<xsl:text> = function(</xsl:text>
											<xsl:call-template name="params"/>
											<xsl:text>) {}</xsl:text>
										</xsl:if>
									</div>
								</td>
								<td class="summaryTableDescription summaryTableCol">
									<xsl:if test="$classDeprecated='true'">
										<xsl:copy-of select="$deprecatedLabel"/>
										<xsl:text>. </xsl:text>
									</xsl:if>
									<xsl:variable name="eventText">
										<xsl:value-of select="normalize-space(./shortdesc)"/>
										<xsl:if test="./shortdesc/@conref">
											<xsl:call-template name="getConRefText">
												<xsl:with-param name="conref" select="./shortdesc/@conref"/>
												<xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
												<xsl:with-param name="entryType" select="'event'"/>
												<xsl:with-param name="currentPackage" select="$currentPackage"/>
											</xsl:call-template>
										</xsl:if>
									</xsl:variable>
									<xsl:if test="string-length($eventText) &gt;0 ">
										<xsl:call-template name="deTilda">
											<xsl:with-param name="inText" select="$eventText"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="not(string-length($eventText) &gt; 0)">

										<xsl:if test="./adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier">
											<xsl:call-template name="getEventDescription">
												<xsl:with-param name="destination" select="adobeApiEventDetail/adobeApiEventDef/apiEventType"/>
												<xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
											</xsl:call-template>
										</xsl:if>
									</xsl:if>
								</td>
								<td class="summaryTableOwnerCol">
									<xsl:choose>
										<xsl:when test="ancestor::ancestors">
											<xsl:variable name="hyperLink">
												<xsl:variable name="id" select="./@id"/>
												<xsl:variable name="text" select="substring-before($id,'_')"/>
												<xsl:variable name="className" select="substring-after($text,':')"/>
												<xsl:variable name="packageName" select="substring-before($text,':')"/>
												<xsl:variable name="destination" select="concat($packageName,':',$className)"/>
												<xsl:variable name="h1" select="substring-before($destination,':')"/>
												<xsl:variable name="h2" select="substring-after($destination,':')"/>
												<xsl:variable name="file" select="concat($baseRef,translate($h1,'.','/'),'/',$h2,'.html')"/>
												<xsl:variable name="gfile" select="concat($baseRef,$h2,'.html')"/>
												<xsl:if test="contains($destination,'.')">
													<xsl:choose>
														<xsl:when test="$prog_language_name='javascript'"/>
														<xsl:otherwise>
															<xsl:value-of select="$file"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
												<xsl:if test="not(contains($destination,'.'))">
													<xsl:choose>
														<xsl:when test="$prog_language_name='javascript'"/>
														<xsl:otherwise>
															<xsl:value-of select="$gfile"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:variable>
											<xsl:variable name="className">
												<xsl:call-template name="getEventClassNameFromId">
													<xsl:with-param name="id" select="./@id"/>
													<xsl:with-param name="currentPackage" select="$currentPackage"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:if test="$hyperLink!=''">
												<a href="{$hyperLink}">
													<xsl:value-of select="$className"/>
												</a>
											</xsl:if>
											<xsl:if test="$hyperLink=''">
												<xsl:value-of select="$className"/>
											</xsl:if>
										</xsl:when>
										<xsl:when test="ancestor::apiClassifier">
											<xsl:value-of select="ancestor::apiClassifier/apiName"/>
										</xsl:when>
									</xsl:choose>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each>
				</table>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="eventDetails">
		<xsl:param name="baseRef"/>
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:if test="count(adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)]) &gt; 0">
			<div class="detailSectionHeader">
				<xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key" select="'EventDetail'"/>
				</xsl:call-template>
			</div>
			<xsl:for-each select="./adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)]">
				<xsl:sort select="apiName" order="ascending" lang="en-US"/>
				<xsl:variable name="name" select="./apiName"/>
				<a name="event:{$name}"/>
				<table class="detailHeader" cellpadding="0" cellspacing="0">
					<tr>
						<td class="detailHeaderName">
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
							<xsl:value-of select="$name"/>
						</td>
						<td class="detailHeaderType">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">EventIn</xsl:with-param>
							</xsl:call-template>
						</td>
						<xsl:if test="position()!=1">
							<td class="detailHeaderRule">
								<xsl:value-of select="$nbsp"/>
							</td>
						</xsl:if>
					</tr>
				</table>
				<div class="detailBody">
					<xsl:if test="string-length(normalize-space(adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier)) &gt; 0">
						<xsl:if test="$name='onCuePoint' or $name='onMetaData'"> </xsl:if>
						<span class="label">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'EventObjectType']]/entry[2]/p"/>
							<xsl:text>: </xsl:text>
						</span>
						<xsl:variable name="eventHyperLink">
							<xsl:call-template name="getEventHyperlink">
								<xsl:with-param name="destination" select="adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier"/>
								<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="eventTypeClassifierTmp" select="adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier"/>

						<xsl:variable name="eventTypeClassifierPkg" >
							<xsl:call-template name="substring-before-last">
								<xsl:with-param name="input" select="$eventTypeClassifierTmp"/>
								<xsl:with-param name="substr" select="'.'"/>
							</xsl:call-template>
						</xsl:variable >

						<xsl:variable name="eventTypeClassifierCls" >
							<xsl:call-template name="substring-after-last">
								<xsl:with-param name="input" select="$eventTypeClassifierTmp"/>
								<xsl:with-param name="substr" select="'.'"/>
							</xsl:call-template>
						</xsl:variable >

						<xsl:variable name="eventTypeClassifier" select="concat($eventTypeClassifierPkg, ':', $eventTypeClassifierCls)"/>

						<xsl:choose>
							<xsl:when test="$eventHyperLink=''">
								<code>
									<xsl:value-of select="adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier"/>
								</code>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$eventHyperLink}">
									<code>
										<xsl:value-of select="$eventTypeClassifierTmp"/>
									</code>
								</a>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						<xsl:variable name="eventTypeDITA" select="adobeApiEventDetail/adobeApiEventDef/apiEventType"/>
						<xsl:if test="string-length($eventTypeDITA) &gt; 0">
							<xsl:variable name="eventTypeHref">
								<xsl:call-template name="getEventTypeHyperlink">
									<xsl:with-param name="destination" select="$eventTypeDITA"/>
									<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
								</xsl:call-template>
							</xsl:variable>
							<span class="label">

								<xsl:if test="contains($eventTypeClassifierTmp,'.')">
									<xsl:call-template name="substring-after-last">
										<xsl:with-param name="input" select="$eventTypeClassifierTmp"/>
										<xsl:with-param name="substr" select="'.'"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="not(contains($eventTypeClassifierTmp,'.'))">
									<xsl:value-of select="$eventTypeClassifierTmp"/>
								</xsl:if>
								<xsl:text>.type</xsl:text>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Property']]/entry[2]/p"/>
								<xsl:text> = </xsl:text>
							</span>
							<xsl:choose>
								<xsl:when test="$eventTypeHref=''">
									<code>
										<xsl:value-of select="$eventTypeDITA"/>
									</code>
								</xsl:when>
								<xsl:otherwise>

									<xsl:if test="contains($eventTypeClassifierTmp,'.')">
										<xsl:if test="count($classHeader_map//apiClassifier[@id=$eventTypeClassifier] ) &gt; 0">
											<a href="{$eventTypeHref}">
												<code>
													<xsl:value-of select="$eventTypeDITA"/>
												</code>
											</a>
										</xsl:if>
										<xsl:if test="not(count($classHeader_map//apiClassifier[@id=$eventTypeClassifier] ) &gt; 0)">
											<code>
												<xsl:value-of select="$eventTypeDITA"/>
											</code>
										</xsl:if>
									</xsl:if>

									<xsl:if test="not(contains($eventTypeClassifierTmp,'.'))">
										<xsl:if test="count($classHeader_map//apiClassifier[@id=concat('globalClassifier:',$eventTypeClassifierTmp)] ) &gt; 0">
											<a href="{$eventTypeHref}">
												<code>
													<xsl:value-of select="$eventTypeDITA"/>
												</code>
											</a>
										</xsl:if>
										<xsl:if test="not(count($classHeader_map//apiClassifier[@id=concat('globalClassifier:',$eventTypeClassifierTmp)] ) &gt; 0)">
											<code>
												<xsl:value-of select="$eventTypeDITA"/>
											</code>
										</xsl:if>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						</xsl:if>
						<xsl:if test="not(string-length($eventTypeDITA) &gt; 0)">
							<p/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$config/options/@docversion='2'">
						<p>
							<code>
								<xsl:text>public </xsl:text>
								<xsl:value-of select="$name"/>
								<xsl:text> = function(</xsl:text>
								<xsl:call-template name="params"/>
								<xsl:text>) {}</xsl:text>
							</code>
						</p>
					</xsl:if>
					<xsl:apply-templates select="adobeApiEventDetail/adobeApiEventDef/apiDeprecated" mode="event" />
					<xsl:if test="$classDeprecated='true'">
						<xsl:call-template name="description">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="addParagraphTags" select="true()"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:call-template name="version"/>
					<xsl:if test="$classDeprecated!='true'">
						<xsl:call-template name="description">
							<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
							<xsl:with-param name="addParagraphTags" select="true()"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="string-length(normalize-space(adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier)) &gt; 0">
						<xsl:call-template name="getEventDescription">
							<xsl:with-param name="destination" select="adobeApiEventDetail/adobeApiEventDef/apiEventType"/>
							<xsl:with-param name="descriptionType" select="'apiDesc'"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:apply-templates select="params"/>
					<xsl:if test="./*/example[codeblock]">
						<xsl:call-template name="includeExamples">
							<xsl:with-param name="createExampleLink" select="'false'"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:call-template name="sees"/>
				</div>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="event">
		<xsl:variable name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="count(adobeApiEvent)">
			<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			<span class="label">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Events']]/entry[2]/p"/>
			</span>
			<table cellpadding="0" cellspacing="0" border="0">
				<xsl:for-each select="adobeApiEvent">
					<tr>
						<td width="20px"/>
						<td>
							<code>
								<b>
									<xsl:if test="$config/options/@docversion='2'">
										<a href="#event:{apiName}">
											<xsl:value-of select="apiName"/>
										</a>
									</xsl:if>
									<xsl:if test="$config/options/@docversion!='2'">
										<xsl:value-of select="apiName"/>
									</xsl:if>
								</b>
								<xsl:if test="adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier">
									<xsl:variable name="destination" select="adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier"/>
									<xsl:variable name="h1" select="substring-after($destination,':')"/>
									<xsl:variable name="h2" select="substring-before($destination,':')"/>
									<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
									<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
									<xsl:variable name="eventHyperLink">
										<xsl:if test="contains($destination,'.')">
											<xsl:value-of select="$file"/>
										</xsl:if>
										<xsl:if test="not(contains($destination,'.'))">
											<xsl:value-of select="$gfile"/>
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="classname">
										<xsl:if test="contains(adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier,':')">
											<xsl:value-of select="substring-after(adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier,':')"/>
										</xsl:if>
										<xsl:if test="not(contains(adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier,':'))">
											<xsl:value-of select="adobeApiEventDetail/adobeApiEventDef/adobeApiEventClassifier"/>
										</xsl:if>
									</xsl:variable>
									<xsl:text>:</xsl:text>
									<xsl:if test="$eventHyperLink = ''">
										<code>
											<xsl:value-of select="$classname"/>
										</code>
									</xsl:if>
									<xsl:if test="$eventHyperLink != ''">
										<a href="{$eventHyperLink}">
											<code>
												<xsl:value-of select="$classname"/>
											</code>
										</a>
									</xsl:if>
								</xsl:if>
							</code>
							<xsl:if test="string-length(adobeApiEventDetail/apiDesc)">
								<xsl:value-of select="$emdash"/>
								<xsl:variable name="desctext">
									<xsl:for-each select="./adobeApiEventDetail/apiDesc">
										<xsl:call-template name="processTags">
											<xsl:with-param name="event" select="'eventdesc'"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:variable>
								<xsl:value-of disable-output-escaping="yes" select="$desctext"/>
							</xsl:if>
						</td>
					</tr>
					<xsl:if test="position()!=last()">
						<tr>
							<td class="paramSpacer">
								<xsl:value-of select="$nbsp"/>
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- METHODS -->
	<xsl:template name="methodSummary">
		<xsl:param name="className"/>
		<xsl:param name="title" select="'Methods'"/>
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="accessLevel" select="'public'"/>
		<xsl:param name="baseRef" select="''"/>
		<xsl:param name="isGlobal" select="false()"/>
		<xsl:param name="showAnchor" select="true()"/>
		<xsl:param name="interfaces" tunnel="yes"/>
		<xsl:variable name="localizedTitle">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">
					<xsl:value-of select="$title"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="hasMethods"
			select="count(apiOperation[apiOperationDetail/apiOperationDef/apiAccess/@value=$accessLevel or apiOperationDetail/apiOperationDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]) &gt; 0 or count(apiConstructor[apiConstructorDetail/apiConstructorDef/apiAccess/@value=$accessLevel or apiConstructorDetail/apiConstructorDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]) &gt; 0"/>
		<xsl:variable name="ancestorexcludes">
			<excludes>
				<xsl:variable name="self" select="@id"/>
				<xsl:for-each select="$classHeader_map//apiClassifier[@id = $self]//Excludes/Exclude[@kind='method']">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</excludes>
		</xsl:variable>
		<!--List of methods to suppress when creating inheritance list.  Includes both the existing methods and any exclusions-->
		<xsl:variable name="newMethodList">
			<xsl:for-each
				select="./apiOperation[apiOperationDetail/apiOperationDef/apiAccess/@value=$accessLevel or apiOperationDetail/apiOperationDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.] | ./apiConstructor[apiConstructorDetail/apiConstructorDef/apiAccess/@value=$accessLevel or apiConstructorDetail/apiConstructorDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]">
				<xsl:text> </xsl:text>
				<xsl:value-of select="./apiName"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
			<xsl:for-each select="$ancestorexcludes/excludes/Exclude">
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="ancestorNode">
			<ancestors>
				<xsl:call-template name="getMethodAncestors">
					<xsl:with-param name="baseRef" select="$baseRef"/>
					<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
					<xsl:with-param name="methodList" select="$newMethodList"/>
					<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
					<xsl:with-param name="accessLevel" select="$accessLevel"/>
				</xsl:call-template>
				<xsl:for-each select="$interfaces/interface">
					<xsl:call-template name="getMethodAncestors">
						<xsl:with-param name="baseRef" select="$baseRef"/>
						<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
						<xsl:with-param name="methodList" select="$newMethodList"/>
						<xsl:with-param name="baseClass" select="."/>
						<xsl:with-param name="accessLevel" select="$accessLevel"/>
						<xsl:with-param name="processParentClass" select="false()"/>
					</xsl:call-template>
				</xsl:for-each>
			</ancestors>
		</xsl:variable>
		<xsl:variable name="hasInherited" select="count ($ancestorNode/ancestors/apiOperation | $ancestorNode/ancestors/apiConstructor) &gt; 0"/>
		<xsl:if test="$hasMethods or $hasInherited">
			<xsl:if test="$showAnchor">
				<xsl:if test="$accessLevel='public'">
					<a name="methodSummary"/>
				</xsl:if>
				<xsl:if test="$accessLevel='protected'">
					<xsl:if
						test="not(count(apiOperation[./apiOperationDetail/apiOperationDef/apiAccess/@value='public' or ./apiOperationDetail/apiOperationDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay='public']/.]) &gt; 0 or count($ancestorNode/ancestors/apiOperation[./apiOperationDetail/apiOperationDef/apiAccess/@value='public' or ./apiOperationDetail/apiOperationDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay='public']/.]) &gt; 0)">
						<a name="methodSummary"/>
					</xsl:if>
					<a name="protectedMethodSummary"/>
				</xsl:if>
			</xsl:if>
			<div class="summarySection">
				<div class="summaryTableTitle">
					<xsl:choose>
						<xsl:when test="$isGlobal">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalMethods']]/entry[2]/p"/>
							<xsl:text> </xsl:text>
						</xsl:when>
						<xsl:when test="$accessLevel='public'">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PublicMethods']]/entry[2]/p"/>
							<xsl:text> </xsl:text>
						</xsl:when>
						<xsl:when test="$accessLevel='protected'">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ProtectedMethods']]/entry[2]/p"/>
							<xsl:text> </xsl:text>
						</xsl:when>
					</xsl:choose>

				</div>
				<xsl:if test="$hasInherited">
					<div class="showHideLinks">
						<xsl:if test="$accessLevel!='protected'">
							<div id="hideInheritedMethod" class="hideInheritedMethod">
								<a class="showHideLink" href="#methodSummary" onclick="javascript:setInheritedVisible(false,'Method');">
									<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideInheritedPublicMethods']]/entry[2]/p"/>
								</a>
							</div>
							<div id="showInheritedMethod" class="showInheritedMethod">
								<a class="showHideLink" href="#methodSummary" onclick="javascript:setInheritedVisible(true,'Method');">
									<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedPublicMethods']]/entry[2]/p"/>
										</xsl:otherwise>
									</xsl:choose>

								</a>
							</div>
						</xsl:if>
						<xsl:if test="$accessLevel='protected'">
							<div id="hideInheritedProtectedMethod" class="hideInheritedProtectedMethod">
								<a class="showHideLink" href="#protectedMethodSummary" onclick="javascript:setInheritedVisible(false,'ProtectedMethod');">
									<img class="showHideLinkImage" src="{$baseRef}images/expanded.gif"/>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedProtectedMethods']]/entry[2]/p"/>
								</a>
							</div>
							<div id="showInheritedProtectedMethod" class="showInheritedProtectedMethod">
								<a class="showHideLink" href="#protectedMethodSummary" onclick="javascript:setInheritedVisible(true,'ProtectedMethod');">
									<img class="showHideLinkImage" src="{$baseRef}images/collapsed.gif"/>
									<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowInheritedProtectedMethods']]/entry[2]/p"/>
								</a>
							</div>
						</xsl:if>
					</div>
				</xsl:if>
				<xsl:variable name="tableStyle">
					<xsl:if test="$hasInherited and not($hasMethods)">
						<xsl:text>hideInherited</xsl:text>
						<xsl:if test="$accessLevel='protected'">
							<xsl:text>Protected</xsl:text>
						</xsl:if>
						<xsl:text>Method</xsl:text>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="tableId">
					<xsl:text>summaryTable</xsl:text>
					<xsl:if test="$accessLevel='protected'">
						<xsl:text>Protected</xsl:text>
					</xsl:if>
					<xsl:text>Method</xsl:text>
				</xsl:variable>
				<table cellspacing="0" cellpadding="3" class="summaryTable {$tableStyle}" id="{$tableId}">
					<tr>
						<th>
							<xsl:value-of select="$nbsp"/>
						</th>
						<th colspan="2">
							<xsl:if test="self::apiClassifier">
								<xsl:text/>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'MethodMethod']]/entry[2]/p"/>
							</xsl:if>
							<xsl:if test="not(self::apiClassifier)">
								<xsl:text/>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'FunctionFunction']]/entry[2]/p"/>
							</xsl:if>
						</th>
						<xsl:if test="not($config/options/@docversion='2')">
							<th class="summaryTableOwnerCol">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefinedBy']]/entry[2]/p"/>
							</th>
						</xsl:if>
					</tr>
					<xsl:apply-templates
						select="apiOperation[apiOperationDetail/apiOperationDef/apiAccess/@value=$accessLevel or apiOperationDetail/apiOperationDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.] | apiConstructor[apiConstructorDetail/apiConstructorDef/apiAccess/@value=$accessLevel or apiConstructorDetail/apiConstructorDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.] | $ancestorNode/ancestors/apiOperation[apiOperationDetail/apiOperationDef/apiAccess/@value=$accessLevel or apiOperationDetail/apiOperationDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.] | $ancestorNode/ancestors/apiConstructor[apiConstructorDetail/apiConstructorDef/apiAccess/@value=$accessLevel or apiConstructorDetail/apiConstructorDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]"
						mode="summary">
						<xsl:sort select="local-name()" lang="en-US"/>
						<xsl:sort select="apiName" order="ascending" lang="en-US"/>
						<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
						<xsl:with-param name="baseRef" select="$baseRef"/>
						<xsl:with-param name="accessLevel" select="$accessLevel"/>
						<xsl:with-param name="currentPackage" select="$currentPackage"/>
					</xsl:apply-templates>
				</table>
				<!-- AS2 INHERITED METHODS -->
				<xsl:if test="$config/options/@docversion='2'">
					<xsl:for-each select="asAncestors/asAncestor">
						<xsl:call-template name="inherited">
							<xsl:with-param name="lowerType" select="'methods'"/>
							<xsl:with-param name="upperType" select="'Methods'"/>
							<xsl:with-param name="inheritedItems" select="@methods"/>
							<xsl:with-param name="staticItems" select="@staticMethods"/>
							<xsl:with-param name="postfix" select="'()'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="methodsDetails">
		<xsl:param name="className"/>
		<xsl:param name="title" select="$asdoc_terms/row[entry[1][p/text() = 'MethodDetail']]/entry[2]/p"/>
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef"/>
		<xsl:param name="constructCall" select="'true'"/>
		<xsl:if test="count(.//apiOperation) &gt; 0">
			<a name="methodDetail"/>
			<div class="detailSectionHeader">
				<xsl:value-of select="$title"/>
			</div>
			<xsl:apply-templates select="apiOperation" mode="detail">
				<xsl:sort select="./apiName" order="ascending" lang="en-US"/>
				<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
				<xsl:with-param name="isMethod" select="$className!='package'"/>
				<xsl:with-param name="className" select="$className"/>
				<xsl:with-param name="baseRef" select="$baseRef"/>
			</xsl:apply-templates>
			<xsl:if test="$constructCall='true'">
				<xsl:apply-templates select="apiConstructor" mode="detail">
					<xsl:sort select="./apiName" order="ascending" lang="en-US"/>
					<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
					<xsl:with-param name="isMethod" select="$className!='package'"/>
					<xsl:with-param name="className" select="$className"/>
					<xsl:with-param name="baseRef" select="$baseRef"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="constantDetails">
		<xsl:param name="title" select="$asdoc_terms/row[entry[1][p/text() = 'ConstantDetail']]/entry[2]/p"/>
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef"/>
		<xsl:param name="isConst" select="'true'"/>
		<xsl:if test="count(./apiValue[not(apiValueDetail/apiValueDef/apiProperty)]) &gt; 0">
			<div class="detailSectionHeader">
				<xsl:value-of select="$title"/>
			</div>
			<xsl:apply-templates select="apiValue[not(apiValueDetail/apiValueDef/apiProperty)]" mode="detail">
				<xsl:sort select="./apiName" order="ascending" lang="en-US"/>
				<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
				<xsl:with-param name="baseRef" select="$baseRef"/>
				<xsl:with-param name="isConst" select="$isConst"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template name="propertyDetails">
		<xsl:param name="title" select="$asdoc_terms/row[entry[1][p/text() = 'PropertyDetail']]/entry[2]/p"/>
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef"/>
		<xsl:if test="count(./apiValue[apiValueDetail/apiValueDef/apiProperty]) &gt; 0">
			<div class="detailSectionHeader">
				<xsl:value-of select="$title"/>
			</div>
			<xsl:apply-templates select="apiValue[apiValueDetail/apiValueDef/apiProperty]" mode="detail">
				<xsl:sort select="./apiName" order="ascending" lang="en-US"/>
				<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
				<xsl:with-param name="baseRef" select="$baseRef"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template name="styleDetails">
		<xsl:param name="title" select="$asdoc_terms/row[entry[1][p/text() = 'StyleDetail']]/entry[2]/p"/>
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef"/>
		<xsl:if test="count(prolog/asMetadata[styles/style]) &gt; 0">
			<div class="detailSectionHeader">
				<xsl:value-of select="$title"/>
			</div>
			<xsl:apply-templates select="prolog/asMetadata[styles/style]" mode="detail">
				<xsl:sort select="@name" order="ascending" lang="en-US"/>
				<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
				<xsl:with-param name="baseRef" select="$baseRef"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="style" mode="detail">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="isMethod" select="true()"/>
		<xsl:param name="className" select="''"/>
		<xsl:param name="baseRef"/>
		<xsl:variable name="name" select="@name"/>
		<xsl:variable name="type" select="@type"/>
		<a name="style:{$name}"/>
		<table class="detailHeader" cellpadding="0" cellspacing="0">
			<tr>
				<td class="detailHeaderName">
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
					<xsl:value-of select="$name"/>
				</td>
				<td class="detailHeaderType">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Style']]/entry[2]/p"/>
				</td>
				<xsl:if test="position()!=1">
					<td class="detailHeaderRule">
						<xsl:value-of select="$nbsp"/>
					</td>
				</xsl:if>
			</tr>
		</table>
		<div class="detailBody">
			<code>
				<xsl:value-of select="$name"/>
				<xsl:if test="@type">
					<xsl:text>:</xsl:text>
					<xsl:call-template name="getSimpleClassName">
						<xsl:with-param name="fullClassName" select="@type"/>
					</xsl:call-template>
				</xsl:if>
			</code>
			<xsl:if test="$classDeprecated!='true'">
				<xsl:call-template name="description">
					<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
					<xsl:with-param name="addParagraphTags" select="true()"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="./default">
				<p>
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefaultValueIs']]/entry[2]/p"/>
					<xsl:text> </xsl:text>
					<code>
						<xsl:value-of select="normalize-space(./default/.)"/>
					</code>
					<xsl:text>.</xsl:text>
				</p>
			</xsl:if>
			<xsl:call-template name="sees"/>
		</div>
	</xsl:template>
	<xsl:template match="apiOperation | apiConstructor" mode="summary">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef" select="''"/>
		<xsl:param name="accessLevel" select="'public'"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="rowStyle">
			<xsl:if test="ancestor::ancestors">
				<xsl:text>hideInherited</xsl:text>
				<xsl:if test="$accessLevel='protected'">
					<xsl:text>Protected</xsl:text>
				</xsl:if>
				<xsl:text>Method</xsl:text>
			</xsl:if>
		</xsl:variable>
		<tr class="{$rowStyle}">
			<td class="summaryTablePaddingCol">
				<xsl:value-of select="$nbsp"/>
			</td>
			<td class="summaryTableInheritanceCol">
				<xsl:if test="ancestor::ancestors">
					<img src="{$baseRef}images/inheritedSummary.gif" alt="Inherited" title="Inherited" class="inheritedSummaryImage"/>
				</xsl:if>
				<xsl:if test="not(ancestor::ancestors)">
					<xsl:value-of select="$nbsp"/>
				</xsl:if>
			</td>
			<td class="summaryTableSignatureCol">
				<div class="summarySignature">
					<xsl:choose>
						<xsl:when test="ancestor::ancestors">
							<xsl:variable name="hLink">
								<xsl:variable name="memberName" select="./apiName"/>
								<xsl:variable name="id" select="./@id"/>
								<xsl:variable name="classNameText" select="substring-after($id,':')"/>
								<xsl:variable name="packageNameText" select="substring-before($id,':')"/>
								<xsl:variable name="h1" select="substring-before($classNameText,':')"/>
								<xsl:variable name="h2" select="$packageNameText"/>
								<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
								<xsl:variable name="gfile" select="concat($baseRef,$packageNameText,'.html')"/>
								<xsl:variable name="packageName">
									<xsl:choose>
										<xsl:when test="not(contains($packageNameText,'.')) and string-length($packageNameText) = 0">
											<xsl:value-of select="''"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$packageNameText"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="methodName">
									<xsl:choose>
										<xsl:when test="$memberName != ''">
											<xsl:value-of select="$memberName"/>
										</xsl:when>
										<xsl:when test="contains($packageName,'.')">
											<xsl:if test="contains($classNameText,':')">
												<xsl:value-of select="substring-after($classNameText,':')"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring-after($id,':')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:if test="contains($id,'.') or string-length($packageNameText) &gt; 0">
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<xsl:value-of select="$file"/>
											<xsl:text>#</xsl:text>
											<xsl:value-of select="$methodName"/>
										</xsl:otherwise>
									</xsl:choose>

								</xsl:if>
								<xsl:if test="not(contains($id,'.')) and string-length($packageNameText) = 0">
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<xsl:value-of select="$gfile"/>
											<xsl:text>#</xsl:text>
											<xsl:value-of select="$methodName"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:variable>
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
							<xsl:if test="$hLink!=''">
								<a href="{$hLink}()" class="signatureLink">
									<xsl:value-of select="./apiName"/>
								</a>
							</xsl:if>
							<xsl:if test="$hLink=''">
								<xsl:value-of select="./apiName"/>
							</xsl:if>
						</xsl:when>
						<xsl:when test="self::apiConstructor">
							<xsl:if test="position()>1">
								<a href="#{./apiName}{position()}()" class="signatureLink">
									<xsl:value-of select="./apiName"/>
								</a>
							</xsl:if>
							<xsl:if test="position()=1">
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
								<a href="#{./apiName}()" class="signatureLink">
									<xsl:value-of select="./apiName"/>
								</a>
							</xsl:if>
						</xsl:when>
						<xsl:when test="ancestor::apiClassifier or ancestor-or-self::apiPackage">
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
							<a href="#{./apiName}()" class="signatureLink">
								<xsl:value-of select="./apiName"/>
							</a>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="self::apiOperation | self::apiConstructor">
						<xsl:text>(</xsl:text>
						<xsl:call-template name="params">
							<xsl:with-param name="currentPackage" select="$currentPackage"/>
						</xsl:call-template>
						<xsl:text>)</xsl:text>
						<xsl:if test="self::apiOperation and $prog_language_name='ActionScript'">
							<xsl:text>:</xsl:text>
							<xsl:call-template name="processReturnType">
								<xsl:with-param name="currentPackage" select="$currentPackage"/>
								<xsl:with-param name="baseRef" select="$baseRef"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:if>
				</div>
				<div class="summaryTableDescription">
					<xsl:apply-templates select="apiOperationDetail/apiOperationDef/apiDeprecated"/>
					<xsl:apply-templates select="deprecated"/>
					  <xsl:if test="apiOperationDetail/apiOperationDef/apiIsOverride">
						<xsl:text>[</xsl:text>
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Override']]/entry[2]/p"/>
						<xsl:text>] </xsl:text>
					  </xsl:if>
					<xsl:if test="not(deprecated)">
						<xsl:if test="apiOperationDetail/apiOperationDef/apiStatic">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'static']]/entry[2]/p"/>
							<xsl:text>] </xsl:text>
						</xsl:if>
						<xsl:if test="./shortdesc or $classDeprecated='true'">
							<xsl:call-template name="shortDescriptionReview"/>
							<xsl:if test="$classDeprecated='true'">
								<xsl:copy-of select="$deprecatedLabel"/>
								<xsl:text>. </xsl:text>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not(string-length(./shortdesc/@conref) &gt; 0)">
							<xsl:for-each select="./shortdesc">
								<xsl:call-template name="processTags"/>
							</xsl:for-each>
						</xsl:if>
					</xsl:if>
				</div>
			</td>
			<xsl:if test="not($config/options/@docversion='2')">
				<td class="summaryTableOwnerCol">
					<xsl:choose>
						<xsl:when test="ancestor::ancestors">
							<xsl:variable name="classLink">
								<xsl:variable name="id" select="./@id"/>
								<xsl:variable name="classNameText" select="substring-after($id,':')"/>
								<xsl:variable name="packageNameText" select="substring-before($id,':')"/>
								<xsl:variable name="h1" select="$packageNameText"/>
								<xsl:variable name="h2" select="substring-before($classNameText,':')"/>
								<xsl:variable name="file" select="concat($baseRef,translate($h1,'.','/'),'/',$h2,'.html')"/>
								<xsl:variable name="gfile" select="concat($baseRef,$packageNameText,'.html')"/>
								<xsl:if test="contains($id,'.') or string-length($packageNameText) &gt; 0">
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<xsl:value-of select="$file"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="not(contains($id,'.')) and string-length($packageNameText) = 0">
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<xsl:value-of select="$gfile"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="className">
								<xsl:call-template name="getClassNameFromId">
									<xsl:with-param name="id" select="./@id"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="$classLink!=''">
								<a href="{$classLink}">
									<xsl:value-of select="$className"/>
								</a>
							</xsl:if>
							<xsl:if test="$classLink=''">
								<xsl:value-of select="$className"/>
							</xsl:if>
						</xsl:when>
						<xsl:when test="ancestor::apiClassifier">
							<xsl:value-of select="ancestor::apiClassifier/apiName"/>
						</xsl:when>
						<xsl:when test="ancestor-or-self::apiPackage">
							<xsl:if test="ancestor-or-self::apiPackage/apiName='__Global__'">
								<xsl:value-of select="concat('Top',$nbsp,'Level')"/>
							</xsl:if>
							<xsl:if test="ancestor-or-self::apiPackage/apiName!='__Global__'">
								<xsl:value-of select="ancestor-or-self::apiPackage/apiName"/>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<xsl:template name="getNamespaceLink">
		<xsl:param name="accessLevel"/>
		<xsl:param name="baseRef"/>
		<xsl:choose>
			<xsl:when test="$config/languageElements[@show='true' and @statements='true']">
				<xsl:if test="$accessLevel='public' or $accessLevel='protected'">
					<xsl:choose>
						<xsl:when test="$prog_language_name='javascript'"/>
						<xsl:otherwise>
							<xsl:value-of select="$accessLevel"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="not($accessLevel='public' or $accessLevel='protected')">
					<a href="{$baseRef}statements.html#{$accessLevel}">
						<xsl:value-of select="$accessLevel"/>
					</a>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$accessLevel"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getSpecialTypeLink">
		<xsl:param name="type"/>
		<xsl:param name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName">
					<xsl:if test="ancestor::apiClassifier">
						<xsl:value-of select="ancestor-or-self::apiPackage/apiName"/>
					</xsl:if>
					<xsl:if test="not(ancestor::apiClassifier)">
						<xsl:value-of select="ancestor-or-self::apiPackage/apiName"/>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="$config/languageElements[@show='true' and @specialTypes='true']">
				<a href="{$baseRef}specialTypes.html#{$type}">
					<xsl:value-of select="$type"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$type"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="includeExamples">
		<xsl:param name="showIncludeExamples" select="$showIncludeExamples"/>
		<xsl:param name="createExampleLink"/>
		<xsl:param name="createExampleInstructionLink" select="'false'"/>
		<xsl:if test="$showIncludeExamples = 'true'">
			<xsl:if test="./*/example/codeblock">
				<xsl:if test="$createExampleLink = 'true'">
					<a name="includeExamplesSummary"/>
					<div class="detailSectionHeader">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Examples']]/entry[2]/p"/>
					</div>
				</xsl:if>
				<xsl:for-each select="./*/example">
					<xsl:if test="$createExampleLink = 'false' and position() = 1">
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						<span class="label">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">Example</xsl:with-param>
							</xsl:call-template>
						</span>
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
					</xsl:if>
					<xsl:if test="$createExampleLink = 'true' and string-length(@conref) &gt; 0 ">
						<div class="exampleHeader">
							<xsl:call-template name="lastIndexOf">
								<xsl:with-param name="string" select="@conref"/>
								<xsl:with-param name="char" select="'\'"/>
							</xsl:call-template>
						</div>
					</xsl:if>
					<xsl:if test="contains(@conref,'.as')">
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
					</xsl:if>
					<div class="detailBody">
						<xsl:call-template name="processTags"/>
						<xsl:if test="swfblock/@conref and $showSWFs='true'">
							<xsl:call-template name="getPlugin">
								<xsl:with-param name="pluginId" select="concat('example',position())"/>
								<xsl:with-param name="filename" select="swfblock/@conref"/>
							</xsl:call-template>
						</xsl:if>
					</div>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getPlugin">
		<xsl:param name="pluginId"/>
		<xsl:param name="filename"/>
		<xsl:if test="not($isEclipse)">
			<script language="javascript" type="text/javascript">
				<xsl:comment> AC_FL_RunContent( "src", "<xsl:value-of select="substring-before($filename,'.swf')"/>", "width", "100%",
					"height","400px", "salign", "TL", "id", "<xsl:value-of select="$pluginId"/>", "quality", "high", "bgcolor", "", "name",
						"<xsl:value-of select="$pluginId"/>", "flashvars","", "allowScriptAccess","sameDomain", "type",
					"application/x-shockwave-flash","pluginspage", "http://www.macromedia.com/go/getflashplayer" ); </xsl:comment>
			</script>
		</xsl:if>
	</xsl:template>
	<xsl:template match="apiOperation" mode="detail">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="isMethod" select="true()"/>
		<xsl:param name="className" select="''"/>
		<xsl:param name="baseRef"/>
		<xsl:variable name="name" select="./apiName"/>
		<a name="{$name}()"/>
		<xsl:if test="count(./apiOperationDetail/apiOperationDef/apiParam) &gt; 0 ">
			<xsl:variable name="anchorWithArgs">
				<xsl:value-of select="./apiName"/>
				<xsl:text>(</xsl:text>
				<xsl:for-each select="./apiOperationDetail/apiOperationDef/apiParam">
					<xsl:if test="./apiOperationClassifier">
						<xsl:value-of select="translate(./apiOperationClassifier, ':', '.')"/>
					</xsl:if>
					<xsl:if test="./apiType">
						<xsl:value-of select="translate(./apiType/@value, ':', '.')"/>
					</xsl:if>
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:variable>
			<a name="{$anchorWithArgs}"/>
		</xsl:if>
		<table class="detailHeader" cellpadding="0" cellspacing="0">
			<tr>
				<td class="detailHeaderName">
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
					<xsl:value-of select="$name"/>
				</td>
				<td class="detailHeaderParens">
					<xsl:text>()</xsl:text>
				</td>
				<td class="detailHeaderType">
					<xsl:if test="$prog_language_name='ActionScript'">
						<xsl:if test="$isMethod">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Method']]/entry[2]/p"/>
						</xsl:if>
						<xsl:if test="not($isMethod)">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Function']]/entry[2]/p"/>
						</xsl:if>
					</xsl:if>
				</td>
				<xsl:if test="position()!=1">
					<td class="detailHeaderRule">
						<xsl:value-of select="$nbsp"/>
					</td>
				</xsl:if>
			</tr>
		</table>
		<div class="detailBody">
			<xsl:if test="(not(@type) or @type='method')">
				<code>
					<xsl:choose>
						<xsl:when test="$prog_language_name='javascript'"/>
						<xsl:otherwise>
							<xsl:if test="./apiOperationDetail/apiOperationDef/apiIsOverride">
								<xsl:text>override</xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:call-template name="getNamespaceLink">
						<xsl:with-param name="accessLevel" select="./apiOperationDetail/apiOperationDef/apiAccess/@value"/>
						<xsl:with-param name="baseRef" select="$baseRef"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:if test="./apiOperationDetail/apiOperationDef/apiFinal">
						<xsl:text>final </xsl:text>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$prog_language_name='javascript'"/>
						<xsl:otherwise>
							<xsl:if test="./apiOperationDetail/apiOperationDef/apiStatic">
								<xsl:text>static </xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$prog_language_name='ActionScript'">
						<xsl:text>function</xsl:text>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./apiName"/>
					<xsl:text>(</xsl:text>
					<xsl:call-template name="params"/>
					<xsl:text>)</xsl:text>
					<xsl:if test="self::apiOperation and $prog_language_name='ActionScript'">
						<xsl:text>:</xsl:text>
						<xsl:call-template name="processReturnType">
							<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
							<xsl:with-param name="baseRef" select="$baseRef"/>
						</xsl:call-template>
					</xsl:if>
				</code>
			</xsl:if>
			<xsl:apply-templates select="apiOperationDetail/apiOperationDef/apiDeprecated"/>
			<xsl:apply-templates select="deprecated"/>
			<xsl:if test="$classDeprecated='true'">
				<xsl:call-template name="description">
					<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
					<xsl:with-param name="addParagraphTags" select="true()"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:call-template name="version"/>
			<xsl:if test="$classDeprecated!='true'">
				<xsl:call-template name="description">
					<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
					<xsl:with-param name="addParagraphTags" select="true()"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="count(./apiOperationDetail/apiOperationDef/apiParam) &gt; 0 ">
				<p>
					<xsl:call-template name="parameters"/>
				</p>
			</xsl:if>
			<xsl:call-template name="result"/>
			<xsl:call-template name="event"/>
			<xsl:if test="apiOperationDetail/apiOperationDef/apiException">
				<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
				<span class="label">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Throws']]/entry[2]/p"/>
				</span>
				<table cellpadding="0" cellspacing="0" border="0">
					<xsl:apply-templates select="apiOperationDetail/apiOperationDef/apiException"/>
				</table>
			</xsl:if>
			<xsl:call-template name="sees"/>
			<xsl:if test="./*/example[codeblock]">
				<xsl:call-template name="includeExamples">
					<xsl:with-param name="createExampleLink" select="'false'"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="./*/example[not(codeblock)] | includeExamples/includeExample[not(codepart)] ">
				<xsl:for-each select="./*/example[not(codeblock)] | includeExamples/includeExample[not(codepart)]">
					<xsl:if test="count(descendant::*) &gt; 0">
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						<span class="label">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">Example</xsl:with-param>
							</xsl:call-template>
						</span>
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						<xsl:call-template name="processTags"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>
	<!-- CONSTRUCTORS -->
	<xsl:template match="apiConstructor" mode="detail">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="baseRef"/>
		<xsl:variable name="name" select="./apiName"/>
		<xsl:if test="position()>1">
			<a name="{$name}{position()}()"/>
		</xsl:if>
		<xsl:if test="position()=1">
			<a name="{$name}()"/>
		</xsl:if>
		<xsl:if test="count(./apiConstructorDetail/apiConstructorDef/apiParam) &gt; 0 ">
			<xsl:variable name="anchorWithArgs">
				<xsl:value-of select="./apiName"/>
				<xsl:text>(</xsl:text>
				<xsl:for-each select="./apiConstructorDetail/apiConstructorDef/apiParam">
					<xsl:if test="./apiOperationClassifier">
						<xsl:value-of select="translate(./apiOperationClassifier, ':', '.')"/>
					</xsl:if>
					<xsl:if test="./apiType">
						<xsl:value-of select="translate(./apiType/@value, ':', '.')"/>
					</xsl:if>
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:variable>

			<a name="{$anchorWithArgs}"/>
		</xsl:if>
		<table class="detailHeader" cellpadding="0" cellspacing="0">
			<tr>
				<td class="detailHeaderName">
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
					<xsl:value-of select="$name"/>
				</td>
				<td class="detailHeaderParens">
					<xsl:text>()</xsl:text>
				</td>
				<xsl:if test="$prog_language_name='ActionScript'">
					<td class="detailHeaderType">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constructor']]/entry[2]/p"/>
					</td>
				</xsl:if>
				<xsl:if test="position()!=1">
					<td class="detailHeaderRule">
						<xsl:value-of select="$nbsp"/>
					</td>
				</xsl:if>
			</tr>
		</table>
		<div class="detailBody">
			<xsl:if test="(not(@type) or @type='method')">
				<code>
					<xsl:call-template name="getNamespaceLink">
						<xsl:with-param name="accessLevel" select="apiConstructorDetail/apiConstructorDef/apiAccess/@value"/>
						<xsl:with-param name="baseRef" select="$baseRef"/>
					</xsl:call-template>
					<xsl:if test="$prog_language_name='ActionScript'">
						<xsl:text> function</xsl:text>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$name"/>
					<xsl:text>(</xsl:text>
					<xsl:call-template name="params"/>
					<xsl:text>)</xsl:text>
				</code>
			</xsl:if>
			<xsl:apply-templates select="apiConstructorDetail/apiConstructorDef/apiDeprecated"/>
			<xsl:call-template name="version"/>
			<xsl:variable name="description">
				<xsl:call-template name="description">
					<xsl:with-param name="classDeprecated" select="$classDeprecated"/>
					<xsl:with-param name="addParagraphTags" select="true()"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$description"/>
			<xsl:if test="$description=''">
				<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			</xsl:if>
			<xsl:if test="count(./apiConstructorDetail/apiConstructorDef/apiParam) &gt; 0">
				<xsl:call-template name="parameters"/>
			</xsl:if>
			<xsl:call-template name="event"/>
			<xsl:if test="apiConstructorDetail/apiConstructorDef/apiException">
				<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
				<span class="label">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Throws']]/entry[2]/p"/>
				</span>
				<table cellpadding="0" cellspacing="0" border="0">
					<xsl:apply-templates select="apiConstructorDetail/apiConstructorDef/apiException"/>
				</table>
			</xsl:if>
			<xsl:call-template name="sees"/>
			<xsl:if test="./*/example[codeblock]">
				<xsl:call-template name="includeExamples">
					<xsl:with-param name="createExampleLink" select="'false'"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="./*/example[not(codeblock)] | includeExamples/includeExample[not(codepart)] ">
				<xsl:for-each select="./*/example | includeExamples/includeExample[not(codepart)]">
					<xsl:if test="count(descendant::*) &gt; 0">
						<xsl:if test="position() = 1">
							<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
							<span class="label">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">Example</xsl:with-param>
								</xsl:call-template>
							</span>
							<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>

						</xsl:if>
						<xsl:call-template name="processTags"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>
	<!-- PARAMS -->
	<xsl:template name="params">
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$currentPackage"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:for-each select=".//apiParam">
			<xsl:if test="position()>1">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:if test="$config/options/@docversion='2' and @optional='true'">
				<xsl:text>[</xsl:text>
			</xsl:if>
			<xsl:if test="./apiType or ./apiOperationClassifier">
				<xsl:if test="./apiType/@value= 'restParam' or ./apiOperationClassifier = 'restParam'">
					<xsl:if test="$config/languageElements[@show='true' and @statements='true']">
						<a href="{$baseRef}statements.html#..._(rest)_parameter">...</a>
					</xsl:if>
					<xsl:if test="not($config/languageElements[@show='true' and @statements='true'])">
						<xsl:text>...</xsl:text>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./apiItemName"/>
				</xsl:if>
				<xsl:if test="((./apiType and ./apiType/@value!='restParam'))  or (./apiOperationClassifier and ./apiOperationClassifier != 'restParam')">
					<xsl:if test="$prog_language_name='ActionScript'">
						<xsl:value-of select="./apiItemName"/>
						<xsl:text>:</xsl:text>
						<xsl:call-template name="processParamType">
							<xsl:with-param name="currentPackage" select="$currentPackage"/>
							<xsl:with-param name="baseRef" select="$baseRef"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="(string-length(apiData) or ./apiOperationClassifier='String') and apiData!='unknown'">
				<xsl:text> = </xsl:text>
				<xsl:if test="./apiOperationClassifier='String' and apiData!='null'">
					<xsl:text>"</xsl:text>
				</xsl:if>
				<xsl:value-of select="apiData"/>
				<xsl:if test="./apiOperationClassifier='String' and apiData!='null'">
					<xsl:text>"</xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="./apiOperationClassifier='Number' and apiData='unknown'">
				<xsl:text> = NaN</xsl:text>
			</xsl:if>
			<xsl:if test="$config/options/@docversion='2' and @optional='true'">
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="processParamType">
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:param name="baseRef" select="''"/>
		<xsl:choose>
			<xsl:when test="./apiOperationClassifier">
				<xsl:variable name="destination" select="./apiOperationClassifier"/>
				<xsl:variable name="h1" select="substring-after($destination,':')"/>
				<xsl:variable name="h2" select="substring-before($destination,':')"/>
				<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
				<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
				<xsl:variable name="hyperLink">
					<xsl:if test="contains($destination,'.')">
						<xsl:if test="$prog_language_name!='javascript'">
							<xsl:value-of select="$file"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not(contains($destination,'.'))">
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>
							<xsl:otherwise>
								<xsl:value-of select="$gfile"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="$hyperLink = ''">
					<xsl:call-template name="getSimpleClassName">
						<xsl:with-param name="fullClassName" select="./apiOperationClassifier"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$hyperLink != ''">
					<a href="{$hyperLink}">
						<xsl:call-template name="getSimpleClassName">
							<xsl:with-param name="fullClassName" select="./apiOperationClassifier"/>
						</xsl:call-template>
					</a>
				</xsl:if>
			</xsl:when>
			<xsl:when test="./apiType/@value='' or ./apiType/@value='*' or ./apiType/@value='any'or ./apiOperationClassifier='' or ./apiOperationClassifier='*'">
				<xsl:call-template name="getSpecialTypeLink">
					<xsl:with-param name="type" select="'*'"/>
					<xsl:with-param name="baseRef" select="$baseRef"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(./apiOperationClassifier)">
				<xsl:call-template name="getSimpleClassName">
					<xsl:with-param name="fullClassName" select="./apiType/@value"/>
					<xsl:with-param name="baseRef" select="$baseRef"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="parameters">
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<span class="label">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">Parameters</xsl:with-param>
			</xsl:call-template>
		</span>
		<table cellpadding="0" cellspacing="0" border="0">
			<xsl:for-each select=".//apiParam">
				<tr>
					<td width="20px"/>
					<td>
						<code>
							<xsl:if test="./apiType/@value='restParam' or ./apiOperationClassifier='restParam'">
								<xsl:variable name="baseRef">
									<xsl:if test="$currentPackage">
										<xsl:call-template name="getBaseRef">
											<xsl:with-param name="packageName" select="$currentPackage"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>
								<xsl:if test="$config/languageElements[@show='true' and @statements='true']">
									<a href="{$baseRef}statements.html#..._(rest)_parameter">...</a>
								</xsl:if>
								<xsl:if test="not($config/languageElements[@show='true' and @statements='true'])">
									<xsl:text>...</xsl:text>
								</xsl:if>
								<xsl:text> </xsl:text>
								<span class="label">
									<xsl:value-of select="./apiItemName"/>
								</span>
							</xsl:if>
							<xsl:if test="((./apiType) and ./apiType/@value!='restParam')  or (./apiOperationClassifier and ./apiOperationClassifier!='restParam')">
								<span class="label">
									<xsl:value-of select="./apiItemName"/>
								</span>
								<xsl:if test="$prog_language_name='ActionScript'">
									<xsl:choose>
										<xsl:when test="./apiOperationClassifier">
											<xsl:variable name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
											<xsl:variable name="baseRef">
												<xsl:call-template name="getBaseRef">
													<xsl:with-param name="packageName" select="$packageName"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="destination" select="./apiOperationClassifier"/>
											<xsl:variable name="h1" select="substring-after($destination,':')"/>
											<xsl:variable name="h2" select="substring-before($destination,':')"/>
											<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
											<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
											<xsl:variable name="hyperLink">
												<xsl:if test="contains($destination,'.')">
													<xsl:value-of select="$file"/>
												</xsl:if>
												<xsl:if test="not(contains($destination,'.'))">
													<xsl:value-of select="$gfile"/>
												</xsl:if>
											</xsl:variable>
											<xsl:text>:</xsl:text>
											<xsl:if test="$hyperLink = ''">
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="./apiOperationClassifier"/>
												</xsl:call-template>
											</xsl:if>
											<xsl:if test="$hyperLink != ''">
												<a href="{$hyperLink}">
													<xsl:call-template name="getSimpleClassName">
														<xsl:with-param name="fullClassName" select="./apiOperationClassifier"/>
													</xsl:call-template>
												</a>
											</xsl:if>
										</xsl:when>
										<xsl:when test="./apiType/@value='' or ./apiType/@value='*' or ./apiType/@value='any' or ./apiOperationClassifier='' or ./apiOperationClassifier='*'">
											<xsl:text>:</xsl:text>
											<xsl:variable name="baseRef">
												<xsl:call-template name="getBaseRef">
													<xsl:with-param name="packageName" select="$currentPackage"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:call-template name="getSpecialTypeLink">
												<xsl:with-param name="type" select="'*'"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="not(./apiOperationClassifier)">
											<xsl:variable name="baseRef">
												<xsl:call-template name="getBaseRef">
													<xsl:with-param name="packageName" select="$currentPackage"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:text>:</xsl:text>
											<xsl:call-template name="getSimpleClassName">
												<xsl:with-param name="fullClassName" select="./apiType/@value"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:if>


							</xsl:if>
							<xsl:if test="(string-length(./apiData) or ./apiOperationClassifier='String') and ./apiData!='unknown'">
								<xsl:text disable-output-escaping="yes">&lt;/code&gt; (default = </xsl:text>
								<xsl:if test="./apiOperationClassifier='String' and ./apiData!='null'">
									<xsl:text>"</xsl:text>
								</xsl:if>
								<xsl:text disable-output-escaping="yes">&lt;code&gt;</xsl:text>
								<xsl:value-of select="apiData"/>
								<xsl:text disable-output-escaping="yes">&lt;/code&gt;</xsl:text>
								<xsl:if test="./apiOperationClassifier='String' and ./apiData!='null'">
									<xsl:text>"</xsl:text>
								</xsl:if>
								<xsl:text>)</xsl:text>
								<xsl:text disable-output-escaping="yes">&lt;code&gt;</xsl:text>
							</xsl:if>
							<xsl:if test="(string-length(./apiData) or ./apiOperationClassifier='Number') and ./apiData='unknown'">
								<xsl:text disable-output-escaping="yes">&lt;/code&gt; (default = </xsl:text>
								<xsl:text disable-output-escaping="yes">&lt;code&gt;</xsl:text>
								<xsl:value-of select="'NaN'"/>
								<xsl:text disable-output-escaping="yes">&lt;/code&gt;</xsl:text>
								<xsl:text>)</xsl:text>
								<xsl:text disable-output-escaping="yes">&lt;code&gt;</xsl:text>
							</xsl:if>
						</code>
						<xsl:if test="@optional='true'">
							<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]>[optional]</xsl:text>
						</xsl:if>
						<xsl:if test="normalize-space(./apiDesc/.)">
							<xsl:value-of select="$emdash"/>
							<xsl:for-each select="./apiDesc">
								<xsl:call-template name="processTags"/>
							</xsl:for-each>
						</xsl:if>
					</td>
				</tr>
				<xsl:if test="position()!=last()">
					<tr>
						<td class="paramSpacer">
							<xsl:value-of select="$nbsp"/>
						</td>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
	</xsl:template>
	<!-- RESULT -->
	<xsl:template name="result">
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$currentPackage"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if
			test="(not(apiOperationDetail/apiOperationDef/apiReturn/apiType) or apiOperationDetail/apiOperationDef/apiReturn/apiType[@value != 'void']) and not($config/options/@docversion='2' and apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifer='Void')">
			<p/>
			<span class="label">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Returns']]/entry[2]/p"/>
			</span>
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="20"/>
					<td>
						<xsl:if test="$prog_language_name='ActionScript'">
							<code>
								<xsl:choose>
									<xsl:when
										test="apiOperationDetail/apiOperationDef/apiReturn/apiType/@value='' or apiOperationDetail/apiOperationDef/apiReturn/apiType/@value='*' or apiOperationDetail/apiOperationDef/apiReturn/apiType/@value='any' ">
										<xsl:call-template name="getSpecialTypeLink">
											<xsl:with-param name="type" select="'*'"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="apiOperationDetail/apiOperationDef/apiReturn/apiType/@value='Void' and $config/options/@docversion='2'">
										<xsl:value-of select="apiOperationDetail/apiOperationDef/apiReturn/apiType/@value"/>
									</xsl:when>
									<xsl:when test="apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier">
										<xsl:variable name="destination" select="apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier"/>
										<xsl:variable name="h1" select="substring-after($destination,':')"/>
										<xsl:variable name="h2" select="substring-before($destination,':')"/>
										<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
										<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
										<xsl:variable name="hyperLink">
											<xsl:if test="contains($destination,'.')">
												<xsl:value-of select="$file"/>
											</xsl:if>
											<xsl:if test="not(contains($destination,'.'))">
												<xsl:value-of select="$gfile"/>
											</xsl:if>
										</xsl:variable>
										<xsl:if test="$hyperLink = ''">
											<xsl:call-template name="getSimpleClassName">
												<xsl:with-param name="fullClassName" select="apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="$hyperLink != ''">
											<a href="{$hyperLink}">
												<xsl:call-template name="getSimpleClassName">
													<xsl:with-param name="fullClassName" select="apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier"/>
												</xsl:call-template>
											</a>
										</xsl:if>
									</xsl:when>
									<xsl:when test="not(apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier)">
										<xsl:call-template name="getSimpleClassName">
											<xsl:with-param name="fullClassName" select="apiOperationDetail/apiOperationDef/apiReturn/apiType/@value"/>
											<xsl:with-param name="baseRef" select="$baseRef"/>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</code>
						</xsl:if>
						<xsl:if test="./apiOperationDetail/apiOperationDef/apiReturn/apiDesc/@conref">
							<xsl:if test="$prog_language_name='ActionScript'">
								<xsl:value-of select="$emdash"/>
							</xsl:if>
							<xsl:call-template name="getConRefText">
								<xsl:with-param name="conref" select="./apiOperationDetail/apiOperationDef/apiReturn/apiDesc/@conref"/>
								<xsl:with-param name="descriptionType" select="local-name(./apiOperationDetail/apiOperationDef/apiReturn/apiDesc)"/>
								<xsl:with-param name="entryType" select="'method'"/>
								<xsl:with-param name="currentPackage" select="$currentPackage"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="not(./apiOperationDetail/apiOperationDef/apiReturn/apiDesc/@conref)">
							<xsl:for-each select="./apiOperationDetail/apiOperationDef/apiReturn/apiDesc">
								<xsl:if test="$prog_language_name='ActionScript'">
									<xsl:value-of select="$emdash"/>
								</xsl:if>
								<xsl:call-template name="processTags"/>
							</xsl:for-each>
						</xsl:if>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- THROWS -->
	<xsl:template match="apiException">
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<tr>
			<td width="20"/>
			<td>
				<code>
					<xsl:if test="apiOperationClassifier">
						<xsl:variable name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
						<xsl:variable name="baseRef">
							<xsl:call-template name="getBaseRef">
								<xsl:with-param name="packageName" select="$packageName"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="destination" select="apiOperationClassifier"/>
						<xsl:if test="count($classHeader_map//apiClassifier[@id=$destination] ) &gt; 0">
							<xsl:variable name="h1" select="substring-after($destination,':')"/>
							<xsl:variable name="h2" select="substring-before($destination,':')"/>
							<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
							<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
							<xsl:variable name="hyperLink">
								<xsl:if test="contains($destination,'.')">
									<xsl:if test="$prog_language_name!='javascript'">
										<xsl:value-of select="$file"/>
									</xsl:if>

								</xsl:if>
								<xsl:if test="not(contains($destination,'.'))">
									<xsl:choose>
										<xsl:when test="$prog_language_name='javascript'"/>
										<xsl:otherwise>
											<xsl:value-of select="$gfile"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:variable>

							<xsl:if test="$hyperLink = ''">
								<xsl:value-of select="apiItemName"/>
							</xsl:if>
							<xsl:if test="$hyperLink != ''">
								<a href="{$hyperLink}">
									<xsl:value-of select="apiItemName"/>
								</a>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not(count($classHeader_map//apiClassifier[@id=$destination] ) &gt; 0)">
								<xsl:value-of select="apiItemName"/>
						</xsl:if>
						<xsl:text> </xsl:text>
					</xsl:if>

				</code>
				<xsl:if test="string-length(apiDesc/.)">
					<xsl:value-of select="$emdash"/>
				</xsl:if>
				<xsl:for-each select="./apiDesc">
					<xsl:call-template name="processTags"/>
				</xsl:for-each>
			</td>
		</tr>
		<xsl:if test="position()!=last()">
			<tr>
				<td class="paramSpacer">
					<xsl:value-of select="$nbsp"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- EXAMPLES -->
	<xsl:template match="example | includeExample">
		<xsl:param name="show" select="$showExamples"/>
		<xsl:if test="$show = 'true'">
			<xsl:if test="position()=1">
				<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
				<span class="label">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Example']]/entry[2]/p"/>
				</span>
				<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>

			</xsl:if>
			<xsl:if test="self::example">
				<xsl:call-template name="deTilda">
					<xsl:with-param name="inText">
						<xsl:apply-templates mode="deTab"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="self::includeExample">
				<xsl:variable name="deTabbed">
					<xsl:call-template name="search-and-replace">
						<xsl:with-param name="input" select="codeblock/."/>
						<xsl:with-param name="search-string" select="$tab"/>
						<xsl:with-param name="replace-string" select="$tabSpaces"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="initialComment" select="starts-with($deTabbed,'/*')"/>
				<xsl:if test="$initialComment">
					<xsl:variable name="comment" select="substring-before($deTabbed,'*/')"/>
					<xsl:if test="contains($comment,'@exampleText ')">
						<xsl:call-template name="deTilda">
							<xsl:with-param name="inText" select="substring-after(translate($comment,'*',''),'@exampleText ')"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$initialComment">
					<xsl:variable name="rest" select="substring-after($deTabbed,'*/')"/>
					<xsl:variable name="finalComment" select="contains($rest,'/*')"/>
					<xsl:if test="$finalComment">
						<div class="listing">
							<pre>
								<xsl:value-of select="substring-before($rest,'/*')"/>
							</pre>
						</div>
						<xsl:if test="contains($rest,'@exampleText ')">
							<xsl:call-template name="deTilda">
								<xsl:with-param name="inText" select="substring-after(translate(substring-before($rest,'*/'),'*',''),'@exampleText ')"/>
							</xsl:call-template>
							<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not($finalComment)">
						<div class="listing">
							<pre>
								<xsl:value-of select="substring-after($deTabbed,'*/')"/>
							</pre>
						</div>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not($initialComment)">
					<xsl:variable name="finalComment" select="contains($deTabbed,'/*')"/>
					<xsl:if test="$finalComment">
						<div class="listing">
							<pre>
								<xsl:value-of select="substring-before($deTabbed,'/*')"/>
							</pre>
						</div>
						<xsl:if test="contains($deTabbed,'@exampleText ')">
							<xsl:call-template name="deTilda">
								<xsl:with-param name="inText" select="substring-after(translate(substring-before($deTabbed,'*/'),'*',''),'@exampleText ')"/>
							</xsl:call-template>
							<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not($finalComment)">
						<div class="listing">
							<pre>
								<xsl:value-of select="$deTabbed"/>
							</pre>
						</div>
					</xsl:if>
				</xsl:if>
				<xsl:if test="swfblock/@conref and $showSWFs='true'">
					<xsl:variable name="filename" select="swfblock/@conref"/>
					<xsl:call-template name="getPlugin">
						<xsl:with-param name="filename" select="$filename"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
			<p/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="text()" mode="deTab">
		<xsl:call-template name="search-and-replace">
			<xsl:with-param name="input" select="."/>
			<xsl:with-param name="search-string" select="'&#09;'"/>
			<xsl:with-param name="replace-string" select="'    '"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="includeExampleLink">
		<xsl:param name="showIncludeExamples" select="$showIncludeExamples"/>
		<xsl:if test="$showIncludeExamples = 'true'">
			<xsl:if test="./*/example/codeblock">
				<p>
					<a href="#includeExamplesSummary">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ViewExamples']]/entry[2]/p"/>
					</a>
				</p>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="inherited">
		<xsl:param name="lowerType"/>
		<xsl:param name="upperType"/>
		<xsl:param name="prefix"/>
		<xsl:param name="postfix"/>
		<xsl:param name="inheritedItems"/>
		<xsl:param name="staticItems"/>
		<xsl:if test="string-length($inheritedItems) &gt; 0">
			<xsl:call-template name="doInherited">
				<xsl:with-param name="lowerType" select="$lowerType"/>
				<xsl:with-param name="upperType" select="$upperType"/>
				<xsl:with-param name="prefix" select="$prefix"/>
				<xsl:with-param name="postfix" select="$postfix"/>
				<xsl:with-param name="items" select="$inheritedItems"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="string-length($staticItems) &gt; 0">
			<xsl:call-template name="doInherited">
				<xsl:with-param name="lowerType" select="$lowerType"/>
				<xsl:with-param name="upperType" select="$upperType"/>
				<xsl:with-param name="prefix" select="$prefix"/>
				<xsl:with-param name="postfix" select="$postfix"/>
				<xsl:with-param name="items" select="$staticItems"/>
				<xsl:with-param name="isStatic" select="true()"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="doInherited">
		<xsl:param name="lowerType"/>
		<xsl:param name="upperType"/>
		<xsl:param name="prefix"/>
		<xsl:param name="postfix"/>
		<xsl:param name="items"/>
		<xsl:param name="innerClass" select="false()"/>
		<xsl:param name="isStatic" select="false()"/>
		<xsl:variable name="classRef" select="classRef"/>
		<xsl:variable name="bgColor">
			<xsl:if test="not($isStatic)">
				<xsl:text>#EEEEEE</xsl:text>
			</xsl:if>
			<xsl:if test="$isStatic">
				<xsl:text>#EEDDDD</xsl:text>
			</xsl:if>
		</xsl:variable>
		<a name="{$lowerType}InheritedFrom{$classRef/@name}"/>
		<table cellspacing="0" cellpadding="3" class="summaryTable">
			<tr>
				<th>
					<xsl:value-of select="$nbsp"/>
				</th>
				<th>
					<xsl:if test="$isStatic">
						<!--defined in class-->
						<xsl:text>Static </xsl:text>
						<xsl:value-of select="$lowerType"/>
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">DefinedIn</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="not($isStatic)">
						<!-- inherited from class -->
						<xsl:value-of select="$upperType"/>
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">InheritedFrom</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<a href="{$classRef/@relativePath}">
						<xsl:value-of select="$classRef/@name"/>
					</a>
				</th>
			</tr>
			<tr>
				<td class="summaryTablePaddingCol">
					<xsl:value-of select="$nbsp"/>
				</td>
				<td class="inheritanceList">
					<code>
						<xsl:for-each select="tokenize($items,';')">
							<xsl:sort select="." order="ascending" data-type="text" lang="en-US"/>
							<xsl:if test="$innerClass">
								<xsl:variable name="href">
									<xsl:if test="contains($classRef/@relativePath,':')">
										<xsl:call-template name="substring-before-last">
											<xsl:with-param name="input" select="$classRef/@relativePath"/>
											<xsl:with-param name="substr" select="':'"/>
										</xsl:call-template>
										<xsl:text>/</xsl:text>
									</xsl:if>
									<xsl:value-of select="."/>
								</xsl:variable>
								<a href="{$href}.html">
									<xsl:value-of select="."/>
								</a>
							</xsl:if>
							<xsl:if test="not($innerClass)">
								<xsl:if test="$prefix">
									<a href="{$classRef/@relativePath}#{$prefix}:{.}{$postfix}">
										<xsl:value-of select="."/>
									</a>
								</xsl:if>
								<xsl:if test="not($prefix)">
									<a href="{$classRef/@relativePath}#{.}{$postfix}">
										<xsl:value-of select="."/>
									</a>
								</xsl:if>
							</xsl:if>
							<xsl:if test="position() != last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</code>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="description">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="addParagraphTags" select="false()"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="sourceName">
			<xsl:value-of select="local-name(.)"/>
			<xsl:value-of select="./apiName"/>
		</xsl:variable>
		<xsl:if test="$classDeprecated='true'">
			<xsl:copy-of select="$deprecatedLabel"/>
			<xsl:message>THIS CODE SHOULD NOT BE CALLED. If you see this message, please notify your local ASDocs contact or the tech team. </xsl:message>
			<xsl:text>.</xsl:text>
			<xsl:text> The </xsl:text>
			<xsl:value-of select="../../apiName"/>
			<xsl:text> class is </xsl:text>
			<a href="#deprecated">deprecated</a>
			<xsl:if test="string-length(../../deprecated/@as-of)">
				<xsl:text> since </xsl:text>
				<xsl:value-of select="../../deprecated/@as-of"/>
			</xsl:if>
			<xsl:text>.</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
		</xsl:if>
		<xsl:variable name="asCustomsText">
			<xsl:value-of select="prolog/asCustoms/review"/>
		</xsl:variable>
		<xsl:if test="string-length($asCustomsText) &gt; 0">
			<xsl:if test="$config/options/@showReview='true'">
				<h2>
					<font color="red">Review Needed</font>
				</h2>
			</xsl:if>
			<xsl:value-of select="$asCustomsText"/>
		</xsl:if>
		<xsl:for-each select="./apiDesc | ./*/apiDesc | ./description">
			<xsl:variable name="entryType">
				<xsl:choose>
					<xsl:when test="self::apiClassifier">
						<xsl:value-of select="'class'"/>
					</xsl:when>
					<xsl:when test="self::apiOperation">
						<xsl:value-of select="'method'"/>
					</xsl:when>
					<xsl:when test="self::apiValue">
						<xsl:value-of select="'property'"/>
					</xsl:when>
					<xsl:when test="self::adobeApiEvent">
						<xsl:value-of select="'event'"/>
					</xsl:when>
					<xsl:when test="self::style">
						<xsl:value-of select="'style'"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>

			<p>
				<xsl:if test="string-length(./@conref) &gt; 0">
					<xsl:call-template name="getConRefText">
						<xsl:with-param name="conref" select="./@conref"/>
						<xsl:with-param name="descriptionType" select="local-name(.)"/>
						<xsl:with-param name="entryType" select="$entryType"/>
						<xsl:with-param name="currentPackage" select="$currentPackage"/>
					</xsl:call-template>
				</xsl:if>
			</p>

			<!-- Call for any child NODE PROCESS-->
			<xsl:call-template name="processTags">
				<xsl:with-param name="addParagraphTags" select="$addParagraphTags"/>
			</xsl:call-template>
			<!-- END Call for any child NODE PROCESS-->
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="shortDescription">
		<xsl:param name="classDeprecated" select="'false'"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:if test="./shortdesc or $classDeprecated='true'">
			<xsl:call-template name="shortDescriptionReview"/>
			<xsl:if test="$classDeprecated='true'">
				<xsl:copy-of select="$deprecatedLabel"/>
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:variable name="entryType">
				<xsl:choose>
					<xsl:when test="self::apiClassifier">
						<xsl:value-of select="'class'"/>
					</xsl:when>
					<xsl:when test="self::apiOperation">
						<xsl:value-of select="'method'"/>
					</xsl:when>
					<xsl:when test="self::apiValue">
						<xsl:value-of select="'property'"/>
					</xsl:when>
					<xsl:when test="self::adobeApiEvent">
						<xsl:value-of select="'event'"/>
					</xsl:when>
					<xsl:when test="self::style">
						<xsl:value-of select="'style'"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="conRefText">
				<xsl:if test="string-length(./shortdesc/@conref) &gt; 0">
					<xsl:for-each select="./shortdesc">
						<xsl:call-template name="processTags"/>
					</xsl:for-each>

					<xsl:call-template name="getConRefText">
						<xsl:with-param name="conref" select="./shortdesc/@conref"/>
						<xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
						<xsl:with-param name="entryType" select="$entryType"/>
						<xsl:with-param name="currentPackage" select="$currentPackage"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="not(string-length(./shortdesc/@conref) &gt; 0)">
					<xsl:for-each select="./shortdesc">
						<xsl:call-template name="processTags"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="string-length($conRefText) &gt; 0">
				<xsl:value-of select="$conRefText"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="hasInnerClasses">
		<xsl:if test="self::apiClassifier">
			<xsl:value-of select="count(./apiClassifier)"/>
		</xsl:if>
		<xsl:if test="self::apiPackage"> </xsl:if>
	</xsl:template>
	<xsl:template name="hasConstants">
		<xsl:if test="self::apiClassifier">
			<xsl:value-of select="count(./apiValue[not(apiValueDetail/apiValueDef/apiProperty)])"/>
		</xsl:if>
		<xsl:if test="self::apiPackage">
			<xsl:value-of select="count(.//*[apiValue[not(apiValueDetail/apiValueDef/apiProperty)]])"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="hasFields">
		<xsl:if test="self::apiClassifier">
			<xsl:value-of select="count(./apiValue[apiValueDetail/apiValueDef/apiProperty])"/>
		</xsl:if>
		<xsl:if test="self::apiPackage">
			<xsl:value-of select="count(.//*[apiValue[apiValueDetail/apiValueDef/apiProperty]])"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="hasConstructor">
		<xsl:if test="self::apiClassifier">
			<xsl:value-of select="count(./apiConstructor)"/>
		</xsl:if>
		<xsl:if test="self::apiPackage">
			<xsl:value-of select="count(./*[apiConstructor])"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="hasMethods">
		<xsl:if test="self::apiClassifier">
			<xsl:value-of select="count(./apiOperation)"/>
		</xsl:if>
		<xsl:if test="self::apiPackage">
			<xsl:value-of select="count(.//*[apiOperation])"/>
		</xsl:if>
	</xsl:template>
	<!-- TODO currently the mxmlc compiler does not recognize events defined in interfaces that are
	     not redeclared by the implementor, so we can not consider them when determining the event count -->
	<xsl:template name="hasEvents">
		<xsl:if test="self::apiClassifier">
			<xsl:value-of select="count(./adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)])"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="hasStyles">
		<xsl:value-of select="count(.//*[style])"/>
	</xsl:template>

	  <xsl:template name="hasSkinPart">
	    <xsl:value-of select="count(.//*[SkinPart])"/>
	  </xsl:template>
	  <xsl:template name="hasSkinState">
	    <xsl:value-of select="count(.//*[SkinState])"/>
	  </xsl:template>	
	<xsl:template name="hasEffects">
		<xsl:value-of select="count(.//*[effect])"/>
	</xsl:template>
	<xsl:template name="hasInheritedConstants">
		<xsl:variable name="countList">
			<xsl:call-template name="inheritPropertyCount">
				<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="accessLevel" select="'public'"/>
				<xsl:with-param name="isConst" select="'true'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hasInherited">
			<xsl:call-template name="convertNumberListIntoBoolean">
				<xsl:with-param name="numberList" select="$countList"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$hasInherited"/>
	</xsl:template>
	<xsl:template name="hasInheritedFields">
		<xsl:variable name="countList">
			<xsl:call-template name="inheritPropertyCount">
				<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="accessLevel" select="'public'"/>
				<xsl:with-param name="isConst" select="'false'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hasInherited">
			<xsl:call-template name="convertNumberListIntoBoolean">
				<xsl:with-param name="numberList" select="$countList"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$hasInherited"/>
	</xsl:template>
	<xsl:template name="hasInheritedMethods">
		<xsl:variable name="countList">
			<xsl:call-template name="inheritMethodCount">
				<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="accessLevel" select="'public'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hasInherited">
			<xsl:call-template name="convertNumberListIntoBoolean">
				<xsl:with-param name="numberList" select="$countList"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$hasInherited"/>
	</xsl:template>
	<xsl:template name="hasInheritedEvents">
		<xsl:variable name="countList">
			<xsl:call-template name="inheritEventCount">
				<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hasInherited">
			<xsl:call-template name="convertNumberListIntoBoolean">
				<xsl:with-param name="numberList" select="$countList"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$hasInherited"/>
	</xsl:template>
	<xsl:template name="hasInheritedStyles">
		<xsl:variable name="countList">
			<xsl:call-template name="inheritStyleCount">
				<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hasInherited">
			<xsl:call-template name="convertNumberListIntoBoolean">
				<xsl:with-param name="numberList" select="$countList"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$hasInherited"/>
	</xsl:template>
	<xsl:template name="hasInheritedSkinPart">
		<xsl:variable name="countList">
			<xsl:call-template name="inheritSkinPartCount">
				<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hasInherited">
			<xsl:call-template name="convertNumberListIntoBoolean">
				<xsl:with-param name="numberList" select="$countList"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$hasInherited"/>
	</xsl:template>
	<xsl:template name="hasInheritedSkinState">
		<xsl:variable name="countList">
			<xsl:call-template name="inheritSkinStateCount">
				<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hasInherited">
			<xsl:call-template name="convertNumberListIntoBoolean">
				<xsl:with-param name="numberList" select="$countList"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$hasInherited"/>
	</xsl:template>
	<xsl:template name="hasInheritedEffects">
		<xsl:variable name="countList">
			<xsl:call-template name="inheritEffectCount">
				<xsl:with-param name="baseClass" select="./apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="hasInherited">
			<xsl:call-template name="convertNumberListIntoBoolean">
				<xsl:with-param name="numberList" select="$countList"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$hasInherited"/>
	</xsl:template>
	<xsl:template name="hasIncludeExamples">
		<xsl:param name="showIncludeExamples" select="$showIncludeExamples"/>
		<xsl:if test="$showIncludeExamples = 'true'">
			<xsl:value-of select="count(./*[example/codeblock])"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getPageLinks">
		<xsl:param name="copyNum" select="'1'"/>
		<xsl:param name="title" select="''"/>
		<xsl:variable name="hasInnerClasses">
			<xsl:call-template name="hasInnerClasses"/>
		</xsl:variable>
		<xsl:variable name="hasConstants">
			<xsl:call-template name="hasConstants"/>
		</xsl:variable>
		<xsl:variable name="hasFields">
			<xsl:call-template name="hasFields"/>
		</xsl:variable>
		<xsl:variable name="hasConstructor">
			<xsl:call-template name="hasConstructor"/>
		</xsl:variable>
		<xsl:variable name="hasMethods">
			<xsl:call-template name="hasMethods"/>
		</xsl:variable>
		<xsl:variable name="hasStyles">
			<xsl:call-template name="hasStyles"/>
		</xsl:variable>
		    <xsl:variable name="hasSkinPart">
		      <xsl:call-template name="hasSkinPart"/>
		    </xsl:variable>
		    <xsl:variable name="hasSkinState">
		      <xsl:call-template name="hasSkinState"/>
		    </xsl:variable>		
		<xsl:variable name="hasEffects">
			<xsl:call-template name="hasEffects"/>
		</xsl:variable>
		<xsl:variable name="hasEvents">
			<xsl:call-template name="hasEvents"/>
		</xsl:variable>
		<xsl:variable name="hasInheritedConstants">
			<xsl:call-template name="hasInheritedConstants"/>
		</xsl:variable>
		<xsl:variable name="hasInheritedFields">
			<xsl:call-template name="hasInheritedFields"/>
		</xsl:variable>
		<xsl:variable name="hasInheritedMethods">
			<xsl:call-template name="hasInheritedMethods"/>
		</xsl:variable>
		<xsl:variable name="hasInheritedStyles">
			<xsl:call-template name="hasInheritedStyles"/>
		</xsl:variable>
		    <xsl:variable name="hasInheritedSkinPart">
		      <xsl:call-template name="hasInheritedSkinPart"/>
		    </xsl:variable>
		    <xsl:variable name="hasInheritedSkinState">
		      <xsl:call-template name="hasInheritedSkinState"/>
		    </xsl:variable>		
		<xsl:variable name="hasInheritedEffects">
			<xsl:call-template name="hasInheritedEffects"/>
		</xsl:variable>
		<xsl:variable name="hasInheritedEvents">
			<xsl:call-template name="hasInheritedEvents"/>
		</xsl:variable>
		<xsl:variable name="hasIncludeExamples">
			<xsl:call-template name="hasIncludeExamples"/>
		</xsl:variable>
		<xsl:variable name="isTopLevel">
			<xsl:call-template name="isTopLevel">
				<xsl:with-param name="packageName" select="../apiName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="getLinks2">
			<xsl:with-param name="subTitle" select="$title"/>
			<xsl:with-param name="packageName" select="../apiName"/>
			<xsl:with-param name="fileName" select="./apiName"/>
			<xsl:with-param name="fileName2">
				<xsl:if test="string-length(../apiName) and $isTopLevel='false'">
					<xsl:value-of select="concat(translate(../apiName,'.','/'),'/class-list.html')"/>
				</xsl:if>
				<xsl:if test="not(string-length(../apiName))">
					<xsl:value-of select="'class-list.html'"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="showInnerClasses" select="boolean(number($hasInnerClasses))"/>
			<xsl:with-param name="showConstants">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:value-of select="boolean(number($hasConstants)) or ($hasInheritedConstants='true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="showProperties">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:value-of select="boolean(number($hasFields)) or ($hasInheritedFields='true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="showConstructors" select="false()" />
			<xsl:with-param name="showMethods">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:value-of select="boolean(number($hasMethods)) or boolean(number($hasConstructor)) or ($hasInheritedMethods='true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="showStyles">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:value-of select="boolean(number($hasStyles)) or ($hasInheritedStyles='true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		      <xsl:with-param name="showSkinPart">
			<xsl:choose>
			  <xsl:when test="$prog_language_name='javascript'">
			    <xsl:value-of select="false()"/>
			  </xsl:when>
			  <xsl:otherwise>
			    <xsl:value-of select="boolean(number($hasSkinPart)) or ($hasInheritedSkinPart='true')"/>
			  </xsl:otherwise>
			</xsl:choose>
		      </xsl:with-param>
		      <xsl:with-param name="showSkinState">
			<xsl:choose>
			  <xsl:when test="$prog_language_name='javascript'">
			    <xsl:value-of select="false()"/>
			  </xsl:when>
			  <xsl:otherwise>
			    <xsl:value-of select="boolean(number($hasSkinState)) or ($hasInheritedSkinState='true')"/>
			  </xsl:otherwise>
			</xsl:choose>
		      </xsl:with-param>			
			<xsl:with-param name="showEffects">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:value-of select="boolean(number($hasEffects)) or ($hasInheritedEffects='true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="showEvents">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:value-of select="boolean(number($hasEvents)) or ($hasInheritedEvents='true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="showIncludeExamples">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:value-of select="boolean(number($hasIncludeExamples))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="copyNum" select="$copyNum"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="processReturnType">
		<xsl:param name="baseRef" select="''"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:choose>
			<xsl:when
				test="./apiOperationDetail/apiOperationDef/apiReturn/apiType/@value='' or ./apiOperationDetail/apiOperationDef/apiReturn/apiType/@value='*' or ./apiOperationDetail/apiOperationDef/apiReturn/apiType/@value='any'">
				<xsl:call-template name="getSpecialTypeLink">
					<xsl:with-param name="type" select="'*'"/>
					<xsl:with-param name="baseRef" select="$baseRef"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="./apiOperationDetail/apiOperationDef/apiReturn/apiType/@value='void'">
				<xsl:call-template name="getSpecialTypeLink">
					<xsl:with-param name="type" select="'void'"/>
					<xsl:with-param name="baseRef" select="$baseRef"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="./apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier='Void' and $config/options/@docversion='2'">
				<xsl:value-of select="./apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier"/>
			</xsl:when>
			<xsl:when test="./apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier">
				<xsl:variable name="destination" select="./apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier"/>
				<xsl:variable name="h1" select="substring-after($destination,':')"/>
				<xsl:variable name="h2" select="substring-before($destination,':')"/>
				<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
				<xsl:variable name="gfile" select="concat($baseRef,$destination,'.html')"/>
				<xsl:variable name="hyperLink">
					<xsl:if test="contains($destination,'.')">
						<xsl:if test="$prog_language_name!='javascript'">
							<xsl:value-of select="$file"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not(contains($destination,'.'))">
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>
							<xsl:otherwise>
								<xsl:value-of select="$gfile"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="$hyperLink = ''">
					<xsl:call-template name="getSimpleClassName">
						<xsl:with-param name="fullClassName" select="./apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$hyperLink != ''">
					<a href="{$hyperLink}">
						<xsl:call-template name="getSimpleClassName">
							<xsl:with-param name="fullClassName" select="./apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier"/>
						</xsl:call-template>
					</a>
				</xsl:if>
			</xsl:when>
			<xsl:when test="not(./apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier) and ./apiOperationDetail/apiOperationDef/apiReturn/apiType">
				<xsl:call-template name="getSimpleClassName">
					<xsl:with-param name="fullClassName" select="./apiOperationDetail/apiOperationDef/apiReturn/apiType/@value"/>
					<xsl:with-param name="baseRef" select="$baseRef"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="getSimpleClassName">
					<xsl:with-param name="fullClassName" select="./apiOperationDetail/apiOperationDef/apiReturn/apiOperationClassifier"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
