<?xml version="1.0" encoding="utf-8"?>
<!--

	ADOBE SYSTEMS INCORPORATED
	Copyright 2008 Adobe Systems Incorporated
	All Rights Reserved.

	NOTICE: Adobe permits you to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.

-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ifn="urn:internal:functions"
  exclude-result-prefixes="saxon xs ifn">
  <xsl:import href="asdoc-util.xslt"/>
  <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="disable" indent="no"/>
  <xsl:param name="titleBarFile" select="''"/>
  <xsl:param name="index-file" select="''"/>
  <xsl:param name="package-frame" select="''"/>
  <xsl:param name="liveDocsTitleBarFile" select="''"/>
  <xsl:param name="packages_map_name" select="'packagemap.xml'"/>
  <xsl:param name="prog_language_name" select="''"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$liveDocsTitleBarFile = '' and  $titleBarFile = ''">
        <xsl:apply-templates select="./html"/>
      </xsl:when>
      <xsl:when test="$isLiveDocs">
        <xsl:apply-templates select="document($liveDocsTitleBarFile)/html"/>
      </xsl:when>
      <xsl:when test="$isStandalone">
        <xsl:apply-templates select="document($titleBarFile)/html"/>
      </xsl:when>
      <xsl:when test="$prog_language_name='javascript'"/>
      <xsl:otherwise>
        <xsl:apply-templates select="document($titleBarFile)/html"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="node() | @*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="html">
    <xsl:copy-of select="$noLiveDocs"/>
    <xsl:choose>
      <xsl:when test=".//frameset">
        <xsl:copy-of select="$frameDocType"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$docType"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$isLiveDocs"/>
      <xsl:otherwise>
        <xsl:value-of select="$markOfTheWeb"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:element name="html">
      <xsl:apply-templates/>
      <xsl:copy-of select="$copyrightComment"/>
      <xsl:value-of select="$newline"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="title">
    <xsl:choose>
        <xsl:when test="$index-file">
		<xsl:copy>
		  <xsl:value-of select="$config/windowTitle"/>
		</xsl:copy>
        </xsl:when>
        <xsl:when test="$package-frame">
          <title>
            <xsl:value-of select="$config/title"/>
          </title>
        </xsl:when>
        <xsl:when test="$titleBarFile">
          <title>
            <xsl:value-of select="$config/title"/>
          </title>
        </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:value-of select="$config/title"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
    <link rel="stylesheet" href="style.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="print.css" type="text/css" media="print"/>
    <link rel="stylesheet" href="override.css" type="text/css"/>
  </xsl:template>
  <xsl:template match="head/link"/>
  <xsl:template name="script">
    <xsl:variable name="loc.search">
      <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'SearchResults']]/entry[2]/p"/>
    </xsl:variable>
    <script language="javascript" type="text/javascript">
      <xsl:text>&#xa;</xsl:text>function submitValue(){
      <xsl:text>&#xa;</xsl:text>
      var searchStr=document.getElementById('search-livedocs').value; var windowLocation=window.top.location.href.split("###");      window.top.location=windowLocation[0]+"###"+searchStr; parent.frames["classFrame"].location = "search.html";      document.getElementById('subTitle').childNodes.item(0).data = "<xsl:value-of select="$loc.search"/>"; document.getElementById('search-livedocs').value=searchStr;      return false; <xsl:text>&#xa;</xsl:text><xsl:text>}</xsl:text>      <xsl:value-of select="$newline"/>      <xsl:text>&#xa;</xsl:text> function noFrms(){ var doc =      parent.frames["classFrame"].location.href.substring(window.location.href.lastIndexOf("/")+1); if(doc=="search.html"){ var      curLoc=window.top.location.href.split("?"); var openFile; if(curLoc[1]!=null){ curLoc = curLoc[1].split("###"); curLoc =      curLoc[0].split("&amp;"); openFile = window.top.location.href.substring(0,window.top.location.href.lastIndexOf("?")+1); openFile =      openFile.substring(0,openFile.lastIndexOf("/")+1)+curLoc[0]; }else{ curLoc[0]="overview.html"; openFile =      window.top.location.href.substring(0,window.top.location.href.lastIndexOf("/")+1)+curLoc[0]; } top.location=openFile; }else{      top.location=top.classFrame.location;
      <xsl:text>&#xa;</xsl:text>
      <xsl:text>}</xsl:text>
      <xsl:text>&#xa;</xsl:text>}
    </script>
  </xsl:template>
  <xsl:template match="td[@class='titleTableTitle']">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:choose>
        <xsl:when test="$prog_language_name='javascript'"/>
        <xsl:otherwise>
          <xsl:value-of select="$config/title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
    <xsl:choose>
      <xsl:when test="$config/options[@standalonesearch='true']">
        <td class="titleTableSearch" align="center">
          <form class="searchForm" method="get" onsubmit="return submitValue();">
            <input class="hidden" name="loc" value="{$liveDocsSearchLocale}" type="hidden"/>
            <input class="hidden" name="termPrefix" value="" type="hidden"/>
            <input class="hidden" name="term" value="" type="hidden"/>
            <input class="hidden" name="area" value="" type="hidden"/>
            <input id="search-livedocs" name="search_text" value="" title="{$liveDocsSearchString}" type="text"/>
            <xsl:text> </xsl:text>
            <input type="button" name="action" value="{$liveDocsSearch}" onclick="submitValue()"/>
          </form>
        </td>
      </xsl:when>
      <xsl:when test="$config/options[@ion='true']">
        <td class="titleTableSearch" align="center">
          <xsl:comment>#include virtual="/livedocs/flex/3/langref/ionsearchform.ssi"</xsl:comment>
        </td>
      </xsl:when>
      <xsl:when test="$config/options[@livedocs='true']">
        <td class="titleTableSearch" align="center">
          <form class="searchForm" method="get" action="http://www.adobe.com/cfusion/search/index.cfm" target="adbe_window"
            onsubmit="this.term.value= this.termPrefix.value + &quot;\&quot;&quot; + this.search_text.value + &quot;\&quot;&quot;;">
            <input class="hidden" name="loc" value="en" type="hidden"/>
            <input class="hidden" name="termPrefix" value="site:livedocs.adobe.com/labs/flex3   " type="hidden"/>
            <input class="hidden" name="term" value="" type="hidden"/>
            <input class="hidden" name="area" value="" type="hidden"/>
            <input id="search-livedocs" name="search_text" value="" title="Search" type="text"/>
            <input type="submit" name="action" value="Search"/>
          </form>
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td class="titleTableSearch" align="center">&#xA0;</td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="td[@class='titleTableSearch']"/>
  <xsl:template match="tr[@class='titleTableRow3']/td[@colspan='2']">
    <xsl:choose>
      <xsl:when test="$config/options[@standalonesearch='true']">
        <td colspan="3">&#xA0;</td>
      </xsl:when>
      <xsl:otherwise>
        <td colspan="3">&#xA0;</td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tr[@class='titleTableRow2']/td[@class='titleTableSubTitle']">
    <xsl:choose>
      <xsl:when test="$config/options[@standalonesearch='true']">
        <td class="titleTableSubTitle" id="subTitle" align="left" colspan="2">&#xA0;</td>
      </xsl:when>
      <xsl:otherwise>
        <td class="titleTableSubTitle" id="subTitle" align="left" colspan="2">&#xA0;</td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="h3">
    <xsl:variable name="localized_value">
      <xsl:choose>
        <xsl:when test="normalize-space(.) = 'Index'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Index</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="$localized_value"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="a">
    <xsl:variable name="re-value" select="normalize-space(.)"/>
    <xsl:variable name="value" select="replace($re-value,'&lt;','&amp;lt;')"/>
    <xsl:variable name="localized_value">
      <xsl:choose>
        <xsl:when test="$value = 'All Classes'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">allClasses</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'All Packages'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">allPackages</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Language Elements'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">LanguageElements</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Appendixes'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Appendix</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Index'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Index</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Conventions'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Conventions</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'No Frames'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">NoFrames</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Properties'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Properties</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Constructor'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Constructor</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Methods'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Methods</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Functions'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Functions</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Events'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Events</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Effects'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Effects</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Constants'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Constants</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Interfaces'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Interfaces</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Classes'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Classes</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Examples'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Examples</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Styles'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Styles</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        
        <xsl:when test="$value = 'Skin States'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">SkinStates</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$value = 'Skin Parts'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">SkinParts</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        
        <xsl:when test="$value = 'Symbols'">
          <xsl:call-template name="getLocalizedString">
            <xsl:with-param name="key">Symbols</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="$localized_value"/>
    </xsl:copy>
  </xsl:template>
  <!-- PSEN: 06/02/2008 We should always show the "No Frames" link  <xsl:template match="a[@onclick='top.location=top.classFrame.location']">    <xsl:if test="$config/options[@standalonesearch='true']">	  <a href="" onclick="noFrms();">          <xsl:call-template name="getLocalizedString">            <xsl:with-param name="key">NoFrames</xsl:with-param>          </xsl:call-template>      </a>    </xsl:if>  </xsl:template>-->
  <xsl:template match="script">
    <xsl:element name="script">
      <xsl:apply-templates select="@* | node()"/>
      <xsl:value-of select="$newline"/>
    </xsl:element>
    <xsl:if test="$config/options[@standalonesearch='true']">
      <xsl:call-template name="script"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="text()">
    <xsl:value-of disable-output-escaping="no" select="."/>
  </xsl:template>
  <xsl:template match="comment()">
    <xsl:comment>
      <xsl:value-of disable-output-escaping="yes" select="."/>
    </xsl:comment>
  </xsl:template>
  <xsl:template match="input[@name='termPrefix']/@value">
    <xsl:attribute name="value">
      <xsl:value-of select="$config/livedocs/searchsite/."/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="input/@value[.='Search']">
    <xsl:attribute name="value">
      <xsl:value-of select="$asdoc_terms/row[entry[1][p/text() = 'searchLivedocs']]/entry[2]/p"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="input[@name='loc']/@value">
    <xsl:attribute name="value">
      <xsl:value-of select="$config/livedocs/locale/."/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="input[@name='search_text']/@title">
    <xsl:attribute name="title">
      <xsl:value-of select="$config/livedocs/searchstring/."/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="input[@name='action']">
    <xsl:if test="$config/options[@standalonesearch='true']">
      <input>
        <xsl:attribute name="type">
          <xsl:if test="contains(@type,'submit')">
            <xsl:value-of select="replace(@type,'submit','button')"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="'action'"/>
        </xsl:attribute>
        <xsl:attribute name="value">
          <xsl:value-of select="'Search'"/>
        </xsl:attribute>
        <xsl:attribute name="onclick">
          <xsl:value-of select="'submitValue()'"/>
        </xsl:attribute>
      </input>
    </xsl:if>
  </xsl:template>
  <xsl:template match="form/@action">
    <xsl:attribute name="action">
      <xsl:value-of select="$config/livedocs/searchservlet/."/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="frameset/@rows">
    <xsl:choose>
      <xsl:when test="$prog_language_name='javascript'"/>
      <xsl:otherwise>
        <xsl:if test="$index-file">
          <xsl:attribute name="rows">
            <xsl:text>80,*</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$package-frame">
          <xsl:attribute name="rows">
            <xsl:text>40%,60%</xsl:text>
          </xsl:attribute>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="td[@class='titleTableTopNav']">
    <xsl:choose>
      <xsl:when test="$prog_language_name='javascript'"/>
      <xsl:otherwise>
        <td class="titleTableTopNav" align="right">
          <xsl:apply-templates/>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
