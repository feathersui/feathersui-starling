<?xml version="1.0" encoding="UTF-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:variable name="classheader" select="document('ClassHeader.xml')"/>
	<xsl:variable name="fieldSummary" select="document('PP_fieldSummary.xml')"/>
	<xsl:variable name="methodSummary" select="document('pp_methodSummary.xml')"/>
	<xsl:template match="node()">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- For FieldSummary -->
	<xsl:template match="apiName[parent::apiValue[not(shortdesc)] and parent::apiValue/apiValueDetail/apiValueDef/apiInheritDoc]">
		<xsl:copy-of select="."/>
		<xsl:variable name="name" select="."/>
		<xsl:variable name="apiID" select="ancestor::apiClassifier/@id"/>
		<xsl:choose>
			<xsl:when test="$classheader//apiPackage/apiClassifier[@id=$apiID]">
				<xsl:for-each select="$classheader//apiPackage/apiClassifier[@id=$apiID]/apiClassifierDetail/Inheritancelist/Inheritance/Inherit/@id">
					<xsl:variable name="baseID" select="."/>
					<xsl:choose>
						<xsl:when test="$fieldSummary//apiPackage/apiClassifier[@id=$baseID]/apiOperation[apiName = $name]/shortdesc">
							<xsl:copy-of select="$fieldSummary//apiPackage/apiClassifier[@id=$baseID]/apiOperation[apiName = $name]/shortdesc"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="no">
					<xsl:text>WARNING : Short Description not present for </xsl:text>
					<xsl:value-of select="parent::apiValue/@id"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="apiValueDef[parent::apiValueDetail[not(apiDesc)] and parent::apiValueDetail/apiValueDef/apiInheritDoc]">
		<xsl:copy-of select="."/>
		<xsl:variable name="name" select="parent::apiValueDetail/parent::apiValue/apiName"/>
		<xsl:variable name="apiID" select="ancestor::apiClassifier/@id"/>
		<xsl:choose>
			<xsl:when test="$classheader//apiPackage/apiClassifier[@id=$apiID]">
				<xsl:for-each select="$classheader//apiPackage/apiClassifier[@id=$apiID]/apiClassifierDetail/Inheritancelist/Inheritance/Inherit/@id">
					<xsl:variable name="baseID" select="."/>
					<xsl:choose>
						<xsl:when test="$fieldSummary//apiPackage/apiClassifier[@id=$baseID]/apiOperation[apiName = $name]/apiValueDetail/apiDesc">
							<xsl:copy-of select="$fieldSummary//apiPackage/apiClassifier[@id=$baseID]/apiOperation[apiName = $name]/apiValueDetail/apiDesc"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="no">
					<xsl:text>WARNING : api Description not present for </xsl:text>
					<xsl:value-of select="parent::apiValueDetail/parent::apiValue/@id"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- For MethodSummary -->
	<xsl:template match="apiName[parent::apiOperation[not(shortdesc)] and parent::apiOperation/apiOperationDetail/apiOperationDef/apiInheritDoc]">
		<xsl:copy-of select="."/>
		<xsl:variable name="name" select="."/>
		<xsl:variable name="apiID" select="ancestor::apiClassifier/@id"/>
		<xsl:choose>
			<xsl:when test="$classheader//apiPackage/apiClassifier[@id=$apiID]">
				<xsl:for-each select="$classheader//apiPackage/apiClassifier[@id=$apiID]/apiClassifierDetail/Inheritancelist/Inheritance/Inherit/@id">
					<xsl:variable name="baseID" select="."/>
					<xsl:choose>
						<xsl:when test="$methodSummary//apiPackage/apiClassifier[@id=$baseID]/apiOperation[apiName = $name]/shortdesc">
							<xsl:copy-of select="$methodSummary//apiPackage/apiClassifier[@id=$baseID]/apiOperation[apiName = $name]/shortdesc"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="no">
					<xsl:text>WARNING : Short Description not present for </xsl:text>
					<xsl:value-of select="parent::apiOperation/@id"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="apiOperationDef[parent::apiOperationDetail[not(apiDesc) or apiDesc[normalize-space(.)=' ']] and parent::apiOperationDetail/apiOperationDef/apiInheritDoc]">
		<xsl:copy-of select="."/>
		<xsl:variable name="name" select="parent::apiOperationDetail/parent::apiOperation/apiName"/>
		<xsl:variable name="apiID" select="ancestor::apiClassifier/@id"/>
		<xsl:choose>
			<xsl:when test="$classheader//apiPackage/apiClassifier[@id=$apiID]">
				<xsl:for-each select="$classheader//apiPackage/apiClassifier[@id=$apiID]/apiClassifierDetail/Inheritancelist/Inheritance/Inherit/@id">
					<xsl:variable name="baseID" select="."/>
					<xsl:choose>
						<xsl:when test="$methodSummary//apiPackage/apiClassifier[@id=$baseID]/apiOperation[apiName = $name]/apiOperationDetail/apiDesc">
							<xsl:copy-of select="$methodSummary//apiPackage/apiClassifier[@id=$baseID]/apiOperation[apiName = $name]/apiOperationDetail/apiDesc"/>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="no">
					<xsl:text>WARNING : api Description not present for </xsl:text>
					<xsl:value-of select="parent::apiOperationDetail/parent::apiOperation/@id"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="shortdesc[normalize-space(.)= ' ']"/>
	<xsl:template match="shortdesc[2]"/>
	<xsl:template match="apiDesc[normalize-space(.) =' ']"/>
	<xsl:template match="apiDesc[2]"/>
</xsl:stylesheet>
