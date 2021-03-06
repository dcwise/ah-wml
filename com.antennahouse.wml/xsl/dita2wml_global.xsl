<?xml version="1.0" encoding="UTF-8" ?>
<!--
****************************************************************
DITA to WordprocessingML Stylesheet
Module: Stylesheet global variables.
Copyright © 2009-2017 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="3.0" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf"
>
    <!-- *************************************** 
            Constants
         ***************************************-->
    
    <xsl:variable name="idSeparator" select="'_'" as="xs:string"/>
    
    <!-- Title generation mode
     -->
    <xsl:variable name="cRoundBulletTitleMode"   select="1" as="xs:integer"/>
    <xsl:variable name="cSquareBulletTitleMode"  select="2" as="xs:integer"/>
    <xsl:variable name="cNoRestrictionTitleMode" select="3" as="xs:integer"/>
    
    <!-- *************************************** 
            IDs
         ***************************************-->
    <xsl:variable name="cTocId"          select="'__TOC'"           as="xs:string"/>
    <xsl:variable name="cFigureListId"   select="'__FIGURE_LIST'"   as="xs:string"/>
    <xsl:variable name="cTableListId"    select="'__TABLE_LIST'"    as="xs:string"/>
    <!--xsl:variable name="cGlossaryListId" select="'__GLOSSARY_LIST'" as="xs:string"/-->
    <xsl:variable name="cIndexId"        select="'__INDEX'"         as="xs:string"/>
    
    <!-- *************************************** 
            Marker class name
         ***************************************-->
    <xsl:variable name="cTitlePrefix" select="'TITLE_PREFIX'" as="xs:string"/>
    <xsl:variable name="cTitleBody"   select="'TITLE_BODY'" as="xs:string"/>
    
    <!-- *************************************** 
            Bookmark related
         ***************************************-->
    <!-- common bookmark starting state -->
    <xsl:variable name="cStartingState" select="ahf:getVarValue('Starting_State')" as="xs:string"/>
    <!-- bookmark nesting level -->
    <xsl:variable name="cBookmarkNestMax" select="ahf:getVarValueAsInteger('Bookmark_Nest_Max')" as="xs:integer"/>
    <!-- bookmark title separater -->
    <xsl:variable name="cTitlePrefixSeparator" select="ahf:getVarValue('Title_Prefix_Separator')" as="xs:string"/>
    
    <!-- *************************************** 
            TOC related
         ***************************************-->
    <!-- TOC nesting level -->
    <xsl:variable name="cTocNestMax" select="ahf:getVarValueAsInteger('Toc_Nest_Max')" as="xs:integer"/>
    
    <!-- *************************************** 
         Words which doe not depend on language
         ***************************************-->
    <!-- Table caption separater -->
    <xsl:variable name="cTitleSeparator" select="ahf:getVarValue('Title_Separator')" as="xs:string"/>
    
    <!-- ************************************************ 
            Words depending on language ($map/@xml:lang)
         ************************************************-->
    <!--xsl:variable name="cPartTitlePrefix"  select="ahf:getVarValue('Part_Title_Prefix')" as="xs:string"/>
    <xsl:variable name="cPartTitleSuffix"  select="ahf:getVarValue('Part_Title_Suffix')" as="xs:string"/>
    <xsl:variable name="cChapterTitlePrefix"  select="ahf:getVarValue('Chapter_Title_Prefix')" as="xs:string"/>
    <xsl:variable name="cChapterTitleSuffix"  select="ahf:getVarValue('Chapter_Title_Suffix')" as="xs:string"/>
    -->
    
    <xsl:variable name="cTocTitle"         select="ahf:getVarValue('Toc_Title')" as="xs:string"/>
    <xsl:variable name="cFigureListTitle"  select="ahf:getVarValue('Figure_List_Title')" as="xs:string"/>
    <xsl:variable name="cTableListTitle"   select="ahf:getVarValue('Table_List_Title')" as="xs:string"/>
    <!--xsl:variable name="cAppendicesTitle"  select="ahf:getVarValue('Appendices_Title')" as="xs:string"/>
    <xsl:variable name="cAppendixTitle"    select="ahf:getVarValue('Appendix_Title')" as="xs:string"/>
    -->
    <xsl:variable name="cGlossaryListTitle" select="ahf:getVarValue('Glossary_List_Title')" as="xs:string"/>
    <xsl:variable name="cIndexTitle"       select="ahf:getVarValue('Index_Title')" as="xs:string"/>
    <xsl:variable name="cNoticeTitle"      select="ahf:getVarValue('Notice_Title')" as="xs:string"/>
    <xsl:variable name="cPrefaceTitle"     select="ahf:getVarValue('Preface_Title')" as="xs:string"/>
    
    <xsl:variable name="cBlankPageTitle"   select="ahf:getVarValue('Blank_Page_Title')" as="xs:string"/>
    
    <xsl:variable name="cTableTitle"       select="ahf:getVarValue('Table_Title')" as="xs:string"/>
    <xsl:variable name="cFigureTitle"      select="ahf:getVarValue('Figure_Title')" as="xs:string"/>
    
    <!-- ************************************************ 
            Thumbnail label & title
         ************************************************-->
    <xsl:variable name="cTocThumbnailLabel"   select="ahf:getVarValue('Toc_Thumbnail_Label')" as="xs:string"/>
    <xsl:variable name="cAppendixThumbnailLabel" select="ahf:getVarValue('Appendix_Thumbnail_Label')" as="xs:string"/>
    <xsl:variable name="cIndexThumbnailLabel" select="ahf:getVarValue('Index_Thumbnail_Label')" as="xs:string"/>
    
    <xsl:variable name="cTocThumbnailTitle"   select="ahf:getVarValue('Toc_Thumbnail_Title')" as="xs:string"/>
    <xsl:variable name="cAppendixThumbnailTitle" select="ahf:getVarValue('Appendix_Thumbnail_Title')" as="xs:string"/>
    <xsl:variable name="cIndexThumbnailTitle" select="ahf:getVarValue('Index_Thumbnail_Title')" as="xs:string"/>
    
    <xsl:variable name="cThumbIndexMax"       select="ahf:getVarValue('Thumbnail_Index_Max')" as="xs:string"/>


    <!-- *************************************** 
            Related-links variable
         ***************************************-->
    <xsl:variable name="cDeadLinkPDF"           select="ahf:getVarValue('Dead_Link_PDF')" as="xs:string"/>
    <xsl:variable name="cDeadLinkColor"         select="ahf:getVarValue('Dead_Link_Color')" as="xs:string"/>
    
    
    <!-- *************************************** 
            Variables depending on document
         ***************************************-->
    <!-- Top level element -->
    <xsl:variable name="root" select="/*[1]" as="element()"/>
    <xsl:variable name="map" select="$root/*[@class => contains-token('map/map')][1]" as="element()"/>
    <xsl:variable name="topics" select="$root/*[@class => contains-token('topic/topic')]" as="element()*"/>
    <xsl:variable name="indexList" as="element()?" select="$map//*[@class => contains-token('bookmap/indexlist')][empty(@href)][1]"/>
    
    <!-- Map class -->
    <xsl:variable name="classMap" select="'map'" as="xs:string"/>
    <xsl:variable name="classBookMap" select="'bookmap'" as="xs:string"/>
    <xsl:variable name="classUnknown" select="'unknown'" as="xs:string"/>
    <xsl:variable name="ditamapClass" as="xs:string">
        <xsl:choose>
            <xsl:when test="$root/*[1][@class => contains-token('map/map')][@class => contains-token('bookmap/bookmap')]">
                <xsl:sequence select="$classBookMap"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$classMap"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="isMap"     select="boolean($ditamapClass eq $classMap)" as="xs:boolean"/>
    <xsl:variable name="isBookMap" select="boolean($ditamapClass eq $classBookMap)" as="xs:boolean"/>
    
    <!-- Document language -->
    <xsl:variable name="documentLang" as="xs:string">
        <xsl:variable name="defaultLang" as="xs:string" select="'en-US'"/>
        <xsl:choose>
            <xsl:when test="string($PRM_LANG) and ($PRM_LANG != $doubleApos)">
                <xsl:sequence select="$PRM_LANG"/>
            </xsl:when>
            <xsl:when test="$root/*[1]/@xml:lang">
                <xsl:sequence select="string($root/*[1]/@xml:lang)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="warningContinue">
                    <xsl:with-param name="prmMes">
                        <xsl:value-of select="ahf:replace($stMes101,('%lang'),($defaultLang))"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:sequence select="$defaultLang"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- Part existence (bookmap only) -->
    <xsl:variable name="isPartExist" as="xs:boolean" select="exists($root/*[1][@class => contains-token('bookmap/bookmap')]/*[@class => contains-token('bookmap/part')])"/>
    
    <!-- Chapter existence (bookmap only) -->
    <xsl:variable name="isChapterExist" as="xs:boolean" select="exists($root/*[1][@class => contains-token('bookmap/bookmap')]/*[@class => contains-token('bookmap/chapter')])"/>

    <!-- Keys -->
    <!-- topic content by id (topics that is referenced from topicref only)-->
    <xsl:key name="topicById"  match="/*//*[@class => contains-token('topic/topic')]" use="@id"/>
    <xsl:key name="topicByOid" match="/*//*[@class => contains-token('topic/topic')]" use="@oid"/>
    <!--topicref by href -->
    <xsl:key name="topicrefByHref" match="/*/*[@class => contains-token('map/map')]
                                           //*[@class => contains-token('map/topicref')]
                                           [ancestor::*[@class => contains-token('map/reltable')] => empty()]"
                                   use="@href"/>
    
    <!-- Elements by id -->
    <xsl:key name="elementById" match="//*[exists(@id)]" use="@id"/>
    
    <!-- Elements by oid -->
    <xsl:key name="elementByOid" match="//*[exists(@oid)]" use="@oid"/>
    
    <!-- topicref by key 
         Added 2010/01/05
     -->
    <xsl:key name="topicrefByKey" match="/*/*[@class => contains-token('map/map')]
                                          //*[@class => contains-token('map/topicref')]" 
                                  use="tokenize(@keys, '[\s]+')"/>
    
    <!-- *************************************** 
            Document variables
         ***************************************-->
    <!-- Book library -->
    <xsl:variable name="bookLibrary" as="node()*">
        <xsl:choose>
            <xsl:when test="$isMap">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:when test="$isBookMap">
                <xsl:apply-templates select="$root/*[@class => contains-token('bookmap/bookmap')]/*[@class => contains-token('bookmap/booktitle')]/*[@class => contains-token('bookmap/booklibrary')]">
                    <xsl:with-param name="prmTopicRef" tunnel="yes" select="()"/>
                    <xsl:with-param name="prmNeedId"   tunnel="yes" select="false()"/>
                    <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'&lt; Dummy Book Library &gt;'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- Title -->
    <xsl:variable name="bookTitle" as="node()*">
        <xsl:choose>
            <xsl:when test="$isMap">
                <xsl:choose>
                    <xsl:when test="$root/*[@class => contains-token('map/map')]/*[@class => contains-token('topic/title')]">
                        <xsl:apply-templates select="$root/*[@class => contains-token('map/map')]/*[@class => contains-token('topic/title')]" >
                            <xsl:with-param name="prmTopicRef" tunnel="yes" select="()"/>
                            <xsl:with-param name="prmNeedId"   tunnel="yes" select="false()"/>
                            <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="$root/*[@class => contains-token('map/map')]/@title">
                        <fo:inline>
                            <xsl:value-of select="$root/*[@class => contains-token('map/map')]/@title"/>
                        </fo:inline>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:inline/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$isBookMap">
                <xsl:choose>
                    <xsl:when test="$root/*[@class => contains-token('bookmap/bookmap')]/*[@class => contains-token('bookmap/booktitle')]">
                        <xsl:apply-templates select="$root/*[@class => contains-token('bookmap/bookmap')]/*[@class => contains-token('bookmap/booktitle')]/*[@class => contains-token('bookmap/mainbooktitle')]">
                            <xsl:with-param name="prmTopicRef" tunnel="yes" select="()"/>
                            <xsl:with-param name="prmNeedId"   tunnel="yes" select="false()"/>
                            <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$root/*[@class => contains-token('bookmap/bookmap')]/*[@class => contains-token('topic/title')]">
                            <xsl:with-param name="prmTopicRef" tunnel="yes" select="()"/>
                            <xsl:with-param name="prmNeedId"   tunnel="yes" select="false()"/>
                            <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline>
                    <xsl:value-of select="'&lt; Dummy Book Title &gt;'"/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- Alt Title -->
    <xsl:variable name="bookAltTitle" as="node()*">
        <xsl:choose>
            <xsl:when test="$isMap">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:when test="$isBookMap">
                <xsl:apply-templates select="$root/*[@class => contains-token('bookmap/bookmap')]/*[@class => contains-token('bookmap/booktitle')]/*[@class => contains-token('bookmap/booktitlealt')]">
                    <xsl:with-param name="prmTopicRef" tunnel="yes" select="()"/>
                    <xsl:with-param name="prmNeedId"   tunnel="yes" select="false()"/>
                    <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'&lt; Dummy Alt Book Title &gt;'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    

</xsl:stylesheet>
