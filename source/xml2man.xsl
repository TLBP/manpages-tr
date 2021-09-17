<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY verbatim "name(..) ='literallayout'
                or name(../..) ='literallayout'
                or name(..) ='screen'
                or name(../..) ='screen'
                or name(..) ='synopsis'
                or name(../..) ='synopsis'
                or name(..) ='programlisting'
                or name(../..) ='programlisting'">

<!ENTITY indented "name(../..) = 'glossdef'
                or name(../..) = 'listitem'
                or name(../..) = 'caution'
                or name(../..) = 'note'
                or name(../..) = 'warning'
                or name(../..) = 'important'
                or name(../..) = 'tip'
                or name(../..) = 'blockquote'">
<!ENTITY allcases  "'aâbcçdefgğhıiîjklmnoöôpqrsştuüûvwxyzAÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZ'">
<!ENTITY uppercases "'AÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZAÂBCÇDEFGĞHIİÎJKLMNOÖÔPQRSŞTUÜÛVWXYZ'">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:key name="id" match="*" use="@id"/>

<xsl:template name="string.replace">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target"></xsl:param>
  <xsl:param name="replace"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string,$target)">
      <xsl:value-of select="concat(substring-before($string,$target),$replace)"/>
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="normalize-space(substring-after($string,$target))"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="replace" select="$replace"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="trimleft">
  <xsl:param name="string"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string, '&#10; ')">
      <xsl:call-template name="trimleft">
        <xsl:with-param name="string" select="concat(substring-before($string,'&#10; '),
                            '&#10;', substring-after($string,'&#10; '))"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*"/>

<xsl:template match="text()">
  <xsl:call-template name="trimleft">
    <xsl:with-param name="string" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="title">
  <xsl:variable name="string">
    <xsl:value-of select="title"/>
  </xsl:variable>
  <xsl:value-of select="translate($string, &allcases;, &uppercases;)"/>
</xsl:template>

<xsl:template match="remark">
<!--xsl:apply-templates/-->
  <xsl:variable name="string">
    <xsl:value-of select="."/>
  </xsl:variable>
  <xsl:call-template name="string.replace">
    <xsl:with-param name="string" select="$string"/>
    <xsl:with-param name="target" select="'.\\'"/>
    <xsl:with-param name="replace" select="'&#10;.\'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refmeta">

  <xsl:variable name="p">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="refentrytitle"/>
    <xsl:text>" </xsl:text>
    <xsl:value-of select="manvolnum"/>
    <xsl:text> "</xsl:text>
    <xsl:value-of select="refmiscinfo[@class='date']"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="refmiscinfo[@class='domain']"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="refmiscinfo[@class='header']"/>
    <xsl:text>"</xsl:text>
  </xsl:variable>
  <xsl:text>&#10;</xsl:text>
  <xsl:value-of select="normalize-space(concat('.TH ', $p))"/>
  <xsl:text>&#10;.nh&#10;.PD 0</xsl:text>
</xsl:template>

<xsl:template match="refnamediv">
  <xsl:if test="position() > 1">
  <xsl:text>&#10;.br</xsl:text>
    <xsl:call-template name="linkme"/>
  </xsl:if>
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:text>&#10;</xsl:text>
  <xsl:value-of select="normalize-space($content)"/>
</xsl:template>

<xsl:template match="refnamediv[1]">
  <xsl:text>&#10;.SH İSİM</xsl:text>
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:text>&#10;</xsl:text>
  <xsl:value-of select="normalize-space($content)"/>
</xsl:template>

<xsl:template match="refname">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text> - </xsl:text>
</xsl:template>

<xsl:template match="refpurpose">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsynopsisdiv">
  <xsl:text>&#10;&#10;.SH KULLANIM</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsect1">
  <xsl:text>&#10;&#10;.SH </xsl:text>
  <xsl:call-template name="title"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsect2">
  <xsl:text>&#10;&#10;.SS </xsl:text>
  <xsl:value-of select="title"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsect3">
  <xsl:text>&#10;&#10;.B </xsl:text>
  <xsl:value-of select="title"/>
  <xsl:text>&#10;.RS 4</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;.RE</xsl:text>
</xsl:template>

