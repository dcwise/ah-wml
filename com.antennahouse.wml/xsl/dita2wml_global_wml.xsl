<?xml version="1.0" encoding="UTF-8" ?>
<!--
****************************************************************
DITA to WordprocessingML Stylesheet
Module: WordprocessingML global constants.
Copyright © 2009-2017 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    exclude-result-prefixes="#all">
    <!-- *************************************** 
            Global Constants
         ***************************************-->
    
    <!-- Style name -->
    <xsl:variable name="cOlStyleName" as="xs:string" select="ahf:getVarValue('OlStyleName')"/>
    <xsl:variable name="cUlStyleName" as="xs:string" select="ahf:getVarValue('UlStyleName')"/>
    <xsl:variable name="cTopicTitleStyleName" as="xs:string" select="ahf:getVarValue('TopicTitleStyleName')"/>
    <xsl:variable name="cTopicTitleStyleName1st" as="xs:string" select="concat($cTopicTitleStyleName,'1')"/>
    
    <!-- w:numId base -->
    <xsl:variable name="numIdBaseForList" as="xs:integer" select="ahf:getVarValueAsInteger('NumIdBaseForList')"/>
    <xsl:variable name="numIdForTopicTitle" as="xs:integer" select="ahf:getVarValueAsInteger('NumIdForTopicTitle')"/>

    <!-- w:abstractNumId -->
    <xsl:variable name="abstractNumIdForTopicTitle" as="xs:integer" select="ahf:getVarValueAsInteger('AbstractNumIdForTopicTitle')"/>

    <!-- ordered list & unordered list w:numId -->
    <xsl:variable name="olAbstractNumId" as="xs:string" select="ahf:getAbstractNumIdFromStyleName($cOlStyleName)"/>
    <xsl:variable name="ulAbstractNumId" as="xs:string" select="ahf:getAbstractNumIdFromStyleName($cUlStyleName)"/>
    
    <!-- Relationship ID prefix -->
    <xsl:variable name="rIdPrefix" as="xs:string" select="'rId'"/>

</xsl:stylesheet>
