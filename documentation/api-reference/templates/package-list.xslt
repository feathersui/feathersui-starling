<?xml version="1.0" encoding="utf-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="asdoc-util.xslt"/>
	<xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" use-character-maps="disable"/>
	<xsl:param name="packages_map_name" select="'packagemap.xml'"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:template match="/">
		<xsl:copy-of select="$noLiveDocs"/>
		<xsl:copy-of select="$docType"/>
		<xsl:element name="html">
			<head>
				<title><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackageList']]/entry[2]/p"/> - <xsl:value-of select="$title-base"/></title>
				<base target="classFrame"/>
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<xsl:call-template name="getStyleLink">
					<xsl:with-param name="link" select="asdoc/link"/>
				</xsl:call-template>
				<script language="javascript" src="asdoc.js" type="text/javascript"/>
			</head>
			<body class="classFrameContent">
				<h3>
					<a href="package-summary.html" onclick="javascript:loadClassListFrame('all-classes.html');" style="color:black">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Packages']]/entry[2]/p"/>
					</a>
				</h3>
				<table cellpadding="0" cellspacing="0">
					<xsl:for-each select="apiMap//apiItemRef">
						<xsl:sort select="substring(@href, 0, string-length(@href)-4)" order="ascending" lang="en-US"/>
						<xsl:variable name="ditaFileName">
							<xsl:value-of select="concat($ditaFileDir,@href)"/>
						</xsl:variable>
						<xsl:if test="document($ditaFileName)/apiPackage[contains(apiName,'__Global__')]/apiClassifier">
							<tr>
								<td>
									<a href="package-detail.html" onclick="javascript:loadClassListFrame('class-list.html');">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
									</a>
								</td>
							</tr>
						</xsl:if>
						<xsl:for-each select="document($ditaFileName)/apiPackage[apiClassifier or apiOperation or apiValue]">
							<xsl:sort select="apiName" order="ascending" lang="en-US"/>
							<xsl:variable name="name" select="apiName"/>
							<xsl:variable name="isTopLevel">
								<xsl:call-template name="isTopLevel">
									<xsl:with-param name="packageName" select="$name"/>
								</xsl:call-template>
							</xsl:variable>
							<tr>
								<td>
									<xsl:if test="$isTopLevel='false'">
										<xsl:variable name="packagePath" select="translate($name,'.','/')"/>
										<a href="{$packagePath}/package-detail.html" onclick="javascript:loadClassListFrame('{$packagePath}/class-list.html');">
											<xsl:value-of select="$name"/>
										</a>
										<xsl:if test="position() != last()">
											<br/>
										</xsl:if>
									</xsl:if>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:for-each>
				</table>
				<xsl:if test="$config/languageElements[@show='true']">
					<h3>
						<a href="language-elements.html" style="color:black">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'LanguageElements']]/entry[2]/p"/>
						</a>
					</h3>
					<table cellpadding="0" cellspacing="0">
						<xsl:if test="$config/languageElements[@directives='true']">
							<tr>
								<td>
									<a href="directives.html">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'CompilerDirectives']]/entry[2]/p"/>
									</a>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="$config/languageElements[@constants='true']">
							<tr>
								<td>
									<xsl:if test="$config/options[@docversion='3']">
										<a href="package.html#constantSummary">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalConstants']]/entry[2]/p"/>
										</a>
									</xsl:if>
									<xsl:if test="not($config/options[@docversion='3'])">
										<a href="constants.html">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalConstants']]/entry[2]/p"/>
										</a>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="$config/languageElements[@functions='true']">
							<tr>
								<td>
									<xsl:if test="$config/options[@docversion='3']">
										<a href="package.html#methodSummary">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalFunctions']]/entry[2]/p"/>
										</a>
									</xsl:if>
									<xsl:if test="not($config/options[@docversion='3'])">
										<a href="global_functions.html">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalFunctions']]/entry[2]/p"/>
										</a>
									</xsl:if>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="$config/languageElements[@properties='true']">
							<tr>
								<td>
									<a href="global_props.html">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalProperties']]/entry[2]/p"/>
									</a>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="$config/languageElements[@operators='true']">
							<tr>
								<td>
									<a href="operators.html">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Operators']]/entry[2]/p"/>
									</a>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="$config/languageElements[@statements='true']">
							<tr>
								<td>
									<a href="statements.html">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'StatementsKeywordsDirectives']]/entry[2]/p"/>
									</a>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="$config/languageElements[@specialTypes='true']">
							<tr>
								<td>
									<a href="specialTypes.html">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SpecialTypes']]/entry[2]/p"/>
									</a>
								</td>
							</tr>
						</xsl:if>
						<xsl:for-each select="$config/languageElements/element">
							<tr>
								<td>
									<a href="{@href}" onclick="{@onclick}">
										<xsl:value-of select="@label"/>
									</a>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:if>
				<xsl:if test="$config/appendixes[@show='true']">
					<h3>
						<a href="appendixes.html" style="color:black">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Appendix']]/entry[2]/p"/>
						</a>
					</h3>
					<table cellpadding="0" cellspacing="0">
						<xsl:if test="$config/appendixes[@deprecated='true']">
							<tr>
								<td>
									<a href="deprecated.html">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Deprecated']]/entry[2]/p"/>
									</a>
								</td>
							</tr>
						</xsl:if>
						<xsl:for-each select="$config/appendixes/appendix">
							<tr>
								<td>
									<a href="{@href}" onclick="{@onclick}">
										<xsl:value-of select="$asdoc_terms/row[entry[1]/p = current()/@label]/entry[2]//p"/>
									</a>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:if>
			</body>
		</xsl:element>
		<xsl:copy-of select="$copyrightComment"/>
	</xsl:template>
</xsl:stylesheet>