<xsl:template match="para">
  <xsl:if test="name(..)='glossdef' and (preceding-sibling::para/child::glosslist)">
    <xsl:text>&#10;.IP </xsl:text>
    <xsl:value-of select="../../@userlevel"/>
  </xsl:if>
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($p, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $p)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="trimleft">
    <xsl:with-param name="string" select="$p1"/>
  </xsl:call-template>
  <xsl:if test="not (@condition) or @condition != 'nospace'">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="literallayout|screen|synopsis|programlisting">
  <xsl:if test="(&indented;)">
    <xsl:text>&#10;.IP&#10;.RS</xsl:text>
  </xsl:if>
  <xsl:if test="@indent and @indent > 0">
    <xsl:text>&#10;.RS </xsl:text>
    <xsl:value-of select="@indent"/>
  </xsl:if>
  <xsl:text>&#10;.nf</xsl:text>
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($p, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $p)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$p"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$p1"/>
  <xsl:variable name="pn">
    <xsl:value-of select="substring($p, string-length($p), 1)"/>
  </xsl:variable>
  <xsl:if test="$pn!='&#10;'">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:text>.fi</xsl:text>
  <xsl:if test="@indent and @indent > 0">
    <xsl:text>&#10;.RE</xsl:text>
  </xsl:if>
  <xsl:if test="(&indented;)">
  <xsl:text>&#10;.RE&#10;.IP</xsl:text>
  </xsl:if>
</xsl:template>
<!--
<xsl:template match="synopsis">
  <xsl:text>&#10;.nf</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>>&#10;.fi</xsl:text>
</xsl:template>
-->
<xsl:template match="link">
  <xsl:variable name="ext">
    <xsl:value-of select="substring-before(substring-after(@linkend,'tr-man'), '-')"/>
  </xsl:variable>
  <xsl:variable name="base">
    <xsl:value-of select="substring-after(@linkend, concat('tr-man', $ext, '-'))"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="(text())">
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:when test="(@xreflabel)">
      <xsl:value-of select="concat('\fB', @xreflabel, '\fR [', $base, '(', $ext, ')]')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('\fB', $base, '(', $ext, ')\fR')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="xref">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]/title"/>
  <xsl:value-of select="concat('\fB', $target,'\fR')"/>
</xsl:template>

<xsl:template match="glosslist|variablelist">
  <xsl:choose>
    <xsl:when test="(&indented;)">
      <xsl:text>&#10;.RS </xsl:text>
      <xsl:if test="not (term or glossterm)">
        <xsl:value-of select="../../../../@userlevel"/>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:text>&#10;.RE&#10;.IP</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="itemizedlist|orderedlist">
  <xsl:choose>
    <xsl:when test="(&indented;)">
      <xsl:value-of select="concat('.RS ', ../../../../@userlevel)"/>
      <xsl:apply-templates/>
      <xsl:text>&#10;.RE&#10;.IP</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossentry">
  <xsl:variable name="p">
    <xsl:number from="glosslist" count="glossentry" format="1"/>
  </xsl:variable>
  <xsl:variable name="pos" select="$p - 1"/>
  <xsl:choose>
    <xsl:when test="not (glossterm) and not (ancestor::glossdef or ancestor::listitem)">
      <xsl:value-of select="concat('&#10;.IP ', ../@userlevel)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="not (../glossentry[$pos]/glossdef)">
        <xsl:text>&#10;.br&#10;.ns</xsl:text>
      </xsl:if>
      <xsl:variable name="terms">
        <xsl:apply-templates select="glossterm"/>
      </xsl:variable>
      <xsl:value-of select="concat('&#10;.TP ', ../@userlevel, '&#10;', normalize-space($terms))"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="glossdef"/>
  <xsl:if test="count(../glossentry)&lt;$p+1"><xsl:text>&#10;.PP</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="varlistentry">
  <xsl:variable name="p">
    <xsl:number from="variablelist" count="varlistentry" format="1"/>
  </xsl:variable>
  <xsl:variable name="pos" select="$p - 1"/>
  <xsl:choose>
    <xsl:when test="not (term) and not (ancestor::glossdef or ancestor::listitem)">
      <xsl:value-of select="concat('.IP ', ../@userlevel, '&#10;')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="not (../varlistentry[$pos]/listitem)">
        <xsl:text>&#10;.br&#10;.ns</xsl:text>
      </xsl:if>
      <xsl:variable name="terms">
        <xsl:apply-templates select="term"/>
      </xsl:variable>
      <xsl:value-of select="concat('&#10;.TP ', ../@userlevel, '&#10;', normalize-space($terms))"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="listitem"/>
  <xsl:if test="count(../varlistentry)&lt;$p+1"><xsl:text>&#10;.PP</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="glossterm">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:if test="name(following-sibling::*)='glossterm'">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="term">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:if test="name(following-sibling::*)='term'">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="glossdef|varlistentry/listitem">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="itemizedlist/listitem">
  <xsl:variable name="pos">
    <xsl:number from="orderedlist" count="listitem" format="1"/>
  </xsl:variable>
  <xsl:variable name="p">
    <xsl:text>&#10;.IP </xsl:text>
    <xsl:choose>
      <xsl:when test="../@mark='disc'">
        <xsl:text>\fBo\fR </xsl:text>
      </xsl:when>
      <xsl:when test="../@mark='square'">
        <xsl:text>\fB-\fR </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\fB·\fR </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="../@userlevel"/>
  </xsl:variable>
  <xsl:value-of select="$p"/>
  <xsl:variable name="pp">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($pp, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $pp)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$p1"/>
  <xsl:if test="count(../listitem)&lt;$pos+1"><xsl:text>&#10;.PP</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="orderedlist/listitem">
  <xsl:variable name="pos">
    <xsl:number from="orderedlist" count="listitem" format="1"/>
  </xsl:variable>
  <xsl:variable name="p">
    <xsl:text>&#10;.IP </xsl:text>
    <xsl:choose>
      <xsl:when test="../@numeration='arabic'">
        <xsl:number from="orderedlist" count="listitem" format="1."/>
      </xsl:when>
      <xsl:when test="../@numeration='loweralpha'">
        <xsl:number from="orderedlist" count="listitem" format="a."/>
      </xsl:when>
      <xsl:when test="../@numeration='lowerroman'">
        <xsl:number from="orderedlist" count="listitem" format="i."/>
      </xsl:when>
      <xsl:when test="../@numeration='upperalpha'">
        <xsl:number from="orderedlist" count="listitem" format="A."/>
      </xsl:when>
      <xsl:when test="../@numeration='upperroman'">
        <xsl:number from="orderedlist" count="listitem" format="I."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number from="orderedlist" count="listitem" format="1."/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:value-of select="../@userlevel"/>
  </xsl:variable>
  <xsl:value-of select="$p"/>
  <xsl:variable name="pp">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:variable name="p1">
    <xsl:choose>
      <xsl:when test="not(starts-with($pp, '&#10;'))">
        <xsl:value-of select="concat('&#10;', $pp)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$p1"/>
  <xsl:if test="count(../listitem)&lt;$pos+1"><xsl:text>&#10;.PP</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="acronym|classname|filename|function|literal|productname|prompt|statement|structfield|structname|symbol|type">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="application|command|emphasis|keyword|option|replaceable|userinput|quote|small|varname|wordasword">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="name(.)='application' or
                    name(.)='command' or
                    name(.)='keyword' or
                    name(.)='option' or
                    name(.)='userinput' or
                    (name(.)='emphasis' and @role='bold')">
      <xsl:value-of select="concat('\fB', $p, '\fR')"/>
    </xsl:when>
    <xsl:when test="name(.)='quote'">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="$p"/>
      <xsl:text>"</xsl:text>
    </xsl:when>
    <xsl:when test="name(.)='small'">
      <xsl:value-of select="concat('\s-1', $p, '\s0')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('\fI', $p, '\fR')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="email">
  <xsl:variable name="p">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="string.replace">
    <xsl:with-param name="string" select="concat('&lt;', $p, '>')"/>
    <xsl:with-param name="target" select="'@'"/>
    <xsl:with-param name="replace" select="' (at) '"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="blockquote">
  <xsl:if test="(&indented;)">
    <xsl:value-of select="concat('&#10;.RS ', ../../../../@userlevel)"/>
  </xsl:if>
  <xsl:text>&#10;.IP</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;.PP</xsl:text>
  <xsl:if test="(&indented;)">
    <xsl:text>&#10;.RE&#10;.IP</xsl:text>
  </xsl:if>

