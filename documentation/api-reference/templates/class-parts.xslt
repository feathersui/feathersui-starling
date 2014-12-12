<?xml version="1.0" encoding="utf-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://sf.net/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ifn="urn:internal:functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="saxon xs ifn">
	<xsl:import href="asdoc-util.xslt"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:param name="outPath" select="''"/>
	<xsl:param name="dita.package" select="'packages.dita'"/>
	<xsl:param name="prog_language_name" select="''"/>
	<xsl:template name="getAncestorProperty">
		<xsl:param name="isConst" select="'false'"/>
		<xsl:param name="accessLevel" select="'public'"/>
		<xsl:param name="baseClass"/>
		<xsl:param name="propertyList"/>
		<xsl:param name="processParentClass" select="true()"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="$isConst='true'">
			<xsl:for-each select="$field_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiValue[not(apiValueDetail/apiValueDef/apiProperty) and apiValueDetail/apiValueDef/apiAccess/@value =$accessLevel]">
				<xsl:if test="not(contains($propertyList,concat(' ',apiName,' ')))">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$isConst='false'">
			<xsl:for-each select="$field_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiValue[apiValueDetail/apiValueDef/apiProperty and apiValueDetail/apiValueDef/apiAccess/@value =$accessLevel or apiValueDetail/apiValueDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.]">
				<xsl:if test="not(contains($propertyList,concat(' ',apiName,' ')))">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$baseClass !='Object' and $processParentClass = true()">
			<!-- do not make a recursive call when processing interfaces -->
			<xsl:variable name="newPropertyList">
				<xsl:if test="$isConst='true'">
					<xsl:for-each
						select="$field_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiValue[not(./apiValueDetail/apiValueDef/apiProperty) and (./apiValueDetail/apiValueDef/apiAccess/@value=$accessLevel or ./apiValueDetail/apiValueDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]">
						<xsl:text> </xsl:text>
						<xsl:value-of select="./apiName"/>
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="$isConst='false'">
					<xsl:for-each
						select="$field_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiValue[./apiValueDetail/apiValueDef/apiProperty and (./apiValueDetail/apiValueDef/apiAccess/@value=$accessLevel or ./apiValueDetail/apiValueDef/apiAccess/@value=$config/namespaces/namespace[@summaryDisplay=$accessLevel]/.)]">
						<xsl:text> </xsl:text>
						<xsl:value-of select="./apiName"/>
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:if>
			</xsl:variable>
			<xsl:call-template name="getAncestorProperty">
				<xsl:with-param name="isConst" select="$isConst"/>
				<xsl:with-param name="accessLevel" select="$accessLevel"/>
				<xsl:with-param name="baseClass" select="$field_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="propertyList" select="concat($propertyList,$newPropertyList)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="inheritPropertyCount">
		<xsl:param name="isConst" select="'false'"/>
		<xsl:param name="accessLevel" select="'public'"/>
		<xsl:param name="baseClass"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countAttribute">
			<xsl:if test="$isConst='true'">
				<xsl:text> </xsl:text>
				<xsl:value-of
					select="count($field_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiValue[not(apiValueDetail/apiValueDef/apiProperty) and apiValueDetail/apiValueDef/apiAccess/@value =$accessLevel])"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="$isConst='false'">
				<xsl:text> </xsl:text>
				<xsl:value-of select="count($field_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiValue[apiValueDetail/apiValueDef/apiProperty and apiValueDetail/apiValueDef/apiAccess/@value =$accessLevel])"/>
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="$countAttribute"/>
		<xsl:if test="$baseClass !='Object'">
			<xsl:variable name="xslDocPath">
				<xsl:if test="contains($baseClass,':')">
					<xsl:value-of select="substring-before($baseClass,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($baseClass,':'))">
					<xsl:value-of select="'__Global__'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:call-template name="inheritPropertyCount">
				<xsl:with-param name="isConst" select="$isConst"/>
				<xsl:with-param name="accessLevel" select="$accessLevel"/>
				<xsl:with-param name="baseClass" select="$field_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getMethodAncestors">
		<xsl:param name="baseRef"/>
		<xsl:param name="accessLevel" select="'public'"/>
		<xsl:param name="baseClass"/>
		<xsl:param name="methodList" select="''"/>
		<xsl:param name="processParentClass" select="true()"/>
		<xsl:param name="classDeprecated"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each
			select="$method_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiOperation[apiOperationDetail/apiOperationDef/apiAccess/@value =$accessLevel or ($accessLevel='public' and apiOperationDetail/apiOperationDef/apiAccess/@value='AS3')]">
			<xsl:if test="not(contains($methodList,concat(' ',apiName,' ')))">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="$baseClass !='Object' and $processParentClass = true()">
			<xsl:variable name="newMethodList">
				<xsl:for-each
					select="$method_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiOperation[apiOperationDetail/apiOperationDef/apiAccess/@value =$accessLevel or ($accessLevel='public' and apiOperationDetail/apiOperationDef/apiAccess/@value='AS3')]">
					<xsl:text> </xsl:text>
					<xsl:value-of select="./apiName"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="xslDocPath">
				<xsl:if test="contains($baseClass,':')">
					<xsl:value-of select="substring-before($baseClass,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($baseClass,':'))">
					<xsl:value-of select="'__Global__'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:call-template name="getMethodAncestors">
				<xsl:with-param name="accessLevel" select="$accessLevel"/>
				<xsl:with-param name="baseClass" select="$method_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="methodList" select="concat($methodList,' ', $newMethodList)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="inheritMethodCount">
		<xsl:param name="accessLevel" select="'public'"/>
		<xsl:param name="baseClass"/>
		<xsl:param name="methodList" select="''"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countAttribute">
			<xsl:text> </xsl:text>
			<xsl:value-of
				select="count($method_map[@id=$xslDocPath]//apiClassifier[apiName=$className and apiOperation/apiOperationDetail/apiOperationDef/apiAccess[@value=$accessLevel or apiConstructor/apiConstructorDetail/apiConstructorDef/apiAccess/@value =$accessLevel]])"/>
			<xsl:text> </xsl:text>
		</xsl:variable>
		<xsl:value-of select="$countAttribute"/>
		<xsl:if test="$baseClass !='Object'">
			<xsl:variable name="newMethodList">
				<xsl:for-each
					select="$method_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/apiOperation[apiOperationDetail/apiOperationDef/apiAccess/@value =$accessLevel or ($accessLevel='public' and apiOperationDetail/apiOperationDef/apiAccess/@value='AS3')]">
					<xsl:text> </xsl:text>
					<xsl:value-of select="./apiName"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="xslDocPath">
				<xsl:if test="contains($baseClass,':')">
					<xsl:value-of select="substring-before($baseClass,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($baseClass,':'))">
					<xsl:value-of select="'__Global__'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:call-template name="inheritMethodCount">
				<xsl:with-param name="accessLevel" select="$accessLevel"/>
				<xsl:with-param name="baseClass" select="$method_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="methodList" select="concat($methodList,' ', $newMethodList)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="doesValueExistsInList">
		<xsl:param name="valueToFind" select="''"/>
		<xsl:param name="givenList" select="''"/>
		<!--If the method or processMethod List is blank return false indicating the method has not been processed-->
		<xsl:if test="string-length($valueToFind) = 0 or string-length(normalize-space($givenList)) = 0 ">
			<xsl:value-of select="'false'"/>
		</xsl:if>
		<xsl:variable name="valueSet" select="tokenize($givenList,' ')"/>
		<xsl:for-each select="$valueSet">
			<xsl:if test=". = $valueToFind">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="inheritEventCount">
		<xsl:param name="baseClass"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countAttribute">
			<xsl:text> </xsl:text>
			<xsl:value-of select="count($event_map[@id=$xslDocPath]/apiClassifier[apiName=$className]/adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)])"/>
			<xsl:text> </xsl:text>
		</xsl:variable>
		<xsl:value-of select="$countAttribute"/>
		<xsl:if test="$baseClass !='Object'">
			<xsl:variable name="xslDocPath">
				<xsl:if test="contains($baseClass,':')">
					<xsl:value-of select="substring-before($baseClass,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($baseClass,':'))">
					<xsl:value-of select="'__Global__'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:call-template name="inheritEventCount">
				<xsl:with-param name="baseClass" select="$event_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$className]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getInheritedEvent">
		<xsl:param name="baseClass"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:param name="eventsList"/>
		<xsl:param name="processParentClass" select="true()"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="$event_map[@id=$xslDocPath]/apiClassifier[apiName=$className]/adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)]">
			<xsl:if test="not(contains($eventsList,concat(' ',apiName,' ')))">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="$baseClass !='Object' and $processParentClass = true()">
			<xsl:variable name="newEventsList">
				<xsl:for-each select="$event_map[@id=$xslDocPath]/apiClassifier[apiName=$className]/adobeApiEvent[not(adobeApiEventDetail/adobeApiEventDef/apiDefinedEvent)]">
					<xsl:text> </xsl:text>
					<xsl:value-of select="./apiName"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="getInheritedEvent">
				<xsl:with-param name="baseClass" select="$event_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$className]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="currentPackage" select="$currentPackage"/>
				<xsl:with-param name="eventsList" select="concat($eventsList,' ', $newEventsList)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="inheritStyleCount">
		<xsl:param name="baseClass"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countAttribute">
			<xsl:text> </xsl:text>
			<xsl:value-of select="count($style_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata[styles/style])"/>
			<xsl:text> </xsl:text>
		</xsl:variable>
		<xsl:value-of select="$countAttribute"/>
		<xsl:if test="$baseClass !='Object'">
			<xsl:call-template name="inheritStyleCount">
				<xsl:with-param name="baseClass" select="$style_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="inheritSkinStateCount">
		<xsl:param name="baseClass"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countAttribute">
			<xsl:text> </xsl:text>
			<xsl:value-of select="count($classHeader_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata[skinStates/SkinState])"/>
			<xsl:text> </xsl:text>
		</xsl:variable>
		<xsl:value-of select="$countAttribute"/>
		<xsl:if test="$baseClass !='Object'">
			<xsl:call-template name="inheritSkinStateCount">
				<xsl:with-param name="baseClass" select="$classHeader_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="inheritSkinPartCount">
		<xsl:param name="baseClass"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countAttribute">
			<xsl:text> </xsl:text>
			<xsl:value-of select="count($classHeader_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata[skinParts/SkinPart])"/>
			<xsl:text> </xsl:text>
		</xsl:variable>
		<xsl:value-of select="$countAttribute"/>
		<xsl:if test="$baseClass !='Object'">
			<xsl:call-template name="inheritSkinPartCount">
				<xsl:with-param name="baseClass" select="$classHeader_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>	
	<xsl:template name="getInheritedStyle">
		<xsl:param name="baseClass"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:param name="stylesList"/>
		<xsl:param name="processParentClass" select="true()"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="$style_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata/styles/style">
			<xsl:if test="not(contains($stylesList,concat(' ',@name,' ')))">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="$baseClass !='Object' and $processParentClass=true()">
			<xsl:variable name="newStylesList">
				<xsl:for-each select="$style_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata/styles/style">
					<xsl:value-of select="concat(' ',@name,' ')"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="getInheritedStyle">
				<xsl:with-param name="baseClass" select="$style_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="currentPackage" select="$currentPackage"/>
				<xsl:with-param name="stylesList" select="concat($stylesList,' ',$newStylesList)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getInheritedSkinState">
		<xsl:param name="baseClass"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:param name="SkinStateList"/>
		<xsl:param name="processParentClass" select="true()"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="$classHeader_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata/skinStates/SkinState">
			<xsl:if test="not(contains($SkinStateList,concat(' ',@name,' ')))">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="$baseClass !='Object' and $processParentClass=true()">
			<xsl:variable name="newSkinStateList">
				<xsl:for-each select="$classHeader_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata/skinStates/SkinState">
					<xsl:value-of select="concat(' ',@name,' ')"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="getInheritedSkinState">
				<xsl:with-param name="baseClass" select="$classHeader_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="currentPackage" select="$currentPackage"/>
				<xsl:with-param name="SkinStateList" select="concat($SkinStateList,' ',$newSkinStateList)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getInheritedSkinPart">
		<xsl:param name="baseClass"/>
		<xsl:param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:param name="SkinPartList"/>
		<xsl:param name="processParentClass" select="true()"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="$classHeader_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata/skinParts/SkinPart">
			<xsl:if test="not(contains($SkinPartList,concat(' ',@name,' ')))">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="$baseClass !='Object' and $processParentClass=true()">
			<xsl:variable name="newSkinPartList">
				<xsl:for-each select="$classHeader_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata/skinParts/SkinPart">
					<xsl:value-of select="concat(' ',@name,' ')"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="getInheritedSkinPart">
				<xsl:with-param name="baseClass" select="$classHeader_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="currentPackage" select="$currentPackage"/>
				<xsl:with-param name="SkinPartList" select="concat($SkinPartList,' ',$newSkinPartList)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>	
	<xsl:template name="inheritEffectCount">
		<xsl:param name="baseClass"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countAttribute">
			<xsl:text> </xsl:text>
			<xsl:value-of select="count($effect_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata[effects/effect])"/>
			<xsl:text> </xsl:text>
		</xsl:variable>
		<xsl:value-of select="$countAttribute"/>
		<xsl:if test="$baseClass !='Object'">
			<xsl:variable name="xslDocPath">
				<xsl:if test="contains($baseClass,':')">
					<xsl:value-of select="substring-before($baseClass,':')"/>
				</xsl:if>
				<xsl:if test="not(contains($baseClass,':'))">
					<xsl:value-of select="'__Global__'"/>
				</xsl:if>
			</xsl:variable>
			<xsl:call-template name="inheritEffectCount">
				<xsl:with-param name="baseClass" select="$effect_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getInheritedEffect">
		<xsl:param name="baseClass"/>
		<xsl:param name="currentPackage"/>
		<xsl:param name="effectsList"/>
		<xsl:param name="processParentClass" select="true()"/>
		<xsl:variable name="className">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-after($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="$baseClass"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="xslDocPath">
			<xsl:if test="contains($baseClass,':')">
				<xsl:value-of select="substring-before($baseClass,':')"/>
			</xsl:if>
			<xsl:if test="not(contains($baseClass,':'))">
				<xsl:value-of select="'__Global__'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="$effect_map[@id=$xslDocPath]//apiClassifier[apiName=$className]/prolog/asMetadata/effects/effect">
			<xsl:if test="not(contains($effectsList,concat(' ',@name,' ')))">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="$baseClass !='Object' and $processParentClass = true()">
			<xsl:variable name="newEffectsList">
				<xsl:for-each select="$effect_map[@id=$xslDocPath]/apiClassifier[apiName=$className]/asMetadata/effects/effect">
					<xsl:text> </xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="getInheritedEffect">
				<xsl:with-param name="baseClass" select="$effect_map[@id=$xslDocPath]/apiClassifier[@id=$baseClass or apiName=$baseClass]/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
				<xsl:with-param name="currentPackage" select="$currentPackage"/>
				<xsl:with-param name="effectsList" select="concat($effectsList,' ',$newEffectsList )"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="DefaultProperty">
		<p>
			<span class="classHeaderTableLabel">
				<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DefaultMXMLProperty']]/entry[2]/p"/>
			</span>
			<code>
				<xsl:value-of select="@name"/>
			</code>
		</p>
	</xsl:template>
	<xsl:template name="classHeader">
		<xsl:param name="classNode"/>
		<xsl:param name="classDeprecated"/>
		<xsl:variable name="packageName" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="baseRef">
			<xsl:call-template name="getBaseRef">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ID" select="@id"/>
		<xsl:variable name="isTopLevel">
			<xsl:call-template name="isTopLevel">
				<xsl:with-param name="packageName" select="$packageName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:for-each select="$classNode">
			<xsl:call-template name="getPageLinks">
				<xsl:with-param name="title">
					<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface">
						<xsl:value-of select="./apiName"/>
					</xsl:if>
					<xsl:if test="not(./apiClassifierDetail/apiClassifierDef/apiInterface)">
						<xsl:value-of select="./apiName"/>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<div class="MainContent">
			<xsl:variable name="id" select="@id"/>
			<xsl:apply-templates mode="annotate"
				select="$config/annotate/item[@type='class' and ((@name=translate($id,':','.') and (not(string-length(@packageName)) or @packageName=$packageName)) or (not(string-length(@name)) and string-length(@packageName) and tokenize(@packageName,',')[starts-with($packageName,.)]))]"/>
			<table class="classHeaderTable" cellpadding="0" cellspacing="0">
				<tr>
					<td class="classHeaderTableLabel">
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>
							<xsl:otherwise>
								<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PackagePackage']]/entry[2]/p"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>
							<xsl:otherwise>
								<a href="package-detail.html" onclick="javascript:loadClassListFrame('class-list.html')">
									<xsl:if test="string-length(../apiName) &gt; 0 and not($isTopLevel='true')">
										<xsl:value-of select="../apiName"/>
									</xsl:if>
									<xsl:if test="$isTopLevel='true'">
										<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'TopLevel']]/entry[2]/p"/>
									</xsl:if>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<xsl:if test="not(.//apiClassifierDef/apiInterface)">
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>
							<xsl:otherwise>
								<td class="classHeaderTableLabel">Class</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test=".//apiClassifierDef/apiInterface">
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>
							<xsl:otherwise>
								<td class="classHeaderTableLabel">Interface</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<td class="classSignature">
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>
							<xsl:otherwise>
								<xsl:value-of select="./apiClassifierDetail/apiClassifierDef/apiAccess/@value"/>
								<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiFinal">
									<xsl:text> final </xsl:text>
								</xsl:if>
								<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiDynamic">
									<xsl:text> dynamic </xsl:text>
								</xsl:if>
								<xsl:text> </xsl:text>
								<xsl:if test="not(./apiClassifierDetail/apiClassifierDef/apiInterface)">
									<xsl:text> class </xsl:text>
								</xsl:if>
								<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface">
									<xsl:text> interface </xsl:text>
								</xsl:if>
								<xsl:text> </xsl:text>
								<xsl:value-of select="./apiName"/>
								<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/Inheritancelist/BaseInterface/Interface">
									<xsl:text> extends </xsl:text>
								</xsl:if>
								<xsl:for-each select="./apiClassifierDetail/Inheritancelist/BaseInterface/Interface/@id">
									<xsl:variable name="text" select="."/>
									<xsl:for-each select="$text">
										<xsl:sort select="substring-after(text(),':')" order="ascending" data-type="text" lang="en-US"/>
									</xsl:for-each>
									<xsl:variable name="h2" select="substring-before($text,':')"/>
									<xsl:variable name="h1" select="substring-after($text,':')"/>
									<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
									<xsl:text> </xsl:text>
									
									<xsl:if test="count($classHeader_map//apiClassifier[@id=$text] ) &gt; 0">
										<a>
											<xsl:attribute name="href">
												<xsl:value-of select="$file"/>
											</xsl:attribute>
											<xsl:value-of select="$h1"/>
										</a>
									</xsl:if>
									<xsl:if test="not(count($classHeader_map//apiClassifier[@id=$text] ) &gt; 0)">
										<xsl:if test="not(contains($text,':'))">
											<xsl:value-of select="$text"/>
										</xsl:if>
										<xsl:if test="contains($text,':')">
											<xsl:value-of select="concat($h2,concat('.',$h1))"/>
										</xsl:if>
									</xsl:if>
									
									<xsl:text></xsl:text>
									<xsl:if test="position() != last()">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:if test="not(./apiClassifierDetail/apiClassifierDef/apiInterface) and ./apiClassifierDetail/Inheritancelist/Inheritance/Inherit/@id">
					<tr>
						<td class="classHeaderTableLabel">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Inheritance']]/entry[2]/p"/>
						</td>
						<td class="inheritanceList">
							<xsl:value-of select="./apiName"/>
							<xsl:text> </xsl:text>
							<xsl:for-each select="./apiClassifierDetail/Inheritancelist/Inheritance/Inherit">
								<xsl:variable name="val" select="@id"/>
								<xsl:choose>
									<xsl:when test="not(@id)"/>
									<xsl:otherwise>
										<xsl:if test="$prog_language_name='javascript'" />
										<xsl:if test="$prog_language_name!='javascript'">
											<xsl:variable name="h2" select="substring-before($val,':')"/>
											<xsl:variable name="h1" select="substring-after($val,':')"/>
											<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
											<xsl:if test="not(contains($val,':'))">
												<xsl:variable name="global" select="$val"/>
												<xsl:if test="contains(ancestor::apiClassifier/@id,'globalClassifier:')">
													<xsl:variable name="gfile" select="concat($val,'.html')"/>
													<xsl:variable name="iconRef">
														<xsl:text>images/inherit-arrow.gif</xsl:text>
													</xsl:variable>
													<xsl:text> </xsl:text>
													<img src="{$iconRef}" title="Inheritance" alt="Inheritance" class="inheritArrow"/>
													<xsl:text> </xsl:text>
													<xsl:if test="count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0">
														<a>
															<xsl:attribute name="href">
																<xsl:value-of select="$gfile"/>
															</xsl:attribute>
															<xsl:value-of select="$val"/>
														</a>
													</xsl:if>
													<xsl:if test="not(count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0)">
														<xsl:value-of select="$val"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(contains(ancestor::apiClassifier/@id,'globalClassifier:'))">
													<xsl:variable name="file1" select="concat($baseRef,$val,'.html')"/>
													<xsl:variable name="iconRef">
														<xsl:text>images/inherit-arrow.gif</xsl:text>
													</xsl:variable>
													<xsl:text> </xsl:text>
													<img src="{$baseRef}{$iconRef}" title="Inheritance" alt="Inheritance" class="inheritArrow"/>
													<xsl:text> </xsl:text>
													<xsl:if test="count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0">
														<a>
															<xsl:attribute name="href">
																<xsl:value-of select="$file1"/>
															</xsl:attribute>
															<xsl:value-of select="$val"/>
														</a>
													</xsl:if>
													<xsl:if test="not(count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0)">
														<xsl:value-of select="$val"/>
													</xsl:if>
												</xsl:if>
											</xsl:if>
											<xsl:if test="contains($val,':')">
												<xsl:variable name="iconRef">
													<xsl:text>images/inherit-arrow.gif</xsl:text>
												</xsl:variable>
												<xsl:text> </xsl:text>
												<img src="{$baseRef}{$iconRef}" title="Inheritance" alt="Inheritance" class="inheritArrow"/>
												<xsl:text> </xsl:text>
												<xsl:if test="count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0">
													<a>
														<xsl:attribute name="href">
															<xsl:value-of select="$file"/>
														</xsl:attribute>
														<xsl:value-of select="$h1"/>
													</a>
												</xsl:if>
												<xsl:if test="not(count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0)">
													<xsl:value-of select="concat($h2,concat('.',$h1))"/>
												</xsl:if>
											</xsl:if>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="not(./apiClassifierDetail/apiClassifierDef/apiInterface) and count(./apiClassifierDetail/Inheritancelist/Implements/Implement) &gt; 0">
					<xsl:choose>
						<xsl:when test="$prog_language_name='javascript'"/>
						<xsl:otherwise>
							<tr>
								<td class="classHeaderTableLabel">Implements</td>
								<td>
									<xsl:for-each select="./apiClassifierDetail/Inheritancelist/Implements/Implement">
										<xsl:variable name="val" select="@id"/>
										<xsl:variable name="h2" select="substring-before($val,':')"/>
										<xsl:variable name="h1" select="substring-after($val,':')"/>
										<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
										<xsl:if test="not(contains($val,':'))">
											<xsl:variable name="file1" select="concat($baseRef,$val,'.html')"/>
											<xsl:text> </xsl:text>
											<xsl:if test="count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0">
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$file1"/>
													</xsl:attribute>
													<xsl:value-of select="$val"/>
												</a>
											</xsl:if>
											<xsl:if test="not(count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0)">
												<xsl:value-of select="$val"/>
											</xsl:if>
										</xsl:if>
										<xsl:if test="contains($val,':')">
											<xsl:text> </xsl:text>
											<xsl:if test="count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0">
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$file"/>
													</xsl:attribute>
													<xsl:value-of select="$h1"/>
												</a>
											</xsl:if>
											<xsl:if test="not(count($classHeader_map//apiClassifier[@id=$val] ) &gt; 0)">
												<xsl:value-of select="concat($h2,concat('.',$h1))"/>
											</xsl:if>
										</xsl:if>
										<xsl:if test="position() != last()">
											<xsl:text>, </xsl:text>
										</xsl:if>
									</xsl:for-each>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="not(./apiClassifierDetail/apiClassifierDef/apiInterface)">
					<xsl:if test="./apiClassifierDetail/Inheritancelist/Subclasses/class">
						<xsl:choose>
							<xsl:when test="$prog_language_name='javascript'"/>
							<xsl:otherwise>
								<tr>
									<td class="classHeaderTableLabel">
										<xsl:text>Subclasses</xsl:text>
									</td>
									<td>
										<xsl:for-each select="./apiClassifierDetail/Inheritancelist/Subclasses/class">
											<xsl:sort select="substring-after(@id,':')" order="ascending" data-type="text" lang="en-US"/>
											<xsl:if test="not(contains(@id,'globalClassifier:'))">
												<xsl:variable name="val" select="@id"/>
												<xsl:variable name="h2" select="substring-before($val,':')"/>
												<xsl:variable name="h1" select="substring-after($val,':')"/>
												<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
												<xsl:if test="not(contains($val,':'))">
													<xsl:variable name="file1" select="concat($baseRef,$val,'.html')"/>
													<xsl:text> </xsl:text>
													<a>
														<xsl:attribute name="href">
															<xsl:value-of select="$file1"/>
														</xsl:attribute>
														<xsl:value-of select="$val"/>
													</a>
												</xsl:if>
												<xsl:if test="contains($val,':')">
													<xsl:text> </xsl:text>
													<a>
														<xsl:attribute name="href">
															<xsl:value-of select="$file"/>
														</xsl:attribute>
														<xsl:value-of select="$h1"/>
													</a>
												</xsl:if>
												<xsl:if test="position() != last()">
													<xsl:text>, </xsl:text>
												</xsl:if>
											</xsl:if>
											<xsl:if test="contains(@id,'globalClassifier:')">
												<xsl:variable name="val" select="substring-after(@id, 'globalClassifier:')"/>
												<xsl:variable name="h2" select="substring-before($val,':')"/>
												<xsl:variable name="h1" select="substring-after($val,':')"/>
												<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
												<xsl:if test="not(contains($val,':'))">
													<xsl:variable name="file1" select="concat($baseRef,$val,'.html')"/>
													<xsl:text> </xsl:text>
													<a>
														<xsl:attribute name="href">
															<xsl:value-of select="$file1"/>
														</xsl:attribute>
														<xsl:value-of select="$val"/>
													</a>
												</xsl:if>
												<xsl:if test="contains($val,':')">
													<xsl:text> </xsl:text>
													<a>
														<xsl:attribute name="href">
															<xsl:value-of select="$file"/>
														</xsl:attribute>
														<xsl:value-of select="$h1"/>
													</a>
												</xsl:if>
												<xsl:if test="position() != last()">
													<xsl:text>, </xsl:text>
												</xsl:if>
											</xsl:if>
										</xsl:for-each>
									</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
				<xsl:if test="./apiClassifierDetail/apiClassifierDef/apiInterface and ./apiClassifierDetail/Inheritancelist/Implementors/Implementor">
					<tr>
						<td class="classHeaderTableLabel">
							<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Implementors']]/entry[2]/p"/>
						</td>
						<td>
							<xsl:for-each select="./apiClassifierDetail/Inheritancelist/Implementors/Implementor">
								<xsl:if test="not(contains(@id,'globalClassifier:'))">
									<xsl:variable name="val" select="@id"/>
									<xsl:variable name="h2" select="substring-before($val,':')"/>
									<xsl:variable name="h1" select="substring-after($val,':')"/>
									<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
									<xsl:if test="not(contains($val,':'))">
										<xsl:variable name="file1" select="concat($baseRef,$val,'.html')"/>
										<xsl:text> </xsl:text>
										<xsl:choose>
											<xsl:when test="$prog_language_name='javascript'"/>
											<xsl:otherwise>
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$file1"/>
													</xsl:attribute>
													<xsl:value-of select="$val"/>
												</a>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="contains($val,':')">
										<xsl:text> </xsl:text>
										<a>
											<xsl:attribute name="href">
												<xsl:value-of select="$file"/>
											</xsl:attribute>
											<xsl:value-of select="$h1"/>
										</a>
									</xsl:if>
									<xsl:if test="position() != last()">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:if>
								<xsl:if test="contains(@id,'globalClassifier:')">
									<xsl:variable name="val" select="substring-after(@id, 'globalClassifier:')"/>
									<xsl:variable name="h2" select="substring-before($val,':')"/>
									<xsl:variable name="h1" select="substring-after($val,':')"/>
									<xsl:variable name="file" select="concat($baseRef,translate($h2,'.','/'),'/',$h1,'.html')"/>
									<xsl:if test="not(contains($val,':'))">
										<xsl:variable name="file1" select="concat($baseRef,$val,'.html')"/>
										<xsl:text> </xsl:text>
										<xsl:choose>
											<xsl:when test="$prog_language_name='javascript'"/>
											<xsl:otherwise>
												<a>
													<xsl:attribute name="href">
														<xsl:value-of select="$file1"/>
													</xsl:attribute>
													<xsl:value-of select="$val"/>
												</a>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="contains($val,':')">
										<xsl:text> </xsl:text>
										<a>
											<xsl:attribute name="href">
												<xsl:value-of select="$file"/>
											</xsl:attribute>
											<xsl:value-of select="$h1"/>
										</a>
									</xsl:if>
									<xsl:if test="position() != last()">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:if>
			</table>
			<xsl:if test="$classDeprecated='true'">
				<xsl:apply-templates select="deprecated"/>
				<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			</xsl:if>
			<xsl:apply-templates select="apiClassifierDetail/apiClassifierDef/apiDeprecated"/>
			<xsl:call-template name="version"/>
			<p/>
			  <xsl:if test="prolog/asMetadata/Alternative">
			    <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			    <table width="100%" class="innertable">
			      <xsl:for-each select="prolog/asMetadata/Alternative">
				<xsl:variable name="replacement" select="@replacement"/>
				<xsl:variable name="version" select="@since"/>
				<xsl:variable name="baseref" select="$baseRef"/>
				<xsl:choose>
				  <xsl:when test="$replacement='none'">
				    <tr>
				      <td bgcolor="#FFFFCC">
				      	<xsl:value-of select="$nbsp"/>
				      </td>
				      <td bgcolor="#FFFFCC">
					<xsl:apply-templates select="./description/node()"/>
				      </td>
				    </tr>
				  </xsl:when>
				  <xsl:when test="$replacement!='none'">
				    <xsl:variable name="desc.terms" select="$asdoc_terms/row[entry[1][p/text() = 'altr.desc.1st']]/entry[2]/p"/>
				    <xsl:variable name="class.link">
				      <xsl:variable name="class" select="substring-after(substring-after($replacement,'.'),'.')"/>
				      <xsl:variable name="alt.pkg" select="substring-before($replacement,concat('.',$class))"/>
				      <xsl:variable name="pkg.path" select="translate($alt.pkg,'.','/')"/>
				      <xsl:value-of select="concat($baseref,$pkg.path,'/',$class,'.html')"/>
				    </xsl:variable>
				    <xsl:variable name="replace.version" select="replace($desc.terms,'%ver%',$version)"/>
				    <tr>
				      <td bgcolor="#FFFFCC">
					
					<img src="{$baseRef}images/P_AlternativeMetadataIndicator_30x28_N.png" />
				      </td>
				      <td bgcolor="#FFFFCC">
					<xsl:value-of select="substring-before($replace.version,'%class%')"/>
					<a href="{$class.link}">
					  <xsl:value-of select="$replacement"/>
					</a>
					<xsl:value-of select="substring-after($replace.version,'%class%')"/>
					<xsl:if test="./description">
					  <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
					  <p>
					    <xsl:apply-templates select="./description/node()"/>
					  </p>
					</xsl:if>
				      </td>
				    </tr>
				  </xsl:when>
				</xsl:choose>
			      </xsl:for-each>
			    </table>
			    <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			  </xsl:if>			
			<xsl:call-template name="description"/>
			<p/>
			<xsl:if test="apiClassifierDetail/apiClassifierDef/apiInheritDoc">
				<xsl:call-template name="getInheritDocText">
					<xsl:with-param name="baseClass" select="ancestor-or-self::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
					<xsl:with-param name="descriptionType" select="'apiDesc'"/>
					<xsl:with-param name="entryType" select="'apiClassifier'"/>
					<xsl:with-param name="nameToMatch" select="./apiName"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="prolog/asCustoms/mxml">
				<a name="mxmlSyntaxSummary"/>
				<span class="classHeaderTableLabel">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'MXMLSyntax']]/entry[2]/p"/>
				</span>
				<span id="showMxmlLink" style="display:none">
					<a href="#mxmlSyntaxSummary" onclick="toggleMXMLOnly();">
						<img src="{$baseRef}images/collapsed.gif" title="collapsed" alt="collapsed" class="collapsedImage"/>
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'ShowMXMLSyntax']]/entry[2]/p"/>
					</a>
					<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
				</span>
				<span id="hideMxmlLink">
					<a href="#mxmlSyntaxSummary" onclick="toggleMXMLOnly();">
						<img src="{$baseRef}images/expanded.gif" title="expanded" alt="expanded" class="expandedImage"/>
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'HideMXMLSyntax']]/entry[2]/p"/>
					</a>
				</span>
				<div id="mxmlSyntax" class="mxmlSyntax">
					<xsl:value-of disable-output-escaping="yes" select="prolog/asCustoms/mxml/."/>
				</div>
				<script language="javascript" type="text/javascript">
					<xsl:comment>
						<xsl:text>
								</xsl:text>
						<xsl:text>setMXMLOnly();</xsl:text>
						<xsl:text>
								</xsl:text>
					</xsl:comment>
				</script>
			</xsl:if>
			<xsl:if test="prolog/asMetadata/SkinStates/@states">
				<xsl:variable name="state" select="normalize-space(prolog/asMetadata/SkinStates/@states)"/>
				<h3>Skinning the component</h3>
				<p>To skin the component, implement a skin that defines the following skin states: &lt;br/&gt;&lt;br/&gt;<xsl:value-of select="$state"/>  &lt;br/&gt;&lt;br/&gt;While you must implement all skin states, a skin state can be empty. An empty skin state defines no changes to the default skin state.</p>
			</xsl:if>
			<xsl:apply-templates select="prolog/asMetadata/DefaultProperty"/>
			<xsl:apply-templates select="example"/>
			<xsl:call-template name="includeExampleLink"/>
			<xsl:call-template name="sees">
				<xsl:with-param name="labelClass" select="'classHeaderTableLabel'"/>
			</xsl:call-template>
			<xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
			<hr/>
		</div>
	</xsl:template>
	<xsl:template match="apiDeprecated" >
		<xsl:variable name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="ancestorPath" select="ancestor::apiClassifierDetail/apiClassifierDef"/>
		<div style="white-space:nowrap" valign="top">
			<xsl:choose>
				<xsl:when test="@sinceVersion">
					<b>
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DeprecatedSince']]/entry[2]/p"/>
					</b>
					<xsl:text> </xsl:text>
					<xsl:value-of select="@sinceVersion"/>
					<xsl:if test="@replacement!=''">
						<xsl:text>: </xsl:text>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<b>
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Deprecated']]/entry[2]/p"/>
						<xsl:text>:</xsl:text>
						<xsl:text> </xsl:text>
					</b>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@replacement!=''">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PleaseUse']]/entry[2]/p"/>
					<xsl:text> </xsl:text>
					<xsl:if test="contains(@replacement,',')">
						<xsl:for-each select="tokenize(@replacement, ',')">
							<xsl:variable name="spec" select="."/>
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
									<xsl:with-param name="currentPackage" select="$currentPackage"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="contains($linkpath1,'.') and contains($linkpath1,'/')">
									<A href="{$linkpath1}">
										<xsl:value-of select="$spec"/>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$spec"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="position() != last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
					<xsl:variable name="linkpath">
						<xsl:call-template name="getDeprecatedReplacementLink">
							<xsl:with-param name="replacement" select="@replacement"/>
							<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
							<xsl:with-param name="ancestorPath" select="$ancestorPath"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="not(contains(@replacement,','))">
						<xsl:if test="$ancestorPath">
							<xsl:variable name="lastToken">
								<xsl:call-template name="lastIndexOf">
									<xsl:with-param name="string" select="@replacement"/>
									<xsl:with-param name="char" select="'.'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="firstPassToken" select="substring-before(@replacement,concat('.',$lastToken))"/>
							<xsl:variable name="testToken">
								<xsl:if test="string-length($firstPassToken) &gt; 0">
									<xsl:value-of select="concat($firstPassToken,':',@replacement)"/>
								</xsl:if>
								<xsl:if test="string-length($firstPassToken) = 0">
									<xsl:if test="$currentPackage = '__Global__'">
										<xsl:value-of select="concat('globalClassifier:',@replacement)"/>
									</xsl:if>
									<xsl:if test="not($currentPackage = '__Global__')">
										<xsl:value-of select="concat($currentPackage,':',@replacement)"/>
									</xsl:if>
								</xsl:if>
							</xsl:variable>
							<xsl:if test="count($classHeader_map//apiClassifier[@id=$testToken] ) &gt; 0">
								<A href="{$linkpath}">
									<xsl:value-of select="@replacement"/>
								</A>
							</xsl:if>
							<xsl:if test="count($classHeader_map//apiClassifier[@id=$testToken] ) = 0">
									<xsl:value-of select="@replacement"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not($ancestorPath)">
							<xsl:if test="contains(@replacement, '.')">
								<xsl:variable name="lastToken">
									<xsl:call-template name="lastIndexOf">
										<xsl:with-param name="string" select="@replacement"/>
										<xsl:with-param name="char" select="'.'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="firstPassToken" select="substring-before(@replacement,concat('.',$lastToken))"/>
								<xsl:variable name="className">
									<xsl:call-template name="lastIndexOf">
										<xsl:with-param name="string" select="$firstPassToken"/>
										<xsl:with-param name="char" select="'.'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="packageName" select="substring-before($firstPassToken,concat('.',$className))"/>
								<xsl:variable name="testToken">
									<xsl:if test="string-length($packageName) &gt; 0">
										<xsl:value-of select="$packageName"/>
									</xsl:if>
									<xsl:if test="string-length($packageName) = 0">
											<xsl:value-of select="$currentPackage"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="testToken2">
									<xsl:if test="string-length($firstPassToken) &gt; 0">
										<xsl:value-of select="$firstPassToken"/>
									</xsl:if>
									<xsl:if test="string-length($firstPassToken) = 0">
											<xsl:value-of select="$classHeader_map//apiClassifier/apiName"/>
									</xsl:if>
								</xsl:variable>
								<xsl:if test="count($classHeader_map//apiClassifier[@id=concat($testToken, ':', $testToken2)] ) &gt; 0">
									<A href="{$linkpath}">
										<xsl:value-of select="@replacement"/>
									</A>
								</xsl:if>
								<xsl:if test="count($classHeader_map//apiClassifier[@id=concat($testToken, ':', $testToken2)] ) = 0">
										<xsl:value-of select="@replacement"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test="not(contains(@replacement, '.'))">
								<A href="{$linkpath}">
									<xsl:value-of select="@replacement"/>
								</A>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:when>
				<xsl:when test="apiDesc">
					<xsl:for-each select="./apiDesc">
						<xsl:call-template name="processTags"/>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template match="apiDeprecated" mode="event" >
		<xsl:variable name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
		<xsl:variable name="ancestorPath" select="ancestor::apiClassifierDetail/apiClassifierDef"/>
		<div style="white-space:nowrap" valign="top">
			<xsl:choose>
				<xsl:when test="@sinceVersion">
					<b>
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'DeprecatedSince']]/entry[2]/p"/>
					</b>
					<xsl:text> </xsl:text>
					<xsl:value-of select="@sinceVersion"/>
					<xsl:if test="@replacement!=''">
						<xsl:text>: </xsl:text>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<b>
						<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'Deprecated']]/entry[2]/p"/>
						<xsl:text>:</xsl:text>
						<xsl:text> </xsl:text>
					</b>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@replacement!=''">
					<xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'PleaseUse']]/entry[2]/p"/>
					<xsl:text> </xsl:text>
					<xsl:if test="contains(@replacement,',')">
						<xsl:for-each select="tokenize(@replacement, ',')">
							<xsl:variable name="spec" select="."/>
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
									<xsl:with-param name="currentPackage" select="$currentPackage"/>
									<xsl:with-param name="mode" select="'event:'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="contains($linkpath1,'.') and contains($linkpath1,'/')">
									<A href="{$linkpath1}">
										<xsl:value-of select="$spec"/>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$spec"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="position() != last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
					<xsl:variable name="linkpath">
						<xsl:call-template name="getDeprecatedReplacementLink">
							<xsl:with-param name="replacement" select="@replacement"/>
							<xsl:with-param name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
							<xsl:with-param name="ancestorPath" select="$ancestorPath"/>
							<xsl:with-param name="mode" select="'event:'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="not(contains(@replacement,','))">
						<xsl:if test="$ancestorPath">
							<xsl:variable name="lastToken">
								<xsl:call-template name="lastIndexOf">
									<xsl:with-param name="string" select="@replacement"/>
									<xsl:with-param name="char" select="'.'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="firstPassToken" select="substring-before(@replacement,concat('.',$lastToken))"/>
							<xsl:variable name="testToken">
								<xsl:if test="string-length($firstPassToken) &gt; 0">
									<xsl:value-of select="concat($firstPassToken,':',@replacement)"/>
								</xsl:if>
								<xsl:if test="string-length($firstPassToken) = 0">
									<xsl:if test="$currentPackage = '__Global__'">
										<xsl:value-of select="concat('globalClassifier:',@replacement)"/>
									</xsl:if>
									<xsl:if test="not($currentPackage = '__Global__')">
										<xsl:value-of select="concat($currentPackage,':',@replacement)"/>
									</xsl:if>
								</xsl:if>
							</xsl:variable>
							<xsl:if test="count($classHeader_map//apiClassifier[@id=$testToken] ) &gt; 0">
								<A href="{$linkpath}">
									<xsl:value-of select="@replacement"/>
								</A>
							</xsl:if>
							<xsl:if test="count($classHeader_map//apiClassifier[@id=$testToken] ) = 0">
									<xsl:value-of select="@replacement"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not($ancestorPath)">
							<xsl:if test="contains(@replacement, '.')">
								<xsl:variable name="lastToken">
									<xsl:call-template name="lastIndexOf">
										<xsl:with-param name="string" select="@replacement"/>
										<xsl:with-param name="char" select="'.'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="firstPassToken" select="substring-before(@replacement,concat('.',$lastToken))"/>
								<xsl:variable name="className">
									<xsl:call-template name="lastIndexOf">
										<xsl:with-param name="string" select="$firstPassToken"/>
										<xsl:with-param name="char" select="'.'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="packageName" select="substring-before($firstPassToken,concat('.',$className))"/>
								<xsl:variable name="testToken">
									<xsl:if test="string-length($packageName) &gt; 0">
										<xsl:value-of select="$packageName"/>
									</xsl:if>
									<xsl:if test="string-length($packageName) = 0">
											<xsl:value-of select="$currentPackage"/>
									</xsl:if>
								</xsl:variable>
								<xsl:variable name="testToken2">
									<xsl:if test="string-length($firstPassToken) &gt; 0">
										<xsl:value-of select="$firstPassToken"/>
									</xsl:if>
									<xsl:if test="string-length($firstPassToken) = 0">
											<xsl:value-of select="$classHeader_map//apiClassifier/apiName"/>
									</xsl:if>
								</xsl:variable>
								<xsl:if test="count($classHeader_map//apiClassifier[@id=concat($testToken, ':', $testToken2)] ) &gt; 0">
									<A href="{$linkpath}">
										<xsl:value-of select="@replacement"/>
									</A>
								</xsl:if>
								<xsl:if test="count($classHeader_map//apiClassifier[@id=concat($testToken, ':', $testToken2)] ) = 0">
										<xsl:value-of select="@replacement"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test="not(contains(@replacement, '.'))">
								<A href="{$linkpath}">
									<xsl:value-of select="@replacement"/>
								</A>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:when>
				<xsl:when test="apiDesc">
					<xsl:for-each select="./apiDesc">
						<xsl:call-template name="processTags"/>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>
</xsl:stylesheet>
