<?xml version="1.0" encoding="UTF-8"?>
<!--
**************************************************************
DITA to WordprocessingML Stylesheet
Document.xml Topic element Templates
**************************************************************
File Name : dita2wml_document_topic.xsl
**************************************************************
Copyright © 2009-2017 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL : http://www.antennahouse.com/
**************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" 
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="xs ahf"
    version="3.0">

    <!-- 
     function:	Topic/shortdesc processing
     param:		prmIndentLevel
     return:	
     note:		Shortdesc is composed of inline elements.
                The DITA Spec described at http://docs.oasis-open.org/dita/dita/v1.3/errata02/os/complete/part3-all-inclusive/langRef/base/shortdesc.html#shortdesc
                is very vague when should the template treat shortdesc as inline or block.
                This template assumes the shortdesc as block that should generate w:p element.
     -->
    <xsl:template match="*[@class => contains-token('topic/topic')]/*[@class => contains-token('topic/shortdesc')][child::node() => empty()]" priority="5"/>
    <xsl:template match="*[@class => contains-token('topic/abstract')]/*[@class => contains-token('topic/shortdesc')][child::node() => empty()]" priority="5"/>
    
    <xsl:template match="*[@class => contains-token('topic/topic')]/*[@class => contains-token('topic/shortdesc')]|*[@class => contains-token('topic/abstract')]/*[@class => contains-token('topic/shortdesc')]">
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmEndIndent" tunnel="yes" required="no" as="xs:integer" select="0"/>
        <w:p>
            <xsl:variable name="shortDescStyle" as="xs:string">
                <xsl:call-template name="getVarValue">
                    <xsl:with-param name="prmVarName" select="'ShortdescStyleName'"/>
                </xsl:call-template>
            </xsl:variable>
            <w:pPr>
                <xsl:if test="string($shortDescStyle)">
                    <w:pStyle w:val="{ahf:getStyleIdFromName($shortDescStyle)}"/>
                </xsl:if>
                <xsl:copy-of select="ahf:getIndentAttrElem(ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent),$prmEndIndent,0,0)"/>
            </w:pPr>
            <xsl:apply-templates/>
        </w:p>
    </xsl:template>

    <!-- 
     function:	Topic/abstract processing
     param:		none
     return:	
     note:		Abstract contains both text or inline elements and block elements.
                The merged file preprocessing converts text or inline elements into <p> element.
                So only <xsl:apply-templates> is needed to process contents.
     -->
    <xsl:template match="*[@class => contains-token('topic/abstract')][empty(child::node())]" priority="5"/>
    
    <xsl:template match="*[@class => contains-token('topic/abstract')]">
        <xsl:apply-templates>
            <xsl:with-param name="prmListOccurenceNumber" tunnel="yes" select="0"/>
            <xsl:with-param name="prmListLevel" tunnel="yes" select="0"/>
            <xsl:with-param name="prmIndentLevel" tunnel="yes" select="0"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- 
     function:	Topic/body processing
     param:		none
     return:	
     note:		Body contains block elements.
                So only <xsl:apply-templates> selecting element is needed to process contents.
                Also as body may have section break opportunity, check section break before and after this element.
     -->
    <xsl:template match="*[@class => contains-token('topic/body')]">
        <xsl:variable name="body" as="element()" select="."/>

        <!-- Generate section property -->
        <xsl:call-template name="getSectionPropertyElemBefore"/>
        
        <xsl:apply-templates select="*">
            <xsl:with-param name="prmListOccurenceNumber" tunnel="yes" select="0"/>
            <xsl:with-param name="prmListLevel" tunnel="yes" select="0"/>
            <xsl:with-param name="prmIndentLevel" tunnel="yes" select="0"/>
        </xsl:apply-templates>

        <xsl:call-template name="getSectionPropertyElemAfter"/>
        
    </xsl:template>

    <!-- 
     function:	Topic/bodydiv processing
     param:		none
     return:	
     note:		Bodydiv contains both text or inline elements and block elements.
                The merged file preprocessing converts text or inline elements into <p> element.
                So only <xsl:apply-templates> is needed to process contents.
     -->
    <xsl:template match="*[@class => contains-token('topic/bodydiv')]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- END OF STYLESHEET -->

</xsl:stylesheet>