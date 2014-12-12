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
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:template match="/">
		<allClasses>
			<xsl:apply-templates select="//apiItemRef">
				<xsl:sort select="@href" order="ascending"/>
			</xsl:apply-templates>
		</allClasses>
	</xsl:template>
	<xsl:template match="apiItemRef">
		<xsl:variable name="ditaFileName">
			<xsl:value-of select="concat($ditaFileDir,@href)"/>
		</xsl:variable>
		<xsl:for-each select="document($ditaFileName)/apiPackage">
			<apiPackage id="{@id}">
				<apiName>
					<xsl:value-of select="./apiName"/>
				</apiName>
				<xsl:copy-of select="./apiDetail"/>
				<xsl:for-each select="//apiClassifier">
					<xsl:variable name="id" select="@id"/>
					<apiClassifier id="{@id}">
						<apiName>
							<xsl:value-of select="apiName/."/>
						</apiName>
						<xsl:apply-templates select="shortdesc"/>
						<xsl:apply-templates select="prolog"/>
						<xsl:apply-templates select="apiClassifierDetail"/>
						<xsl:apply-templates select="related-links"/>
						<Keywords>
							<xsl:variable name="keywords">
								<xsl:if test=".//Xkeyword">
									<xsl:for-each select=".//keyword">
										<xsl:sort order="ascending"/>
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
										<xsl:sort order="ascending"/>
										<xsl:value-of select="./apiName"/>
										<xsl:if test="position() != last()">
											<xsl:text>,</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="apiOperation">
									<xsl:text>,</xsl:text>
									<xsl:for-each select="//apiOperation">
										<xsl:sort order="ascending"/>
										<xsl:value-of select="./apiName"/>
										<xsl:if test="position() != last()">
											<xsl:text>,</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
							</xsl:variable>
							<meta name="keywords" content="{$keywords}"/>
						</Keywords>
						<xsl:if test="./prolog/asMetadata/Exclude">
							<Excludes>
								<xsl:for-each select="./prolog/asMetadata/Exclude">
									<Exclude name="{@name}" kind="{@kind}" class="+ topic/ph adobe-api-d/Exclude "/>
								</xsl:for-each>
							</Excludes>
						</xsl:if>
					</apiClassifier>
				</xsl:for-each>
			</apiPackage>
		</xsl:for-each>
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
				<xsl:value-of select="$input"/>
			</xsl:otherwise>
		</xsl:choose>
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
	<xsl:template name="isTopLevel">
		<xsl:param name="packageName"/>
		<xsl:value-of select="string-length($packageName)=0 or contains($packageName,'__Global__')"/>
	</xsl:template>
	<xsl:template match="related-links">
		<related-links>
			<xsl:apply-templates select="node()"/>
		</related-links>
	</xsl:template>
	<xsl:template match="apiClassifierDetail">
		<apiClassifierDetail>
			<xsl:apply-templates select="node()"/>
		</apiClassifierDetail>
	</xsl:template>
	<xsl:template match="shortdesc">
		<shortdesc>
			<xsl:apply-templates select="node()"/>
		</shortdesc>
	</xsl:template>
	<xsl:template match="prolog">
		<prolog>
			<xsl:apply-templates select="node()"/>
		</prolog>
	</xsl:template>
	<xsl:template match="node()">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="styles"/>
	<xsl:template match="prolog/asMetadata/Exclude"/>
</xsl:stylesheet>
