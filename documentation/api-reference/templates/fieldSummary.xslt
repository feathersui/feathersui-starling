<?xml version="1.0" encoding="UTF-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://sf.net/saxon" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ifn="urn:internal:functions"
	xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/" exclude-result-prefixes="saxon xs ifn ditaarch">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	<xsl:param name="ditaFileDir" select="''"/>
	<xsl:variable name="isConst" select="'false'"/>
	<xsl:variable name="accessLevel" select="'public'"/>
	<xsl:variable name="accessLevelpr" select="'protected'"/>
	<xsl:param name="configFilename" select="'../../bin/ASDoc_Config.xml'"/>
	<xsl:variable name="config" select="document($configFilename)/asDocConfig"/>
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
				<xsl:apply-templates select="apiClassifier"/>
			</apiPackage>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="apiClassifier">
		<apiClassifier id="{@id}">
			<apiName>
				<xsl:value-of select="./apiName"/>
			</apiName>
			<xsl:apply-templates select="shortdesc"/>
			<xsl:apply-templates select="prolog"/>
			<xsl:apply-templates select="apiClassifierDetail"/>
			<xsl:apply-templates select="apiValue"/>
		</apiClassifier>
	</xsl:template>
	<xsl:template match="apiValue">
		<apiValue id="{@id}">
			<xsl:apply-templates select="node()"/>
		</apiValue>
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
				<xsl:when test="$entryType='apiValue'">
					<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and apiClassifierDetail/apiClassifierDef/apiInterface]/apiValue[apiName=$nameToMatch]">
						<xsl:choose>
							<xsl:when test="$descriptionType='shortdesc'">
								<xsl:for-each select="./shortdesc[normalize-space(.)!='']">
									<shortdesc>
										<xsl:apply-templates select="node()"/>
									</shortdesc>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$descriptionType='apiDesc'">
								<xsl:for-each select="./apiValueDetail/apiDesc[normalize-space(.)!='']">
									<apiDesc>
										<xsl:apply-templates select="node()"/>
									</apiDesc>
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
			<xsl:when test="$entryType='apiValue'">
				<xsl:for-each select="document($xslDocPath)/apiPackage/apiClassifier[apiName=$className and not(apiClassifierDetail/apiClassifierDef/apiInterface)]/apiValue[apiName=$nameToMatch]">
					<xsl:choose>
						<xsl:when test="$descriptionType='shortdesc'">
							<xsl:for-each select="./shortdesc[normalize-space(.)!='']">
								<shortdesc>
									<xsl:apply-templates select="node()"/>
								</shortdesc>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="$descriptionType='apiDesc'">
							<xsl:for-each select="./apiValueDetail/apiDesc[normalize-space(.)!='']">
								<apiDesc>
									<xsl:apply-templates select="node()"/>
								</apiDesc>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		<!-- Now process the base class till object reached-->
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
			<xsl:for-each select="document(concat($ditaFileDir,$destPackageName))/apiPackage//apiClassifier[apiName=$className]">
				<xsl:if test="string-length($entryType) &gt; 0">
					<xsl:choose>
						<xsl:when test="contains($entryType,'property')">
							<xsl:variable name="property.desc">
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
													<xsl:apply-templates select="node()"/>
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
													<xsl:apply-templates select="node()"/>
												</xsl:for-each>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:variable>
							<xsl:variable name="skin.desc">
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
							              <xsl:apply-templates select="node()"/>
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
							              <xsl:apply-templates select="node()"/>
							            </xsl:for-each>
							          </xsl:if>
							        </xsl:otherwise>
							      </xsl:choose>
							    </xsl:for-each>						
							</xsl:variable>
							<xsl:if test="$property.desc=''">
								<xsl:copy-of select="$skin.desc" copy-namespaces="no"/>
							</xsl:if>
							<xsl:if test="$property.desc!=''">
								<xsl:copy-of select="$property.desc" copy-namespaces="no"/>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
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
	<xsl:template match="apiClassifierDetail">
		<apiClassifierDetail>
			<xsl:apply-templates select="node()"/>
		</apiClassifierDetail>
	</xsl:template>
	<xsl:template match="apiClassifierDef">
		<apiClassifierDef>
			<xsl:apply-templates select="node()"/>
		</apiClassifierDef>
	</xsl:template>
	<xsl:template match="shortdesc">
		<xsl:choose>
			<xsl:when test="parent::apiValue/apiValueDetail/apiValueDef/apiInheritDoc">
				<xsl:if test="ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier or ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseInterface ">
					<xsl:call-template name="getInheritDocText">
						<xsl:with-param name="baseClass" select="ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
						<xsl:with-param name="implementedInterface" select="ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseInterface"/>
						<xsl:with-param name="descriptionType" select="'shortdesc'"/>
						<xsl:with-param name="entryType" select="'apiValue'"/>
						<xsl:with-param name="nameToMatch" select="parent::apiValue/apiName"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@conref">
				<xsl:variable name="entryType" select="'property'"/>
				<xsl:variable name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
				<shortdesc>
					<xsl:if test="normalize-space(.)">
						<xsl:apply-templates select="node()"/>
					</xsl:if>
					<xsl:call-template name="getConRefText">
						<xsl:with-param name="conref" select="@conref"/>
						<xsl:with-param name="descriptionType" select="'shortdesc'"/>
						<xsl:with-param name="entryType" select="$entryType"/>
						<xsl:with-param name="currentPackage" select="$currentPackage"/>
					</xsl:call-template>

				</shortdesc>
			</xsl:when>
			<xsl:otherwise>
				<shortdesc>
					<xsl:apply-templates select="node()"/>
				</shortdesc>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="apiDesc">
		<xsl:choose>
			<xsl:when test="@conref">
				<xsl:variable name="entryType" select="'property'"/>
				<xsl:variable name="currentPackage" select="ancestor-or-self::apiPackage/apiName"/>
				<apiDesc>
					<xsl:if test="normalize-space(.)">
						<p class="- topic/p ">
							<xsl:apply-templates select="node()"/>
						</p>
					</xsl:if>
					<xsl:call-template name="getConRefText">
						<xsl:with-param name="conref" select="@conref"/>
						<xsl:with-param name="descriptionType" select="'apiDesc'"/>
						<xsl:with-param name="entryType" select="$entryType"/>
						<xsl:with-param name="currentPackage" select="$currentPackage"/>
					</xsl:call-template>
				</apiDesc>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="not(parent::apiValueDetail/apiValueDef/apiInheritDoc)">
				<apiDesc>
					<xsl:apply-templates select="node()"/>
				</apiDesc>
			</xsl:when>
			<xsl:when test="parent::apiValueDetail/apiValueDef/apiInheritDoc">
				<xsl:if test="ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier or ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseInterface ">
					<xsl:call-template name="getInheritDocText">
						<xsl:with-param name="baseClass" select="ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseClassifier"/>
						<xsl:with-param name="implementedInterface" select="ancestor::apiClassifier/apiClassifierDetail/apiClassifierDef/apiBaseInterface"/>
						<xsl:with-param name="descriptionType" select="'apiDesc'"/>
						<xsl:with-param name="entryType" select="'apiValue'"/>
						<xsl:with-param name="nameToMatch" select="ancestor::apiValue/apiName"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="related-links">
		<related-links>
			<xsl:apply-templates select="node()"/>
		</related-links>
	</xsl:template>
	<xsl:template match="example">
		<example>
			<xsl:apply-templates select="node()"/>
		</example>
	</xsl:template>
	<xsl:template match="prolog">
		<prolog>
			<xsl:apply-templates select="node()"/>
		</prolog>
	</xsl:template>
	<xsl:template match="styles"/>
	<xsl:template match="node()">
		<xsl:copy copy-namespaces="no">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
