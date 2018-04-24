<?xml version="1.0" encoding="UTF-8"?>
<!--
**************************************************************
DITA to WordprocessingML Stylesheet
Document.xml list element Templates
**************************************************************
File Name : dita2wml_document_list.xsl
**************************************************************
Copyright © 2009-2017 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL : http://www.antennahouse.co.jp/
**************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" 
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf"
    version="3.0">

    <!-- ol/ul instance id -->
    <xsl:variable name="listId" as="xs:string*">
        <xsl:for-each select="//*[contains(@class, ' topic/ol ') or contains(@class, ' topic/ul ')]">
            <xsl:sequence select="ahf:genHistoryId(.)"/>
        </xsl:for-each>
    </xsl:variable>

    <!-- 
     function:	ol/ul element processing
     param:		none
     return:	
     note:      Pass list occurence number and list nesting level to li template
     -->
    <xsl:template match="*[contains(@class,' topic/ol ') or contains(@class,' topic/ul ')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:variable name="id" as="xs:string" select="ahf:genHistoryId(.)"/>
        <xsl:variable name="occurenceNumber" as="xs:integer?" select="index-of($listId,$id)"/>
        <xsl:assert test="exists($occurenceNumber)" select="'[ol/ul] id=',$id,' does not exits in $listId=',$listId"/>
        <xsl:variable name="listLevel" as="xs:integer" select="ahf:getListLevel(.)"/>
        <xsl:apply-templates select="*">
            <xsl:with-param name="prmListOccurenceNumber" tunnel="yes" select="$occurenceNumber"/>
            <xsl:with-param name="prmListLevel" tunnel="yes" select="$listLevel"/>
            <xsl:with-param name="prmIndentLevel" tunnel="yes" select="if ($pAdoptFixedListIndent) then ($prmIndentLevel + 1) else $prmIndentLevel"/>
            <xsl:with-param name="prmExtraIndent" tunnel="yes">
                <xsl:choose>
                    <xsl:when test="$pAdoptFixedListIndent">
                        <xsl:sequence select="$prmExtraIndent"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="styleName" as="xs:string">
                            <xsl:call-template name="getVarValue">
                                <xsl:with-param name="prmVarName">
                                    <xsl:choose>
                                        <xsl:when test="contains(@class,' topic/ol ')">
                                            <xsl:sequence select="'Ol_Style_Name'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:sequence select="'Ul_Style_Name'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="hangingInTwip" as="xs:integer" select="ahf:getHangingFromStyleNameAndLevel($styleName,$listLevel)"/>
                        <xsl:sequence select="$hangingInTwip + $prmExtraIndent"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- 
     function:	ol/li, ul/li element processing
     param:		prmListOccurenceNumber, prmListLevel, prmIndentLevel, prmExtraIndent
     return:	
     note:      In WordprocessingML an list is special form of paragraph (w:p with w:pPr/w;num).
                DITA allows block element as the first child of li sucha as <table>, <ul>, <codeblock>.
                But it cannot be expressed in WordprocessingML.
                For this reason, this template inserts dummy w:p if li/*[1] is not a <p> element.
     -->
    <xsl:template match="*[contains(@class,' topic/li ')]">
        <xsl:param name="prmListOccurenceNumber" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmListLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:if test="empty(child::*[1][contains(@class,' topic/p ')])">
            <!-- generate dummmy w:p -->
            <w:p>
                <w:pPr>
                    <w:pStyle w:val="{ahf:getStyleNameFromLi(.)}"/>
                    <w:numPr>
                        <w:ilvl w:val="{string(ahf:getIlvlFromListLevel($prmListLevel))}"/>
                        <w:numId w:val="{ahf:getNumIdFromListOccurenceNumber($prmListOccurenceNumber)}"/>
                    </w:numPr>
                    <xsl:copy-of select="ahf:getIndentAttrElem($prmIndentLevel,$prmExtraIndent)"/>
                </w:pPr>
            </w:p>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- 
     function:	dl related element template
     param:		prmIndentLevel
     return:	dt returns w:p. dd returns block elements (like w:p or w:table)
     note:      dd is indented one more deeper level.
     -->
    <xsl:template match="*[contains(@class,' topic/dl ')]">
        <xsl:apply-templates select="*"/>
    </xsl:template>
        
    <xsl:template match="*[contains(@class,' topic/dlhead ')]">
        <xsl:call-template name="warningContinue">
            <xsl:with-param name="prmMes" select="ahf:replace($stMes2024,('%pos'),(ahf:genHistoryId(.)))"/>
        </xsl:call-template>
        <xsl:apply-templates select="*[contains(@class,' topic/dlentry ')]"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/dlentry ')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:apply-templates select="*[contains(@class,' topic/dt ')]"/>
        <xsl:apply-templates select="*[contains(@class,' topic/dd ')]">
            <xsl:with-param name="prmIndentLevel" tunnel="yes" select="$prmIndentLevel + 1"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/dt ')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:variable name="dtStyleName" as="xs:string" select="ahf:getVarValue('Dt_Style_Name')"/>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($dtStyleName)}"/>
                <w:ind w:left="{ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent)}"/>
            </w:pPr>
            <xsl:apply-templates/>
        </w:p>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/dd ')]/*[contains(@class,' topic/p ')]" priority="5">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:variable name="ddStyleName" as="xs:string" select="ahf:getVarValue('Dd_Style_Name')"/>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($ddStyleName)}"/>
                <w:ind w:left="{ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent)}"/>
            </w:pPr>
            <xsl:apply-templates/>
        </w:p>
    </xsl:template>

    <!-- 
     function:	sl related element template
     param:		prmIndentLevel, prmExtraIndent
     return:	sli returns w:p.
     note:      sli is indented one more deeper level.
     -->
    <xsl:template match="*[contains(@class,' topic/sl ')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:apply-templates select="*[contains(@class,' topic/sli ')]">
            <xsl:with-param name="prmIndentLevel" tunnel="yes" select="$prmIndentLevel + 1"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/sli ')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:variable name="slStyleName" as="xs:string" select="ahf:getVarValue('Sl_Style_Name')"/>
        <w:p>
            <w:pPr>
                <xsl:if test="string($slStyleName)">
                    <w:pStyle w:val="{ahf:getStyleIdFromName($slStyleName)}"/>
                </xsl:if>
                <w:ind w:left="{ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent)}"/>
            </w:pPr>
            <xsl:apply-templates/>
        </w:p>
    </xsl:template>

    <!-- END OF STYLESHEET -->
</xsl:stylesheet>