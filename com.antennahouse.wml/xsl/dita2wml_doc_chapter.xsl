<?xml version="1.0" encoding="UTF-8"?>
<!--
**************************************************************
DITA to WordprocessingML Stylesheet
Document.xml Chapter Templates
**************************************************************
File Name : dita2wml_document_chapter.xsl
**************************************************************
Copyright © 2009-2017 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL : http://www.antennahouse.com/
**************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf"
    version="3.0">

    <!-- 
     function:	Genral topicref processing
     param:		none
     return:	
     note:		If topicref/@href points to topic, an section break should be detected at topic level.
                Otherwise it should be detected at topicref level.
     -->
    <xsl:template match="*[@class => contains-token('map/topicref')][exists(@href)]">
        <xsl:variable name="topicRef" select="."/>
        
        <!-- get topic from @href -->
        <xsl:variable name="topic" select="ahf:getTopicFromTopicRef($topicRef)" as="element()?"/>
        <xsl:variable name="topicRefLevel" select="ahf:getTopicRefLevel($topicRef)" as="xs:integer"/>
        
        <xsl:choose>
            <xsl:when test="exists($topic)">
                <!-- Process contents -->
                <xsl:apply-templates select="$topic">
                    <xsl:with-param name="prmTopicRef"       tunnel="yes" select="$topicRef"/>
                    <xsl:with-param name="prmTopicRefLevel"  tunnel="yes" select="$topicRefLevel"/>
                    <xsl:with-param name="prmTopic"          tunnel="yes" select="$topic"/>
                    <xsl:with-param name="prmIndentLevel"    tunnel="yes" select="0"/>
                    <xsl:with-param name="prmExtraIndent"    tunnel="yes" select="0"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="warningContinue">
                    <xsl:with-param name="prmMes" 
                        select="ahf:replace($stMes070,('%href','%file'),(string(@href),string(@xtrf)))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- Nested topicref processing -->
        <xsl:apply-templates select="child::*[@class => contains-token('map/topicref')]"/>
        
    </xsl:template>

    <xsl:template match="*[@class => contains-token('map/topicref')][empty(@href)]">
        <xsl:variable name="topicRef" select="."/>
        
        <!-- Generate section property -->
        <xsl:call-template name="getSectionPropertyElemBefore"/>

        <!-- Generate column break -->
        <xsl:call-template name="getColumnBreak">
            <xsl:with-param name="prmTopicRef" select="$topicRef"/>
            <xsl:with-param name="prmTopic" select="()"/>
        </xsl:call-template>

        <xsl:choose>
            <xsl:when test="$topicRef/*[@class => contains-token('map/topicmeta')]/*[@class => contains-token('topic/navtitle')] or exists(@navtitle) or $topicRef[@class => contains-token('bookmap/glossarylist')]">
                <!-- Process title -->
                <xsl:call-template name="genTopicHeadTitle">
                    <xsl:with-param name="prmTopicRef"       select="$topicRef"/>
                    <xsl:with-param name="prmIndentLevel"    tunnel="yes" select="0"/>
                    <xsl:with-param name="prmExtraIndent"    tunnel="yes" select="0"/>
                    <xsl:with-param name="prmDefaultTitle">
                        <xsl:choose>
                            <xsl:when test="$topicRef[@class => contains-token('bookmap/glossarylist')]">
                                <xsl:call-template name="getVarValue">
                                    <xsl:with-param name="prmVarName" select="'Glossary_List_Title'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>

        <xsl:call-template name="getSectionPropertyElemAfter"/>
        
        <!-- Nested topicref processing -->
        <xsl:apply-templates select="child::*[@class => contains-token('map/topicref')]"/>
        
    </xsl:template>
    

    <!-- 
     function:	General topic processing
     param:		prmTopicRef
     return:	
     note:		related-links is not implemented yet!
                Section break must be detected after shortdesc/abstract processing.
                An boy may have another section property.
     -->
    <xsl:template match="*[@class => contains-token('topic/topic')]">
        <xsl:param name="prmTopicRef" as="element()" tunnel="yes" required="yes"/>
        <xsl:comment> topic @id="<xsl:value-of select="ahf:generateId(.)"/>"</xsl:comment>
        
        <!-- Generate section property -->
        <xsl:call-template name="getSectionPropertyElemBefore"/>

        <!-- Generate column break -->
        <xsl:call-template name="getColumnBreak">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmTopic" select="."/>
        </xsl:call-template>
        
        <xsl:apply-templates select="*[@class => contains-token('topic/title')]"/>    
        <xsl:apply-templates select="*[@class => contains-token('topic/shortdesc')] | *[@class => contains-token('topic/abstract')]"/>

        <!-- Generate section property -->
        <xsl:call-template name="getSectionPropertyElemAfter"/>

        <xsl:apply-templates select="*[@class => contains-token('topic/body')]"/>
        <xsl:apply-templates select="*[@class => contains-token('topic/related-links')]"/>

        <!-- Nested topic processing -->
        <xsl:apply-templates select="*[@class => contains-token('topic/topic')]"/>
    </xsl:template>

    <!-- ==== END OF STYLESHEET === -->

</xsl:stylesheet>