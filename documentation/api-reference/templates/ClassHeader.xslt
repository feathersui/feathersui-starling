<?xml version="1.0" encoding="UTF-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://sf.net/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ifn="urn:internal:functions" exclude-result-prefixes="saxon xs ifn">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:key name="baseclass" match="apiClassifier" use=".//apiBaseClassifier/text()"/>
	<xsl:key name="id" match="//apiClassifier" use="@id"/>
	<xsl:key name="idg" match="//apiClassifier" use="substring-after(@id,':')"/>
	<xsl:key name="baseInter" match="//apiBaseInterface" use="text()"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="apiPackage">
		<apiPackage id="{@id}">
			<apiName>
				<xsl:value-of select="@id"/>
			</apiName>
			<xsl:copy-of select="./apiDetail"/>
			<xsl:apply-templates select="apiClassifier"/>
		</apiPackage>
	</xsl:template>
	<xsl:template match="apiClassifier">
		<apiClassifier id="{@id}">
			<apiName>
				<xsl:value-of select="./apiName"/>
			</apiName>
			<xsl:apply-templates select="shortdesc"/>
			<xsl:apply-templates select="prolog"/>
			<xsl:apply-templates select="Keywords" mode="keys"/>
			<xsl:apply-templates select="apiClassifierDetail"/>
			<xsl:apply-templates select="related-links"/>
		</apiClassifier>
	</xsl:template>
	<xsl:template match="apiClassifierDetail">
		<apiClassifierDetail>
			<xsl:apply-templates select="node()"/>
			<Inheritancelist>
				<BaseInterface>
					<xsl:if test="./apiClassifierDef/apiInterface and ./apiClassifierDef/apiBaseInterface">
						<xsl:for-each select="./apiClassifierDef/apiBaseInterface">
							<xsl:sort select="substring-after(./apiClassifierDef/apiBaseInterface/.,':')" order="ascending" data-type="text"/>
							<Interface id="{.}"/>
						</xsl:for-each>
						<xsl:call-template name="nested"/>
					</xsl:if>
				</BaseInterface>
				<Inheritance>
					<xsl:variable name="baseClass" select=".//apiBaseClassifier/text()"/>
					<xsl:for-each select=".//apiBaseClassifier">
						<Inherit id="{$baseClass}"/>
					</xsl:for-each>
					<xsl:call-template name="inheritList">
						<xsl:with-param name="base" select="$baseClass"/>
					</xsl:call-template>
				</Inheritance>
				<Implements>
					<xsl:for-each select=".//apiBaseInterface">
						<Implement id="{@*|node()}"/>
					</xsl:for-each>
				</Implements>
				<Subclasses>
					<xsl:variable name="apiClass" select="ancestor::apiClassifier/@id"/>
					<xsl:variable name="apiClassGlb" select="substring-after($apiClass,'globalClassifier:')"/>
					<xsl:for-each select="key('baseclass',  $apiClass)">
						<class id="{@id}"/>
					</xsl:for-each>
					<xsl:for-each select="key('baseclass',  $apiClassGlb)">
						<class id="{@id}"/>
					</xsl:for-each>
				</Subclasses>
				<Implementors>
					<xsl:if test=".//apiInterface">
						<xsl:variable name="apiClass" select="ancestor::apiClassifier/@id"/>
						<xsl:for-each select="key('baseInter',$apiClass)">
							<xsl:sort select="substring-after(ancestor::apiClassifier/@id,':')" order="ascending"/>
							<xsl:if test="not(parent::apiClassifierDef/apiInterface)">
								<Implementor id="{ancestor::apiClassifier/@id}"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
				</Implementors>
				<Excludes>
					<xsl:copy-of select="ancestor::apiClassifier/Excludes/Exclude"/>
					<xsl:for-each select=".//apiBaseClassifier">
						<xsl:call-template name="getexcludes"/>
					</xsl:for-each>
				</Excludes>
			</Inheritancelist>
		</apiClassifierDetail>
	</xsl:template>
	<xsl:template match="Keywords" mode="keys">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	<xsl:template match="apiClassifierDef">
		<apiClassifierDef>
			<xsl:apply-templates select="node()"/>
		</apiClassifierDef>
	</xsl:template>
	<xsl:template name="nested">
		<xsl:variable name="apiBaseInter" select=".//apiBaseInterface/."/>
		<xsl:for-each select="key('id', $apiBaseInter)/apiClassifierDetail/apiClassifierDef/apiBaseInterface">
			<xsl:variable name="nested.apiBaseInter" select="."/>
			<xsl:choose>
				<xsl:when test="$apiBaseInter=$nested.apiBaseInter"/>
				<xsl:otherwise>
					<Interface id="{.}"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:call-template name="sub-nested"/>
	</xsl:template>
	<xsl:template name="sub-nested">
		<xsl:variable name="apiBaseInter" select=".//apiBaseInterface/."/>
		<xsl:variable name="subnested.apiBaseInter" select="key('id', $apiBaseInter)/apiClassifierDetail/apiClassifierDef/apiBaseInterface"/>
		<xsl:for-each select="key('id', $subnested.apiBaseInter)/apiClassifierDetail/apiClassifierDef/apiBaseInterface">
			<xsl:variable name="nested.apiBaseInter" select="."/>
			<xsl:choose>
				<xsl:when test="$subnested.apiBaseInter=$nested.apiBaseInter"/>
				<xsl:otherwise>
					<Interface id="{.}"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="inheritList">
		<xsl:param name="base"/>
		<xsl:variable name="match">
			<xsl:if test="contains($base,':')">
				<xsl:value-of select="$base"/>
			</xsl:if>
			<xsl:if test="not(contains($base,':'))">
				<xsl:text>globalClassifier:</xsl:text>
				<xsl:value-of select="$base"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="key('id',$match)">
			<xsl:variable name="find" select=".//apiBaseClassifier/."/>
			<xsl:if test=".//apiBaseClassifier/.">
				<Inherit id="{$find}"/>
			</xsl:if>
			<xsl:if test="not($find='Object')">
				<xsl:call-template name="inheritList">
					<xsl:with-param name="base" select="$find"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="getexcludes">
		<xsl:for-each select="key('id', ./text())">
			<xsl:copy-of select=".//Excludes/Exclude"/>
			<xsl:for-each select=".//apiBaseClassifier">
				<xsl:call-template name="getexcludes"/>
			</xsl:for-each>
		</xsl:for-each>
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
	<xsl:template match="related-links">
		<related-links>
			<xsl:apply-templates select="node()"/>
		</related-links>
	</xsl:template>
	<xsl:template match="node()">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
