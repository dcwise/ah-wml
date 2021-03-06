<?xml version="1.0" encoding="UTF-8"?>
<!--
**************************************************************
DITA to WordprocessingML Stylesheet
Document.xml body element Templates
**************************************************************
File Name : dita2wml_document_body.xsl
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
     function:	p element processing
     param:		prmListOccurenceNumber, prmListLevel, prmIndentLevel, prmTcAttr
     return:	w:p
     note:      prmListOccurenceNumber is used to get w:numPr/w:numId. All of the list has its own w:num/@w:numId.
                prmListLevel is used to get w:numPr\w:ilevl/@w:val. It is only a list level that corresponds w:abstractNum/w:lvl/@w:ilvl.
                prmIndentLevel is used to count the indent level that list nesting generates.
                prmExtraIndent is used to express twip unit indent that is generated other than list.
                prmTcAttr is used to control alignment in table cell.
                - If <p> is first child of <step> and <step> contains info/floatfig, it is pulled at the start of w:p.
     -->
    <xsl:template match="*[@class => contains-token('task/info')]/*[@class => contains-token('topic/p')][empty(child::text())][every $e in child::* satisfies exists($e[@class => contains-token('floatfig-d/floatfig')])]" priority="5"/>
    
    <xsl:template match="*[@class => contains-token('topic/p')]" as="element(w:p)+">
        <xsl:param name="prmListOccurenceNumber" tunnel="yes" required="no" as="xs:integer?" select="()"/>
        <xsl:param name="prmListLevel" tunnel="yes" required="no" as="xs:integer?" select="()"/>
        <xsl:param name="prmListStyle" tunnel="yes" required="no" as="xs:string?" select="()"/>
        <xsl:param name="prmIndentLevel" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmExtraIndent" tunnel="yes" required="yes" as="xs:integer"/>
        <xsl:param name="prmEndIndent" tunnel="yes" required="no" as="xs:integer" select="0"/>
        <xsl:param name="prmTcAttr" tunnel="yes" as="element()?" select="()"/>
        <xsl:param name="prmFrameId" tunnel="yes" as="xs:integer?" select="()"/>
        
        <xsl:variable name="p" as="element()" select="."/>
        <xsl:variable name="isChildOfStepSection" as="xs:boolean" select="exists(parent::*[@class => contains-token('task/stepsection')])"/>
        <xsl:variable name="isFirstChildOfLi" as="xs:boolean" select="exists(parent::*[@class => contains-token('topic/li')]/*[1][. is current()])"/>
        <xsl:variable name="isChildOfEntry" as="xs:boolean" select="exists(parent::*[@class => ahf:seqContainsToken(('topic/entry','topic/stentry'))])"/>
        <xsl:variable name="isInThead" as="xs:boolean" select="$isChildOfEntry and (exists(parent::*/parent::*[@class => contains-token('topic/sthead')]) or exists(parent::*/parent::*/parent::*[@class => contains-token('topic/thead')]))"/>
        <xsl:variable name="floatFigs" as="element()*" select="parent::*[@class => contains-token('task/step')]/*[@class => contains-token('task/info')][1]/descendant::*[@class => contains-token('floatfig-d/floatfig')][ahf:isNotEmptyElement(.)]"/>
        <xsl:variable name="pStyle" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'PStyle'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="divId" as="element()?">
            <xsl:choose>
                <xsl:when test="exists($prmFrameId)">
                    <w:divId w:val="{string($prmFrameId)}"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="ahf:genPFromOutputClass">
            <xsl:with-param name="prmRegx" select="'(before)(\d+)(p)'"/>
            <xsl:with-param name="prmReplace" select="'$2'"/>
        </xsl:call-template>
        <w:p>
            <xsl:choose>
                <xsl:when test="$isChildOfStepSection">
                    <!-- Generate left indent considering hanging indent for stepsection -->
                    <xsl:assert test="exists($prmListLevel)" select="'[ASSERT: topic/p] $prmListLevel is empty!'"/>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>
                        <xsl:copy-of select="ahf:getKeepNextAttrElem($p)"/>
                        <xsl:copy-of select="ahf:getPageBreakBeforeAttrElem(.)"/>
                        <xsl:copy-of select="ahf:getIndentAttrElem(0,$prmEndIndent,0,0)"/>
                        <xsl:copy-of select="$divId"/>
                    </w:pPr>                    
                </xsl:when>
                <xsl:when test="$isFirstChildOfLi">
                    <!-- Generate list property for first child of li -->
                    <xsl:assert test="exists($prmListLevel)" select="'[ASSERT: topic/p] $prmListLevel is empty!'"/>
                    <xsl:assert test="exists($prmListOccurenceNumber)" select="'[ASSERT: topic/p] $prmListOccurenceNumber is empty!'"/>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($prmListStyle)}"/>
                        <xsl:copy-of select="ahf:getKeepNextAttrElem($p)"/>
                        <xsl:copy-of select="ahf:getPageBreakBeforeAttrElem(.)"/>
                        <w:numPr>
                            <w:ilvl w:val="{string(ahf:getIlvlFromListLevel($prmListLevel))}"/>
                            <w:numId w:val="{ahf:getNumIdFromListOccurenceNumber($prmListOccurenceNumber)}"/>
                        </w:numPr>
                        <xsl:if test="not($pAdoptFixedListIndent)">
                            <xsl:copy-of select="ahf:getIndentAttrElem(ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent),$prmEndIndent,0,0)"/>
                        </xsl:if>
                        <xsl:copy-of select="ahf:getAlignAttrElem($prmTcAttr/@align)"/>
                        <xsl:copy-of select="$divId"/>
                    </w:pPr>
                </xsl:when>
                <xsl:when test="$isChildOfEntry">
                    <!-- Generate initial indent -->
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>
                        <xsl:copy-of select="ahf:getKeepNextAttrElem($p)"/>
                        <xsl:copy-of select="ahf:getPageBreakBeforeAttrElem(.)"/>
                        <xsl:copy-of select="ahf:getIndentAttrElem(0,0,0,0)"/>
                        <xsl:copy-of select="ahf:getAlignAttrElem($prmTcAttr/@align)"/>
                        <xsl:copy-of select="$divId"/>
                    </w:pPr>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Generate left indent take into account list nesting level -->
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>
                        <xsl:copy-of select="ahf:getKeepNextAttrElem($p)"/>
                        <xsl:copy-of select="ahf:getPageBreakBeforeAttrElem(.)"/>
                        <xsl:copy-of select="ahf:getIndentAttrElem(ahf:getIndentFromIndentLevel($prmIndentLevel, $prmExtraIndent),$prmEndIndent,0,0)"/>
                        <xsl:copy-of select="ahf:getAlignAttrElem($prmTcAttr/@align)"/>
                        <xsl:copy-of select="$divId"/>
                    </w:pPr>                    
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$isFirstChildOfLi">
                <xsl:call-template name="genBookmarkStart">
                    <xsl:with-param name="prmElem" select="parent::*"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="exists($floatFigs)">
                <xsl:for-each select="$floatFigs">
                    <xsl:call-template name="processFloatFigInline"/>
                </xsl:for-each>
            </xsl:if>
            <xsl:apply-templates>
                <xsl:with-param name="prmRunProps" as="element()*" tunnel="yes">
                    <xsl:choose>
                        <xsl:when test="$isChildOfStepSection">
                            <xsl:call-template name="getWmlObject">
                                <xsl:with-param name="prmObjName" select="'wmlStepSectionRunProp'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$isInThead">
                            <xsl:call-template name="getWmlObject">
                                <xsl:with-param name="prmObjName" select="'wmlTheadRunProp'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:apply-templates>
            <xsl:if test="$isFirstChildOfLi">
                <xsl:call-template name="genBookmarkEnd">
                    <xsl:with-param name="prmElem" select="parent::*"/>
                </xsl:call-template>
            </xsl:if>
        </w:p>
        <xsl:call-template name="ahf:genPFromOutputClass">
            <xsl:with-param name="prmRegx" select="'(after)(\d+)(p)'"/>
            <xsl:with-param name="prmReplace" select="'$2'"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- 
     function:	generate <w:p> for floatfig position adjusting
     param:		prmElem (that has @outputclass), prmRegx, prmReplace
     return:	element(w:p)*
     note:		paragraph count is specified such as @outputclass="beforeNNp" or "afterNNp" where NN is digit
     -->
    <xsl:template name="ahf:genPFromOutputClass" as="element(w:p)*">
        <xsl:param name="prmElem" as="element()" required="no" select="."/>
        <xsl:param name="prmRegx" as="xs:string" required="yes"/>
        <xsl:param name="prmReplace" as="xs:string" required="yes"/>
        <xsl:variable name="pCount" as="xs:integer" select="xs:integer(ahf:getOutputClassRegxWithDefault($prmElem,$prmRegx,$prmReplace,'0'))"/>
        <xsl:for-each select="1 to $pCount">
            <w:p/>
        </xsl:for-each>        
    </xsl:template>
    
    <!-- 
     function:	generate <w:pageBreakBefore> for given position
     param:		prmElem (that has @outputclass)
     return:	element(w:pageBreakBefore)?
     note:		
     -->
    <xsl:function name="ahf:getPageBreakBeforeAttrElem" as="element(w:pageBreakBefore)?">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:choose>
            <xsl:when test="ahf:hasFoProperty($prmElem,'break-before','page')">
                <w:pageBreakBefore w:val="true"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:	generate <w:keepNext/> for given position
     param:		prmElem (that has @outputclass)
     return:	element(w:keepNext)?
     note:		
     -->
    <xsl:function name="ahf:getKeepNextAttrElem" as="element(w:keepNext)?">
        <xsl:param name="prmElem" as="element()"/>
        <xsl:variable name="isP" as="xs:boolean" select="exists($prmElem/self::*[@class => contains-token('topic/p')])"/>
        <xsl:variable name="hasCmdOfStep" as="xs:boolean" select="exists($prmElem/child::*[@class => contains-token('task/cmd')])"/>
        <xsl:variable name="hasFollowingItemGroup" as="xs:boolean" select="exists($prmElem/following-sibling::*[@class => contains-token('topic/itemgroup')])"/>
        <xsl:choose>
            <xsl:when test="ahf:hasFoProperty($prmElem,'keep-with-next.within-column','always') or ahf:hasFoProperty($prmElem,'keep-with-next.within-page','always')">
                <w:keepNext w:val="true"/>
            </xsl:when>
            <xsl:when test="$isP and $hasCmdOfStep and $hasFollowingItemGroup">
                <w:keepNext w:val="true"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- 
     function:	div element processing
     param:		none
     return:	
     note:		Div contains both text or inline elements and block elements.
                The merged file preprocessing converts text or inline elements into <p> element.
                So only <xsl:apply-templates> is needed to process contents.
     -->
    <xsl:template match="*[@class => contains-token('topic/div')]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- 
     function:	fig,table/desc template
     param:		none
     return:	w:p
     note:		
     -->
    <xsl:template match="*[@class => ahf:seqContainsToken(('topic/table','topic/fig'))]/*[@class => contains-token('topic/desc')]">
        <xsl:variable name="descStyle" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'DescStyle'"/>
            </xsl:call-template>
        </xsl:variable>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($descStyle)}"/>
            </w:pPr>
            <xsl:apply-templates/>
        </w:p>
    </xsl:template>
    
    <!-- 
     function:	section/title
     param:		none
     return:	
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/section')]/*[@class => contains-token('topic/title')]">
        <xsl:variable name="sectionStyle" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'SectionStyle'"/>
            </xsl:call-template>
        </xsl:variable>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($sectionStyle)}"/>
            </w:pPr>
            <xsl:call-template name="genBookmarkStart">
                <xsl:with-param name="prmElem" select="parent::*"/>
            </xsl:call-template>
            <xsl:apply-templates/>
            <xsl:call-template name="genBookmarkEnd">
                <xsl:with-param name="prmElem" select="parent::*"/>
            </xsl:call-template>
        </w:p>
    </xsl:template>

    <!-- 
     function:	example/title
     param:		none
     return:	
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/example')]/*[@class => contains-token('topic/title')]">
        <xsl:variable name="exampleStyle" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'ExampleStyle'"/>
            </xsl:call-template>
        </xsl:variable>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($exampleStyle)}"/>
            </w:pPr>
            <xsl:call-template name="genBookmarkStart">
                <xsl:with-param name="prmElem" select="parent::*"/>
            </xsl:call-template>
            <xsl:apply-templates/>
            <xsl:call-template name="genBookmarkEnd">
                <xsl:with-param name="prmElem" select="parent::*"/>
            </xsl:call-template>
        </w:p>
    </xsl:template>
    
    <!-- 
     function:	Figure title processing
     param:		none
     return:	w:p
     note:		 
     -->
    <xsl:template match="*[@class => contains-token('topic/fig')]/*[@class => contains-token('topic/title')]">
        <xsl:variable name="figStyle" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'FigStyle'"/>
            </xsl:call-template>
        </xsl:variable>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($figStyle)}"/>
            </w:pPr>
            <xsl:call-template name="genBookmarkStart">
                <xsl:with-param name="prmElem" select="parent::*"/>
            </xsl:call-template>
            <xsl:call-template name="ahf:getFigTitlePrefix">
                <xsl:with-param name="prmFig" select="parent::*"/>
            </xsl:call-template>
            <xsl:apply-templates/>
            <xsl:call-template name="genBookmarkEnd">
                <xsl:with-param name="prmElem" select="parent::*"/>
            </xsl:call-template>
        </w:p>        
    </xsl:template>
    
    
    <!-- 
     function:	Generate fig title prefix
     param:		prmTopicRef, prmTable
     return:	Figure title prefix
     note:		
     -->
    <xsl:template name="ahf:getFigTitlePrefix" as="element(w:r)*">
        <xsl:param name="prmTopicRef" tunnel="yes" required="yes" as="element()"/>
        <xsl:param name="prmFig" required="no" as="element()" select="."/>
        
        <xsl:variable name="topicNode" select="$prmFig/ancestor::*[@class => contains-token('topic/topic')][position() eq last()]"/>
        
        <xsl:variable name="figPreviousAmount" as="xs:integer">
            <xsl:variable name="topicNodeId" select="ahf:generateId($topicNode)"/>
            <xsl:variable name="prevCount" as="xs:integer?" select="$figNumberingMap/*[string(@id) eq $topicNodeId]/@prev-count/xs:integer(.)"/>
            <xsl:assert test="exists($prevCount)" select="concat('[ahf:getFigTitlePrefix] $prevCount is not defined for topic=''',$topicNodeId,'''')"/>
            <xsl:sequence select="$prevCount"/>
        </xsl:variable>
        
        <xsl:variable name="figCurrentAmount"  as="xs:integer">
            <xsl:variable name="topic" as="element()" select="$prmFig/ancestor::*[@class => contains-token('topic/topic')][last()]"/>
            <xsl:sequence select="($topic//*[@class => contains-token('topic/fig')][child::*[@class => contains-token('topic/title')]][. &lt;&lt; $prmFig]|$prmFig) => count()"/>
        </xsl:variable>
        
        <xsl:variable name="tableNumber" select="$figPreviousAmount + $figCurrentAmount" as="xs:integer"/>
        
        <xsl:variable name="topTopicrefNumber" as="xs:integer">
            <xsl:call-template name="getTopTopicrefNumber">
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            </xsl:call-template>
        </xsl:variable>
        
        <w:r>
            <w:t xml:space="preserve"><xsl:value-of select="$cFigureTitle"/></w:t>
        </w:r>
        <xsl:if test="$pAddChapterNumberPrefixToFigTitle and ahf:hasTopTopicrefNumber($prmTopicRef)">
            <xsl:call-template name="getWmlObjectReplacing">
                <xsl:with-param name="prmObjName" select="'wmlStyleRefField'"/>
                <xsl:with-param name="prmSrc" select="('%style-name','%field-opt','%style-ref-result')"/>
                <xsl:with-param name="prmDst" select="($cTopicTitleStyleName1st,'\s',string($topTopicrefNumber))"/>
            </xsl:call-template>            
            <w:r>
                <w:t>
                    <xsl:value-of select="$cTitleSeparator"/>
                </w:t>
            </w:r>
        </xsl:if>
        <xsl:call-template name="getWmlObjectReplacing">
            <xsl:with-param name="prmObjName" select="'wmlSeqField'"/>
            <xsl:with-param name="prmSrc" select="('%tag','%field-opt','%seq-result')"/>
            <xsl:with-param name="prmDst" select="('Figure',concat('\* ARABIC \s ',ahf:getStyleIdFromName($cTopicTitleStyleName1st)),string($figCurrentAmount))"/>
        </xsl:call-template>            
    </xsl:template>
    
    <xsl:function name="ahf:getFigTitlePrefix" as="element(w:r)*">
        <xsl:param name="prmTopicRef" as="element()"/>
        <xsl:param name="prmFig" as="element()"/>
        
        <xsl:call-template name="ahf:getFigTitlePrefix">
            <xsl:with-param name="prmTopicRef" tunnel="yes" select="$prmTopicRef"/>
            <xsl:with-param name="prmFig" select="$prmFig"/>
        </xsl:call-template>
    </xsl:function>
    
    <!-- 
     function:	pre template
     param:		none
     return:	w:p
     note:		use 'HTML Preformatted' style
     -->
    <xsl:template match="*[@class => contains-token('topic/pre')]">
        <xsl:variable name="preStyle" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'PreStyle'"/>
            </xsl:call-template>
        </xsl:variable>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($preStyle)}"/>               
            </w:pPr>
            <xsl:apply-templates>
                <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
            </xsl:apply-templates>
        </w:p>
    </xsl:template>

    <!-- 
     function:	lines template
     param:		none
     return:	w:p
     note:		use 'Body Text' style
     -->
    <xsl:template match="*[@class => contains-token('topic/lines')]">
        <xsl:variable name="linesStyle" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'LinesStyle'"/>
            </xsl:call-template>
        </xsl:variable>
        <w:p>
            <w:pPr>
                <w:pStyle w:val="{ahf:getStyleIdFromName($linesStyle)}"/>                
            </w:pPr>
            <xsl:apply-templates>
                <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
            </xsl:apply-templates>
        </w:p>
    </xsl:template>

    <!-- 
     function:	draft-comment template
     param:		none
     return:	w:p, etc
     note:		use 'Body Text' style
     -->
    <xsl:template match="*[@class => contains-token('topic/draft-comment')]">
        <xsl:variable name="pStyle" as="xs:string">
            <xsl:call-template name="getVarValueWithLang">
                <xsl:with-param name="prmVarName" select="'PStyle'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="*[1][@class => contains-token('topic/p')] and (*[1] is *[last()])">
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentPrefix'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="*[1]/node()">
                        <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                        <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                    </xsl:apply-templates>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentSuffix'"/>
                    </xsl:call-template>
                </w:p>
            </xsl:when>
            <xsl:when test="*[1][@class => contains-token('topic/p')] => exists() and *[last()][@class => contains-token('topic/p')] => exists()">
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentPrefix'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="*[1]/node()">
                        <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                        <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                    </xsl:apply-templates>
                </w:p>
                <xsl:apply-templates select="*[(position() gt 1) and (position() lt last())]">
                    <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                    <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                </xsl:apply-templates>
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:apply-templates select="*[last()]/node()">
                        <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                        <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                    </xsl:apply-templates>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentSuffix'"/>
                    </xsl:call-template>
                </w:p>
            </xsl:when>
            <xsl:when test="*[1][@class => contains-token('topic/p')] => exists() and *[last()][@class => contains-token('topic/p')] => empty()">
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentPrefix'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="*[1]/node()">
                        <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                        <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                    </xsl:apply-templates>
                </w:p>
                <xsl:apply-templates select="*[(position() gt 1)]">
                    <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                    <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                </xsl:apply-templates>
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentSuffix'"/>
                    </xsl:call-template>
                </w:p>
            </xsl:when>
            <xsl:when test="*[1][@class => contains-token('topic/p')] => empty() and *[last()][@class => contains-token('topic/p')] => exists()">
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentPrefix'"/>
                    </xsl:call-template>
                </w:p>
                <xsl:apply-templates select="*[(position() lt last())]">
                    <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                    <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                </xsl:apply-templates>
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentSuffix'"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="*[last()]/node()">
                        <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                        <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                    </xsl:apply-templates>
                </w:p>
            </xsl:when>
            <xsl:otherwise>
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentPrefix'"/>
                    </xsl:call-template>
                </w:p>
                <xsl:apply-templates select="*">
                    <xsl:with-param name="prmInPre" tunnel="yes" select="true()"/>
                    <xsl:with-param name="prmInLines" tunnel="yes" select="true()"/>
                </xsl:apply-templates>
                <w:p>
                    <w:pPr>
                        <w:pStyle w:val="{ahf:getStyleIdFromName($pStyle)}"/>                
                    </w:pPr>
                    <xsl:call-template name="getWmlObject">
                        <xsl:with-param name="prmObjName" select="'wmlDraftCommentSuffix'"/>
                    </xsl:call-template>
                </w:p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 
     function:	ph template
     param:		none
     return:	under-laying result
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/ph')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- 
     function:	fig template
     param:		none
     return:	under-laying result
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/fig')]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- 
     function:	dd template
     param:		none
     return:	under-laying result
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/dd')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- 
     function:	keyword template
     param:		none
     return:	under-laying result
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/keyword')]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- 
     function:  term template
     param:     none
     return:    under-laying result
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/term')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- 
     function:	text template
     param:		none
     return:	under-laying result
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/text')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- 
     function:	section template
     param:		none
     return:	under-laying result
     note:		
     -->
    <xsl:template match="*[@class => contains-token('topic/section')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <!-- END OF STYLESHEET -->

</xsl:stylesheet>