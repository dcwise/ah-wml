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
URL : http://www.antennahouse.com/
**************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" 
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs map ahf"
    version="3.0">

    <!-- 
     function:	ol/ul element processing
     param:		none
     return:	
     note:      Pass list occurence number and list nesting level to li template
     -->
    <xsl:template match="*[@class => ahf:seqContainsToken(('topic/ol','topic/ul'))]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:variable name="id" as="xs:string" select="ahf:generateId(.)"/>
        <xsl:variable name="occurenceNumber" as="xs:integer?" select="map:get($listNumberMap,$id)"/>
        <xsl:assert test="exists($occurenceNumber)" select="'[ol/ul] id=',$id,' does not exits in $listNumberMap'"/>
        <xsl:variable name="isOl" as="xs:boolean" select="@class => contains-token('topic/ol')"/>
        <xsl:variable name="listStyle" as="xs:string">
            <xsl:choose>
                <xsl:when test="$isOl">
                    <xsl:sequence select="$cOlStyleName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="$cUlStyleName"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="listLevel" as="xs:integer" select="ahf:getListLevel(.)"/>
        <xsl:variable name="absListLevel" as="xs:integer" select="ahf:getAbsListLevel(.)"/>
        <xsl:apply-templates select="*">
            <xsl:with-param name="prmListOccurenceNumber" tunnel="yes" select="$occurenceNumber"/>
            <xsl:with-param name="prmListLevel" tunnel="yes" select="$listLevel"/>
            <xsl:with-param name="prmListStyle" tunnel="yes" select="$listStyle"/>
            <xsl:with-param name="prmIndentLevel" tunnel="yes" select="if ($pAdoptFixedListIndent) then ($prmIndentLevel + 1) else $prmIndentLevel"/>
            <xsl:with-param name="prmExtraIndent" tunnel="yes">
                <xsl:choose>
                    <xsl:when test="$pAdoptFixedListIndent">
                        <xsl:sequence select="$prmExtraIndent"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="hangingInTwip" as="xs:integer" select="ahf:getHangingFromStyleNameAndLevel($listStyle,$listLevel)"/>
                        <xsl:choose>
                            <xsl:when test="$absListLevel eq 1">
                                <xsl:variable name="initialListIndentInTwip" as="xs:integer">
                                    <xsl:choose>
                                        <xsl:when test="$isOl">
                                            <xsl:sequence select="$pOlBaseIndentSizeInTwip"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:sequence select="$pUlBaseIndentSizeInTwip"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:sequence select="$hangingInTwip + $prmExtraIndent + $initialListIndentInTwip"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="$hangingInTwip + $prmExtraIndent"/>
                            </xsl:otherwise>
                        </xsl:choose>
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
                DITA allows block element as the first child of li such as <table>, <ul>, <codeblock>.
                But it cannot be expressed in WordprocessingML.
                For this reason, this template inserts dummy w:p if li/*[1] is not a <p> element.
     -->
    <xsl:template match="*[@class => contains-token('topic/li')]">
        <xsl:param name="prmListOccurenceNumber" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmListLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmListStyle" tunnel="yes" required="no" as="xs:string?"/>
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmEndIndent" tunnel="yes" required="no" as="xs:integer" select="0"/>
        <xsl:assert test="exists($prmListStyle)" select="'[topic/li] $prmListStyle is empty. current=',ahf:generateId(.)"/>
        <xsl:if test="empty(child::*[1][@class => contains-token('topic/p')])">
            <!-- generate dummmy w:p -->
            <xsl:variable name="listLevelBreakElem" as="element()?">
                <xsl:choose>
                    <xsl:when test="empty(preceding-sibling::*)">
                        <xsl:copy-of select="ahf:getPageBreakBeforeAttrElem(parent::*[1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <w:p>
                <w:pPr>
                    <w:pStyle w:val="{ahf:getStyleIdFromName($prmListStyle)}"/>
                    <xsl:choose>
                        <xsl:when test="exists($listLevelBreakElem)">
                            <xsl:copy-of select="$listLevelBreakElem"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="ahf:getPageBreakBeforeAttrElem(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <w:numPr>
                        <w:ilvl w:val="{string(ahf:getIlvlFromListLevel($prmListLevel))}"/>
                        <w:numId w:val="{ahf:getNumIdFromListOccurenceNumber($prmListOccurenceNumber)}"/>
                    </w:numPr>
                    <xsl:copy-of select="ahf:getIndentAttrElem(ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent),$prmEndIndent,0,0)"/>
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
    <xsl:template match="*[@class => contains-token('topic/dl')]">
        <xsl:apply-templates select="*"/>
    </xsl:template>
        
    <xsl:template match="*[@class => contains-token('topic/dlhead')]">
        <xsl:call-template name="warningContinue">
            <xsl:with-param name="prmMes" select="ahf:replace($stMes2024,('%pos'),(ahf:genHistoryId(.)))"/>
        </xsl:call-template>
        <xsl:apply-templates select="*[@class => contains-token('topic/dlentry')]"/>
    </xsl:template>
    
    <xsl:template match="*[@class => contains-token('topic/dlentry')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:apply-templates select="*[@class => contains-token('topic/dt')]"/>
        <xsl:apply-templates select="*[@class => contains-token('topic/dd')]">
            <xsl:with-param name="prmIndentLevel" tunnel="yes" select="$prmIndentLevel + 1"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*[@class => contains-token('topic/dt')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmEndIndent" tunnel="yes" required="no" as="xs:integer" select="0"/>
        <xsl:variable name="dtStyleName" as="xs:string" select="ahf:getVarValue('DtStyleName')"/>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($dtStyleName)}"/>
                <xsl:copy-of select="ahf:getIndentAttrElem(ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent),$prmEndIndent,0,0)"/>
            </w:pPr>
            <xsl:apply-templates/>
        </w:p>
    </xsl:template>

    <xsl:template match="*[@class => contains-token('topic/dd')]/*[@class => contains-token('topic/p')]" priority="5">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmEndIndent" tunnel="yes" required="no" as="xs:integer" select="0"/>
        <xsl:variable name="ddStyleName" as="xs:string" select="ahf:getVarValue('DdStyleName')"/>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($ddStyleName)}"/>
                <xsl:copy-of select="ahf:getIndentAttrElem(ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent),$prmEndIndent,0,0)"/>
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
    <xsl:template match="*[@class => contains-token('topic/sl')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:apply-templates select="*[@class => contains-token('topic/sli')]">
            <xsl:with-param name="prmIndentLevel" tunnel="yes" select="$prmIndentLevel + 1"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*[@class => contains-token('topic/sli')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmEndIndent" tunnel="yes" required="no" as="xs:integer" select="0"/>
        <xsl:variable name="slStyleName" as="xs:string" select="ahf:getVarValue('SlStyleName')"/>
        <w:p>
            <w:pPr>
                <xsl:if test="string($slStyleName)">
                    <w:pStyle w:val="{ahf:getStyleIdFromName($slStyleName)}"/>
                </xsl:if>
                <xsl:copy-of select="ahf:getIndentAttrElem(ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent),$prmEndIndent,0,0)"/>
            </w:pPr>
            <xsl:apply-templates/>
        </w:p>
    </xsl:template>

    <!-- END OF STYLESHEET -->
</xsl:stylesheet>