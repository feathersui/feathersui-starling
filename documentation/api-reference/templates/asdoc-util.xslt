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
	<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes" use-character-maps="disable"/>
	<xsl:key name="match" match="//apiPackage" use="@id"/>
	<xsl:variable name="newline">
		<xsl:text/>
	</xsl:variable>
	<xsl:variable name="productName" select="$config//product"/>
	<xsl:variable name="markOfTheWeb" select="'&lt;!-- saved from url=(0014)about:internet -->'"/>
	<xsl:variable name="docType">
		<!-- insert byte order mark needed for Flash Panel Help -->
		<xsl:if test="$config/options[@livedocs!='true']">
			<xsl:text disable-output-escaping="yes"></xsl:text>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML PUBLIC &quot;-//W3C//DTD HTML 4.01 Transitional//EN&quot; &quot;http://www.w3.org/TR/html4/loose.dtd&quot;&gt;</xsl:text>
		<xsl:value-of select="$newline"/>
		<xsl:if test="$config/options[@standalone='true']">
			<xsl:value-of disable-output-escaping="yes" select="$markOfTheWeb"/>
			<xsl:value-of select="$newline"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="frameDocType">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML PUBLIC &quot;-//W3C//DTD HTML 4.01 Frameset//EN&quot; &quot;http://www.w3.org/TR/html4/frameset.dtd&quot;&gt;</xsl:text>
		<xsl:value-of select="$newline"/>
	</xsl:variable>
	<xsl:function name="ifn:myFormatDate">
		<xsl:variable name="lookup" as="node()+">
			<term value="Jan">January</term>
			<term value="Feb">February</term>
			<term value="Mar">March</term>
			<term value="Apr">April</term>
			<term value="May">May</term>
			<term value="Jun">June</term>
			<term value="Jul">July</term>
			<term value="Aug">August</term>
			<term value="Sep">September</term>
			<term value="Oct">October</term>
			<term value="Nov">November</term>
			<term value="Dec">December</term>
			<term value="Mon">Monday</term>
			<term value="Tue">Tuesday</term>
			<term value="Wed">Wednesday</term>
			<term value="Thu">Thursday</term>
			<term value="Fri">Friday</term>
			<term value="Sat">Saturday</term>
			<term value="Sun">Sunday</term>
			<term value="AM">A.M.</term>
			<term value="PM">P.M.</term>
		</xsl:variable>
		<xsl:variable name="date" select="format-dateTime(current-dateTime(),  '[F] [MNn] [D] [Y], [h01]:[m01] [PN] [ZN] ' )"/>
		<xsl:value-of select="for $i in tokenize($date, ' ') return ($lookup[. = $i]/@value, $i)[1]"/>
	</xsl:function>
	<xsl:param name="locale" select="'en-us'"/>
	<xsl:param name="asdocTermsFilename" select="'ASDoc_terms.xml'"/>
	<xsl:variable name="asdoc_terms" select="document($asdocTermsFilename)//tbody"/>
	<xsl:param name="configFilename" select="'ASDoc_Config.xml'"/>
	<xsl:variable name="config" select="document($configFilename)/asDocConfig"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:param name="packageCommentsFilename" select="'packages.xml'"/>
	<xsl:param name="AS1tooltip" select="'This example can be used with ActionScript 1.0'"/>
	<xsl:param name="AS2tooltip" select="$asdoc_terms/row[entry[1][p/text() = 'AS2tooltip']]/entry[2]/p"/>
	<xsl:param name="AS3tooltip" select="$asdoc_terms/row[entry[1][p/text() = 'AS3tooltip']]/entry[2]/p"/>
	<xsl:param name="showASIcons" select="'false'"/>
	<xsl:param name="showInheritanceIcon" select="'true'"/>
	<xsl:param name="inheritanceIcon" select="'inherit-arrow.jpg'"/>
	<xsl:param name="isEclipse" select="$config/options[@eclipse='true']"/>
	<xsl:param name="isLiveDocs" select="$config/options[@livedocs='true']"/>
	<xsl:param name="liveDocsSearchSite" select="$config/livedocs/searchsite/."/>
	<xsl:param name="liveDocsSearchString" select="$config/livedocs/searchstring/."/>
	<xsl:param name="liveDocsSearchLocale" select="$config/livedocs/locale/."/>
	<xsl:param name="liveDocsSearch" select="$asdoc_terms/row[entry[1][p/text() = 'searchLivedocs']]/entry[2]/p"/>
	<xsl:param name="liveDocsSearchServlet" select="$config/livedocs/searchservlet/."/>
	<xsl:param name="isStandalone" select="$config/options[@standalone='true']"/>
	<xsl:param name="isSkin" select="$config/skinLink/."/>	
	<xsl:param name="prog_language_name" select="'ActionScript'"/>
	<xsl:variable name="id.match" select="document('flashclasses.xml')//package//class"/>
	<xsl:variable name="id.match.name" select="document('flashclasses.xml')//package"/>
	<xsl:variable name="id.match.class" select="document('flashclasses.xml')//category//class"/>
	<xsl:variable name="class.File.Name" select="document('ClassHeader.xml')//apiClassifier"/>
	<xsl:param name="process_xref_href_attribute" select="'0'"/>
	<xsl:param name="showLangVersionWarnings">
		<xsl:if test="$config/warnings/@langversion='true'">
			<xsl:value-of select="'true'"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="showPlayerVersionWarnings">
		<xsl:if test="$config/warnings/@playerversion='true'">
			<xsl:value-of select="'true'"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="noLiveDocs">
		<xsl:if test="$config/options[@livedocs='true']">
			<xsl:comment>livedocs:no</xsl:comment>
			<xsl:value-of select="$newline"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="showXrefs" select="$config/xrefs[@show='true']"/>
	<xsl:variable name="xrefs">
		<xsl:if test="$showXrefs">
			<xsl:copy-of select="document($config/xrefs/@mapfile)/helpreferences"/>
		</xsl:if>
	</xsl:variable>
	<xsl:param name="title-base" select="$config/windowTitle/."/>
	<xsl:param name="title-jslr" select="$asdoc_terms/row[entry[1][p/text() = 'JSLR_Book_Title']]/entry[2]/p"/>
	<xsl:param name="page-title-base" select="$config/title/."/>
	<xsl:param name="timestamp">
		<xsl:value-of select="ifn:myFormatDate()"/>
	</xsl:param>
	<xsl:param name="copyright">
		<xsl:copy-of select="$config/footer"/>
		<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
		<xsl:if test="$config/dateInFooter='true'">
			<xsl:value-of select="$timestamp"/>
		</xsl:if>
		<xsl:text> </xsl:text>
	</xsl:param>
	<xsl:variable name="copyrightComment">
		<xsl:comment>
			<xsl:copy-of select="$copyright"/>
		</xsl:comment>
	</xsl:variable>
	<xsl:variable name="upperCase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="lowerCase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="thinsp">
		<xsl:text>&#x2009;</xsl:text>
	</xsl:variable>
	<xsl:variable name="emdash">
		<xsl:text> &#x2014; </xsl:text>
	</xsl:variable>
	<xsl:variable name="asterisk">
		<xsl:text>&#x2A;</xsl:text>
	</xsl:variable>
	<xsl:variable name="nbsp">
		<xsl:text>&#xA0;</xsl:text>
	</xsl:variable>
	<xsl:variable name="degree">
		<xsl:text>&#xB0;</xsl:text>
	</xsl:variable>
	<xsl:variable name="trademark">
		<xsl:text>&#x2122;</xsl:text>
	</xsl:variable>
	<xsl:variable name="registered">
		<xsl:text>&#xAE;</xsl:text>
	</xsl:variable>
	<xsl:template name="getRelativePath">
		<xsl:param name="currentPath"/>
		<xsl:choose>
			<xsl:when test="not($currentPath) or $currentPath='__Global__'">
				<xsl:value-of select="''"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="contains($currentPath,'.')">
					<xsl:call-template name="getRelativePath">
						<xsl:with-param name="currentPath" select="substring-after($currentPath,'.')"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:value-of select="'../'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getBaseRef">
		<xsl:param name="packageName"/>
		<xsl:variable name="isTopLevel">
			<xsl:call-template name="isTopLevel">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$isTopLevel='false'">
			<xsl:variable name="newName" select="substring-after($packageName,'.')"/>
			<xsl:if test="$packageName">
				<xsl:text>../</xsl:text>
				<xsl:call-template name="getBaseRef">
					<xsl:with-param name="packageName" select="$newName"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="convertNumberListIntoBoolean">
		<xsl:param name="numberList"/>
		<xsl:choose>
			<xsl:when
				test="contains($numberList,'1') or contains($numberList,'2') or contains($numberList,'3') or contains($numberList,'4') or contains($numberList,'5') or contains($numberList,'6') or contains($numberList,'7') or contains($numberList,'8') or contains($numberList,'9')">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getStyleLink">
		<xsl:param name="link"/>
		<xsl:param name="packageName"/>
		<xsl:choose>
			<!-- TODO support this? -->
			<xsl:when test="false()">
				<xsl:for-each select="$link">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="baseRef">
					<xsl:call-template name="getBaseRef">
						<xsl:with-param name="packageName" select="$packageName"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:element name="link">
					<xsl:attribute name="rel">stylesheet</xsl:attribute>
					<xsl:attribute name="href"><xsl:value-of select="$baseRef"/>style.css</xsl:attribute>
					<xsl:attribute name="type">text/css</xsl:attribute>
					<xsl:attribute name="media">screen</xsl:attribute>
				</xsl:element>
				<xsl:element name="link">
					<xsl:attribute name="rel">stylesheet</xsl:attribute>
					<xsl:attribute name="href"><xsl:value-of select="$baseRef"/>print.css</xsl:attribute>
					<xsl:attribute name="type">text/css</xsl:attribute>
					<xsl:attribute name="media">print</xsl:attribute>
				</xsl:element>
				<xsl:element name="link">
					<xsl:attribute name="rel">stylesheet</xsl:attribute>
					<xsl:attribute name="href"><xsl:value-of select="$baseRef"/>override.css</xsl:attribute>
					<xsl:attribute name="type">text/css</xsl:attribute>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getTitleScript">
		<xsl:param name="packageName"/>
		<xsl:param name="title" select="$title-base"/>
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<script language="javascript" type="text/javascript">
			<xsl:attribute name="src">
				<xsl:value-of select="$baseRef"/>
				<xsl:text>asdoc.js</xsl:text>
			</xsl:attribute>
		</script>
		<xsl:if test="$isEclipse">
			<script language="javascript" type="text/javascript">
				<xsl:comment> eclipseBuild = true;</xsl:comment>
			</script>
		</xsl:if>
		<script language="javascript" type="text/javascript">
			<xsl:attribute name="src">
				<xsl:value-of select="$baseRef"/>
				<xsl:text>help.js</xsl:text>
			</xsl:attribute>
		</script>
		<script language="javascript" type="text/javascript">
			<xsl:attribute name="src">
				<xsl:value-of select="$baseRef"/>
				<xsl:text>cookies.js</xsl:text>
			</xsl:attribute>
		</script>
		<script language="javascript" type="text/javascript">
			<xsl:comment>
				asdocTitle = '<xsl:value-of select="$title"/>';
				var baseRef = '<xsl:value-of select="$baseRef"/>';
				window.onload = configPage;
			</xsl:comment>
		</script>
		<xsl:text>&#xa;</xsl:text>
		<xsl:if test="$config/options[@standalonesearch='true']">
			<xsl:call-template name="search.function.submit">
				<xsl:with-param name="baseRef" select="$baseRef"/>
			</xsl:call-template>
		</xsl:if>
		<script type="text/javascript">
			scrollToNameAnchor();
		</script>
	</xsl:template>
	<xsl:template name="search.function.submit">
		<xsl:param name="baseRef"/>
		<script language="javascript" type="text/javascript">
			<xsl:comment>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>function submitValue(){</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>var searchStr=document.getElementById('search-livedocs').value;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>window.location="</xsl:text><xsl:value-of select="$baseRef"/><xsl:text>search.html"+"###"+searchStr;</xsl:text>
				<xsl:text>&#xa;</xsl:text>
				<xsl:text>}</xsl:text>
				<xsl:text>&#xa;</xsl:text>
			</xsl:comment>
		</script>
	</xsl:template>
	<xsl:template name="getLinks">
		<xsl:param name="packageName" select="''"/>
		<xsl:param name="fileName"/>
		<xsl:param name="fileName2" select="'all-classes.html'"/>
		<xsl:param name="showInnerClasses" select="false()"/>
		<xsl:param name="showConstants" select="false()"/>
		<xsl:param name="showProperties" select="true()"/>
		<xsl:param name="showConstructors" select="false()"/>
		<xsl:param name="showMethods" select="true()"/>
		<xsl:param name="showStyles" select="false()"/>
		<xsl:param name="showSkinState" select="false()"/>
		<xsl:param name="showSkinPart" select="false()"/>		
		<xsl:param name="showEffects" select="false()"/>
		<xsl:param name="showEvents" select="false()"/>
		<xsl:param name="showIncludeExamples" select="false()"/>
		<xsl:param name="showPackages" select="true()"/>
		<xsl:param name="showAllClasses" select="true()"/>
		<xsl:param name="showLanguageElements" select="boolean($config/languageElements[@show='true'])"/>
		<xsl:param name="showIndex" select="true()"/>
		<xsl:param name="showAppendixes" select="true()"/>
		<xsl:param name="showPackageConstants" select="false()"/>
		<xsl:param name="showPackageProperties" select="false()"/>
		<xsl:param name="showPackageFunctions" select="false()"/>
		<xsl:param name="showInterfaces" select="false()"/>
		<xsl:param name="showClasses" select="false()"/>
		<xsl:param name="showPackageUse" select="false()"/>
		<xsl:param name="copyNum" select="'1'"/>
		<xsl:param name="additionalLinks"/>
		<xsl:param name="splitIndex" select="$config/options[@splitIndex='true']"/>
		<xsl:param name="showMXMLOnly" select="boolean($config/options[@showMXMLOnly='true'])"/>
		<xsl:param name="showConventions" select="boolean($config/options[@showConventions!='false'])"/>
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="href">
			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="$packageName"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$isTopLevel='false'">
				<xsl:value-of select="translate($packageName,'.','/')"/>
				<xsl:text>/</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="$copyNum='1'">
			<div class="pageTop"/>
			<table width="100%" cellpadding="0" cellspacing="0" id="titleTable" style="display:none">
				<tr>
					<td valign="left" width="64" style="padding-left:5px">
						<img src="{$baseRef}images/mm-icon.jpg" border="0">
							<xsl:attribute name="alt">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">AdobeLogo</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">AdobeLogo</xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
						</img>
					</td>
					<td align="center" valign="middle">
						<xsl:variable name="fontSize">
							<xsl:if test="string-length($config/title/@size)">
								<xsl:value-of select="$config/title/@size"/>
							</xsl:if>
							<xsl:if test="not(string-length($config/title/@size))">
								<xsl:value-of select="24"/>
							</xsl:if>
						</xsl:variable>
						<h1 style="font-size:{$fontSize}px">
							<xsl:value-of select="$title-base"/>
						</h1>
					</td>
				</tr>
				<tr>
					<td colspan="2" height="5px"/>
				</tr>
			</table>
		</xsl:if>
		<xsl:if test="not($copyNum='1')">
			<xsl:call-template name="getNavLinks">
				<xsl:with-param name="copyNum" select="$copyNum"/>
				<xsl:with-param name="baseRef" select="$baseRef"/>
				<xsl:with-param name="showPackages" select="$showPackages"/>
				<xsl:with-param name="showAllClasses" select="$showAllClasses"/>
				<xsl:with-param name="showLanguageElements" select="$showLanguageElements"/>
				<xsl:with-param name="showMXMLOnly" select="$showMXMLOnly"/>
				<xsl:with-param name="showIndex" select="$showIndex"/>
				<xsl:with-param name="splitIndex" select="$splitIndex"/>
				<xsl:with-param name="showAppendixes" select="$showAppendixes"/>
				<xsl:with-param name="showConventions" select="$showConventions"/>
				<xsl:with-param name="href" select="$href"/>
				<xsl:with-param name="fileName" select="$fileName"/>
				<xsl:with-param name="fileName2" select="$fileName2"/>
			</xsl:call-template>
		</xsl:if>
		<div width="100%" class="topLinks" align="right">
			<span>

				<xsl:if test="$showProperties">
					<a href="#propertySummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Properties']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showPackageProperties">
					<a href="package.html#propertySummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Properties']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showConstructors">
					<a href="#constructorSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constructor']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="not($showMethods=false)">
					<a href="#methodSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Method']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showPackageFunctions">
					<a href="package.html#methodSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Functions']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showEvents">
					<a href="#eventSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Events']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showStyles">
					<a href="#styleSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Styles']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showSkinPart">
					<a href="#SkinPartSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinParts']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showSkinState">
					<a href="#SkinStateSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinStates']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showEffects">
					<a href="#effectSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Effects']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showConstants">
					<a href="#constantSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constants']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showPackageConstants">
					<a href="package.html#constantSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constants']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showInterfaces">
					<a href="package-detail.html#interfaceSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Interfaces']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showClasses">
					<a href="package-detail.html#classSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Classes']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showPackageUse">
					<a href="package-use.html"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Use']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showIncludeExamples">
					<a href="#includeExamplesSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Examples']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$additionalLinks">
					<xsl:copy-of select="$additionalLinks"/>
				</xsl:if>
			</span>
		</div>
		<xsl:if test="not($copyNum='2')">
			<xsl:call-template name="getNavLinks">
				<xsl:with-param name="copyNum" select="$copyNum"/>
				<xsl:with-param name="baseRef" select="$baseRef"/>
				<xsl:with-param name="showPackages" select="$showPackages"/>
				<xsl:with-param name="showAllClasses" select="$showAllClasses"/>
				<xsl:with-param name="showLanguageElements" select="$showLanguageElements"/>
				<xsl:with-param name="showMXMLOnly" select="$showMXMLOnly"/>
				<xsl:with-param name="showIndex" select="$showIndex"/>
				<xsl:with-param name="splitIndex" select="$splitIndex"/>
				<xsl:with-param name="showAppendixes" select="$showAppendixes"/>
				<xsl:with-param name="showConventions" select="$showConventions"/>
				<xsl:with-param name="href" select="$href"/>
				<xsl:with-param name="fileName" select="$fileName"/>
				<xsl:with-param name="fileName2" select="$fileName2"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getLinks2">
		<xsl:param name="subTitle" select="$nbsp"/>
		<xsl:param name="packageName" select="''"/>
		<xsl:param name="fileName"/>
		<xsl:param name="fileName2" select="'all-classes.html'"/>
		<xsl:param name="showInnerClasses"/>
		<xsl:param name="showConstants" select="false()"/>
		<xsl:param name="showProperties" select="true()"/>
		<xsl:param name="showConstructors" select="false()"/>
		<xsl:param name="showMethods" select="true()"/>
		<xsl:param name="showStyles" select="false()"/>
		<xsl:param name="showSkinState" select="false()"/>
		<xsl:param name="showSkinPart" select="false()"/>		
		<xsl:param name="showEffects" select="false()"/>
		<xsl:param name="showEvents" select="false()"/>
		<xsl:param name="showIncludeExamples" select="false()"/>
		<xsl:param name="showPackages" select="true()"/>
		<xsl:param name="showAllClasses" select="true()"/>
		<xsl:param name="showLanguageElements" select="boolean($config/languageElements[@show='true'])"/>
		<xsl:param name="showIndex" select="true()"/>
		<xsl:param name="showAppendixes" select="boolean($config/appendixes[@show='true'])"/>
		<xsl:param name="showPackageConstants" select="false()"/>
		<xsl:param name="showPackageProperties" select="false()"/>
		<xsl:param name="showPackageFunctions" select="false()"/>
		<xsl:param name="showInterfaces" select="false()"/>
		<xsl:param name="showClasses" select="false()"/>
		<xsl:param name="showPackageUse" select="false()"/>
		<xsl:param name="copyNum" select="'1'"/>
		<xsl:param name="additionalLinks"/>
		<xsl:param name="splitIndex" select="$config/options[@splitIndex='true']"/>
		<xsl:param name="showConventions" select="boolean($config/options[@showConventions!='false'])"/>
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="href">
			<xsl:variable name="isTopLevel">
				<xsl:call-template name="isTopLevel">
					<xsl:with-param name="packageName" select="$packageName"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$isTopLevel='false'">
				<xsl:value-of select="translate($packageName,'.','/')"/>
				<xsl:text>/</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="$copyNum='1'">
			<xsl:if test="not($config/options[@eclipse='true'])">
				<table class="titleTable" cellpadding="0" cellspacing="0" id="titleTable" style="display:none">
					<tr>
						<td class="titleTableTitle" align="left">
							<xsl:choose>
								<xsl:when test="$prog_language_name='javascript'"/>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="$page-title-base"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<xsl:if test="$config/options[@ion='true']">
							<td class="titleTableSearch" align="center">
								<xsl:comment>#include virtual="/livedocs/flex/3/langref/ionsearchform.ssi"</xsl:comment>
							</td>
						</xsl:if>
						<xsl:if test="$config/options[@livedocs='true']">
							<td class="titleTableSearch" align="center">
								<form class="searchForm" target="adbe_window" method="get" action="{$liveDocsSearchServlet}"
									onsubmit="this.term.value = this.termPrefix.value + &quot;\&quot;&quot; + this.search_text.value + &quot;\&quot;&quot;;">
									<input class="hidden" name="loc" value="{$liveDocsSearchLocale}" type="hidden"/>
									<input class="hidden" name="termPrefix" value="{$liveDocsSearchSite}" type="hidden"/>
									<input class="hidden" name="term" value="" type="hidden"/>
									<input class="hidden" name="area" value="" type="hidden"/>
									<input id="search-livedocs" name="search_text" value="" title="{$liveDocsSearchString}" type="text"/>
									<xsl:text> </xsl:text>
									<input type="submit" name="action" value="{$liveDocsSearch}"/>
								</form>
							</td>
						</xsl:if>
						<xsl:variable name="ref.path">
							<xsl:value-of select="$baseRef"/>
							<xsl:text>search.html</xsl:text>
						</xsl:variable>
						<xsl:if test="$config/options[@standalonesearch='true']">
							<td class="titleTableSearch" align="center">
								<form class="searchForm" method="get" action="{$ref.path}" onsubmit="submitValue();">
									<input class="hidden" name="loc" value="{$liveDocsSearchLocale}" type="hidden"/>
									<input class="hidden" name="termPrefix" value="" type="hidden"/>
									<input class="hidden" name="term" value="" type="hidden"/>
									<input class="hidden" name="area" value="" type="hidden"/>
									<input id="search-livedocs" name="search_text" value="" title="{$liveDocsSearchString}" type="text"/>
									<xsl:text> </xsl:text>
									<input type="button" name="action" value="{$liveDocsSearch}" onclick="submitValue()"/>
								</form>
							</td>
						</xsl:if>
						<td class="titleTableTopNav" align="right">
							<xsl:choose>
								<xsl:when test="$prog_language_name='javascript'"/>
								<xsl:otherwise>
									<xsl:call-template name="getNavLinks2">
										<xsl:with-param name="copyNum" select="$copyNum"/>
										<xsl:with-param name="baseRef" select="$baseRef"/>
										<xsl:with-param name="showPackages" select="$showPackages"/>
										<xsl:with-param name="showAllClasses" select="$showAllClasses"/>
										<xsl:with-param name="showLanguageElements" select="$showLanguageElements"/>
										<xsl:with-param name="showIndex" select="$showIndex"/>
										<xsl:with-param name="splitIndex" select="$splitIndex"/>
										<xsl:with-param name="showAppendixes" select="$showAppendixes"/>
										<xsl:with-param name="showConventions" select="$showConventions"/>
										<xsl:with-param name="href" select="$href"/>
										<xsl:with-param name="fileName" select="$fileName"/>
										<xsl:with-param name="fileName2" select="$fileName2"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="titleTableLogo" align="right" rowspan="3">
							<picture>
								<img src="{$baseRef}images/logo.jpg" srcset="{$baseRef}images/logo@2x.jpg 2x" class="logoImage">
									<xsl:attribute name="alt">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">AdobeLogo</xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:attribute name="title">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">AdobeLogo</xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
								</img>
							</picture>
						</td>
					</tr>
					<tr class="titleTableRow2">
						<td class="titleTableSubTitle" id="subTitle" align="left">
							<xsl:if test="string-length($subTitle)">
								<xsl:value-of select="$subTitle"/>
							</xsl:if>
							<xsl:if test="not(string-length($subTitle))">
								<xsl:value-of select="$nbsp"/>
							</xsl:if>
						</td>
						<td class="titleTableSubNav" id="subNav" align="right">
							<xsl:if test="$config/options[@livedocs='true']">
								<xsl:attribute name="colspan">
									<xsl:text>2</xsl:text>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="$config/options[@ion='true']">
								<xsl:attribute name="colspan">
									<xsl:text>2</xsl:text>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="$config/options[@standalonesearch='true']">
								<xsl:attribute name="colspan">
									<xsl:text>2</xsl:text>
								</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$prog_language_name='javascript'"/>
								<xsl:otherwise>
									<xsl:if test="$showProperties=true()">
										<a href="#propertySummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Properties']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showPackageProperties">
										<a href="package.html#propertySummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Properties']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showConstructors=true()">
										<a href="#constructorSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constructor']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="not($showMethods=false())">
										<a href="#methodSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Methods']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showPackageFunctions">
										<a href="package.html#methodSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Functions']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showEvents=true()">
										<a href="#eventSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Events']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showStyles=true()">
										<a href="#styleSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Styles']]/entry[2]/p"/></a>
									</xsl:if>

									<xsl:if test="$showSkinPart=true()">
										<a href="#SkinPartSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinParts']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showSkinState=true()">
										<a href="#SkinStateSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SkinStates']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showEffects=true()">
										<a href="#effectSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Effects']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showConstants=true()">
										<a href="#constantSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constants']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showPackageConstants">
										<a href="package.html#constantSummary"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Constants']]/entry[2]/p"/></a>
									</xsl:if>
									<xsl:if test="$showInterfaces">
										<a href="package-detail.html#interfaceSummary">
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">Interfaces</xsl:with-param>
											</xsl:call-template>
										</a>
									</xsl:if>
									<xsl:if test="$showClasses">
										<xsl:variable name="href">
											<xsl:if test="$fileName != 'deprecated'">
												<xsl:text>package-detail.html</xsl:text>
											</xsl:if>
											<xsl:text>#classSummary</xsl:text>
										</xsl:variable>
										<a href="{$href}">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Classes']]/entry[2]/p"/>
										</a>
									</xsl:if>
									<xsl:if test="$showPackageUse">
										<a href="package-use.html">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Use']]/entry[2]/p"/>
										</a>
									</xsl:if>
									<xsl:if test="$showIncludeExamples=true()">
										<a href="#includeExamplesSummary">
											<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Examples']]/entry[2]/p"/>
										</a>
									</xsl:if>
									<xsl:if test="$additionalLinks">
										<xsl:copy-of select="$additionalLinks"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr class="titleTableRow3">
						<td>
							<xsl:attribute name="colspan">
								<xsl:if test="$config/options[@livedocs='true']">
									<xsl:text>3</xsl:text>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="not($config/options[@livedocs='true']) and $config/options[@standalonesearch='false']">
										<xsl:text>3</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>3</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:value-of select="$nbsp"/>
						</td>
					</tr>
				</table>
			</xsl:if>
			<script language="javascript" type="text/javascript" xml:space="preserve">
				<xsl:comment>
				<xsl:text/>
					<xsl:text>if (!isEclipse() || window.name != ECLIPSE_FRAME_NAME) {</xsl:text><xsl:text>titleBar_setSubTitle("</xsl:text><xsl:value-of select="$subTitle"/><xsl:text>"); </xsl:text><xsl:text>titleBar_setSubNav(</xsl:text><xsl:value-of select="$showConstants"/><xsl:text>,</xsl:text><xsl:value-of select="$showProperties"/><xsl:text>,</xsl:text><xsl:value-of select="$showStyles"/><xsl:text>,</xsl:text><xsl:value-of select="$showSkinPart"/><xsl:text>,</xsl:text><xsl:value-of select="$showSkinState"/><xsl:text>,</xsl:text><xsl:value-of select="$showEffects"/><xsl:text>,</xsl:text><xsl:value-of select="$showEvents"/><xsl:text>,</xsl:text><xsl:value-of select="$showConstructors"/><xsl:text>,</xsl:text><xsl:value-of select="$showMethods"/><xsl:text>,</xsl:text><xsl:value-of select="$showIncludeExamples"/><xsl:text>,</xsl:text><xsl:value-of select="$showPackageConstants"/>	<xsl:text>,</xsl:text><xsl:value-of select="$showPackageProperties"/><xsl:text>,</xsl:text><xsl:value-of select="$showPackageFunctions"/><xsl:text>,</xsl:text><xsl:value-of select="$showInterfaces"/><xsl:text>,</xsl:text><xsl:value-of select="$showClasses"/><xsl:text>,</xsl:text><xsl:value-of select="$showPackageUse"/><xsl:text>);</xsl:text><xsl:text>}</xsl:text>	<xsl:text/>
				</xsl:comment>
			</script>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getNavLinks2">
		<xsl:param name="copyNum"/>
		<xsl:param name="baseRef"/>
		<xsl:param name="showPackages"/>
		<xsl:param name="showAllClasses"/>
		<xsl:param name="showLanguageElements"/>
		<xsl:param name="showIndex"/>
		<xsl:param name="splitIndex"/>
		<xsl:param name="showAppendixes"/>
		<xsl:param name="showConventions"/>
		<xsl:param name="href"/>
		<xsl:param name="fileName"/>
		<xsl:param name="fileName2"/>
		<xsl:if test="$showPackages">
			<a href="{$baseRef}package-summary.html" onclick="loadClassListFrame('{$baseRef}all-classes.html')"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'allPackages']]/entry[2]/p"/></a>
		</xsl:if>
		<xsl:if test="$showAllClasses">
			<xsl:choose>
				<xsl:when test="$prog_language_name='javascript'"/>
				<xsl:otherwise>
					<a href="{$baseRef}class-summary.html" onclick="loadClassListFrame('{$baseRef}all-classes.html')"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'allClasses']]/entry[2]/p"/></a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$showLanguageElements">
			<xsl:choose>
				<xsl:when test="$prog_language_name='javascript'"/>
				<xsl:otherwise>
					<a href="{$baseRef}language-elements.html"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'LanguageElements']]/entry[2]/p"/></a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$showIndex">
			<xsl:if test="$splitIndex='false'">
				<a href="{$baseRef}all-index.html" onclick="loadClassListFrame('{$baseRef}index-list.html')"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Index']]/entry[2]/p"/></a>
			</xsl:if>
			<xsl:if test="$splitIndex!='false' and $config/languageElements/@show='true' and $config/languageElements/@operators='true'">
				<a href="{$baseRef}all-index-Symbols.html" onclick="loadClassListFrame('{$baseRef}index-list.html')"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Index']]/entry[2]/p"/></a>
			</xsl:if>
			<xsl:if test="$isLiveDocs">
				<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			</xsl:if>
			<xsl:if test="$splitIndex!='false' and ($config/languageElements/@show!='true' or $config/languageElements/@operators!='true')">
				<a href="{$baseRef}all-index-A.html" onclick="loadClassListFrame('{$baseRef}index-list.html')"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Index']]/entry[2]/p"/></a>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$showAppendixes and $config/appendixes/@show='true'">
			<a href="{$baseRef}appendixes.html"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Appendix']]/entry[2]/p"/></a>
		</xsl:if>
		<xsl:if test="$showConventions">
			<xsl:choose>
				<xsl:when test="$prog_language_name='javascript'"/>
				<xsl:otherwise>
					<a href="{$baseRef}conventions.html"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Conventions']]/entry[2]/p"/></a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$prog_language_name='javascript'"/>
			<xsl:otherwise>
				<a id="framesLink{$copyNum}" href="{$baseRef}index.html?{$href}{$fileName}.html&amp;{$fileName2}">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Frames']]/entry[2]/p"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
		<a id="noFramesLink{$copyNum}" style="display:none" href="" onclick="parent.location=document.location">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">NoFrames</xsl:with-param>
			</xsl:call-template>
		</a>
	</xsl:template>
	<xsl:template name="getNavLinks">
		<xsl:param name="copyNum"/>
		<xsl:param name="baseRef"/>
		<xsl:param name="showPackages"/>
		<xsl:param name="showAllClasses"/>
		<xsl:param name="showLanguageElements"/>
		<xsl:param name="showMXMLOnly"/>
		<xsl:param name="showIndex"/>
		<xsl:param name="splitIndex"/>
		<xsl:param name="showAppendixes"/>
		<xsl:param name="showConventions"/>
		<xsl:param name="href"/>
		<xsl:param name="fileName"/>
		<xsl:param name="fileName2"/>
		<div width="100%" class="topLinks" align="right" style="padding-bottom:5px">
			<span id="navigationCell{$copyNum}" style="display:none;font-size:14px;font-weight:bold">
				<xsl:if test="$showPackages">
					<a href="{$baseRef}package-summary.html" onclick="loadClassListFrame('{$baseRef}all-classes.html')"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'allPackages']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showAllClasses">
					<a href="{$baseRef}class-summary.html" onclick="loadClassListFrame('{$baseRef}all-classes.html')"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'allClasses']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showLanguageElements">
					<a href="{$baseRef}language-elements.html"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'LanguageElements']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showMXMLOnly">
					<a href="{$baseRef}mxml-tag-detail.html" onclick="loadClassListFrame('{$baseRef}mxml-tags.html')"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'MXMLOnly']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showIndex">
					<xsl:if test="$splitIndex='false'">
						<a href="{$baseRef}all-index.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Index']]/entry[2]/p"/>
						</a>
					</xsl:if>
					<xsl:if test="$splitIndex!='false' and $config/languageElements/@show='true' and $config/languageElements/@operators='true'">
						<a href="{$baseRef}all-index-Symbols.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Index']]/entry[2]/p"/>
						</a>
					</xsl:if>
					<xsl:if test="$splitIndex!='false' and ($config/languageElements/@show!='true' or $config/languageElements/@operators!='true')">
						<a href="{$baseRef}all-index-A.html" onclick="loadClassListFrame('{$baseRef}index-list.html')">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Index']]/entry[2]/p"/>
						</a>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$showAppendixes and $config/appendixes/@show='true'">
					<a href="{$baseRef}appendixes.html"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Appendix']]/entry[2]/p"/></a>
				</xsl:if>
				<xsl:if test="$showConventions">
					<a href="{$baseRef}conventions.html"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Conventions']]/entry[2]/p"/></a>
				</xsl:if>
				<a id="framesLink{$copyNum}" href="{$baseRef}index.html?{$href}{$fileName}.html&amp;{$fileName2}"><xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Frames']]/entry[2]/p"/></a>
				<a id="noFramesLink{$copyNum}" style="display:none" href="" onclick="parent.location=document.location"><xsl:call-template name="getLocalizedString">
						<xsl:with-param name="key">NoFrames</xsl:with-param>
					</xsl:call-template></a>
			</span>
		</div>
	</xsl:template>
	<xsl:template name="getFeedbackLink">
		<xsl:param name="topic"/>
		<xsl:param name="filename"/>
		<xsl:param name="filename2" select="''"/>
		<xsl:param name="baseRef"/>
		<xsl:if test="not ($isLiveDocs)">
			<xsl:if test="$config/feedback[@show='true']">
				<xsl:choose>
					<xsl:when test="$prog_language_name='javascript'"/>
					<xsl:otherwise>
						<div class="feedbackLink">
							<center>
								<xsl:if test="$config/feedback[@type='email']">
									<a href="mailto:{$config/feedback/feedbackEmail/address/.}?subject=ASLR Feedback({$timestamp}) : {$topic}">
										<xsl:value-of select="$config/feedback/feedbackEmail/label/."/>
									</a>
								</xsl:if>
								<xsl:if test="$config/feedback[@type='livedocs']">
									<a href="javascript:gotoLiveDocs('{$filename}','{$filename2}','{$locale}');">
										<xsl:value-of select="$config/feedback/feedbackLiveDocs/label/."/>
									</a>
								</xsl:if>
							</center>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$config/options[@ion='true']">
			<xsl:if test="$config/feedback[@show='true']">
				<script src="{$baseRef}currentpage.js" type="text/javascript" language="Javascript" charset="UTF-8"/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$config/options[@livedocs='true']">
			<div class="feedbackLink">
				<center>
					<xsl:if test="$config/feedback[@type='livedocs']">
						<a href="javascript:gotoLiveDocs('{$filename}','{$filename2}','{$locale}');">
							<xsl:value-of select="$config/feedback/feedbackLiveDocs/label/."/>
						</a>
					</xsl:if>
				</center>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="showHelpLink">
		<xsl:if test="$config/exampleHelp and $config/exampleHelp/@show='true'">
			<xsl:variable name="linkurl" select="concat('&lt;a href=&quot;',$config/exampleHelp/linkUrl,'&quot; target=&quot;external&quot;&gt;')"/>
			<xsl:value-of disable-output-escaping="yes" select="$linkurl"/>
			<xsl:value-of disable-output-escaping="yes" select="$config/exampleHelp/linkText"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/a&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="oldversion">
		<xsl:if test="$showLangVersionWarnings='true' and not(count(versions/langversion))">
			<xsl:message>WARNING: no langversion for <xsl:if test="../../@name">
					<xsl:value-of select="../../@name"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</xsl:message>
		</xsl:if>
		<xsl:if test="$showPlayerVersionWarnings='true' and not(count(versions/playerversion))">
			<xsl:message>WARNING: no playerversion for <xsl:if test="../../@name">
					<xsl:value-of select="../../@name"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</xsl:message>
		</xsl:if>
		<xsl:if test="not($config/options/@showVersions) or $config/options[@showVersions!='false']">
			<xsl:if test="count(versions/langversion[not(starts-with(@version,'1'))]) or count(versions/playerversion)">
				<p/>
				<xsl:if test="count(versions/langversion[not(starts-with(@version,'1'))])">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="white-space:nowrap" valign="top">
								<b>
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">LanguageVersion</xsl:with-param>
									</xsl:call-template>
									<xsl:text disable-output-escaping="yes">:&amp;nbsp;</xsl:text>
								</b>
							</td>
							<td>
								<xsl:text>ActionScript </xsl:text>
								<xsl:value-of select="translate(versions/langversion/@version,'+','')"/>
								<xsl:if test="substring-before(versions/langversion/@version, '+')">
									<xsl:text> and later</xsl:text>
								</xsl:if>
								<xsl:if test="string-length(normalize-space(versions/langversion))">
									<xsl:value-of select="$emdash"/>
									<xsl:call-template name="deTilda">
										<xsl:with-param name="inText" select="normalize-space(versions/langversion)"/>
									</xsl:call-template>
								</xsl:if>
							</td>
						</tr>
					</table>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not($config/options/@showVersions) or $config/options[@showVersions!='false'] or $config/options[@showRuntimeVersions='true']">
				<xsl:if test="count(versions/playerversion)">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="white-space:nowrap" valign="top">
								<b>
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">RuntimeVersions</xsl:with-param>
									</xsl:call-template>
									<xsl:text disable-output-escaping="yes">:&amp;nbsp;</xsl:text>
								</b>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="versions/playerversion/@name='Flash'">
										<xsl:text>Flash Player </xsl:text>
									</xsl:when>
									<xsl:when test="versions/playerversion/@name='Lite'">
										<xsl:text>Flash Lite </xsl:text>
									</xsl:when>
								</xsl:choose>
								<xsl:value-of select="translate(translate(versions/playerversion/@version,'+',''),',','.')"/>
								<xsl:if test="substring-before(versions/playerversion/@version, '+')">
									<xsl:text> and later</xsl:text>
								</xsl:if>
								<xsl:if test="string-length(normalize-space(versions/playerversion))">
									<xsl:value-of select="$emdash"/>
									<xsl:call-template name="deTilda">
										<xsl:with-param name="inText" select="normalize-space(versions/playerversion)"/>
									</xsl:call-template>
								</xsl:if>
							</td>
						</tr>
					</table>
				</xsl:if>
				<p/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- TODO support multiple? -->
	<xsl:template name="version">
		<xsl:if test="$showLangVersionWarnings='true' and not(count(prolog/asMetadata/apiVersion/apiLanguage))">
			<xsl:message>WARNING: no langversion for <xsl:if test="../../apiName">
					<xsl:value-of select="../../apiName"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:value-of select="apiName"/>
			</xsl:message>
		</xsl:if>
		<xsl:if test="$showPlayerVersionWarnings='true' and not(count(prolog/asMetadata/apiVersion/apiPlatform))">
			<xsl:message>WARNING: no playerversion for <xsl:if test="../../apiName">
					<xsl:value-of select="../../apiName"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:value-of select="apiName"/>
			</xsl:message>
		</xsl:if>
		<xsl:if test="not($config/options/@showVersions) or $config/options[@showVersions!='false']">
			<xsl:if test="count(prolog/asMetadata/apiVersion[not(starts-with(./apiLanguage/@version,'1'))]) or count(./prolog/asMetadata/apiVersion/apiPlatform/@version)">
				<p/>
				<xsl:if test="prolog/asMetadata/apiVersion/apiLanguage/@version and count(prolog/asMetadata/apiVersion[not(starts-with(./apiLanguage/@version,'1'))])">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="white-space:nowrap" valign="top">
								<b>
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">LanguageVersion</xsl:with-param>
									</xsl:call-template>
									<xsl:text disable-output-escaping="yes">:&amp;nbsp;</xsl:text>
								</b>
							</td>
							<td>
								<xsl:text>ActionScript </xsl:text>
								<xsl:value-of select="translate(prolog/asMetadata/apiVersion/apiLanguage/@version,'+','')"/>
								<xsl:if test="substring-before(prolog/asMetadata/apiVersion/apiLanguage/@version, '+')">
									<xsl:text> and later</xsl:text>
								</xsl:if>
								<xsl:if test="string-length(normalize-space(prolog/asMetadata/apiVersion/apiLanguage))">
									<xsl:value-of select="$emdash"/>
									<xsl:call-template name="deTilda">
										<xsl:with-param name="inText" select="normalize-space(prolog/asMetadata/apiVersion/apiLanguage)"/>
									</xsl:call-template>
								</xsl:if>
							</td>
						</tr>
					</table>
				</xsl:if>
				<!--apiLanguage-->
				<!-- Product Version -->
				<xsl:if test="count(prolog/asMetadata/apiVersion/apiTool)">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="white-space:nowrap" valign="top">
								<b>
									<xsl:if test="count(prolog/asMetadata/apiVersion/apiTool) = 1">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">ProductVersion</xsl:with-param>
										</xsl:call-template>
										<xsl:text disable-output-escaping="yes">:&amp;nbsp;</xsl:text>
									</xsl:if>
									<xsl:if test="count(prolog/asMetadata/apiVersion/apiTool) &gt; 1">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">ProductVersions</xsl:with-param>
										</xsl:call-template>
										<xsl:text disable-output-escaping="yes">:&amp;nbsp;</xsl:text>
									</xsl:if>
								</b>
							</td>
							<td>
								<xsl:for-each select="prolog/asMetadata/apiVersion/apiTool">
									<xsl:variable name="ToolExpanded">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">
												<xsl:value-of select="@name"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$ToolExpanded">
											<xsl:value-of select="$ToolExpanded"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@name"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text> </xsl:text>
									<xsl:value-of select="translate(translate(@version,'+',''),',','.')"/>
									<xsl:if test="position() != last()">
										<xsl:text>,</xsl:text>
										<xsl:text> </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</td>
						</tr>
					</table>
				</xsl:if>
				<!--apiTool-->

				<!-- Since -->
				<xsl:if test="count(prolog/asMetadata/apiVersion/apiSince)">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="white-space:nowrap" valign="top">
								<b>
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">Since</xsl:with-param>
									</xsl:call-template>
									<xsl:text disable-output-escaping="yes">:&amp;nbsp;</xsl:text>
								</b>
							</td>
							<td>
								<xsl:for-each select="prolog/asMetadata/apiVersion/apiSince">
									<xsl:value-of select="translate(translate(@version,'+',''),',','.')"/>
									<xsl:if test="position() != last()">
										<xsl:text>,</xsl:text>
										<xsl:text> </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</td>
						</tr>
					</table>
				</xsl:if>
				<!--apiSince-->

			</xsl:if>
			<!--apiVersion-->
		</xsl:if>
		<!--showVersion-->
		<xsl:if test="not($config/options/@showVersions) or $config/options[@showVersions!='false'] or $config/options[@showRuntimeVersions='true']">
			<!-- Multiple Versions -->
			<xsl:if test="prolog/asMetadata/apiVersion[apiPlatform]">
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td style="white-space:nowrap" valign="top">
							<b>
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">RuntimeVersions</xsl:with-param>
								</xsl:call-template>
								<xsl:text disable-output-escaping="yes">:&amp;nbsp;</xsl:text>
							</b>
						</td>
						<td>
							<!-- Add default air 1.0 runtime -->
							<xsl:if test="count(prolog/asMetadata/apiVersion/apiPlatform) = 1 and (prolog/asMetadata/apiVersion/apiPlatform[@name='Flash'])">
								<xsl:text>AIR 1.0, </xsl:text>
							</xsl:if>
							<xsl:for-each select="prolog/asMetadata/apiVersion/apiPlatform">
								<xsl:choose>
									<xsl:when test="@name='Flash'">
										<xsl:text>Flash Player </xsl:text>
									</xsl:when>
									<xsl:when test="@name='AIR'">
										<xsl:text>AIR</xsl:text>
									</xsl:when>
									<xsl:when test="@name='Lite'">
										<xsl:text>Flash Lite </xsl:text>
									</xsl:when>
								</xsl:choose>
								<xsl:text> </xsl:text>
								<xsl:value-of select="translate(translate(@version,'+',''),',','.')"/>
								<xsl:if test="@description!=''">
									<xsl:text> </xsl:text>
									<xsl:text>-</xsl:text>
									<xsl:text> </xsl:text>
									<xsl:value-of select="normalize-space(@description)"/>
                                </xsl:if>
								<xsl:if test="substring-before(string-join(@version, ''), '+')">
									<xsl:text> and later</xsl:text>
								</xsl:if>
								<xsl:if test="position() != last()">
									<xsl:text>,</xsl:text>
									<xsl:text> </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</table>
			</xsl:if>
			<!--apiPlatform-->
			<p/>
		</xsl:if>
		<!--showVersions / showRuntimeVersions-->
	</xsl:template>
	<xsl:template name="isTopLevel">
		<xsl:param name="packageName"/>
		<xsl:value-of select="string-length($packageName)=0 or contains($packageName,'__Global__')"/>
	</xsl:template>
	<xsl:template name="getPackageComments">
		<xsl:param name="name"/>
		<xsl:element name="package">
			<xsl:copy-of select="document($packageCommentsFilename)/packages/package[@name=$name]"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="getLinkFromId">
		<xsl:param name="id" select="''"/>
		<xsl:param name="currentPackage" select="''"/>
		<xsl:param name="memberName" select="''"/>
		<xsl:if test="string-length($id) &gt; 0">
			<xsl:variable name="classNameText" select="substring-after($id,':')"/>
			<xsl:variable name="packageNameText" select="substring-before($id,':')"/>
			<xsl:variable name="packageName">
				<xsl:choose>
					<xsl:when test="not(contains($packageNameText,'.'))">
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
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before($id,':')"/>
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
			<xsl:variable name="hPath">
				<xsl:call-template name="getHyperlinkPath">
					<xsl:with-param name="destination" select="concat($packageName,':',$className)"/>
					<xsl:with-param name="currentPackage" select="$currentPackage"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="completeHLink">
				<xsl:if test="string-length($methodName) &gt; 0">
					<xsl:choose>
						<xsl:when test="contains($methodName,':')">
							<xsl:value-of select="concat($hPath,'#',substring-before($methodName,':'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($hPath,'#',$methodName)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of select="$completeHLink"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getClassLinkFromId">
		<xsl:param name="id" select="''"/>
		<xsl:param name="currentPackage" select="''"/>
		<xsl:if test="string-length($id) &gt; 0">
			<xsl:variable name="classNameText" select="substring-after($id,':')"/>
			<xsl:variable name="packageNameText" select="substring-before($id,':')"/>
			<xsl:variable name="packageName">
				<xsl:choose>
					<xsl:when test="not(contains($packageNameText,'.'))">
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
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before($id,':')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="hPath">
				<xsl:call-template name="getHyperlinkPath">
					<xsl:with-param name="destination" select="concat($packageName,':',$className)"/>
					<xsl:with-param name="currentPackage" select="$currentPackage"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$hPath"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getClassNameFromId">
		<xsl:param name="id" select="''"/>
		<xsl:if test="string-length($id) &gt; 0">
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
			<xsl:value-of select="$className"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="styleTypeHyperlink">
		<xsl:param name="type" select="''"/>
		<xsl:param name="currentPackage" select="''"/>
		<xsl:if test="$type">
			<xsl:variable name="relativePath">
				<xsl:call-template name="getRelativePath">
					<xsl:with-param name="currentPath" select="$currentPackage"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="hyperLink">
				<xsl:choose>
					<xsl:when test="not(contains($type,'.'))">
						<xsl:value-of select="concat($relativePath,$type,'.html')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="package">
							<xsl:call-template name="substring-before-last">
								<xsl:with-param name="input" select="$type"/>
								<xsl:with-param name="substr" select="'.'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="class">
							<xsl:call-template name="substring-after-last">
								<xsl:with-param name="input" select="$type"/>
								<xsl:with-param name="substr" select="'.'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="concat($relativePath,translate($package,'.','/'),'/',$class,'.html')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="$hyperLink"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getEventClassLinkFromId">
		<xsl:param name="id" select="''"/>
		<xsl:param name="currentPackage" select="''"/>
		<xsl:if test="string-length($id) &gt; 0">
			<xsl:variable name="text" select="substring-before($id,'_')"/>
			<xsl:variable name="className" select="substring-after($text,':')"/>
			<xsl:variable name="packageName" select="substring-before($text,':')"/>
			<xsl:variable name="hPath">
				<xsl:call-template name="getHyperlinkPath">
					<xsl:with-param name="destination" select="concat($packageName,':',$className)"/>
					<xsl:with-param name="currentPackage" select="$currentPackage"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$hPath"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getEventClassNameFromId">
		<xsl:param name="currentPackage"/>
		<xsl:param name="id" select="''"/>
		<xsl:if test="string-length($id) &gt; 0">
			<xsl:variable name="text" select="substring-before($id,'_')"/>
			<xsl:variable name="className" select="substring-after($text,':')"/>
			<xsl:value-of select="$className"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getConRefText">
		<xsl:param name="conref"/>
		<xsl:param name="descriptionType"/>
		<xsl:param name="entryType"/>
		<xsl:param name="doNotProcessTags" select="false()"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:if test="string-length($conref) &gt; 0">
			<xsl:variable name="relativePath">
				<xsl:call-template name="getRelativePath">
					<xsl:with-param name="currentPath" select="$currentPackage"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="packageClassText">
				<xsl:if test="contains($conref,'#') and contains(substring-before($conref,'#'),'.')">
					<xsl:value-of select="substring-before($conref,'#')"/>
				</xsl:if>
				<xsl:if test="contains($conref,'#') and not(contains(substring-before($conref,'#'),'.'))">
					<xsl:value-of select="concat($currentPackage,'.',substring-before($conref,'#'))"/>
				</xsl:if>
				<xsl:if test="not(contains($conref,'#'))">
					<xsl:value-of select="$conref"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="className">
				<xsl:if test="contains($conref,'#') and contains(substring-before($conref,'#'),'.')">
					<xsl:call-template name="lastIndexOf">
						<xsl:with-param name="string" select="$packageClassText"/>
						<xsl:with-param name="char" select="'.'"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="contains($conref,'#') and not(contains(substring-before($conref,'#'),'.'))">
					<xsl:if test="string-length(substring-before($conref,'#')) = 0">
						<xsl:value-of select="ancestor-or-self::apiPackage/apiClassifier/apiName"/>
					</xsl:if>
					<xsl:if test="string-length(substring-before($conref,'#')) &gt; 0">
						<xsl:value-of select="substring-before($conref,'#')"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="destPackageName1">
				<xsl:value-of select="substring-before($packageClassText,concat('.',$className))"/>
			</xsl:variable>
			<xsl:variable name="destPackageName">
				<xsl:if test="$destPackageName1 = '' or $destPackageName1='__Global__'">
					<xsl:value-of select="'__Global__.xml'"/>
				</xsl:if>
				<xsl:if test="not($destPackageName1='') and not($destPackageName1='__Global__')">
					<xsl:value-of select="concat($destPackageName1, '.xml')"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="entryTypeNameText" select="substring-after($conref,'#')"/>
			<xsl:variable name="nameToMatch">
				<xsl:if test="string-length($entryTypeNameText) = 0">
					<xsl:value-of select="$className"/>
				</xsl:if>
				<xsl:if test="contains($entryTypeNameText,':')">
					<xsl:value-of select="substring-after($entryTypeNameText,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($entryTypeNameText,':')) and string-length($entryTypeNameText) &gt; 0">
					<xsl:if test="contains($entryTypeNameText,')')">
						<xsl:value-of select="substring-before($entryTypeNameText,'(')"/>
					</xsl:if>
					<xsl:if test="not(contains($entryTypeNameText,')'))">
						<xsl:value-of select="$entryTypeNameText"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="entryType">
				<xsl:if test="string-length($entryTypeNameText) = 0">
					<xsl:value-of select="'class'"/>
				</xsl:if>
				<xsl:if test="contains($entryTypeNameText,':')">
					<xsl:value-of select="substring-before($entryTypeNameText,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($entryTypeNameText,':')) and string-length($entryTypeNameText) &gt; 0">
					<xsl:if test="contains($entryTypeNameText,')')">
						<xsl:value-of select="'method'"/>
					</xsl:if>
					<xsl:if test="not(contains($entryTypeNameText,')'))">
						<xsl:value-of select="'property'"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="string-length(normalize-space($destPackageName)) = 4">
				<xsl:message> CAlling class : <xsl:value-of select="ancestor-or-self::apiClassifier/apiName"/> currentpackage : <xsl:value-of select="ancestor-or-self::apiPackage/apiName"/> Entry Type : <xsl:value-of
						select="$entryType"/> Entry Type Text:		<xsl:value-of select="$entryTypeNameText"/> descriptionType : <xsl:value-of select="$descriptionType"/> Conref : <xsl:value-of select="$conref"
						/> nameToMatch : <xsl:value-of select="$nameToMatch"/> Class Name : <xsl:value-of select="$className"/>	packageClassText Name : <xsl:value-of select="$packageClassText"
						/> destPackageName Name : <xsl:value-of select="$destPackageName"/>
				</xsl:message>
			</xsl:if>
			<xsl:for-each select="document(concat($ditaFileDir,$destPackageName))/apiPackage//apiClassifier[apiName=$className]">
				<xsl:if test="string-length($entryType) &gt; 0">
					<xsl:choose>
						<xsl:when test="contains($entryType,'class')">
							<xsl:choose>
								<xsl:when test="$descriptionType='shortdesc'">
									<xsl:if test="./shortdesc[@conref]">
										<xsl:call-template name="getConRefText">
											<xsl:with-param name="conref" select="./shortdesc/@conref"/>
											<xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="not(./shortdesc[@conref])">
										<xsl:for-each select="./shortdesc/.">
											<xsl:if test="$doNotProcessTags">
												<xsl:value-of select="."/>
											</xsl:if>
											<xsl:if test="not ($doNotProcessTags)">
												<xsl:call-template name="processTags"/>
											</xsl:if>
										</xsl:for-each>
									</xsl:if>
								</xsl:when>
								<xsl:when test="$descriptionType='apiDesc'">
									<xsl:if test="./apiClassifierDetail/apiDesc[@conref]">
										<xsl:call-template name="getConRefText">
											<xsl:with-param name="conref" select="./apiClassifierDetail/apiDesc/@conref"/>
											<xsl:with-param name="descriptionType" select="local-name(./apiClassifierDetail/apiDesc)"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="not(./apiClassifierDetail/apiDesc[@conref])">
										<xsl:for-each select="./apiClassifierDetail/apiDesc">
											<xsl:if test="$doNotProcessTags">
												<xsl:value-of select="."/>
											</xsl:if>
											<xsl:if test="not ($doNotProcessTags)">
												<xsl:call-template name="processTags"/>
											</xsl:if>
										</xsl:for-each>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="./description[@conref]">
										<xsl:call-template name="getConRefText">
											<xsl:with-param name="conref" select="./description/@conref"/>
											<xsl:with-param name="descriptionType" select="local-name(./description)"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="not(./description[@conref])">
										<xsl:for-each select="./description">
											<xsl:if test="$doNotProcessTags">
												<xsl:value-of select="."/>
											</xsl:if>
											<xsl:if test="not ($doNotProcessTags)">
												<xsl:call-template name="processTags"/>
											</xsl:if>
										</xsl:for-each>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="contains($entryType,'style')">
							<xsl:for-each select="./prolog/asMetadata/styles/style[@name=$nameToMatch]">
								<xsl:choose>
									<xsl:when test="$descriptionType='shortdesc'">
										<xsl:if test="./shortdesc[@conref]">
											<xsl:call-template name="getConRefText">
												<xsl:with-param name="conref" select="./shortdesc/@conref"/>
												<xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="not(./shortdesc[@conref])">
											<xsl:for-each select="./shortdesc/.">
												<xsl:if test="$doNotProcessTags">
													<xsl:value-of select="."/>
												</xsl:if>
												<xsl:if test="not ($doNotProcessTags)">
													<xsl:call-template name="processTags"/>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="./description[@conref]">
											<xsl:call-template name="getConRefText">
												<xsl:with-param name="conref" select="./description/@conref"/>
												<xsl:with-param name="descriptionType" select="local-name(./description)"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="not(./description[@conref])">
											<xsl:for-each select="./description">
												<xsl:if test="$doNotProcessTags">
													<xsl:value-of select="."/>
												</xsl:if>
												<xsl:if test="not ($doNotProcessTags)">
													<xsl:call-template name="processTags"/>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains($entryType,'event')">
							<xsl:for-each select=".//adobeApiEvent[apiName=$nameToMatch]">
								<xsl:choose>
									<xsl:when test="$descriptionType='shortdesc'">
										<xsl:if test="./shortdesc[@conref]">
											<xsl:call-template name="getConRefText">
												<xsl:with-param name="conref" select="./shortdesc/@conref"/>
												<xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="not(./shortdesc[@conref])">
											<xsl:for-each select="./shortdesc/.">
												<xsl:if test="$doNotProcessTags">
													<xsl:value-of select="."/>
												</xsl:if>
												<xsl:if test="not ($doNotProcessTags)">
													<xsl:call-template name="processTags"/>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="./adobeApiEventDetail/apiDesc[@conref]">
											<xsl:call-template name="getConRefText">
												<xsl:with-param name="conref" select="./adobeApiEventDetail/apiDesc/@conref"/>
												<xsl:with-param name="descriptionType" select="local-name(./adobeApiEventDetail/apiDesc)"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="not(./adobeApiEventDetail/apiDesc[@conref])">
											<xsl:for-each select="./adobeApiEventDetail/apiDesc">
												<xsl:if test="$doNotProcessTags">
													<xsl:value-of select="."/>
												</xsl:if>
												<xsl:if test="not ($doNotProcessTags)">
													<xsl:call-template name="processTags"/>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains($entryType,'method')">
							<xsl:for-each select="./apiOperation[apiName=$nameToMatch]">
								<xsl:choose>
									<xsl:when test="$descriptionType='shortdesc'">
										<xsl:if test="./shortdesc[@conref]">
											<xsl:call-template name="getConRefText">
												<xsl:with-param name="conref" select="./shortdesc/@conref"/>
												<xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="not(./shortdesc[@conref])">
											<xsl:for-each select="./shortdesc/.">
												<xsl:if test="$doNotProcessTags">
													<xsl:value-of select="."/>
												</xsl:if>
												<xsl:if test="not ($doNotProcessTags)">
													<xsl:call-template name="processTags"/>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="./apiOperationDetail/apiDesc[@conref]">
											<xsl:call-template name="getConRefText">
												<xsl:with-param name="conref" select="./apiOperationDetail/apiDesc/@conref"/>
												<xsl:with-param name="descriptionType" select="local-name(./apiOperationDetail/apiDesc)"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="not(./apiOperationDetail/apiDesc[@conref])">
											<xsl:for-each select="./apiOperationDetail/apiDesc">
												<xsl:if test="$doNotProcessTags">
													<xsl:value-of select="."/>
												</xsl:if>
												<xsl:if test="not ($doNotProcessTags)">
													<xsl:call-template name="processTags"/>
												</xsl:if>
											</xsl:for-each>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="contains($entryType,'property')">
							<xsl:choose>
				                <xsl:when test="count(./apiValue[apiName=$nameToMatch]) &gt; 0">
				                  <xsl:for-each select="./apiValue[apiName=$nameToMatch]">
				                    <xsl:choose>
				                      <xsl:when test="$descriptionType='shortdesc'">
				                        <xsl:if test="./shortdesc[@conref]">
				                          <xsl:call-template name="getConRefText">
				                            <xsl:with-param name="conref" select="./shortdesc/@conref"/>
				                            <xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
				                          </xsl:call-template>
				                        </xsl:if>
				                        <xsl:if test="not(./shortdesc[@conref])">
				                          <xsl:for-each select="./shortdesc/.">
				                            <xsl:if test="$doNotProcessTags">
				                              <xsl:value-of select="."/>
				                            </xsl:if>
				                            <xsl:if test="not($doNotProcessTags)">
				                              <xsl:call-template name="processTags"/>
				                            </xsl:if>
				                          </xsl:for-each>
				                        </xsl:if>
				                      </xsl:when>
				                      <xsl:otherwise>
				                        <xsl:if test="./apiValueDetail/apiDesc[@conref]">
				                          <xsl:call-template name="getConRefText">
				                            <xsl:with-param name="conref" select="./apiValueDetail/apiDesc/@conref"/>
				                            <xsl:with-param name="descriptionType" select="local-name(./apiValueDetail/apiDesc)"/>
				                          </xsl:call-template>
				                        </xsl:if>
				                        <xsl:if test="not(./apiValueDetail/apiDesc[@conref])">
				                          <xsl:for-each select="./apiValueDetail/apiDesc">
				                            <xsl:if test="$doNotProcessTags">
				                              <xsl:value-of select="."/>
				                            </xsl:if>
				                            <xsl:if test="not($doNotProcessTags)">
				                              <xsl:call-template name="processTags"/>
				                            </xsl:if>
				                          </xsl:for-each>
				                        </xsl:if>
				                      </xsl:otherwise>
				                    </xsl:choose>
				                  </xsl:for-each>                  
				                </xsl:when>
				                <xsl:when test="count(./prolog/asMetadata/skinParts/SkinPart[@name=$nameToMatch]) &gt; 0">
				                  <xsl:for-each select="./prolog/asMetadata/skinParts/SkinPart[@name=$nameToMatch]">
				                    <xsl:choose>
				                      <xsl:when test="$descriptionType='shortdesc'">
				                        <xsl:if test="./shortdesc[@conref]">
				                          <xsl:call-template name="getConRefText">
				                            <xsl:with-param name="conref" select="./shortdesc/@conref"/>
				                            <xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
				                          </xsl:call-template>
				                        </xsl:if>
				                        <xsl:if test="not(./shortdesc[@conref])">
				                          <xsl:for-each select="./shortdesc/.">
				                            <xsl:if test="$doNotProcessTags">
				                              <xsl:value-of select="."/>
				                            </xsl:if>
				                            <xsl:if test="not($doNotProcessTags)">
				                              <xsl:call-template name="processTags"/>
				                            </xsl:if>
				                          </xsl:for-each>
				                        </xsl:if>
				                      </xsl:when>
				                      <xsl:otherwise>
				                        <xsl:if test="./description[@conref]">
				                          <xsl:call-template name="getConRefText">
				                            <xsl:with-param name="conref" select="./description/@conref"/>
				                            <xsl:with-param name="descriptionType" select="local-name(./description)"/>
				                          </xsl:call-template>
				                        </xsl:if>
				                        <xsl:if test="not(./description[@conref])">
				                          <xsl:for-each select="./description">
				                            <xsl:if test="$doNotProcessTags">
				                              <xsl:value-of select="."/>
				                            </xsl:if>
				                            <xsl:if test="not($doNotProcessTags)">
				                              <xsl:call-template name="processTags"/>
				                            </xsl:if>
				                          </xsl:for-each>
				                        </xsl:if>
				                      </xsl:otherwise>
				                    </xsl:choose>
				                  </xsl:for-each>
				                </xsl:when>
				              </xsl:choose>						
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$descriptionType='shortdesc'">
									<xsl:if test="./shortdesc[@conref]">
										<xsl:call-template name="getConRefText">
											<xsl:with-param name="conref" select="./shortdesc/@conref"/>
											<xsl:with-param name="descriptionType" select="local-name(./shortdesc)"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="not(./shortdesc[@conref])">
										<xsl:for-each select="./shortdesc/.">
											<xsl:if test="$doNotProcessTags">
												<xsl:value-of select="."/>
											</xsl:if>
											<xsl:if test="not ($doNotProcessTags)">
												<xsl:call-template name="processTags"/>
											</xsl:if>
										</xsl:for-each>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="./apiClassifierDetail/apiDesc[@conref]">
										<xsl:call-template name="getConRefText">
											<xsl:with-param name="conref" select="./apiClassifierDetail/apiDesc/@conref"/>
											<xsl:with-param name="descriptionType" select="local-name(./apiClassifierDetail/apiDesc)"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="not(./apiClassifierDetail/apiDesc[@conref])">
										<xsl:for-each select="./apiClassifierDetail/apiDesc">
											<xsl:if test="$doNotProcessTags">
												<xsl:value-of select="."/>
											</xsl:if>
											<xsl:if test="not ($doNotProcessTags)">
												<xsl:call-template name="processTags"/>
											</xsl:if>
										</xsl:for-each>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="doesClassExist">
		<xsl:param name="class_name"/>
		<xsl:variable name="xslDocPath">
			<xsl:choose>
				<xsl:when test="contains($class_name,':') and  substring-before($class_name,':') != '' ">
					<xsl:value-of select="substring-before($class_name,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'__Global__'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="className">
			<xsl:if test="contains($class_name,':')">
				<xsl:value-of select="substring-after($class_name,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($class_name,':'))">
				<xsl:value-of select="$class_name"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::allClasses/apiPackage[@id=$xslDocPath]/apiClassifier[@id=$class_name or apiName=$class_name or apiName=$className]">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>0</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getHyperlinkPath">
		<xsl:param name="destination"/>
		<xsl:param name="currentPackage"/>
		<xsl:if test="string-length($destination) &gt; 0">
			<xsl:variable name="doesClassExist">
				<xsl:call-template name="doesClassExist">
					<xsl:with-param name="class_name" select="$destination"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$doesClassExist = '1'">
				<xsl:variable name="relativePath">
					<xsl:call-template name="getRelativePath">
						<xsl:with-param name="currentPath" select="$currentPackage"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="className">
					<xsl:if test="contains($destination,':')">
						<xsl:value-of select="substring-after($destination,':')"/>
					</xsl:if>
					<xsl:if test="not(contains($destination,':'))">
						<xsl:if test="not(contains($destination,'.'))">
							<xsl:value-of select="$destination"/>
						</xsl:if>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="packageName">
					<xsl:if test="contains($destination,':')">
						<xsl:value-of select="substring-before($destination,':')"/>
					</xsl:if>
					<xsl:if test="not(contains($destination,':'))">
						<xsl:if test="contains($destination,'.')">
							<xsl:value-of select="$destination"/>
						</xsl:if>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="string-length($packageName) &gt; 0">
					<xsl:if test="string-length($className) &gt; 0">
						<xsl:value-of select="concat($relativePath,translate($packageName,'.','/'),'/',$className,'.html')"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="string-length($packageName) = 0">
					<xsl:if test="string-length($className) &gt; 0">
						<xsl:value-of select="concat($relativePath,$className,'.html')"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$doesClassExist != '1'"> </xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getHyperlinkRef">
		<xsl:param name="destination"/>
		<xsl:param name="baseRef"/>
		<xsl:if test="string-length($destination) &gt; 0">
			<xsl:variable name="className">
				<xsl:if test="contains($destination,':')">
					<xsl:value-of select="substring-after($destination,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($destination,':'))">
					<xsl:value-of select="$destination"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="packageName">
				<xsl:if test="contains($destination,':')">
					<xsl:value-of select="substring-before($destination,':')"/>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="string-length($packageName) &gt; 0">
				<xsl:if test="string-length($className) &gt; 0">
					<xsl:value-of select="concat($baseRef,translate($packageName,'.','/'),'/',$className,'.html')"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="string-length($packageName) = 0">
				<xsl:if test="string-length($className) &gt; 0">
					<xsl:value-of select="concat($baseRef,$className,'.html')"/>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getEventHyperlink">
		<xsl:param name="destination"/>
		<xsl:param name="currentPackage"/>
		<xsl:if test="string-length($destination) &gt; 0">

			<xsl:variable name="className">
				<xsl:call-template name="lastIndexOf">
					<xsl:with-param name="string" select="$destination"/>
					<xsl:with-param name="char" select="'.'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="packageName">
				<xsl:if test="contains($destination,'.')">
					<xsl:value-of select="substring-before($destination,concat('.',$className))"/>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="classHeader_map" select="document('ClassHeader.xml')//apiPackage"/>
			<xsl:if test="contains($destination,'.')">
				<xsl:if test="count($classHeader_map//apiClassifier[@id=concat($packageName,':',$className)] ) &gt; 0">

					<xsl:variable name="relativePath">
						<xsl:call-template name="getRelativePath">
							<xsl:with-param name="currentPath" select="$currentPackage"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="string-length($packageName) &gt; 0">
						<xsl:if test="string-length($className) &gt; 0">
							<xsl:choose>
								<xsl:when test="$prog_language_name!='javascript'">
									<xsl:value-of select="concat($relativePath,translate($packageName,'.','/'),'/',$className,'.html')"/>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:if>
					</xsl:if>
					<xsl:if test="string-length($packageName) = 0">
						<xsl:if test="string-length($className) &gt; 0">
							<xsl:value-of select="concat($relativePath,$className,'.html')"/>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not(contains($destination,'.'))">
				<xsl:if test="count($classHeader_map//apiClassifier[@id=concat('globalClassifier:',$className)] ) &gt; 0">

					<xsl:variable name="relativePath">
						<xsl:call-template name="getRelativePath">
							<xsl:with-param name="currentPath" select="$currentPackage"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="string-length($packageName) &gt; 0">
						<xsl:if test="string-length($className) &gt; 0">
							<xsl:choose>
								<xsl:when test="$prog_language_name!='javascript'">
									<xsl:value-of select="concat($relativePath,translate($packageName,'.','/'),'/',$className,'.html')"/>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:if>
					</xsl:if>
					<xsl:if test="string-length($packageName) = 0">
						<xsl:if test="string-length($className) &gt; 0">
							<xsl:value-of select="concat($relativePath,$className,'.html')"/>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:if>

		</xsl:if>
	</xsl:template>
	<xsl:template name="getEventTypeHyperlink">
		<xsl:param name="destination"/>
		<xsl:param name="currentPackage"/>
		<xsl:if test="string-length($destination) &gt; 0">
			<xsl:variable name="relativePath">
				<xsl:call-template name="getRelativePath">
					<xsl:with-param name="currentPath" select="$currentPackage"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="lastToken">
				<xsl:call-template name="lastIndexOf">
					<xsl:with-param name="string" select="$destination"/>
					<xsl:with-param name="char" select="'.'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="firstPassToken" select="substring-before($destination,concat('.',$lastToken))"/>
			<xsl:variable name="eventTypeLink">
				<xsl:if test="document(concat($ditaFileDir,'packages.dita'))/apiMap//apiItemRef[substring-before(@href,'xml')=$firstPassToken]">
					<xsl:value-of select="concat($relativePath,translate($firstPassToken,'.','/'),'.html')"/>
				</xsl:if>
				<xsl:if test="not(document(concat($ditaFileDir,'packages.dita'))/apiMap//apiItemRef[substring-before(@href,'.xml')=$firstPassToken])">
					<xsl:choose>
						<xsl:when test="$prog_language_name!='javascript'">
							<xsl:value-of select="concat($relativePath,translate($firstPassToken,'.','/'),'.html#',$lastToken)"/>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of select="$eventTypeLink"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getEventDescription">
		<xsl:param name="destination"/>
		<xsl:param name="descriptionType" select="'apiDesc'"/>
		<xsl:if test="string-length($destination) &gt; 0">
			<xsl:variable name="lastToken">
				<xsl:call-template name="lastIndexOf">
					<xsl:with-param name="string" select="$destination"/>
					<xsl:with-param name="char" select="'.'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="firstPassToken" select="substring-before($destination,concat('.',$lastToken))"/>
			<xsl:variable name="firstPassCount" select="count(document(concat($ditaFileDir,'packages.dita'))/apiMap//apiItemRef[@href=concat($firstPassToken,'.xml')])"/>
			<xsl:if test="$firstPassCount &gt; 0">
				<xsl:variable name="packageName" select="$firstPassToken"/>
				<xsl:variable name="className" select="$lastToken"/>
				<xsl:for-each select="document(concat($ditaFileDir,$packageName,'.xml'))/apiPackage//apiClassifier[apiName=$className]">
					<xsl:choose>
						<xsl:when test="$descriptionType='apiDesc'">
							<xsl:for-each select="./apiValueDetail/apiDesc">
								<xsl:call-template name="processTags"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="./apiValueDetail/shortdesc">
								<xsl:call-template name="processTags"/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="not($firstPassCount &gt; 0)">
				<xsl:variable name="eventName" select="$lastToken"/>
				<xsl:variable name="className">
					<xsl:call-template name="lastIndexOf">
						<xsl:with-param name="string" select="$firstPassToken"/>
						<xsl:with-param name="char" select="'.'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="packageName" select="substring-before($firstPassToken,concat('.',$className))"/>
				<xsl:for-each select="document(concat($ditaFileDir,$packageName,'.xml'))/apiPackage//apiClassifier[apiName=$className]">
					<xsl:for-each select=".//apiValue[apiName=$eventName and not(apiValueDetail/apiValueDef/apiProperty)]">
						<xsl:choose>
							<xsl:when test="$descriptionType='apiDesc'">
								<xsl:for-each select="./apiValueDetail/apiDesc">
									<xsl:call-template name="processTags"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="./shortdesc">
									<xsl:call-template name="processTags"/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="lastIndexOf">
		<xsl:param name="string"/>
		<xsl:param name="char"/>
		<xsl:choose>
			<xsl:when test="contains($string, $char)">
				<xsl:call-template name="lastIndexOf">
					<xsl:with-param name="string" select="substring-after($string, $char)"/>
					<xsl:with-param name="char" select="$char"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getFirstSentence">
		<xsl:param name="inText"/>
		<xsl:variable name="text" select="normalize-space($inText)"/>
		<xsl:variable name="periodWithTag">
			<xsl:text disable-output-escaping="yes">.&lt;</xsl:text>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($text) = 0"/>
			<xsl:when test="substring-before($text,'. ')">
				<xsl:value-of select="substring-before($text,'. ')" disable-output-escaping="yes"/>.</xsl:when>
			<xsl:when test="substring-before($text,$periodWithTag)">
				<xsl:value-of select="substring-before($inText,$periodWithTag)" disable-output-escaping="yes"/>.</xsl:when>
			<xsl:when test="substring-before($text,'.')">
				<xsl:value-of select="substring-before($text,'.')" disable-output-escaping="yes"/>.</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" disable-output-escaping="yes"/>.</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="deTilda">
		<xsl:param name="inText"/>
		<xsl:variable name="text">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="search-string" select="'~~'"/>
				<xsl:with-param name="replace-string" select="'*'"/>
				<xsl:with-param name="input">
					<xsl:call-template name="convertListing">
						<xsl:with-param name="inText" select="$inText"/>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="text2">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="search-string" select="'TAAB'"/>
				<xsl:with-param name="replace-string" select="'    '"/>
				<xsl:with-param name="input" select="$text"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$text2" disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template name="listingIcon">
		<xsl:param name="version"/>
		<xsl:variable name="conditionalText">
			<xsl:choose>
				<xsl:when test="number($version)=3">
					<xsl:text>3.gif' alt='</xsl:text>
					<xsl:value-of select="$AS3tooltip"/>
					<xsl:text>' title='</xsl:text>
					<xsl:value-of select="$AS3tooltip"/>
				</xsl:when>
				<xsl:when test="number($version)=2">
					<xsl:text>2.gif' alt='</xsl:text>
					<xsl:value-of select="$AS2tooltip"/>
					<xsl:text>' title='</xsl:text>
					<xsl:value-of select="$AS2tooltip"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>1.gif' alt='</xsl:text>
					<xsl:value-of select="$AS1tooltip"/>
					<xsl:text>' title='</xsl:text>
					<xsl:value-of select="$AS1tooltip"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:text disable-output-escaping="yes">&lt;img src='</xsl:text>
		<xsl:call-template name="getBaseRef">
			<xsl:with-param name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
		</xsl:call-template>
		<xsl:text>images/AS</xsl:text>
		<xsl:value-of select="$conditionalText"/>
		<xsl:text>' width='96' height='15' style='margin-right:5px' /&gt;</xsl:text>
	</xsl:template>
	<xsl:template name="convertListing">
		<xsl:param name="inText" select="''"/>
		<xsl:if test="not(contains($inText,'&lt;listing'))">
			<xsl:value-of select="$inText"/>
		</xsl:if>
		<xsl:if test="contains($inText,'&lt;listing')">
			<xsl:value-of select="substring-before($inText,'&lt;listing')"/>
			<xsl:if test="$showASIcons='true'">
				<xsl:text disable-output-escaping="yes">&lt;div class='listingIcons'&gt;</xsl:text>
				<xsl:choose>
					<xsl:when test="contains(substring-before($inText,'&lt;/listing&gt;'),'version=&quot;3')">
						<xsl:call-template name="listingIcon">
							<xsl:with-param name="version" select="3"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="contains(substring-before($inText,'&lt;/listing&gt;'),'version=&quot;2')">
						<xsl:call-template name="listingIcon">
							<xsl:with-param name="version" select="2"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="listingIcon">
							<xsl:with-param name="version" select="1"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
			</xsl:if>
			<xsl:variable name="remainder" select="substring-after(substring-after($inText,'&lt;listing'),'&gt;')"/>
			<xsl:text disable-output-escaping="yes">&lt;div class='listing'&gt;&lt;pre&gt;</xsl:text>
			<xsl:value-of select="substring-before($remainder,'&lt;/listing&gt;')"/>
			<xsl:text disable-output-escaping="yes">&lt;/pre&gt;&lt;/div&gt;</xsl:text>
			<xsl:call-template name="convertListing">
				<xsl:with-param name="inText" select="substring-after($remainder,'&lt;/listing&gt;')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getKeywords">
		<xsl:variable name="keywords">
			<!-- TODO use defined keywords after scrub? -->
			<xsl:if test=".//Xkeyword">
				<xsl:for-each select=".//keyword">
					<xsl:value-of select="normalize-space()"/>
					<xsl:text>, </xsl:text>
				</xsl:for-each>
			</xsl:if>
			<xsl:value-of select="./apiName"/>
			<xsl:if test="string-length(../apiName)">
				<xsl:text>,</xsl:text>
				<xsl:call-template name="convertFullName">
					<xsl:with-param name="fullname" select="@id"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="apiValue">
				<xsl:text>,</xsl:text>
				<xsl:for-each select="//apiValue">
					<xsl:value-of select="./apiName"/>
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="apiOperation">
				<xsl:text>,</xsl:text>
				<xsl:for-each select="//apiOperation">
					<xsl:value-of select="./apiName"/>
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		<meta name="keywords" content="{$keywords}"/>
	</xsl:template>
	<xsl:template name="convertClassifierLink">
		<xsl:param name="fullname"/>
		<xsl:variable name="className">
			<xsl:if test="contains($fullname,':')">
				<xsl:value-of select="substring-after($fullname,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($fullname,':'))">
				<xsl:value-of select="$fullname"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="packageName">
			<xsl:if test="contains($fullname,':')">
				<xsl:value-of select="substring-before($fullname,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($fullname,':'))">
				<xsl:value-of select="''"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="hyperLink">
			<xsl:if test="string-length($packageName) &gt; 0 and string-length($className) &gt; 0">
				<xsl:value-of select="concat('./',translate($packageName,'.','/'),'/',$className,'.html')"/>
			</xsl:if>
			<xsl:if test="string-length($packageName) = 0 and string-length($className) &gt; 0">
				<xsl:value-of select="concat('./',$className,'.html')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="$hyperLink"/>
	</xsl:template>
	<xsl:template name="convertFullName">
		<xsl:param name="fullname"/>
		<xsl:param name="separator">.</xsl:param>
		<xsl:param name="justClass">false</xsl:param>
		<xsl:variable name="trimmed">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="input" select="$fullname"/>
				<xsl:with-param name="search-string">:public</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="trimmed2">
			<xsl:call-template name="search-and-replace">
				<xsl:with-param name="input" select="$trimmed"/>
				<xsl:with-param name="search-string">:internal</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="trimmed3" select="translate($trimmed2,':','.')"/>
		<xsl:choose>
			<xsl:when test="$justClass = 'true'">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="translate($trimmed3,'/','.')"/>
					<xsl:with-param name="substr">.</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($trimmed3,'/')">
				<!-- inner class -->
				<xsl:value-of select="translate(substring-before($trimmed3,'/'),'.',$separator)"/>
				<xsl:text>.</xsl:text>
				<xsl:variable name="trimmed4" select="substring-after($trimmed3,'/')"/>
				<xsl:if test="contains($trimmed4,'.')">
					<xsl:variable name="trimmed5">
						<xsl:call-template name="substring-after-last">
							<xsl:with-param name="input" select="$trimmed4"/>
							<xsl:with-param name="substr" select="'.'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="translate($trimmed5,'.',$separator)"/>
				</xsl:if>
				<xsl:if test="not(contains($trimmed4,'.'))">
					<xsl:value-of select="translate($trimmed4,'.',$separator)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate($trimmed3,'.',$separator)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="buildInheritanceTree">
		<xsl:param name="package"/>
		<xsl:variable name="iconRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$package"/>
			</xsl:call-template>
			<xsl:text>images/</xsl:text>
			<xsl:value-of select="$inheritanceIcon"/>
		</xsl:variable>
		<pre>
			<script type="text/javascript">var tabCount=3;</script>
			<xsl:variable name="objType" select="@type"/>
			<xsl:variable name="className" select="@name"/>
			<xsl:for-each select="asAncestors/asAncestor">
				<xsl:sort select="position()" order="descending" data-type="number"/>
				<!-- TODO remove hack when interfaces no longer inherit from Object and Object no longer inherits from itself -->
				<xsl:if test="(position()=1) and ($className!='Object')">
					<a href="{classRef/@relativePath}">
						<xsl:call-template name="convertFullName">
							<xsl:with-param name="fullname" select="classRef/@fullName"/>
						</xsl:call-template>
					</a>
					<script type="text/javascript">
						<xsl:text>document.writeln();</xsl:text>
					</script>
				</xsl:if>
				<xsl:if test="position()!=1">
					<xsl:if test="$showInheritanceIcon='false'">
						<script type="text/javascript">for (var cnt=0; cnt &lt; tabCount; cnt++)document.write(" ");document.writeln("|");</script>
						<script type="text/javascript">for (var cnt=0; cnt &lt; tabCount; cnt++)document.write(" ");document.write("+--");</script>
					</xsl:if>
					<xsl:if test="$showInheritanceIcon='true'">
						<script type="text/javascript">for (var cnt=0; cnt &lt; tabCount; cnt++)document.write(" ");document.write("&lt;img src='<xsl:value-of select="$iconRef"/>' style='margin-top:1px' /&gt;");document.write(" ");
						</script>
					</xsl:if>
					<script type="text/javascript">document.writeln("&lt;a href=\"<xsl:value-of select="translate(classRef/@relativePath,':','/')"/>\"&gt;<xsl:call-template name="convertFullName">
						<xsl:with-param name="fullname" select="classRef/@fullName"/>
					</xsl:call-template>&lt;/a&gt;");</script>
					<script type="text/javascript">tabCount+=5;</script>
				</xsl:if>
			</xsl:for-each>
			<xsl:choose>
				<xsl:when test="not(asAncestors/asAncestor)">
					<script type="text/javascript">var showInheritance = false;</script></xsl:when>
				<xsl:when test="@type = 'interface'">
					<script type="text/javascript">var showInheritance = true;</script>
				</xsl:when>
				<!-- TODO remove hack when Object no longer inherits from itself -->
				<xsl:otherwise>
					<xsl:if test="@name != 'Object'">
						<script type="text/javascript">var showInheritance = true;</script>
					</xsl:if>
					<xsl:if test="@name='Object'">
						<script type="text/javascript">var showInheritance = false;</script>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$showInheritanceIcon='false'">
				<script type="text/javascript">if (showInheritance) { for (var cnt=0; cnt &lt; tabCount; cnt++)document.write(" ");document.writeln("|");}</script>
				<script type="text/javascript">if (showInheritance) { for (var cnt=0; cnt &lt; tabCount; cnt++)document.write(" ");document.write("+--");};</script>
			</xsl:if>
			<xsl:if test="$showInheritanceIcon='true'">
				<script type="text/javascript">if (showInheritance) { for (var cnt=0; cnt &lt; tabCount; cnt++)document.write(" ");document.write("&lt;img src='<xsl:value-of select="$iconRef"/>' style='margin-top:1px' /&gt;");document.write(" ");};</script>
			</xsl:if>
			<script type="text/javascript">document.writeln("<xsl:call-template name="convertFullName"><xsl:with-param name="fullname" select="@fullname"/></xsl:call-template>");</script>
		</pre>
	</xsl:template>
	<xsl:template name="sees">
		<xsl:param name="currentPackage" />
		<xsl:param name="labelClass" select="'label'"/>
		<xsl:param name="xrefId">
			<xsl:choose>
				<xsl:when test="self::operator">
					<xsl:text>operator#</xsl:text>
				</xsl:when>
				<xsl:when test="self::statement">
					<xsl:text>statement#</xsl:text>
				</xsl:when>
				<xsl:when test="self::specialType">
					<xsl:text>specialType#</xsl:text>
				</xsl:when>
				<xsl:when test="self::statements">
					<xsl:text>statements</xsl:text>
				</xsl:when>
				<xsl:when test="self::operators">
					<xsl:text>operators</xsl:text>
				</xsl:when>
				<xsl:when test="self::specialTypes">
					<xsl:text>special-types</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="ancestor::apiPackage/apiName='__Global__' and not(ancestor-or-self::apiClassifier)">
						<xsl:text>global</xsl:text>
						<xsl:if test="ancestor::apiClassifier">
							<xsl:text>.</xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not(ancestor::apiPackage/apiName='__Global__')">
						<xsl:value-of select="ancestor::apiPackage/apiName"/>
						<xsl:if test="ancestor-or-self::apiClassifier">
							<xsl:text>.</xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="ancestor-or-self::apiClassifier">
						<xsl:value-of select="ancestor::apiClassifier/apiName"/>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="self::apiConstructor">
							<xsl:text>#method:</xsl:text>
						</xsl:when>
						<xsl:when test="self::apiOperation">
							<xsl:text>#method:</xsl:text>
						</xsl:when>
						<xsl:when test="self::apiValue">
							<xsl:text>#property:</xsl:text>
						</xsl:when>
						<xsl:when test="self::adobeApiEvent">
							<xsl:text>#event:</xsl:text>
						</xsl:when>
						<xsl:when test="self::style">
							<xsl:text>#style:</xsl:text>
						</xsl:when>
						<xsl:when test="self::effect">
							<xsl:text>#effect:</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="apiName"/>
		</xsl:param>
		<xsl:param name="packageName">
			<xsl:if test="ancestor-or-self::apiPackage/apiName!='__Global__'">
				<xsl:value-of select="ancestor-or-self::apiPackage/apiName"/>
			</xsl:if>
		</xsl:param>
		<xsl:variable name="numSees" select="count(./related-links/link[normalize-space(./linktext) or @href])"/>
		<xsl:if test="$numSees or $xrefs/helpreferences/helpreference[normalize-space(id/.)=$xrefId]">
			<p>
				<span class="{$labelClass}">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'seeAlso']]/entry[2]/p"/>
				</span>
			</p>
			<div class="seeAlso">
				<xsl:for-each select="./related-links/link[string-length(@href) or string-length(./linktext)]">
					<xsl:if test="string-length(@href) &gt; 0">
						<!-- Get the method name -->
						<xsl:variable name="methodNameText" select="substring-after(@href,'/')"/>
						<!-- Get the Classname name -->
						<xsl:variable name="classNameText">
							<xsl:if test="contains(@href,'/')">
								<xsl:value-of select="substring-before(substring-after(@href,'#'),'/')"/>
							</xsl:if>
							<xsl:if test="not(contains(@href,'/'))">
								<xsl:value-of select="substring-after(@href,'#')"/>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="className">
							<xsl:if test="string-length($classNameText) &gt; 0">
								<xsl:value-of select="$classNameText"/>
							</xsl:if>
							<xsl:if test="string-length($classNameText) = 0">
								<xsl:value-of select="ancestor-or-self::apiClassifier/apiName"/>
							</xsl:if>
						</xsl:variable>
						<!-- Get the package name -->
						<xsl:variable name="packName">
							<xsl:choose>
								<xsl:when test="contains(@href,'.xml.xml')">
									<xsl:if test="contains(@href,'#')">
										<xsl:value-of select="substring(substring-before(@href,'#'),0,string-length(substring-before(@href,'#'))-string-length('.xml')+1)"/>
									</xsl:if>
									<xsl:if test="not(contains(@href,'#')) and not(contains(@href,'/')) and not(contains(@href,'.htm'))">
										<xsl:value-of select="substring(@href,0,string-length(@href)-string-length('.xml')+1)"/>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="contains(@href,'#')">
										<xsl:value-of select="substring-before(substring-before(@href,'#'),'.xml')"/>
									</xsl:if>
									<xsl:if test="not(contains(@href,'#')) and not(contains(@href,'/')) and not(contains(@href,'.htm'))">
										<xsl:value-of select="substring-before(@href,'.xml')"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="hyperlinkLocation">
							<xsl:choose>
								<xsl:when test="contains(@href,'.htm') or starts-with(@href,'http://')">
									<xsl:value-of select="@href"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="string-length($packName) &gt; 0 and not($packName=ancestor-or-self::apiPackage/apiName) and  not(contains(@href,'.htm'))">
										<xsl:variable name="relPathParam">
											<xsl:if test="ancestor-or-self::apiPackage/apiName">
												<xsl:value-of select="ancestor-or-self::apiPackage/apiName"/>
											</xsl:if>
											<xsl:if test="not(ancestor-or-self::apiPackage/apiName)">
												<xsl:value-of select="$currentPackage"/>
											</xsl:if>												
										</xsl:variable>
										<xsl:variable name="relPath">
											<xsl:call-template name="getRelativePath">
												<xsl:with-param name="currentPath" select="$relPathParam"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:if test="string-length($classNameText) &gt; 0">
											<xsl:if test="string-length($methodNameText) &gt; 0 ">
												<xsl:value-of select="concat($relPath,translate($packName,'.','/'),'/',$classNameText,'.html#',$methodNameText)"/>
											</xsl:if>
											<xsl:if test="string-length($methodNameText) = 0">
												<xsl:value-of select="concat($relPath,translate($packName,'.','/'),'/',$classNameText,'.html')"/>
											</xsl:if>
										</xsl:if>
										<xsl:if test="string-length($classNameText) = 0">
											<xsl:if test="string-length($methodNameText) &gt; 0 ">
												<xsl:value-of select="concat($relPath,translate($packName,'.','/'),'/','package.html#',$methodNameText)"/>
											</xsl:if>
											<xsl:if test="string-length($methodNameText) = 0">
												<xsl:value-of select="concat($relPath,translate($packName,'.','/'),'/','package-detail.html')"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
									<xsl:if test="(string-length($packName) = 0 or  ($packName=ancestor-or-self::apiPackage/apiName)) and not(contains(@href,'.htm'))">
										<xsl:if test="string-length($classNameText) &gt; 0 and not($classNameText='global') and string-length($packName) != 0 ">
											<xsl:if test="string-length($methodNameText) &gt; 0">
												<xsl:value-of select="concat($classNameText,'.html#',$methodNameText)"/>
											</xsl:if>
											<xsl:if test="string-length($methodNameText) = 0">
												<xsl:value-of select="concat($classNameText,'.html')"/>
											</xsl:if>
										</xsl:if>
										<!-- To handle the <#Array/sort() kind of stuff in a package>-->
										<xsl:if
											test="string-length($classNameText) &gt; 0 and not($classNameText='global') and (string-length(ancestor-or-self::apiPackage/apiName) &gt; 0 or string-length($currentPackage) &gt; 0)and string-length($packName) = 0 ">
											<xsl:variable name="relPathParam">
												<xsl:if test="ancestor-or-self::apiPackage/apiName">
													<xsl:value-of select="ancestor-or-self::apiPackage/apiName"/>
												</xsl:if>
												<xsl:if test="not(ancestor-or-self::apiPackage/apiName)">
													<xsl:value-of select="$currentPackage"/>
												</xsl:if>												
											</xsl:variable>
											<xsl:variable name="relPath">
												<xsl:if test="contains($relPathParam,'.')">
													<xsl:call-template name="getRelativePath">
														<xsl:with-param name="currentPath" select="$relPathParam"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:variable>
											
											<xsl:if test="string-length($methodNameText) &gt; 0">
												<xsl:value-of select="concat($relPath,$classNameText,'.html#',$methodNameText)"/>
											</xsl:if>
											<xsl:if test="string-length($methodNameText) = 0">
												<xsl:value-of select="concat($relPath,$classNameText,'.html')"/>
											</xsl:if>
										</xsl:if>
										<xsl:if test="string-length($classNameText) &gt; 0 and $classNameText='global'">
											<xsl:variable name="relPathParam">
												<xsl:if test="ancestor-or-self::apiPackage/apiName">
													<xsl:value-of select="ancestor-or-self::apiPackage/apiName"/>
												</xsl:if>
												<xsl:if test="not(ancestor-or-self::apiPackage/apiName)">
													<xsl:value-of select="$currentPackage"/>
												</xsl:if>												
											</xsl:variable>
											<xsl:variable name="relPath">
												<xsl:if test="contains($relPathParam,'.')">
													<xsl:call-template name="getRelativePath">
														<xsl:with-param name="currentPath" select="$relPathParam"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:variable>
											<xsl:if test="string-length($methodNameText) &gt; 0">
												<xsl:value-of select="concat($relPath,'package.html#',$methodNameText)"/>
											</xsl:if>
										</xsl:if>
										<xsl:if test="string-length($classNameText) = 0">
											<xsl:if test="string-length($packName) &gt; 0">
												<xsl:value-of select="concat('package.html#',$methodNameText)"/>
											</xsl:if>
											<xsl:if test="string-length($packName) = 0">
												<xsl:value-of select="concat('#',$methodNameText)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="linktxt" select="./linktext"/>
						<xsl:if test="$prog_language_name!='javascript'">
							<a href="{$hyperlinkLocation}">
								<xsl:attribute name="target">
									<xsl:if test="starts-with(@href,'http:')">
										<xsl:text>_top</xsl:text>
									</xsl:if>
									<xsl:if test="contains(@href,'../help/')">
										<xsl:text>_top</xsl:text>
									</xsl:if>
								</xsl:attribute>
								<xsl:if test="normalize-space(./linktext)">
									<xsl:value-of select="normalize-space(./linktext)"/>
								</xsl:if>
								<xsl:if test="not(normalize-space(./linktext))">
									<xsl:value-of select="@href"/>
								</xsl:if>
							</a>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$prog_language_name!='javascript'">
						<xsl:if test="not(string-length(@href)) and string-length(./linktext) &gt; 0">
							<xsl:value-of select="normalize-space(./linktext)"/>
						</xsl:if>
						<xsl:if test="position() != last()">
							<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
				<xsl:variable name="baseRef">
					<xsl:call-template name="getBaseRef">
						<xsl:with-param name="packageName" select="$packageName"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:for-each select="$xrefs/helpreferences/helpreference[normalize-space(id/.)=$xrefId]">
					<xsl:if test="position()=1 and $numSees">
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
					</xsl:if>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="not(bookfolder) or bookfolder=''">
									<xsl:value-of select="concat($baseRef,$config/xrefs/@baseRef,href/.)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($baseRef,$config/xrefs/@baseRef,bookfolder/text(),'/',href/.)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="string-length($config/xrefs/@target)">
							<xsl:attribute name="target">
								<xsl:value-of select="$config/xrefs/@target"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:variable name="titletext" select="replace(title/.,'&lt;/','&amp;lt;/')"/>
						<xsl:value-of select="$titletext"/>
					</xsl:element>
					<xsl:if test="position() != last()">
						<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getInheritDocText">
		<xsl:param name="baseClass"/>
		<xsl:param name="implementedInterface"/>
		<xsl:param name="descriptionType"/>
		<xsl:param name="entryType"/>
		<xsl:param name="nameToMatch"/>
		<xsl:param name="itemNameToMatch"/>
		<xsl:param name="doNotProcessTags" select="false()"/>
		<xsl:for-each select="ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseInterface">
			<xsl:call-template name="inheritDocFromInterfaces">
				<xsl:with-param name="implementedInterface" select="."/>
				<xsl:with-param name="descriptionType" select="$descriptionType"/>
				<xsl:with-param name="entryType" select="$entryType"/>
				<xsl:with-param name="nameToMatch" select="$nameToMatch"/>
				<xsl:with-param name="doNotProcessTags" select="$doNotProcessTags"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="inheritDocFromBaseClass">
			<xsl:with-param name="baseClass" select="$baseClass"/>
			<xsl:with-param name="descriptionType" select="$descriptionType"/>
			<xsl:with-param name="entryType" select="$entryType"/>
			<xsl:with-param name="nameToMatch" select="$nameToMatch"/>
			<xsl:with-param name="itemNameToMatch" select="$itemNameToMatch"/>
			<xsl:with-param name="doNotProcessTags" select="$doNotProcessTags"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="inheritDocFromInterfaces">
		<xsl:param name="implementedInterface"/>
		<xsl:param name="descriptionType"/>
		<xsl:param name="entryType"/>
		<xsl:param name="nameToMatch"/>
		<xsl:param name="doNotProcessTags" select="false()"/>
		<xsl:for-each select="$implementedInterface">
			<xsl:variable name="baseClass" select="."/>
			<xsl:variable name="className">
				<xsl:if test="contains($baseClass,':')">
					<xsl:value-of select="substring-after($baseClass,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($baseClass,':'))">
					<xsl:value-of select="$baseClass"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="packageName">
				<xsl:if test="contains($baseClass,':')">
					<xsl:value-of select="substring-before($baseClass,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($baseClass,':'))">
					<xsl:value-of select="__Global__"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="xslDocPath">
				<xsl:if test="contains($baseClass,':')">
					<xsl:value-of select="concat($ditaFileDir,substring-before($baseClass,':'),'.xml')"/>
				</xsl:if>
				<xsl:if test="not(contains($baseClass,':'))">
					<xsl:value-of select="concat($ditaFileDir,'__Global__.xml')"/>
				</xsl:if>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$entryType='apiClassifier'">
					<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$nameToMatch and apiClassifierDetail/apiClassifierDef/apiInterface]">
						<xsl:choose>
							<xsl:when test="$descriptionType='shortdesc'">
								<xsl:for-each select="./shortdesc">
									<xsl:if test="$doNotProcessTags">
										<xsl:value-of select="."/>
									</xsl:if>
									<xsl:if test="not ($doNotProcessTags)">
										<xsl:call-template name="processTags">
											<xsl:with-param name="addParagraphTags" select="false()"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$descriptionType='apiDesc'">
								<xsl:for-each select="./apiClassifierDetail/apiDesc">
									<xsl:if test="$doNotProcessTags">
										<xsl:value-of select="."/>
									</xsl:if>
									<xsl:if test="not ($doNotProcessTags)">
										<xsl:call-template name="processTags">
											<xsl:with-param name="addParagraphTags" select="true()"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="$entryType='apiOperation'">
					<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and  apiClassifierDetail/apiClassifierDef/apiInterface]/apiOperation[apiName=$nameToMatch]">
						<xsl:choose>
							<xsl:when test="$descriptionType='shortdesc'">
								<xsl:for-each select="./shortdesc">
									<xsl:if test="$doNotProcessTags">
										<xsl:value-of select="."/>
									</xsl:if>
									<xsl:if test="not ($doNotProcessTags)">
										<xsl:call-template name="processTags">
											<xsl:with-param name="addParagraphTags" select="false()"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$descriptionType='apiDesc'">
								<xsl:for-each select="./apiOperationDetail/apiDesc">
									<xsl:if test="$doNotProcessTags">
										<xsl:value-of select="."/>
									</xsl:if>
									<xsl:if test="not ($doNotProcessTags)">
										<xsl:call-template name="processTags">
											<xsl:with-param name="addParagraphTags" select="true()"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="$entryType='apiValue'">
					<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and apiClassifierDetail/apiClassifierDef/apiInterface]/apiValue[apiName=$nameToMatch]">
						<xsl:choose>
							<xsl:when test="$descriptionType='shortdesc'">
								<xsl:for-each select="./shortdesc">
									<xsl:if test="$doNotProcessTags">
										<xsl:value-of select="."/>
									</xsl:if>
									<xsl:if test="not ($doNotProcessTags)">
										<xsl:call-template name="processTags">
											<xsl:with-param name="addParagraphTags" select="false()"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$descriptionType='apiDesc'">
								<xsl:for-each select="./apiValueDetail/apiDesc">
									<xsl:if test="$doNotProcessTags">
										<xsl:value-of select="."/>
									</xsl:if>
									<xsl:if test="not ($doNotProcessTags)">
										<xsl:call-template name="processTags">
											<xsl:with-param name="addParagraphTags" select="true()"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
			<!-- Now process the base interface of the current interface-->
			<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className]/apiClassifierDetail/apiClassifierDef/apiBaseInterface">
				<xsl:call-template name="inheritDocFromInterfaces">
					<xsl:with-param name="implementedInterface" select="."/>
					<xsl:with-param name="descriptionType" select="$descriptionType"/>
					<xsl:with-param name="entryType" select="$entryType"/>
					<xsl:with-param name="nameToMatch" select="$nameToMatch"/>
					<xsl:with-param name="doNotProcessTags" select="$doNotProcessTags"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="inheritDocFromBaseClass">
		<xsl:param name="baseClass"/>
		<xsl:param name="descriptionType"/>
		<xsl:param name="entryType"/>
		<xsl:param name="nameToMatch"/>
		<xsl:param name="itemNameToMatch"/>
		<xsl:param name="doNotProcessTags" select="false()"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="packageName">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="__Global__"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="concat($ditaFileDir,substring-before($baseClass,':'),'.xml')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="concat($ditaFileDir,'__Global__.xml')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$entryType='apiClassifier'">
				<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$nameToMatch and not(apiClassifierDetail/apiClassifierDef/apiInterface)]">
					<xsl:choose>
						<xsl:when test="$descriptionType='shortdesc'">
							<xsl:for-each select="./shortdesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="false()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$descriptionType='apiDesc'">
							<xsl:for-each select="./apiClassifierDetail/apiDesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="true()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$entryType='apiOperation'">
				<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and not(apiClassifierDetail/apiClassifierDef/apiInterface)]/apiOperation[apiName=$nameToMatch]">
					<xsl:choose>
						<xsl:when test="$descriptionType='shortdesc'">
							<xsl:for-each select="./shortdesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="false()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$descriptionType='apiDesc'">
							<xsl:for-each select="./apiOperationDetail/apiDesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="false()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$entryType='apiValue'">
				<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and not(apiClassifierDetail/apiClassifierDef/apiInterface)]/apiValue[apiName=$nameToMatch]">
					<xsl:choose>
						<xsl:when test="$descriptionType='shortdesc'">
							<xsl:for-each select="./shortdesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="false()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$descriptionType='apiDesc'">
							<xsl:for-each select="./apiValueDetail/apiDesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="true()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$entryType='apiParam'">
				<xsl:for-each
					select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and not(apiClassifierDetail/apiClassifierDef/apiInterface)]/apiOperation[apiName=$nameToMatch]/apiOperationDetail/apiOperationDef/apiParam[apiItemName=$itemNameToMatch]">
					<xsl:choose>
						<xsl:when test="$descriptionType='shortdesc'">
							<xsl:for-each select="./shortdesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="false()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$descriptionType='apiDesc'">
							<xsl:for-each select="./apiDesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="false()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$entryType='apiReturn'">
				<xsl:for-each
					select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and not(apiClassifierDetail/apiClassifierDef/apiInterface)]/apiOperation[apiName=$nameToMatch]/apiOperationDetail/apiOperationDef/apiReturn">
					<xsl:choose>
						<xsl:when test="$descriptionType='shortdesc'">
							<xsl:for-each select="./shortdesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="false()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$descriptionType='apiDesc'">
							<xsl:for-each select="./apiDesc">
								<xsl:if test="$doNotProcessTags">
									<xsl:value-of select="."/>
								</xsl:if>
								<xsl:if test="not ($doNotProcessTags)">
									<xsl:call-template name="processTags">
										<xsl:with-param name="addParagraphTags" select="false()"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="not($className='Object')">
			<xsl:variable name="newBaseClass"
				select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and not(apiClassifierDetail/apiClassifierDef/apiInterface)]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			<xsl:if test="string-length($newBaseClass) &gt; 0">
				<xsl:call-template name="inheritDocFromBaseClass">
					<xsl:with-param name="baseClass" select="$newBaseClass"/>
					<xsl:with-param name="descriptionType" select="$descriptionType"/>
					<xsl:with-param name="entryType" select="$entryType"/>
					<xsl:with-param name="nameToMatch" select="$nameToMatch"/>
					<xsl:with-param name="itemNameToMatch" select="$itemNameToMatch"/>
					<xsl:with-param name="doNotProcessTags" select="$doNotProcessTags"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getSimpleClassName">
		<xsl:param name="fullClassName"/>
		<xsl:param name="baseRef"/>
		<xsl:choose>
			<xsl:when test="contains($fullClassName,':') and not(contains($fullClassName,'Vector$'))">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$fullClassName"/>
					<xsl:with-param name="substr" select="':'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($fullClassName,'.') and not(contains($fullClassName,'Vector$'))">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$fullClassName"/>
					<xsl:with-param name="substr" select="'.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- Vector  -->
				<xsl:choose>
					<xsl:when test="contains($fullClassName,'Vector$')">
						<xsl:variable name="vector.link" select="$fullClassName"/>
						<xsl:if test="not(contains($fullClassName,'*'))">
							<xsl:variable name="bef.vec" select="substring-before($fullClassName,'$')"/>
							<xsl:variable name="aft.vec" select="substring-after($fullClassName,'$')"/>
							<xsl:variable name="bef.vec.file" select="concat($baseRef,$bef.vec,'.html')"/>
							<xsl:variable name="aft.vec.aft" select="substring-after($aft.vec,':')"/>
							<xsl:variable name="aft.vec.bef" select="substring-before($aft.vec,':')"/>
							<xsl:variable name="aft.vec.file">
								<xsl:if test="contains($aft.vec,':')">
									<xsl:variable name="aft.vec.bef" select="substring-before($aft.vec,':')"/>
									<xsl:variable name="aft.vec.aft" select="substring-after($aft.vec,':')"/>
									<xsl:value-of select="concat($baseRef,translate($aft.vec.bef,'.','/'),'/',$aft.vec.aft,'.html')"/>
								</xsl:if>
								<xsl:if test="not(contains($aft.vec,':'))">
									<xsl:variable name="aft.vec.file" select="concat($baseRef,$aft.vec,'.html')"/>
									<xsl:value-of select="$aft.vec.file"/>
								</xsl:if>
							</xsl:variable>
							<xsl:if test="count($class.File.Name[apiName[.=$bef.vec]] ) &gt; 0">
								<a href="{$bef.vec.file}">
									<xsl:value-of select="$bef.vec"/>
								</a>
							</xsl:if>
							<xsl:if test="count($class.File.Name[apiName[.=$bef.vec]]) = 0">
								<xsl:value-of select="$bef.vec"/>

							</xsl:if>
							<xsl:text>.</xsl:text>
							<xsl:text>&amp;lt;</xsl:text>
							<xsl:choose>
								<!-- Matched ID's -->
								<xsl:when test="$class.File.Name[apiName[.=$aft.vec]]">
									<a href="{$aft.vec.file}">
										<xsl:value-of select="$aft.vec"/>
									</a>
								</xsl:when>
								<xsl:when test="$class.File.Name[@id=$aft.vec and apiName[.=$aft.vec.aft]]">
									<a href="{$aft.vec.file}">
										<xsl:value-of select="$aft.vec.aft"/>
									</a>
								</xsl:when>
								<!-- Non-Matched ID's -->
								<xsl:otherwise>
									<xsl:if test="contains($aft.vec,':')">
										<xsl:value-of select="$aft.vec.aft"/>
									</xsl:if>
									<xsl:if test="not(contains($aft.vec,':'))">
										<xsl:if test="contains($aft.vec,'$')">
											<xsl:call-template name="getSimpleClassName">
												<xsl:with-param name="fullClassName" select="$aft.vec"/>
												<xsl:with-param name="baseRef" select="$baseRef"/>
											</xsl:call-template>
										</xsl:if>
										<xsl:if test="not(contains($aft.vec,'$'))">
											<xsl:value-of select="$aft.vec"/>
										</xsl:if>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text>&amp;gt;</xsl:text>
						</xsl:if>
						<!-- Vector: Special Types -->
						<xsl:if test="contains($fullClassName,'Vector$*')">
							<xsl:variable name="bef.vec" select="substring-before($fullClassName,'$')"/>
							<xsl:variable name="aft.vec" select="substring-after($fullClassName,'$')"/>
							<xsl:variable name="bef.vec.file" select="concat($baseRef,$bef.vec,'.html')"/>
							<xsl:variable name="aft.vec.file" select="concat($baseRef,$aft.vec,'.html')"/>
							<a href="{$bef.vec.file}">
								<xsl:value-of select="$bef.vec"/>
							</a>
							<xsl:text>.</xsl:text>
							<xsl:text>&amp;lt;</xsl:text>
							<xsl:call-template name="getSpecialTypeLink">
								<xsl:with-param name="type" select="'*'"/>
								<xsl:with-param name="baseRef" select="$baseRef"/>
							</xsl:call-template>
							<xsl:text>&amp;gt;</xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$fullClassName"/>
					</xsl:otherwise>
				</xsl:choose>
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
	<xsl:variable name="deprecatedLabel">
		<b>
			<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Deprecated']]/entry[2]/p"/>
		</b>
	</xsl:variable>
	<xsl:template match="deprecated">
		<xsl:param name="showDescription" select="'true'"/>
		<xsl:copy-of select="$deprecatedLabel"/>
		<xsl:if test="string-length(@as-of)">
			<xsl:text> since </xsl:text>
			<xsl:value-of select="normalize-space(@as-of)"/>
		</xsl:if>
		<xsl:if test="$showDescription='true' and string-length(normalize-space())">
			<xsl:value-of select="$emdash"/>
			<xsl:call-template name="deTilda">
				<xsl:with-param name="inText" select="normalize-space()"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$showDescription!='true' or not(string-length(normalize-space()))">
			<xsl:text>.</xsl:text>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
	</xsl:template>
	<xsl:template match="item" mode="annotate">
		<xsl:for-each select="annotation">
			<xsl:choose>
				<xsl:when test="@type='text'">
					<div class="annotation">
						<xsl:value-of disable-output-escaping="yes" select="."/>
					</div>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="shortDescriptionReview">
		<xsl:variable name="asCustomsText">
			<xsl:value-of select="./prolog/asCustoms/review"/>
		</xsl:variable>
		<xsl:if test="string-length($asCustomsText) &gt; 0">
			<xsl:if test="$asCustomsText and $config/options/@showReview='true'">
				<xsl:value-of select="$nbsp"/>
				<font color="red">Review Needed.<xsl:value-of select="$nbsp"/>
				</font>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getPageTitlePostFix">
		<xsl:if test="string-length($config/pageTitlePostFix/.)">
			<xsl:text> </xsl:text>
			<xsl:value-of select="$config/pageTitlePostFix/."/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="addKeywords">
		<xsl:param name="keyword"/>
		<xsl:param name="num" select="$config/keywords/@num"/>
		<xsl:if test="$config/keywords[@show='true'] and $keyword">
			<div style="display:none">
				<xsl:call-template name="duplicateString">
					<xsl:with-param name="input" select="concat($keyword,' ')"/>
					<xsl:with-param name="count" select="$num"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="duplicateString">
		<xsl:param name="input"/>
		<xsl:param name="count" select="1"/>
		<xsl:choose>
			<xsl:when test="not($count) or not($input)"/>
			<xsl:when test="$count=1">
				<xsl:value-of select="$input"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$count mod 2">
					<xsl:value-of select="$input"/>
				</xsl:if>
				<xsl:call-template name="duplicateString">
					<xsl:with-param name="input" select="concat($input,$input)"/>
					<xsl:with-param name="count" select="floor($count div 2)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="substring-before-last">
		<xsl:param name="input"/>
		<xsl:param name="substr"/>
		<xsl:if test="$substr and contains($input,$substr)">
			<xsl:variable name="tmp" select="substring-after($input,$substr)"/>
			<xsl:value-of select="substring-before($input,$substr)"/>
			<xsl:if test="contains($tmp,$substr)">
				<xsl:value-of select="$substr"/>
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="input" select="$tmp"/>
					<xsl:with-param name="substr" select="$substr"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="substring-after-last">
		<xsl:param name="input"/>
		<xsl:param name="substr"/>
		<xsl:variable name="tmp" select="substring-after($input,$substr)"/>
		<xsl:choose>
			<xsl:when test="$substr and contains($tmp,$substr)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$tmp"/>
					<xsl:with-param name="substr" select="$substr"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$tmp"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="search-and-replace">
		<xsl:param name="input"/>
		<xsl:param name="search-string"/>
		<xsl:param name="replace-string"/>
		<xsl:choose>
			<xsl:when test="$search-string and contains($input,$search-string)">
				<xsl:value-of select="substring-before($input,$search-string)"/>
				<xsl:value-of select="$replace-string"/>
				<xsl:call-template name="search-and-replace">
					<xsl:with-param name="input" select="substring-after($input,$search-string)"/>
					<xsl:with-param name="search-string" select="$search-string"/>
					<xsl:with-param name="replace-string" select="$replace-string"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$input" disable-output-escaping="no"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="p" mode="terms">
		<xsl:param name="class"/>
		<xsl:param name="package"/>
		<xsl:param name="as-of"/>
		<xsl:param name="type"/>
		<xsl:param name="value"/>
		<xsl:apply-templates mode="terms">
			<xsl:with-param name="class" select="$class"/>
			<xsl:with-param name="package" select="$package"/>
			<xsl:with-param name="as-of" select="$as-of"/>
			<xsl:with-param name="type" select="$type"/>
			<xsl:with-param name="value" select="$value"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="class" mode="terms">
		<xsl:param name="class"/>
		<xsl:value-of select="$class"/>
	</xsl:template>
	<xsl:template match="package" mode="terms">
		<xsl:param name="package"/>
		<xsl:value-of select="$package"/>
	</xsl:template>
	<xsl:template match="as-of" mode="terms">
		<xsl:param name="as-of"/>
		<xsl:value-of select="$as-of"/>
	</xsl:template>
	<xsl:template match="type" mode="terms">
		<xsl:param name="type"/>
		<xsl:value-of select="$type"/>
	</xsl:template>
	<xsl:template match="value" mode="terms">
		<xsl:param name="value"/>
		<xsl:value-of select="$value"/>
	</xsl:template>
	<xsl:template match="* | @*" mode="terms" priority="-1">
		<xsl:copy>
			<xsl:apply-templates mode="terms"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="getLocalizedString">
		<xsl:param name="key"/>
		<xsl:choose>
			<xsl:when test="$asdoc_terms/row[entry[1][p/text() = $key]]/entry[2]/p">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = $key]]/entry[2]/p"/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$key"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getAppendixLocalizedString">
		<xsl:param name="key"/>
		<xsl:choose>
			<xsl:when test="$asdoc_terms/row[entry[1][p/text() = $key]]/entry[2]/p">
				<xsl:text> </xsl:text>
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = $key]]/entry[2]/p"/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$config/appendixes/appendix[@overview=$key]/@label"/>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- For HTML Processing-->
	<xsl:template name="processTags">
		<xsl:param name="addParagraphTags" select="false()"/>
		<xsl:param name="createLinkFromRootContext" select="false()"/>
		<xsl:param name="event"/>
		<xsl:variable name="matchHTML" select="./adobetable |  ./ol |  ./p | ./codeblock |  ./ul |  ./b |  ./adobeimage | ./ph |  ./codeph | ./bold | ./strong |  ./em |  ./i |  ./xref | ./pre | ./text() | ./li| ./sup"/>
		<xsl:for-each select="$matchHTML">
			<xsl:if test="self::text()">
				<xsl:if test="$addParagraphTags">
					<xsl:if test="position()=1">
						<xsl:value-of disable-output-escaping="yes" select="'&lt;p&gt;'"/>
					</xsl:if>
				</xsl:if>
				<xsl:variable name="text">
					<xsl:if test="contains(.,'~~')">
						<xsl:call-template name="search-and-replace">
							<xsl:with-param name="search-string" select="'~~'"/>
							<xsl:with-param name="replace-string" select="'*'"/>
							<xsl:with-param name="input" select="."/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="not(contains(.,'~~'))">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="retext" select="replace($text,'&lt;mx','&amp;lt;mx')"/>
				<xsl:variable name="re.text" select="replace($retext,'&lt;','&amp;lt;')"/>
				<xsl:if test="$event!='eventdesc'">
					<xsl:value-of select="replace($re.text,'&lt;/mx','&amp;lt;/mx')"/>
				</xsl:if>
				<xsl:if test="$event='eventdesc'">
					<xsl:value-of select="."/>
				</xsl:if>
				<xsl:if test="$addParagraphTags">
					<xsl:if test="position()=last()">
						<xsl:value-of disable-output-escaping="yes" select="'&lt;/p&gt;'"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="self::codeblock">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::ol | self::ul">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::li">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::p">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::b | self::bold | self::strong">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::adobetable">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::adobeimage">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::ph">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::sup">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::em | self::i">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::codeph">
				<xsl:apply-templates select="."/>
			</xsl:if>
			<xsl:if test="self::xref">
				<xsl:apply-templates select=".">
					<xsl:with-param name="createLinkFromRootContext" select="$createLinkFromRootContext"/>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="self::pre">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="codeblock">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<!-- for some reason, asdoc includes all whitespace before
				the * in documentation comments -->
			<!-- the Feathers codebase uses tabs for indentation, and one
				space before *, so we can remove the space -->
			<xsl:variable name="deTabbed">
				<xsl:call-template name="search-and-replace">
					<xsl:with-param name="input" select="."/>
					<xsl:with-param name="search-string" select="'&#09; '"/>
					<xsl:with-param name="replace-string" select="'&#09;'"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- Feathers examples only use spaces so we can safely remove
				all tabs in code blocks -->
			<xsl:variable name="deTabbed" select="replace($deTabbed,'&#09;','')"/>
			<xsl:variable name="listingversion" select="./@rev"/>
			<xsl:variable name="openTag">
				<xsl:if test="string-length($listingversion) &gt; 0">
					<xsl:value-of select="concat('&lt;div class=&quot;','listing','&quot; version=&quot;',$listingversion,'&quot;&gt;')"/>
				</xsl:if>
				<xsl:if test="string-length($listingversion) = 0">
					<xsl:value-of select="concat('&lt;div class=&quot;','listing','&quot;&gt;')"/>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of disable-output-escaping="yes" select="$openTag"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;pre&gt;'"/>
			<xsl:if test="contains($deTabbed,'~~')">
				<xsl:call-template name="search-and-replace">
					<xsl:with-param name="input" select="$deTabbed"/>
					<xsl:with-param name="search-string" select="'~~'"/>
					<xsl:with-param name="replace-string" select="'*'"/>		
				</xsl:call-template>
			</xsl:if>
			<xsl:variable name="text" select="replace($deTabbed,'&lt;','&amp;lt;')"/>
			<xsl:variable name="finaltext" select="replace($text,'&gt;','&amp;gt;')"/>
			<xsl:if test="not(contains($deTabbed,'~~'))">
				<xsl:value-of select="$finaltext"/>
			</xsl:if>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/pre&gt;'"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/div&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ol | ul">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:variable name="openTag">
				<xsl:variable name="className" select="./@outputclass"/>
				<xsl:if test="self::ol">
					<xsl:if test="string-length($className) &gt; 0">
						<xsl:value-of disable-output-escaping="yes" select="concat('&lt;ol type=&quot;',$className,'&quot; &gt;')"/>
					</xsl:if>
					<xsl:if test="string-length($className) = 0">
						<xsl:value-of disable-output-escaping="yes" select="'&lt;ol&gt;'"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="self::ul">
					<xsl:if test="string-length($className) &gt; 0">
						<xsl:value-of disable-output-escaping="yes" select="concat('&lt;ul type=&quot;',$className,'&quot; &gt;')"/>
					</xsl:if>
					<xsl:if test="string-length($className) = 0">
						<xsl:value-of disable-output-escaping="yes" select="'&lt;ul&gt;'"/>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="closeTag">
				<xsl:if test="self::ol">
					<xsl:value-of disable-output-escaping="yes" select="'&lt;/ol&gt;'"/>
				</xsl:if>
				<xsl:if test="self::ul">
					<xsl:value-of disable-output-escaping="yes" select="'&lt;/ul&gt;'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of disable-output-escaping="yes" select="$openTag"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="$closeTag"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="li">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:value-of disable-output-escaping="yes" select="'&lt;li&gt;'"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/li&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="p">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:value-of disable-output-escaping="yes" select="'&lt;p&gt;'"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/p&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="b | bold | strong">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:value-of disable-output-escaping="yes" select="'&lt;b&gt;'"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/b&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="sup">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:value-of disable-output-escaping="yes" select="'&lt;sup&gt;'"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/sup&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="pre">
		<xsl:variable name="product" select="./@product | ./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:value-of disable-output-escaping="yes" select="'&lt;pre&gt;'"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/pre&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="em | i">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:value-of disable-output-escaping="yes" select="'&lt;i&gt;'"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/i&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="codeph">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:value-of disable-output-escaping="yes" select="'&lt;code&gt;'"/>
			<xsl:choose>
				<xsl:when test="contains(.,'&lt;') and contains(.,'&gt;')">
					<xsl:variable name="rep" select="replace(.,'&lt;','&amp;lt;')"/>
					<xsl:value-of select="replace($rep,'&gt;','&amp;gt;')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="processTags"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/code&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="adobetable">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:variable name="colCount" select="./tgroup/@cols"/>
			<xsl:if test="string-length(./@class) &gt; 0">
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;table class=&quot;',./@class,'&quot; &gt;')"/>
			</xsl:if>
			<xsl:if test="string-length(./@class) = 0">
				<xsl:value-of disable-output-escaping="yes" select="'&lt;table &gt;'"/>
			</xsl:if>
			<xsl:for-each select="./tgroup/thead//row">
				<tr>
					<xsl:for-each select="entry">
						<xsl:choose>
							<xsl:when test="string-length(./@align) &gt; 0">
								<xsl:value-of disable-output-escaping="yes" select="concat('&lt;th align=&quot;',./@align,'&quot;&gt;')"/>
								<xsl:call-template name="processTags"/>
								<xsl:value-of disable-output-escaping="yes" select="'&lt;/th&gt;'"/>
							</xsl:when>
							<xsl:otherwise>
								<th>
									<xsl:call-template name="processTags"/>
								</th>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
			<xsl:for-each select="./tgroup/tbody//row">
				<tr>
					<xsl:for-each select="entry">
						<xsl:choose>
							<xsl:when test="string-length(./@align) &gt; 0">
								<xsl:value-of disable-output-escaping="yes" select="concat('&lt;td align=&quot;',./@align,'&quot;&gt;')"/>
								<xsl:call-template name="processTags"/>
								<xsl:value-of disable-output-escaping="yes" select="'&lt;/td&gt;'"/>
							</xsl:when>
							<xsl:otherwise>
								<td>
									<xsl:call-template name="processTags"/>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
			<xsl:value-of disable-output-escaping="yes" select="'&lt;/table&gt;'"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="adobeimage">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:variable name="hrefUrl" select="./@href"/>
			<xsl:variable name="alt.text" select="./@alt"/>
			<xsl:variable name="openTag">
				<xsl:if test="string-length($hrefUrl) &gt; 0">
					<xsl:if test="string-length($alt.text) &gt; 0">
						<xsl:value-of disable-output-escaping="yes" select="concat('&lt;img src=&quot;',$hrefUrl,'&quot; alt=&quot;',$alt.text,'&quot;&gt;')"/>
					</xsl:if>								
					<xsl:if test="not(string-length($alt.text) &gt; 0)">
						<xsl:value-of disable-output-escaping="yes" select="concat('&lt;img src=&quot;',$hrefUrl,'&quot; &gt;')"/>
					</xsl:if>								
				</xsl:if>			
				<xsl:if test="not(string-length($hrefUrl) &gt; 0) and not(string-length($alt.text) &gt; 0)">
					<xsl:value-of disable-output-escaping="yes" select="'&lt;img&gt;'"/>
				</xsl:if>					
			</xsl:variable>
			<xsl:variable name="closeTag">
				<xsl:value-of disable-output-escaping="yes" select="'&lt;/img&gt;'"/>
			</xsl:variable>
			<xsl:value-of disable-output-escaping="yes" select="$openTag"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="$closeTag"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ph">
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:variable name="class" select="./@outputclass"/>
			<xsl:choose>
				<xsl:when test="$class='br'">
					<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="openTag">
						<xsl:if test="string-length($class) &gt; 0">
							<xsl:value-of disable-output-escaping="yes" select="concat('&lt;span src=&quot;',$class,'&quot;&gt;')"/>
						</xsl:if>
						<xsl:if test="not(string-length($class) &gt; 0)">
							<xsl:value-of disable-output-escaping="yes" select="'&lt;span&gt;'"/>
						</xsl:if>
					</xsl:variable>
					<xsl:variable name="closeTag">
						<xsl:value-of disable-output-escaping="yes" select="'&lt;/span&gt;'"/>
					</xsl:variable>
					<xsl:value-of disable-output-escaping="yes" select="$openTag"/>
					<xsl:call-template name="processTags"/>
					<xsl:value-of disable-output-escaping="yes" select="$closeTag"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="xref">
		<xsl:param name="createLinkFromRootContext" select="false()"/>
		<xsl:variable name="product" select="./@product|./@class[contains(.,'only')] | ./@outputclass"/>
		<xsl:if test="string-length($product)=0 or $product=concat($productName,'only')">
			<xsl:variable name="source">
				<xsl:choose>
					<xsl:when test="$process_xref_href_attribute ='0' or contains(@href,'http://') or contains(@href,'.htm')">
						<xsl:value-of select="@href"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="getLinkURL">
							<xsl:with-param name="href" select="@href"/>
							<xsl:with-param name="createLinkFromRootContext" select="$createLinkFromRootContext"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="target" select="@scope"/>
			<xsl:variable name="openTag">
				<xsl:if test="string-length($source) &gt; 0">
					<xsl:value-of disable-output-escaping="yes" select="concat('&lt;a href=&quot;',$source,'&quot; target=&quot;',$target,'&quot;&gt;')"/>
				</xsl:if>
				<xsl:if test="not(string-length($source) &gt; 0)">
					<xsl:value-of disable-output-escaping="yes" select="'&lt;a&gt;'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="closeTag">
				<xsl:value-of disable-output-escaping="yes" select="'&lt;/a&gt;'"/>
			</xsl:variable>
			<xsl:value-of disable-output-escaping="yes" select="$openTag"/>
			<xsl:call-template name="processTags"/>
			<xsl:value-of disable-output-escaping="yes" select="$closeTag"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getLinkURL">
		<xsl:param name="href"/>
		<xsl:param name="createLinkFromRootContext" select="false()"/>
		<xsl:if test="string-length(@href) &gt; 0">
			<xsl:variable name="methodNameText" select="substring-after(@href,'/')"/>
			<xsl:variable name="classNameText">
				<xsl:if test="contains(@href,'/')">
					<xsl:value-of select="substring-before(substring-after(@href,'#'),'/')"/>
				</xsl:if>
				<xsl:if test="not(contains(@href,'/'))">
					<xsl:value-of select="substring-after(@href,'#')"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="className">
				<xsl:if test="string-length($classNameText) &gt; 0">
					<xsl:value-of select="$classNameText"/>
				</xsl:if>
				<xsl:if test="string-length($classNameText) = 0">
					<xsl:value-of select="ancestor-or-self::apiClassifier/apiName"/>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="packName">
				<xsl:choose>
					<xsl:when test="contains(@href,'.xml.xml')">
						<xsl:if test="contains(@href,'#')">
							<xsl:value-of select="substring(substring-before(@href,'#'),0,string-length(substring-before(@href,'#'))-string-length('.xml')+1)"/>
						</xsl:if>
						<xsl:if test="not(contains(@href,'#')) and not(contains(@href,'/')) and not(contains(@href,'.htm'))">
							<xsl:value-of select="substring(@href,0,string-length(@href)-string-length('.xml')+1)"/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="contains(@href,'#')">
							<xsl:value-of select="substring-before(substring-before(@href,'#'),'.xml')"/>
						</xsl:if>
						<xsl:if test="not(contains(@href,'#')) and not(contains(@href,'/')) and not(contains(@href,'.htm'))">
							<xsl:value-of select="substring-before(@href,'.xml')"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="contains(@href,'.htm') ">
				<xsl:value-of select="@href"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="string-length($packName) &gt; 0 and ( not($packName=ancestor-or-self::apiPackage/apiName) or $createLinkFromRootContext = true() )and  not(contains(@href,'.htm'))">
					<xsl:variable name="relPath">
						<xsl:if test="$createLinkFromRootContext = false() and contains(ancestor-or-self::apiPackage/apiName,'.')">
							<xsl:call-template name="getRelativePath">
								<xsl:with-param name="currentPath" select="ancestor-or-self::apiPackage/apiName"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:variable>
					<xsl:if test="string-length($classNameText) &gt; 0">
						<xsl:if test="string-length($methodNameText) &gt; 0 ">
							<xsl:value-of select="concat($relPath,translate($packName,'.','/'),'/',$classNameText,'.html#',$methodNameText)"/>
						</xsl:if>
						<xsl:if test="string-length($methodNameText) = 0">
							<xsl:value-of select="concat($relPath,translate($packName,'.','/'),'/',$classNameText,'.html')"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="string-length($classNameText) = 0">
						<xsl:if test="string-length($methodNameText) &gt; 0 ">
							<xsl:value-of select="concat($relPath,translate($packName,'.','/'),'/','package.html#',$methodNameText)"/>
						</xsl:if>
						<xsl:if test="string-length($methodNameText) = 0">
							<xsl:value-of select="concat($relPath,translate($packName,'.','/'),'/','package-detail.html')"/>
						</xsl:if>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="(string-length($packName) = 0 or  ($packName=ancestor-or-self::apiPackage/apiName)) and not(contains(@href,'.htm'))">
						<xsl:if test="string-length($classNameText) &gt; 0 and not($classNameText='global') and string-length($packName) != 0 ">
							<xsl:if test="string-length($methodNameText) &gt; 0">
								<xsl:value-of select="concat($classNameText,'.html#',$methodNameText)"/>
							</xsl:if>
							<xsl:if test="string-length($methodNameText) = 0">
								<xsl:value-of select="concat($classNameText,'.html')"/>
							</xsl:if>
						</xsl:if>
						<!-- To handle the <#Array/sort() kind of stuff in a package>-->
						<xsl:if test="string-length($classNameText) &gt; 0 and not($classNameText='global') and string-length(ancestor-or-self::apiPackage/apiName) &gt; 0 and string-length($packName) = 0 ">
							<xsl:variable name="relPath">
								<xsl:if test="$prog_language_name = 'ActionScript' and contains(ancestor-or-self::apiPackage/apiName,'.')">
									<xsl:call-template name="getRelativePath">
										<xsl:with-param name="currentPath" select="ancestor-or-self::apiPackage/apiName"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:variable>
							<xsl:if test="string-length($methodNameText) &gt; 0">
								<xsl:value-of select="concat($relPath,$classNameText,'.html#',$methodNameText)"/>
							</xsl:if>
							<xsl:if test="string-length($methodNameText) = 0">
								<xsl:value-of select="concat($relPath,$classNameText,'.html')"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="string-length($classNameText) &gt; 0 and $classNameText='global'">
							<xsl:variable name="relPath">
								<xsl:if test="contains(ancestor-or-self::apiPackage/apiName,'.')">
									<xsl:call-template name="getRelativePath">
										<xsl:with-param name="currentPath" select="ancestor-or-self::apiPackage/apiName"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:variable>
							<xsl:if test="string-length($methodNameText) &gt; 0">
								<xsl:value-of select="concat($relPath,'package.html#',$methodNameText)"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="string-length($classNameText) = 0">
							<xsl:value-of select="concat('#',$methodNameText)"/>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getDeprecatedReplacementLink">
		<xsl:param name="replacement"/>
		<xsl:param name="currentPackage"/>
		<xsl:param name="linkFromRootContext" select="false()"/>
		<xsl:param name="ancestorPath"/>
		<xsl:param name="anchorPrefix" select="''"/>
		<xsl:param name="mode" select="''"/>

		<xsl:variable name="relativePath">
			<xsl:call-template name="getRelativePath">
				<xsl:with-param name="currentPath" select="$currentPackage"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ancestorPath">
				<xsl:variable name="lastToken">
					<xsl:call-template name="lastIndexOf">
						<xsl:with-param name="string" select="$replacement"/>
						<xsl:with-param name="char" select="'.'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="firstPassToken" select="substring-before($replacement,concat('.',$lastToken))"/>
				<xsl:choose>
					<xsl:when test="string-length($firstPassToken) &gt; 0">
						<xsl:if test="$linkFromRootContext = false()">
							<xsl:value-of select="$relativePath"/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$linkFromRootContext = true()">
							<xsl:value-of select="translate($currentPackage,'.','/')"/>
							<xsl:text>/</xsl:text>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="concat(translate($replacement,'.','/'),'.html')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="lastToken">
					<xsl:call-template name="lastIndexOf">
						<xsl:with-param name="string" select="$replacement"/>
						<xsl:with-param name="char" select="'.'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="firstPassToken" select="substring-before($replacement,concat('.',$lastToken))"/>
				<xsl:variable name="className">
					<xsl:call-template name="lastIndexOf">
						<xsl:with-param name="string" select="$firstPassToken"/>
						<xsl:with-param name="char" select="'.'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="packageName" select="substring-before($firstPassToken,concat('.',$className))"/>
				<xsl:choose>
					<xsl:when test="string-length($packageName) &gt; 0">
						<xsl:if test="$linkFromRootContext = false()">
							<xsl:value-of select="$relativePath"/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$linkFromRootContext = true()">
							<xsl:value-of select="translate($currentPackage,'.','/')"/>
							<xsl:text>/</xsl:text>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length($firstPassToken) &gt; 0">
						<xsl:value-of select="concat(translate($firstPassToken,'.','/'),'.html')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$linkFromRootContext = true()">
							<xsl:value-of select="concat(ancestor::apiClassifier/apiName,'.html')"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="string-length($mode) = 0">
						<xsl:value-of select="concat('#', $anchorPrefix, $lastToken)"/>
					</xsl:when>
					<xsl:otherwise>
							<xsl:value-of select="concat('#', $mode, $anchorPrefix, $lastToken)"/>
					</xsl:otherwise>
				</xsl:choose>


			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()">
		<xsl:call-template name="deTilda">
			<xsl:with-param name="inText" select="."/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="getParentInterfaces">
		<xsl:param name="currentInterface"/>
		<xsl:param name="interfaceList"/>
		<xsl:variable name="className">
			<xsl:if test="contains($currentInterface,':')">
				<xsl:value-of select="substring-after($currentInterface,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($currentInterface,':'))">
				<xsl:value-of select="$currentInterface"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($currentInterface,':')">
				<xsl:value-of select="concat($ditaFileDir,substring-before($currentInterface,':'),'.xml')"/>
			</xsl:if>
			<xsl:if test="not(contains($currentInterface,':'))">
				<xsl:value-of select="concat($ditaFileDir,'__Global__.xml')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="document($xslDocPath)/apiPackage//apiClassifier[apiName=$className]/apiClassifierDetail/apiClassifierDef/apiBaseInterface">
			<xsl:if test="not(contains($interfaceList,.))">
				<interface>
					<xsl:value-of select="."/>
				</interface>
			</xsl:if>
		</xsl:for-each>
		<xsl:variable name="newInterfaceList">
			<xsl:for-each select="document($xslDocPath)/apiPackage//apiClassifier[apiName=$className]/apiClassifierDetail/apiClassifierDef/apiBaseInterface">
				<xsl:if test="not(contains($interfaceList,.))">
					<xsl:value-of select="."/>
					<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="document($xslDocPath)/apiPackage//apiClassifier[apiName=$className]/apiClassifierDetail/apiClassifierDef/apiBaseInterface">
			<xsl:if test="not(contains($interfaceList,.))">
				<xsl:call-template name="getParentInterfaces">
					<xsl:with-param name="currentInterface" select="."/>
					<xsl:with-param name="interfaceList" select="concat($interfaceList, ' ', $newInterfaceList)"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="createBaseInterfaceList">
		<xsl:variable name="interfaceList">
			<xsl:for-each select="./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
				<xsl:value-of select="."/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="baseinterfaces">
			<xsl:for-each select="./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
				<interface>
					<xsl:value-of select="."/>
				</interface>
			</xsl:for-each>
			<xsl:for-each select="./apiClassifierDetail/apiClassifierDef/apiBaseInterface">
				<xsl:call-template name="getParentInterfaces">
					<xsl:with-param name="currentInterface" select="."/>
					<xsl:with-param name="interfaceList" select="$interfaceList"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="$baseinterfaces/interface">
			<xsl:if test="not(node()) or not(preceding-sibling::node()[.=string(current()) and name()=name(current())])">
				<xsl:copy>
					<interface>
						<xsl:value-of select="."/>
					</interface>
				</xsl:copy>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="insertAIRIcon">
		<xsl:param name="baseRef"/>
		<img src="{$baseRef}images/AirIcon12x12.gif" width="12" height="12" hspace="0" vspace="0" alt="AIR-only" title="Only available in the AIR runtime"/>
	</xsl:template>
</xsl:stylesheet>
