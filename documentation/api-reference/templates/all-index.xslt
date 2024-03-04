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
	<xsl:output encoding="UTF-8" method="html" omit-xml-declaration="yes" use-character-maps="disable"/>
	<xsl:param name="basedir" select="''"/>
	<xsl:param name="directivesFile" select="'directives.xml'"/>
	<xsl:param name="globalFuncFile" select="'global_functions.xml'"/>
	<xsl:param name="globalPropsFile" select="'global_props.xml'"/>
	<xsl:param name="constantsFile" select="'constants.xml'"/>
	<xsl:param name="operatorsFile" select="'operators.xml'"/>
	<xsl:param name="statementsFile" select="'statements.xml'"/>
	<xsl:param name="specialTypesFile" select="'specialTypes.xml'"/>
	<xsl:param name="unsupportedFile" select="'unsupported.xml'"/>
	<xsl:param name="fscommandFile" select="'fscommand.xml'"/>
	<xsl:param name="splitIndex" select="$config/options[@splitIndex='true']"/>
	<xsl:param name="outputPath" select="''"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:param name="ditaFile" select="'packages.dita'"/>
	<xsl:param name="packages_map_name" select="'packagemap.xml'"/>
	<xsl:param name="symbolsName" select="'Symbols'"/>
	<xsl:param name="packageOverviewFile" select="'overviews.xml'"/>
	<xsl:param name="prog_language_name" select="'ActionScript'"/>
	<xsl:variable name="directives">
		<xsl:if test="$config/languageElements[@show='true' and @directives='true']">
			<xsl:copy-of select="document(concat($basedir,$directivesFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="globalFuncs">
		<xsl:if test="$config/languageElements[@show='true' and @functions='true'] and $config/options[@docversion!='3']">
			<xsl:copy-of select="document(concat($basedir,$globalFuncFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="globalProps">
		<xsl:if test="$config/languageElements[@show='true' and @properties='true']">
			<xsl:copy-of select="document(concat($basedir,$globalPropsFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="constants">
		<xsl:if test="$config/languageElements[@show='true' and @constants='true'] and $config/options[@docversion!='3']">
			<xsl:copy-of select="document(concat($basedir,$constantsFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="operators">
		<xsl:if test="$config/languageElements[@show='true' and @operators='true']">
			<xsl:copy-of select="document(concat($basedir,$operatorsFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="statements">
		<xsl:if test="$config/languageElements[@show='true' and @statements='true']">
			<xsl:copy-of select="document(concat($basedir,$statementsFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="specialTypes">
		<xsl:if test="$config/languageElements[@show='true' and @specialTypes='true']">
			<xsl:copy-of select="document(concat($basedir,$specialTypesFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="unsupported">
		<xsl:if test="$config/index[@showUnsupported='true']">
			<xsl:copy-of select="document(concat($basedir,$unsupportedFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="fscommand">
		<xsl:if test="$config/index[@showFscommand='true']">
			<xsl:copy-of select="document(concat($basedir,$fscommandFile))/asdoc"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="matches"
		select="//*[((self::apiOperation or self::apiValue or self::apiConstructor or self::style or self::SkinPart or self::SkinState or self::effect) and not(ancestor::asAncestor)) or self::apiPackage or self::apiClassifier or (self::adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)] and (not(parent::apiOperation) and not(parent::apiConstructor) and not(parent::eventsDefined) and not(ancestor::asAncestor)))] | $directives/asdoc/object/methods/method | $globalFuncs/asdoc/object/methods/method | $globalProps/asdoc/object/fields/field | $constants/asdoc/object/fields/field | $operators/asdoc/operators/operator | $statements/asdoc/statements/statement | $specialTypes/asdoc/specialTypes/specialType | $unsupported/asdoc/unsupported//*[@name] | $fscommand/asdoc/fscommand | $config/index/entry"/>
	<xsl:variable name="symbols">
		<xsl:text disable-output-escaping="yes">+,:!?/.^~*=%|&amp;&lt;>()[]{}"</xsl:text>
	</xsl:variable>
	<xsl:variable name="letters">
		<xsl:if test="$config/languageElements[@show='true' and (@operators='true' or @specialTypes='true')]">
			<xsl:value-of select="$symbolsName"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:text>A B C D E F G H I J K L M N O P Q R S T U V W X Y Z</xsl:text>
	</xsl:variable>
	<xsl:variable name="letterSet" select="tokenize($letters,' ')"/>
	<xsl:template match="/">
		<xsl:if test="$splitIndex='false'">
			<xsl:apply-templates select="allClasses"/>
		</xsl:if>
		<xsl:if test="$splitIndex!='false'">
			<xsl:variable name="context" select="/"/>
			<xsl:for-each select="$letterSet">
				<xsl:variable name="fileName" select="concat('all-index-',.)"/>
				<xsl:result-document href="{concat($outputPath,$fileName,'.html')}">
					<xsl:apply-templates select="$context/allClasses">
						<xsl:with-param name="displayLetters" select="tokenize(.,' ')"/>
						<xsl:with-param name="fileName" select="$fileName"/>
						<xsl:with-param name="letter" select="."/>
					</xsl:apply-templates>
				</xsl:result-document>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="allClasses">
		<xsl:param name="displayLetters" select="$letterSet"/>
		<xsl:param name="fileName" select="'all-index'"/>
		<xsl:param name="letter"/>
		<xsl:variable name="localizedLetter">
			<xsl:choose>
				<xsl:when test="$letter = 'Symbols'">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Symbols']]/entry[2]/p"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$letter"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="localizedIndex">
			<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Index']]/entry[2]/p"/>
		</xsl:variable>
		<xsl:copy-of select="$noLiveDocs"/>
		<xsl:copy-of select="$docType"/>
		<xsl:if test="$config/options[@livedocs='true']">
			<xsl:comment>#config errmsg=""</xsl:comment>
		</xsl:if>
		<xsl:element name="html">
			<head>
				<title>
					<xsl:if test="$splitIndex and $letter">
						<xsl:value-of select="$localizedLetter"/>
					</xsl:if>
					<xsl:if test="not($splitIndex)">
						<xsl:value-of select="$config/title"/>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="localizedIndex"/>
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
					<xsl:with-param name="title">
						<xsl:if test="$splitIndex">
							<xsl:value-of select="concat($letter,' ',$localizedIndex,' - ',$title-base)"/>
						</xsl:if>
						<xsl:if test="not($splitIndex)">
							<xsl:value-of select="concat('All Index - ',$title-base)"/>
						</xsl:if>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="getLinks2">
					<xsl:with-param name="subTitle">
						<xsl:if test="$splitIndex">
							<xsl:if test="$letter!='Symbols'">
								<xsl:value-of select="concat($localizedLetter,$nbsp,$localizedIndex)"/>
							</xsl:if>
							<xsl:if test="$letter='Symbols'">
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SymbolsIndex']]/entry[2]/p"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not($splitIndex)">
							<xsl:value-of select="concat('All',$nbsp,'Index')"/>
						</xsl:if>
					</xsl:with-param>
					<xsl:with-param name="fileName" select="$fileName"/>
					<xsl:with-param name="fileName2" select="'index-list.html'"/>
					<xsl:with-param name="showProperties" select="false()"/>
					<xsl:with-param name="showMethods" select="false()"/>
					<xsl:with-param name="showIndex" select="false()"/>
				</xsl:call-template>
				<div class="MainContent">
					<br/>
					<table class="allIndexTable" border="0" cellspacing="0" cellpadding="0">
						<xsl:for-each select="$displayLetters">
							<tr>
								<td colspan="2">
									<a name="{.}"/>
									<xsl:variable name="currLetter" select="."/>
									<xsl:for-each select="$letterSet">
										<xsl:if test="$currLetter=.">
											<xsl:if test="$currLetter=$symbolsName">
												<font color="black" size="6px" style="bold">
													<xsl:call-template name="getLocalizedString">
														<xsl:with-param name="key" select="."/>
													</xsl:call-template>
												</font>
											</xsl:if>
											<xsl:if test="$currLetter!=$symbolsName">
												<font color="black" size="10px" style="bold">
													<xsl:call-template name="getLocalizedString">
														<xsl:with-param name="key" select="."/>
													</xsl:call-template>
												</font>
											</xsl:if>
										</xsl:if>
										<xsl:if test="$currLetter!=.">
											<xsl:if test="$splitIndex='false'">
												<xsl:choose>
													<xsl:when test="$prog_language_name='javascript'"/>
													<xsl:otherwise>
														<a href="#{.}" onclick="javascript:loadClassListFrame('index-list.html');">
															<xsl:call-template name="getLocalizedString">
																<xsl:with-param name="key" select="."/>
															</xsl:call-template>
														</a>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
											<xsl:if test="$splitIndex!='false'">
												<xsl:choose>
													<xsl:when test="$prog_language_name='javascript'"/>
													<xsl:otherwise>
														<a href="all-index-{.}.html" onclick="javascript:loadClassListFrame('index-list.html');">
															<xsl:call-template name="getLocalizedString">
																<xsl:with-param name="key" select="."/>
															</xsl:call-template>
														</a>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:if>
										<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp; ]]></xsl:text>
									</xsl:for-each>
								</td>
							</tr>
							<xsl:variable name="firstUpper" select="."/>
							<xsl:variable name="checkingSymbol" select=".=$symbolsName and $config/languageElements[@show='true' and (@operators='true' or @specialTypes='true')]"/>
							<xsl:variable name="firstLower" select="translate($firstUpper,$upperCase,$lowerCase)"/>
							<xsl:for-each select="$matches">
								<xsl:sort select="concat(translate(self::apiPackage[apiName='__Global__']/apiName,'Global__','Top Le'),translate(@symbol,$symbols,''),translate(./apiName | @name,'#_.( ',''))"
									data-type="text" lang="en-US"/>
								<xsl:sort select="../../apiName | @name"/>
								<xsl:sort select="../apiName | @name"/>
								<xsl:variable name="isSymbol" select="string-length(./@symbol) > 0 and not(contains($letters,translate(substring(./@symbol,1,1),$lowerCase,$upperCase)))"/>
								<xsl:variable name="isSpecialSymbol" select="self::specialType and not(contains($letters,translate(substring(@name,1,1),$lowerCase,$upperCase)))"/>
								<xsl:variable name="isRestParam" select="starts-with(@name,'...')"/>
								<xsl:variable name="sortableName">
									<xsl:choose>
										<!-- special case for -Infinity -->
										<xsl:when test="./apiName='-Infinity'">
											<xsl:value-of select="substring(./apiName,2)"/>
										</xsl:when>
										<xsl:when test="./apiName='__Global__'">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$isSymbol">
												<xsl:value-of select="@symbol"/>
											</xsl:if>
											<xsl:if test="not($isSymbol)">
												<xsl:if test="string-length(@symbol) > 0">
													<xsl:value-of select="@symbol"/>
												</xsl:if>
												<xsl:if test="not(string-length(@symbol) > 0)">
													<xsl:value-of select="translate(./apiName,'#_.( ','')"/>
												</xsl:if>
												<xsl:if test="local-name(.) ='style' or local-name(.) ='SkinPart' or local-name(.) ='SkinState' or local-name(.) ='effect' or local-name(.) ='statement' or local-name(.) ='specialType' or local-name(.) ='operator'">
													<xsl:value-of select="./@name"/>
												</xsl:if>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="symbolMatch" select="$checkingSymbol and ($isSymbol or $isSpecialSymbol or $isRestParam)"/>
								<xsl:if test="$symbolMatch or starts-with($sortableName,$firstLower) or starts-with($sortableName,$firstUpper)">
									<tr>
										<td class="idxrow" colspan="2">
											<xsl:choose>
												<!-- unsupported must come first, otherwise they show up in their original sections -->
												<xsl:when test="ancestor::unsupported">
													<a href="unsupported.html">
														<xsl:value-of select="@name"/>
														<xsl:if test="self::method">
															<xsl:text>()</xsl:text>
														</xsl:if>
													</a>
													<xsl:value-of select="$emdash"/>
													<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Unsupported']]/entry[2]/p"/>
													<xsl:text> </xsl:text>
													<xsl:choose>
														<xsl:when test="self::globalFunction">
															<a href="global_functions.html">
																<xsl:value-of select="../@label"/>
															</a>
														</xsl:when>
														<xsl:when test="self::fscommand">
															<a href="global_functions.html#fscommand()">
																<xsl:value-of select="../@label"/>
															</a>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="self::eventHandler and not(string-length(@class))">
																<xsl:text> global </xsl:text>
															</xsl:if>
															<xsl:value-of select="parent::node()/@label"/>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="string-length(@package)">
														<xsl:text>, </xsl:text>
														<xsl:if test="string-length(@class)">
															<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
															<xsl:text> </xsl:text>
															<a href="">
																<xsl:value-of select="@package"/>
															</a>
														</xsl:if>
														<xsl:if test="not(string-length(@class))">
															<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Package']]/entry[2]/p"/>
															<xsl:text> </xsl:text>
															<a href="{concat(translate(@package,'.','/'),'/package-detail.html')}">
																<xsl:value-of select="@package"/>
															</a>
														</xsl:if>
													</xsl:if>
													<xsl:if test="not(string-length(@package))">
														<xsl:choose>
															<xsl:when test="self::class">
																<xsl:text>, </xsl:text>
																<a href="package-detail.html" onclick="javascript:loadClassListFrame('class-list.html');">
																	<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
																</a>
															</xsl:when>
															<xsl:otherwise>
																<xsl:if test="string-length(@class)">
																	<xsl:text>, </xsl:text>
																	<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
																	<xsl:text> </xsl:text>
																	<a href="{@class}.html" onclick="javascript:loadClassListFrame('class-list.html');">
																		<xsl:value-of select="@class"/>
																	</a>
																</xsl:if>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</xsl:when>
												<xsl:when test="self::fscommand">
													<a href="{concat('fscommand/',@name,'.html')}" onclick="javascript:loadClassListFrame('fscommand-list.html');">
														<xsl:value-of select="@name"/>
													</a>
													<xsl:value-of select="$emdash"/>
													<xsl:text>Command for </xsl:text>
													<a href="global_functions.html#fscommand2()">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'fscommand2']]/entry[2]/p"/>
													</a>
													<xsl:text> </xsl:text>
													<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalFunction']]/entry[2]/p"/>
												</xsl:when>
												<xsl:when test="(self::apiOperation and (not(@type) or (@type!='handler'))) or self::apiConstructor">
													<xsl:variable name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
													<xsl:variable name="isTopLevel">
														<xsl:call-template name="isTopLevel">
															<xsl:with-param name="packageName" select="$packageName"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="classPath">
														<!-- AS2 lang elements -->
														<xsl:if test="$isTopLevel='true' or ../../@type='list'">
															<xsl:text>.</xsl:text>
														</xsl:if>
														<xsl:if test="$isTopLevel='false'">
															<xsl:value-of select="translate($packageName,'.','/')"/>
														</xsl:if>
													</xsl:variable>
													<xsl:choose>
														<!-- AS2 lang elements -->
														<xsl:when test="../../@type='list'">
															<a href="{../../@href}#{@name}()">
																<xsl:value-of select="@name"/>
															</a>
														</xsl:when>
														<xsl:when test="ancestor::apiClassifier">
															<a href="{$classPath}/{../apiName}.html#{apiName}()" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
																<xsl:value-of select="apiName"/>
															</a>
														</xsl:when>
														<xsl:otherwise>
															<a href="{$classPath}/package.html#{apiName}()" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
																<xsl:value-of select="apiName"/>
															</a>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="not(@type) or @type!='directive'">
														<xsl:variable name="params">
															<xsl:call-template name="getParamList">
																<xsl:with-param name="params" select=".//apiParam"/>
															</xsl:call-template>
														</xsl:variable>
														<xsl:text>(</xsl:text>
														<xsl:copy-of select="$params"/>
														<xsl:text>)</xsl:text>
													</xsl:if>
													<xsl:value-of select="$emdash"/>
													<xsl:if test="self::apiOperation">
														<xsl:call-template name="getMethodDesc">
															<xsl:with-param name="classPath" select="$classPath"/>
														</xsl:call-template>
													</xsl:if>
													<xsl:if test="self::apiConstructor">
														<xsl:call-template name="getConstructorDesc">
															<xsl:with-param name="classPath" select="$classPath"/>
														</xsl:call-template>
													</xsl:if>
												</xsl:when>
												<xsl:when test="self::apiValue">
													<xsl:variable name="isTopLevel">
														<xsl:call-template name="isTopLevel">
															<xsl:with-param name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="classPath">
														<!-- AS2 lang elements -->
														<xsl:if test="$isTopLevel='true' or ../../@type='list'">
															<xsl:text>.</xsl:text>
														</xsl:if>
														<xsl:if test="$isTopLevel='false'">
															<xsl:if test="ancestor::apiClassifier">
																<xsl:value-of select="translate(ancestor-or-self::apiPackage/apiName,'.','/')"/>
															</xsl:if>
															<xsl:if test="not(ancestor::apiClassifier)">
																<xsl:value-of select="translate(ancestor-or-self::apiPackage/apiName,'.','/')"/>
															</xsl:if>
														</xsl:if>
													</xsl:variable>
													<xsl:choose>
														<!-- AS2 lang elements -->
														<xsl:when test="../../@type='list'">
															<a href="{../../@href}#{apiName}">
																<xsl:value-of select="apiName"/>
															</a>
														</xsl:when>
														<xsl:when test="ancestor::apiClassifier">
															<a href="{$classPath}/{ancestor::apiClassifier/apiName}.html#{apiName}" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
																<xsl:value-of select="apiName"/>
															</a>
														</xsl:when>
														<xsl:otherwise>
															<a href="{$classPath}/package.html#{apiName}" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
																<xsl:value-of select="apiName"/>
															</a>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:value-of select="$emdash"/>
													<xsl:call-template name="getPropertyDesc">
														<xsl:with-param name="classPath" select="$classPath"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="self::style or self::SkinPart or self::SkinState or self::effect">
													<xsl:variable name="isTopLevel">
														<xsl:call-template name="isTopLevel">
															<xsl:with-param name="packageName" select="ancestor::apiPackage/apiName"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="classPath">
														<!-- AS2 lang elements -->
														<xsl:if test="$isTopLevel='true' or ../../@type='list'">
															<xsl:text>.</xsl:text>
														</xsl:if>
														<xsl:if test="$isTopLevel='false'">
															<xsl:value-of select="translate(ancestor-or-self::apiPackage/apiName,'.','/')"/>
														</xsl:if>
													</xsl:variable>
													<xsl:if test="self::style">
														<a href="{$classPath}/{ancestor::apiClassifier/apiName}.html#style:{@name}" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
															<xsl:value-of select="@name"/>
														</a>
														<xsl:value-of select="$emdash"/>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Style']]/entry[2]/p"/>
														<xsl:text>, </xsl:text>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
														<xsl:text> </xsl:text>
														<xsl:call-template name="getClassRef">
															<xsl:with-param name="classPath" select="$classPath"/>
														</xsl:call-template>
														<tr>
															<td width="20"/>
															<td>
																<xsl:variable name="styleText">
																	<xsl:if test="./description/@conref">
																		<xsl:call-template name="getConRefText">
																			<xsl:with-param name="conref" select="./description/@conref"/>
																			<xsl:with-param name="descriptionType" select="local-name(./description)"/>
																			<xsl:with-param name="entryType" select="'style'"/>
																		</xsl:call-template>
																	</xsl:if>
																	<xsl:if test="not(./description/@conref)">
																		<xsl:value-of select="normalize-space(./description)"/>
																	</xsl:if>
																</xsl:variable>
																<xsl:if test="string-length($styleText) &gt; 0">
																	<xsl:variable name="styleTextShortDesc">
																		<xsl:call-template name="getFirstSentence">
																			<xsl:with-param name="inText" select="$styleText"/>
																		</xsl:call-template>
																	</xsl:variable>
																	<xsl:value-of disable-output-escaping="yes" select="$styleTextShortDesc"/>
																</xsl:if>
															</td>
														</tr>
													</xsl:if>
													
				
													<xsl:if test="self::SkinPart">
														<xsl:variable name="pkg" select="translate($classPath,'/','.')"/>
														<xsl:variable name="class" select="ancestor::apiClassifier/apiName"/>
														<a href="{$classPath}/{ancestor::apiClassifier/apiName}.html#skinpart:{@name}" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
															<xsl:value-of select="@name"/>
														</a>
														<xsl:value-of select="$emdash"/>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinPart']]/entry[2]/p"/>
														<xsl:text>, </xsl:text>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
														<xsl:text> </xsl:text>
														<xsl:call-template name="getClassRef">
															<xsl:with-param name="classPath" select="$classPath"/>
														</xsl:call-template>
														<tr>
															<td width="20"/>
															<td>
																<xsl:value-of select="normalize-space(./description)"/>
															</td>
														</tr>
													</xsl:if>
													
													<xsl:if test="self::SkinState">
														<xsl:variable name="pkg" select="translate($classPath,'/','.')"/>
														<xsl:variable name="class" select="ancestor::apiClassifier/apiName"/>
														<a href="{$classPath}/{ancestor::apiClassifier/apiName}.html#skinstate:{@name}" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
															<xsl:value-of select="@name"/>Skin
														</a>
														<xsl:value-of select="$emdash"/>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinState']]/entry[2]/p"/>
														<xsl:text>, </xsl:text>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
														<xsl:text> </xsl:text>
														<xsl:call-template name="getClassRef">
															<xsl:with-param name="classPath" select="$classPath"/>
														</xsl:call-template>
														<tr>
															<td width="20"/>
															<td>
																<xsl:value-of select="normalize-space(./description)"/>
															</td>
														</tr>
													</xsl:if>
																										
													<xsl:if test="self::effect">
														<a href="{$classPath}/{ancestor::apiClassifier/apiName}.html#effect:{@name}" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
															<xsl:value-of select="@name"/>
														</a>
														<xsl:value-of select="$emdash"/>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Effect']]/entry[2]/p"/>
														<xsl:text>, </xsl:text>
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
														<xsl:text> </xsl:text>
														<xsl:call-template name="getClassRef">
															<xsl:with-param name="classPath" select="$classPath"/>
														</xsl:call-template>
													</xsl:if>
												</xsl:when>
												<xsl:when test="self::apiPackage">
													<xsl:variable name="isTopLevel">
														<xsl:call-template name="isTopLevel">
															<xsl:with-param name="packageName" select="./apiName"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="packagePath">
														<xsl:if test="$isTopLevel='true'">
															<xsl:text>.</xsl:text>
														</xsl:if>
														<xsl:if test="$isTopLevel='false'">
															<xsl:value-of select="translate(./apiName,'.','/')"/>
														</xsl:if>
													</xsl:variable>
													<a href="{$packagePath}/package-detail.html" onclick="javascript:loadClassListFrame('{$packagePath}/class-list.html');">
														<xsl:if test="$isTopLevel='true'">
															<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
														</xsl:if>
														<xsl:if test="$isTopLevel='false'">
															<xsl:value-of select="./apiName"/>
														</xsl:if>
													</a>
													<xsl:value-of select="$emdash"/>
													<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Package']]/entry[2]/p"/>
												</xsl:when>
												<xsl:when test="self::apiClassifier">
													<xsl:variable name="name" select="./apiName"/>
													<xsl:variable name="packageName">
														<xsl:if test="../apiName != '__Global__'">
															<xsl:value-of select="../apiName"/>
														</xsl:if>
													</xsl:variable>
													<xsl:variable name="isTopLevel">
														<xsl:call-template name="isTopLevel">
															<xsl:with-param name="packageName" select="$packageName"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="classPath">
														<xsl:if test="$isTopLevel='true'">
															<xsl:text>.</xsl:text>
														</xsl:if>
														<xsl:if test="$isTopLevel='false'">
															<xsl:value-of select="translate($packageName,'.','/')"/>
														</xsl:if>
													</xsl:variable>
													<a href="{$classPath}/{$name}.html" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
														<xsl:if test="./apiClassifierDetail/apiClassifierDef[apiInterface]">
															<i>
																<xsl:value-of select="$name"/>
															</i>
														</xsl:if>
														<xsl:if test="./apiClassifierDetail/apiClassifierDef[not(apiInterface)]">
															<xsl:value-of select="$name"/>
														</xsl:if>
													</a>
													<xsl:value-of select="$emdash"/>
													<xsl:call-template name="getClassDesc">
														<xsl:with-param name="packageName" select="$packageName"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="self::adobeApiEvent or (self::apiOperation and @type='handler')">
													<xsl:variable name="isTopLevel">
														<xsl:call-template name="isTopLevel">
															<xsl:with-param name="packageName" select="ancestor::apiPackage/apiName"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="classPath">
														<!-- AS2 lang elements -->
														<xsl:if test="$isTopLevel='true' or ../../@type='list'">
															<xsl:text>.</xsl:text>
														</xsl:if>
														<xsl:if test="$isTopLevel='false'">
															<xsl:if test="ancestor::apiClassifier">
																<xsl:value-of select="translate(../../apiName,'.','/')"/>
															</xsl:if>
															<xsl:if test="not(ancestor::apiClassifier)">
																<xsl:value-of select="translate(../apiName,'.','/')"/>
															</xsl:if>
														</xsl:if>
													</xsl:variable>
													<xsl:choose>
														<!-- AS2 lang elements -->
														<xsl:when test="../../@type='list'">
															<a href="{../../@href}#event:{./apiName}">
																<xsl:value-of select="./apiName"/>
															</a>
														</xsl:when>
														<xsl:when test="ancestor::apiClassifier">
															<a href="{$classPath}/{../apiName}.html#event:{./apiName}" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
																<xsl:value-of select="./apiName"/>
															</a>
														</xsl:when>
														<xsl:otherwise>
															<a href="{$classPath}/package-detail.html#event:{./apiName}" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
																<xsl:value-of select="./apiName"/>
															</a>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="@type='handler'">
														<xsl:variable name="params">
															<xsl:call-template name="getParamList">
																<xsl:with-param name="params" select="params"/>
															</xsl:call-template>
														</xsl:variable>
														<xsl:text>(</xsl:text>
														<xsl:copy-of select="$params"/>
														<xsl:text>)</xsl:text>
													</xsl:if>
													<xsl:value-of select="$emdash"/>
													<xsl:call-template name="getEventDesc">
														<xsl:with-param name="classPath" select="$classPath"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="self::operator or self::statement">
													<xsl:variable name="suffix">
														<xsl:if test="self::operator and deprecated">
															<xsl:value-of select="'_deprecated'"/>
														</xsl:if>
														<xsl:if test="self::statment or not(deprecated)">
															<xsl:value-of select="''"/>
														</xsl:if>
													</xsl:variable>
													<xsl:variable name="href">
														<xsl:if test="$config/options/@docversion='2'">
															<xsl:value-of select="../@href"/>
														</xsl:if>
														<xsl:if test="not($config/options/@docversion='2')">
															<xsl:value-of select="local-name()"/>
															<xsl:text>s.html</xsl:text>
														</xsl:if>
													</xsl:variable>
													<a href="{$href}#{concat(translate(@name,' ','_'),$suffix)}">
														<xsl:if test="string-length(@symbol)">
															<xsl:value-of select="@symbol"/>
															<xsl:text> (</xsl:text>
														</xsl:if>
														<xsl:value-of select="@name"/>
														<xsl:if test="string-length(@symbol)">
															<xsl:text>)</xsl:text>
														</xsl:if>
													</a>
													<xsl:value-of select="$emdash"/>
													<xsl:if test="self::operator">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Operator']]/entry[2]/p"/>
													</xsl:if>
													<xsl:if test="self::statement">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Statement']]/entry[2]/p"/>
													</xsl:if>
												</xsl:when>
												<xsl:when test="self::specialType">
													<a href="specialTypes.html#{@name}">
														<xsl:value-of select="@name"/>
													</a>
													<xsl:value-of select="$emdash"/>
													<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SpecialType']]/entry[2]/p"/>
												</xsl:when>
												<xsl:when test="self::entry">
													<a href="{@href}" onclick="loadClassListFrame('mxml-tags.html');">
														<xsl:value-of select="@name"/>
													</a>
													<xsl:value-of select="$emdash"/>
													<a href="mxml-tag-detail.html" onclick="loadClassListFrame('mxml-tags.html');">
														<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'MXMLOnly']]/entry[2]/p"/>
													</a>
													<xsl:choose>
														<xsl:when test="(self::statement or self::specialType)">
															<xsl:variable name="desc">
																<xsl:value-of disable-output-escaping="yes" select="./shortDescription"/>
															</xsl:variable>
															<xsl:call-template name="deTilda">
																<xsl:with-param name="inText" select="$desc"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:otherwise>
															<xsl:variable name="desc">
																<xsl:if test="string-length(./shortdesc) &gt; 0 and not(string-length(./shortdesc/@conref) &gt; 0)">
																	<xsl:value-of disable-output-escaping="yes" select="./shortdesc"/>
																</xsl:if>
																<xsl:if test="not(string-length(./shortdesc) &gt; 0) and (string-length(./shortdesc/@conref) &gt; 0)">
																	<xsl:choose>
																		<xsl:when test="ancestor-or-self::apiOperation">
																			<xsl:call-template name="getConRefText">
																				<xsl:with-param name="conref" select="./shortdesc/@conref"/>
																				<xsl:with-param name="descriptionType" select="'shortdesc'"/>
																				<xsl:with-param name="entryType" select="'method'"/>
																				<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
																			</xsl:call-template>
																		</xsl:when>
																		<xsl:when test="ancestor-or-self::apiValue">
																			<xsl:call-template name="getConRefText">
																				<xsl:with-param name="conref" select="./shortdesc/@conref"/>
																				<xsl:with-param name="descriptionType" select="'shortdesc'"/>
																				<xsl:with-param name="entryType" select="'property'"/>
																				<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
																			</xsl:call-template>
																		</xsl:when>
																		<xsl:when test="ancestor-or-self::adobeApiEvent">
																			<xsl:call-template name="getConRefText">
																				<xsl:with-param name="conref" select="./shortdesc/@conref"/>
																				<xsl:with-param name="descriptionType" select="'shortdesc'"/>
																				<xsl:with-param name="entryType" select="'event'"/>
																				<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
																			</xsl:call-template>
																		</xsl:when>
																	</xsl:choose>
																</xsl:if>
															</xsl:variable>
															<xsl:call-template name="deTilda">
																<xsl:with-param name="inText" select="$desc"/>
															</xsl:call-template>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
											</xsl:choose>
										</td>
									</tr>
									<tr>
										<td width="20"/>
										<td>
											<xsl:choose>
												<xsl:when test="deprecated">
													<xsl:apply-templates select="deprecated"/>
												</xsl:when>
												<xsl:when test="(self::apiValue or self::apiOperation or self::apiConstructor or self::adobeApiEvent) and ../../deprecated">
													<xsl:copy-of select="$deprecatedLabel"/>
													<em>
														<xsl:variable name="deprecated" select="$asdoc_terms/row[entry[1][p/text() = 'DeprecatedAsOf']]/entry[2]/p"/>
														<xsl:apply-templates select="$deprecated" mode="terms">
															<xsl:with-param name="class" select="../../@name"/>
															<xsl:with-param name="as-of" select="../../deprecated/@as-of"/>
														</xsl:apply-templates>
													</em>
												</xsl:when>
												<xsl:when test="self::entry">
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="node()"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="self::effect">
													<xsl:call-template name="deTilda">
														<xsl:with-param name="inText" select="./description"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="self::apiPackage">
													<xsl:call-template name="getPackageComment">
														<xsl:with-param name="packageName" select="./apiName"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<!-- AS2 lang elements -->
													<xsl:choose>
														<xsl:when test="(self::operator or self::statement or self::specialType)">
															<xsl:if test="string-length(shortDescription/.) or string-length(short-description)">
																<xsl:call-template name="deTilda">
																	<xsl:with-param name="inText" select="shortDescription/. | short-description/."/>
																</xsl:call-template>
															</xsl:if>
														</xsl:when>
														<xsl:otherwise>
															<xsl:variable name="desc">
																<xsl:if test="string-length(normalize-space(./shortdesc)) &gt; 0 and not(string-length(normalize-space(./shortdesc/@conref)) &gt; 0)">
																	<xsl:call-template name="deTilda">
																		<xsl:with-param name="inText" select="./shortdesc"/>
																	</xsl:call-template>
																</xsl:if>
																<xsl:if test="not(string-length(normalize-space(./shortdesc)) &gt; 0) and (string-length(normalize-space(./shortdesc/@conref)) &gt; 0)">
																	<xsl:choose>
																		<xsl:when test="ancestor-or-self::apiOperation">
																			<xsl:call-template name="getConRefText">
																				<xsl:with-param name="conref" select="./shortdesc/@conref"/>
																				<xsl:with-param name="descriptionType" select="'shortdesc'"/>
																				<xsl:with-param name="entryType" select="'method'"/>
																				<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
																			</xsl:call-template>
																		</xsl:when>
																		<xsl:when test="ancestor-or-self::apiValue">
																			<xsl:call-template name="getConRefText">
																				<xsl:with-param name="conref" select="./shortdesc/@conref"/>
																				<xsl:with-param name="descriptionType" select="'shortdesc'"/>
																				<xsl:with-param name="entryType" select="'property'"/>
																				<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
																			</xsl:call-template>
																		</xsl:when>
																		<xsl:when test="ancestor-or-self::adobeApiEvent">
																			<xsl:call-template name="getConRefText">
																				<xsl:with-param name="conref" select="./shortdesc/@conref"/>
																				<xsl:with-param name="descriptionType" select="'shortdesc'"/>
																				<xsl:with-param name="entryType" select="'event'"/>
																				<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
																			</xsl:call-template>
																		</xsl:when>
																	</xsl:choose>
																</xsl:if>
																<xsl:if test="not(string-length(normalize-space(./shortdesc)) &gt; 0) and (string-length(normalize-space(./shortdesc/@conref)) = 0)">
																	<xsl:choose>
																		<xsl:when test="ancestor-or-self::apiOperation">
																			<xsl:if test="ancestor-or-self::apiOperation/apiOperationDetail/apiOperationDef/apiInheritDoc">
																				<xsl:if
																					test="ancestor-or-self::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier or ancestor-or-self::apiClassifier/apiClassifierDetail/apiBaseInterface ">
																					<xsl:call-template name="getInheritDocText">
																						<xsl:with-param name="baseClass" select="ancestor-or-self::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
																						<xsl:with-param name="descriptionType" select="'shortdesc'"/>
																						<xsl:with-param name="entryType" select="'apiOperation'"/>
																						<xsl:with-param name="nameToMatch" select="ancestor-or-self::apiOperation/apiName"/>
																					</xsl:call-template>
																				</xsl:if>
																			</xsl:if>
																		</xsl:when>
																		<xsl:when test="ancestor-or-self::apiValue">
																			<xsl:if test="ancestor-or-self::apiValue/apiValueDetail/apiValueDef/apiInheritDoc">
																				<xsl:if
																					test="ancestor-or-self::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier or ancestor-or-self::apiClassifier/apiClassifierDetail/apiBaseInterface ">
																					<xsl:call-template name="getInheritDocText">
																						<xsl:with-param name="baseClass" select="ancestor-or-self::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
																						<xsl:with-param name="descriptionType" select="'shortdesc'"/>
																						<xsl:with-param name="entryType" select="'apiValue'"/>
																						<xsl:with-param name="nameToMatch" select="ancestor-or-self::apiValue/apiName"/>
																					</xsl:call-template>
																				</xsl:if>
																			</xsl:if>
																		</xsl:when>
																	</xsl:choose>
																</xsl:if>
															</xsl:variable>
															<xsl:variable name="text">
																<xsl:call-template name="search-and-replace">
																	<xsl:with-param name="search-string" select="'~~'"/>
																	<xsl:with-param name="replace-string" select="'*'"/>
																	<xsl:with-param name="input" select="$desc"/>
																</xsl:call-template>
															</xsl:variable>
															<xsl:value-of select="$text"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
							<tr>
								<td colspan="2" style="padding-bottom:20px"/>
							</tr>
							<xsl:if test="$splitIndex!='false'">
								<tr>
									<td colspan="2">
										<xsl:variable name="currLetter" select="."/>
										<xsl:for-each select="$letterSet">
											<xsl:if test="$currLetter=.">
												<xsl:if test="$currLetter=$symbolsName">
													<font color="black" size="6px" style="bold">
														<xsl:call-template name="getLocalizedString">
															<xsl:with-param name="key" select="."/>
														</xsl:call-template>
													</font>
												</xsl:if>
												<xsl:if test="$currLetter!=$symbolsName">
													<font color="black" size="10px" style="bold">
														<xsl:call-template name="getLocalizedString">
															<xsl:with-param name="key" select="."/>
														</xsl:call-template>
													</font>
												</xsl:if>
											</xsl:if>
											<xsl:if test="$currLetter!=.">
												<xsl:if test="$splitIndex='false'">
													<xsl:choose>
														<xsl:when test="$prog_language_name='javascript'"/>
														<xsl:otherwise>
															<a href="#{.}" onclick="javascript:loadClassListFrame('index-list.html');">
																<xsl:call-template name="getLocalizedString">
																	<xsl:with-param name="key" select="."/>
																</xsl:call-template>
															</a>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
												<xsl:if test="$splitIndex!='false'">
													<xsl:choose>
														<xsl:when test="$prog_language_name='javascript'"/>
														<xsl:otherwise>
															<a href="all-index-{.}.html" onclick="javascript:loadClassListFrame('index-list.html');">
																<xsl:call-template name="getLocalizedString">
																	<xsl:with-param name="key" select="."/>
																</xsl:call-template>
															</a>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:if>
											<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp; ]]></xsl:text>
										</xsl:for-each>
									</td>
								</tr>
							</xsl:if>
						</xsl:for-each>
					</table>
					<p/>
					<xsl:call-template name="getFeedbackLink">
						<xsl:with-param name="topic">
							<xsl:if test="$splitIndex">
								<xsl:value-of select="concat($letter,' Index')"/>
							</xsl:if>
							<xsl:if test="not($splitIndex)">
								<xsl:value-of select="'Index'"/>
							</xsl:if>
						</xsl:with-param>
						<xsl:with-param name="filename" select="$fileName"/>
						<xsl:with-param name="filename2" select="'index-list.html'"/>
					</xsl:call-template>
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
	<xsl:template name="getClassRef">
		<xsl:param name="classPath"/>
		<xsl:choose>
			<xsl:when test="string-length($classPath) > 1">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<xsl:value-of select="ancestor::apiPackage/apiName"/>
						<xsl:text>.</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<a href="{$classPath}/{ancestor::apiClassifier/apiName}.html" onclick="javascript:loadClassListFrame('{$classPath}/class-list.html');">
					<xsl:value-of select="ancestor::apiClassifier/apiName"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{ancestor::apiClassifier/apiName}.html" onclick="javascript:loadClassListFrame('class-list.html');">
					<xsl:value-of select="ancestor::apiClassifier/apiName"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getMethodDesc">
		<xsl:param name="classPath"/>
		<!-- AS2 lang elements -->
		<xsl:if test="parent::apiClassifier">
			<!-- TODO handle more variations (override,final?) -->
			<xsl:if test="apiOperationDetail/apiOperationDef/apiStatic">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'StaticMethodIn']]/entry[2]/p"/>
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:if test="not(apiOperationDetail/apiOperationDef/apiStatic)">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Method']]/entry[2]/p"/>
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:if test="../apiClassifierDetail/apiClassifierDef/apiInterface">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'InterfaceIn']]/entry[2]/p"/>
			</xsl:if>
			<xsl:if test="not(../apiClassifierDetail/apiClassifierDef/apiInterface)">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:call-template name="getClassRef">
				<xsl:with-param name="classPath" select="$classPath"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="parent::apiPackage">
			<xsl:if test="apiOperationDetail/apiOperationDef/apiStatic">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackageStaticFunctionIn']]/entry[2]/p"/>
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:if test="not(apiOperationDetail/apiOperationDef/apiStatic)">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackageFunctionIn']]/entry[2]/p"/>
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="ancestor::apiPackage/apiName"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$isTopLevel='false'">
				<a href="{$classPath}/package.html" onclick="loadClassListFrame('{$classPath}/class-list.html')">
					<xsl:value-of select="ancestor::apiPackage/apiName"/>
				</a>
			</xsl:if>
			<xsl:if test="$isTopLevel!='false'">
				<a href="package.html" onclick="loadClassListFrame('class-list.html')">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
				</a>
			</xsl:if>
		</xsl:if>
		<!-- AS2 lang elements -->
		<xsl:if test="../../@type='list'">
			<xsl:if test="@type='directive'">
				<xsl:text>Compiler Directive</xsl:text>
			</xsl:if>
			<xsl:if test="@type!='directive'">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalFunction']]/entry[2]/p"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getConstructorDesc">
		<xsl:param name="classPath"/>
		<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constructor']]/entry[2]/p"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
		<xsl:text> </xsl:text>
		<xsl:call-template name="getClassRef">
			<xsl:with-param name="classPath" select="$classPath"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="getPropertyDesc">
		<xsl:param name="classPath"/>
		<!-- AS2 lang elements -->
		<xsl:if test="parent::apiClassifier">
			<xsl:if test="$prog_language_name='ActionScript'">
				<xsl:if test="apiValueDetail/apiValueDef/apiStatic">
					<xsl:if test="not(apiValueDetail/apiValueDef/apiProperty)">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ConstantStaticPropertyIn']]/entry[2]/p"/>
						<xsl:text>,</xsl:text>
					</xsl:if>
					<xsl:if test="apiValueDetail/apiValueDef/apiProperty">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'StaticPropertyIn']]/entry[2]/p"/>
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not(apiValueDetail/apiValueDef/apiStatic)">
					<xsl:if test="not(apiValueDetail/apiValueDef/apiProperty)">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ConstantPropertyIn']]/entry[2]/p"/>
						<xsl:text>,</xsl:text>
					</xsl:if>
					<xsl:if test="apiValueDetail/apiValueDef/apiProperty">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PropertyIn']]/entry[2]/p"/>
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:if test="../apiClassifierDetail/apiClassifierDef/apiInterface">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'InterfaceIn']]/entry[2]/p"/>
			</xsl:if>
			<xsl:if test="not(../apiClassifierDetail/apiClassifierDef/apiInterface)">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:call-template name="getClassRef">
				<xsl:with-param name="classPath" select="$classPath"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="parent::apiPackage">
			<xsl:if test="apiValueDetail/apiValueDef/apiStatic">
				<xsl:if test="not(apiValueDetail/apiValueDef/apiProperty)">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackageConstantStaticPropertyIn']]/entry[2]/p"/>
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:if test="apiValueDetail/apiValueDef/apiProperty">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackageStaticPropertyIn']]/entry[2]/p"/>
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not(apiValueDetail/apiValueDef/apiStatic)">
				<xsl:if test="not(apiValueDetail/apiValueDef/apiProperty)">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackageConstantPropertyIn']]/entry[2]/p"/>
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:if test="apiValueDetail/apiValueDef/apiProperty">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Package']]/entry[2]/p"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Property']]/entry[2]/p"/>
					<xsl:text>, </xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="ancestor::apiPackage/apiName"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$isTopLevel='false'">
				<a href="{$classPath}/package.html" onclick="loadClassListFrame('{$classPath}/class-list.html')">
					<xsl:value-of select="ancestor::apiPackage/apiName"/>
				</a>
			</xsl:if>
			<xsl:if test="$isTopLevel!='false'">
				<a href="package.html" onclick="loadClassListFrame('class-list.html')">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
				</a>
			</xsl:if>
		</xsl:if>
		<!-- AS2 lang elements -->
		<xsl:if test="../../@type='list'">
			<xsl:if test="../../@name='Constants'">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ConstantProperty']]/entry[2]/p"/>
			</xsl:if>
			<xsl:if test="../../@name!='Constants'">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalProperty']]/entry[2]/p"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getEventDesc">
		<xsl:param name="classPath"/>
		<!-- AS2 lang elements -->
		<xsl:if test="parent::apiClassifier">
			<xsl:variable name="typeName">
				<xsl:if test="../apiClassifierDetail/apiClassifierDef/apiInterface">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'InterfaceIn']]/entry[2]/p"/>
				</xsl:if>
				<xsl:if test="not(../apiClassifierDetail/apiClassifierDef/apiInterface)">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
				</xsl:if>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="@type = 'handler'">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'EventHandlerIn']]/entry[2]/p"/>
					<xsl:text>,</xsl:text>
				</xsl:when>
				<xsl:when test="@type != 'handler'">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'EventListenerIn']]/entry[2]/p"/>
					<xsl:text>,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'EventIn']]/entry[2]/p"/>
					<xsl:text>,</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$typeName"/>
			<xsl:text> </xsl:text>
			<xsl:call-template name="getClassRef">
				<xsl:with-param name="classPath" select="$classPath"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not(../../@type) or ../../@type='list'">
			<xsl:if test="@type = 'handler'">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalEventHandler']]/entry[2]/p"/>
			</xsl:if>
			<xsl:if test="@type != 'handler'">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'GlobalEventListener']]/entry[2]/p"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getPackageComment">
		<xsl:param name="packageName"/>
		<xsl:if test="not($config/overviews/package)">
			<xsl:variable name="packageComments" select="document($packageOverviewFile)/overviews/packages/package[@name=$packageName]"/>
			<xsl:for-each select="$packageComments/shortDescription">
				<xsl:call-template name="deTilda">
					<xsl:with-param name="inText" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$config/overviews/package">
			<xsl:for-each select="$config/overviews/package">
				<xsl:variable name="packageOverview" select="document(.)/overviews/packages/package[@name=$packageName]"/>
				<xsl:for-each select="$packageOverview/shortDescription">
					<xsl:call-template name="deTilda">
						<xsl:with-param name="inText" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getClassDesc">
		<xsl:param name="packageName"/>
		<xsl:if test="string-length($packageName)=0">
			<xsl:if test="apiClassifierDetail/apiClassifierDef/apiFinal">
				<xsl:if test="apiClassifierDetail/apiClassifierDef/apiDynamic">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'FinalDynamicClass']]/entry[2]/p"/>
				</xsl:if>
				<xsl:if test="not(apiClassifierDetail/apiClassifierDef/apiDynamic)">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'FinalClass']]/entry[2]/p"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not(apiClassifierDetail/apiClassifierDef/apiFinal)">
				<xsl:if test="apiClassifierDetail/apiClassifierDef/apiDynamic">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DynamicClassIn']]/entry[2]/p"/>
				</xsl:if>
				<xsl:if test="not(apiClassifierDetail/apiClassifierDef/apiDynamic)">
					<xsl:if test="apiClassifierDetail/apiClassifierDef/apiInterface">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Interface']]/entry[2]/p"/>
					</xsl:if>
					<xsl:if test="not(apiClassifierDetail/apiClassifierDef/apiInterface)">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:text>, </xsl:text>
			<a href="package-detail.html" onclick="javascript:loadClassListFrame('class-list.html');">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
			</a>
		</xsl:if>
		<xsl:if test="string-length($packageName)">
			<xsl:if test="apiClassifierDetail/apiClassifierDef/apiFinal">
				<xsl:if test="apiClassifierDetail/apiClassifierDef/apiDynamic">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'FinalDynamicClass']]/entry[2]/p"/>
				</xsl:if>
				<xsl:if test="not(apiClassifierDetail/apiClassifierDef/apiDynamic)">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'FinalClass']]/entry[2]/p"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not(apiClassifierDetail/apiClassifierDef/apiFinal)">
				<xsl:if test="apiClassifierDetail/apiClassifierDef/apiDynamic">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DynamicClassIn']]/entry[2]/p"/>
				</xsl:if>
				<xsl:if test="not(apiClassifierDetail/apiClassifierDef/apiDynamic)">
					<xsl:if test="apiClassifierDetail/apiClassifierDef/apiInterface">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Interface']]/entry[2]/p"/>
					</xsl:if>
					<xsl:if test="not(apiClassifierDetail/apiClassifierDef/apiInterface)">
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ClassIn']]/entry[2]/p"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Package']]/entry[2]/p"/>
			<xsl:text> </xsl:text>
			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="$packageName"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$isTopLevel='false'">
				<a href="{translate($packageName,'.','/')}/package-detail.html" onclick="javascript:loadClassListFrame('{translate($packageName,'.','/')}/class-list.html');">
					<xsl:value-of select="$packageName"/>
				</a>
			</xsl:if>
			<xsl:if test="$isTopLevel!='false'">
				<a href="package.html" onclick="loadClassListFrame('class-list.html')">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
				</a>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getParamList">
		<xsl:param name="params"/>
		<xsl:for-each select="$params">
			<xsl:if test="position()>1">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:variable name="typeName">
				<xsl:if test="./apiType and not(./apiOperationClassifier)">
					<xsl:value-of select="./apiType/@value"/>
				</xsl:if>
				<xsl:if test="./apiOperationClassifier and not(./apiType)">
					<xsl:value-of select="./apiOperationClassifier"/>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="$prog_language_name = 'ActionScript'">
				<xsl:if test="$config/options/@docversion='2' and @optional='true'">
					<xsl:text>[</xsl:text>
				</xsl:if>
				<xsl:if test="($typeName!= 'restParam')">
					<xsl:value-of select="./apiItemName"/>
					<xsl:if test="($typeName!= '')">
						<xsl:text>:</xsl:text>
						<xsl:call-template name="processParamType">
							<xsl:with-param name="typeName" select="$typeName"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<xsl:if test="($typeName = 'restParam')">
					<xsl:text>... rest</xsl:text>
				</xsl:if>
				<xsl:if test="$config/options/@docversion='2' and @optional='true'">
					<xsl:text>]</xsl:text>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="processParamType">
		<xsl:param name="typeName"/>
		<xsl:if test="($typeName='list')">
			<a href="{$typeName}.html">
				<xsl:value-of select="$typeName"/>
			</a>
		</xsl:if>
		<xsl:if test="$typeName !='list'">
			<xsl:variable name="doesTypeExist">
				<xsl:call-template name="doesClassExist">
					<xsl:with-param name="class_name" select="translate($typeName, '[]', '')"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$doesTypeExist = '1'">
					<xsl:variable name="href">
						<xsl:call-template name="convertFullName">
							<xsl:with-param name="fullname" select="$typeName"/>
							<xsl:with-param name="separator">/</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="string-length($href)">
						<a href="{$href}.html">
							<xsl:attribute name="onclick">
								<xsl:text>javascript:loadClassListFrame('</xsl:text>
								<xsl:call-template name="substring-before-last">
									<xsl:with-param name="input" select="$href"/>
									<xsl:with-param name="substr" select="'/'"/>
								</xsl:call-template>
								<xsl:text>./class-list.html');</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="$typeName"/>
						</a>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$typeName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