</xsl:template>

<xsl:template match="ulink">
  <xsl:choose>
    <xsl:when test="count(child::node())=0">
      <xsl:value-of select="@url"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="sbr">
  <xsl:text>&#10;.br&#10;</xsl:text>
</xsl:template>

<xsl:template match="warning|caution|note|important|tip">
  <xsl:param name="etiket"><xsl:value-of select="title"/></xsl:param>
  <xsl:if test="(&indented;)">
    <xsl:value-of select="concat('&#10;.RS ', ../../../../@userlevel)"/>
  </xsl:if>
  <xsl:variable name="intd">
    <xsl:value-of select="../../*[last()-1]/@userlevel"/>
  </xsl:variable>
  <xsl:value-of select="concat('&#10;.br&#10;.ns&#10;.TP ', $intd,'&#10;')"/>
  <xsl:choose>
    <xsl:when test="$etiket='' and name(.) = 'warning'">
      <xsl:text>\fBUyarı:\fR</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'caution'">
      <xsl:text>\fBDikkat:\fR</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'note'">
      <xsl:text>\fBBilgi:\fR</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'important'">
      <xsl:text>\fBÖnemli:\fR</xsl:text>
    </xsl:when>
    <xsl:when test="$etiket='' and name(.) = 'tip'">
      <xsl:text>\fBİpucu:\fR</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\fB</xsl:text><xsl:value-of select="title"/><xsl:text>:\fR</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
  <xsl:text>&#10;.PP</xsl:text>
  <xsl:if test="(&indented;)">
    <xsl:text>&#10;.RE&#10;.IP</xsl:text>
  </xsl:if>

</xsl:template>

</xsl:stylesheet>
