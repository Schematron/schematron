<?xml version="1.0"?>
<!-- EXPAND REFERENCES -->
<!-- Expand references to complexType, attributeGroup and group. -->
<!-- Expand equivalence group heads as choice groups -->

<!-- TODO:   Handle redefine problem, if some overridden declarations have snuck in -->
<!-- TODO: This does not handle references to groups in different schemas ?-->

<!--
 Programmers: Rick Jelliffe, Cheney Xin, Rahul Grewel
--> 
<!--
	The code was written under sponsorship of JSTOR The Scholarly Journal Archive
	 
	This code is also available under the GPL (v3. http://www.gnu.org/copyleft/gpl.html)	
 -->
 
 <!--
Open Source Initiative OSI - The MIT License:Licensing
[OSI Approved License]

The MIT License

	This code copyright 2007-2009 jointly and severally
		Allette Systems Pty. Ltd. (www.allette.com.au), 
		Topologi Pty. Ltd. (www.topologi.com), 
		JSTOR (http://www.jstor.org/)
		and Rick Jelliffe. 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

-->


<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/TR/xpath-functions">
	
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		omit-xml-declaration="no"/>
	
	<!-- ============================================================================= -->
	<!-- ================SUBSTITUTION GROUPS========================================== -->
	<!-- ============================================================================= -->
	<!--
	     TODO: check up on substitutions across namespaces
     -->
	<xsl:template
		match="xs:element[@abstract='true'][ancestor::xs:element]">
		    <xsl:comment>Abstract substitution group <xsl:value-of select="@name"/></xsl:comment>
		  
					    <xs:choice>
					       <!-- the cardinality of the head becomes the cardinality of the choice group -->
					       <xsl:copy-of select="@minOccurs"/>
					       <xsl:copy-of select="@maxOccurs"/> 
					       <xsl:copy-of select="namespace::node()"/>
						   <xsl:for-each select="//xs:element[not(ancestor::xs:element)]
						   		[@name]
						   		[@substitutionGroup=current()/@name]">
						   		<xs:element ref="@name" />
						   </xsl:for-each>
						</xs:choice> 
 
	</xsl:template>
	
	<!-- Now handle the case of an non-abstract element which is the head of a substitution group
	where the element is just a ref. -->
	<xsl:template
		match="xs:element[@ref]">
		
		<xsl:variable name="substitutes" select="//xs:element[not(ancestor::xs:element)]
						   		[@name]
						   		[@substitutionGroup=current()/@ref]"/>
						   		
		<xsl:choose>
		   <xsl:when test="$substitutes  and parent::xs:choice">
		   <!-- there are substitutes and we are already in a choice group -->
		      <xsl:copy-of select="." />
		      <xsl:for-each select="$substitutes" >
		          <xs:element ref="{name()}" >
					       <!-- the cardinality of the head becomes the cardinality of the choice group -->
					       <xsl:copy-of select="@minOccurs"/>
					       <xsl:copy-of select="@maxOccurs"/> 
		          </xs:element>
		      </xsl:for-each>
		   </xsl:when>
		   <xsl:when test="substitutes">
		   <!-- there are substitutes and we are not in a choice group -->
		     <xs:choice>
		       
		            <xsl:copy-of select="." />
		       <xsl:for-each select="$substitutes" >
		          <xs:element ref="{name()}" >
					       <!-- the cardinality of the head becomes the cardinality of the choice group -->
					       <xsl:copy-of select="@minOccurs"/>
					       <xsl:copy-of select="@maxOccurs"/> 
		          </xs:element>
		      </xsl:for-each>
		      </xs:choice>
		   </xsl:when>
		   <xsl:otherwise>
		   <!-- there are no substitutes, so just copy -->
		   		<xsl:copy-of select = "."/>
		   </xsl:otherwise>
	</xsl:choose>
		   
	</xsl:template>
	
	<!-- TODO: handle the case where an non-abstract element is the head of a substitution group
	and the group has a name but not a type. -->
	<xsl:template
		match="xs:element[@name][not(@type)][ancestor::xs:element]">
		<xsl:variable name="substitutes" select="//xs:element[not(ancestor::xs:element)]
						   		[@name]
						   		[@substitutionGroup=current()/@name]"/>
		<xsl:choose>
		   <xsl:when test="$substitutes  and parent::xs:choice">
		   <!-- there are substitutes and we are already in a choice group -->
		      <xsl:copy-of select="." />
		      <xsl:for-each select="$substitutes" >
		          <xs:element ref="{name()}" >
					       <!-- the cardinality of the head becomes the cardinality of the choice group -->
					       <xsl:copy-of select="@minOccurs"/>
					       <xsl:copy-of select="@maxOccurs"/> 
		          </xs:element>
		      </xsl:for-each>
		   </xsl:when>
		   <xsl:when test="substitutes">
		   <!-- there are substitutes and we are not in a choice group -->
		     <xs:choice>
		       
		         <xs:element ref="{name()}" >
					   <!-- the cardinality of the head becomes the cardinality of the choice group -->
					   <xsl:copy-of select="@minOccurs"/>
					   <xsl:copy-of select="@maxOccurs"/> 
		         </xs:element>
		       <xsl:for-each select="$substitutes" >
		          <xs:element ref="{name()}" >
					       <!-- the cardinality of the head becomes the cardinality of the choice group -->
					       <xsl:copy-of select="@minOccurs"/>
					       <xsl:copy-of select="@maxOccurs"/> 
		          </xs:element>
		      </xsl:for-each>
		      </xs:choice>
		   </xsl:when>
		   <xsl:otherwise>
		   <!-- there are no substitutes, so just copy -->
		   		<xsl:copy-of select = "."/>
		   </xsl:otherwise>
	</xsl:choose> 		
						   		
		
	</xsl:template>
	
	
	<!-- ============================================================================= -->
	<!-- ================TYPE ATTRIBUTE=============================================== -->
	<!-- ============================================================================= -->
	<!-- dereference for element which has type attribute and found type defined before -->
	<xsl:template
		match="xs:element[@name][@type]"
		priority="10" mode="deep">
		<xsl:call-template name="handle-element-with-name-and-type"  />
	</xsl:template>
		
	<xsl:template name="handle-element-with-name-and-type">	
		<xsl:choose>
		    <xsl:when test=" ancestor::xs:complexType[@name = current()/@type]" >
		       <!-- Reported PH
		          Workaround to prevent recursion: in the case where an element in a complexType
		          has the same type as the currently defined one: just swallow it.
		          TODO: need to figure out something better for this case.
		       -->
		    </xsl:when>
			<!-- dereference for element which has type attribute and found type defined in the same schema -->
			<xsl:when test="ancestor::xs:schema/xs:complexType[@name=current()/@type]">
				<xs:element name="{@name}">
					<xsl:for-each select="@*[name() != 'name' and name() != 'type']|namespace::node()">
						<xsl:copy/>
					</xsl:for-each>
					<!-- handle reference to complex type in same schema -->
					<xsl:comment>Expanded from a reference to <xsl:value-of select="@type"/></xsl:comment>
					<xsl:apply-templates
						select="ancestor::xs:schema/xs:complexType[@name=current()/@type]"
						mode="deep"/>
				</xs:element>
			</xsl:when>
			<!-- dereference for element which has type and there is : inside the type means external schema reference -->
			<!-- if it is a embedded xsd type, then don't expand it -->
			<xsl:when test="contains(@type,':') and substring-before(@type,':') != 'xs' and substring-before(@type,':') != 'xsd' and substring-before(@type,':') != 'xsi'">
				<xsl:variable name="prefix" select="substring-before(@type,':')"/>
				<xsl:variable name="typename" select="substring-after(@type,':')"/>
				<xsl:variable name="uri" select="namespace-uri-for-prefix($prefix,.)"/>
				<xsl:comment>Found element who reference external complexType:: prefix=<xsl:value-of select="$prefix"/></xsl:comment>
				<xsl:comment> typename=<xsl:value-of select="$typename"/> uri=<xsl:value-of select="$uri"/></xsl:comment>
				<xsl:choose>
					<!--  if found the complexType with the same name in that schema then replace it -->
					<xsl:when
						test="//xs:schema[@targetNamespace = $uri]/xs:complexType[@name=$typename]">
						<xs:element name="{@name}">
							<xsl:for-each select="@*[name() != 'name' and name() != 'type']|namespace::node()">
								<xsl:copy/>
							</xsl:for-each>
							<xsl:apply-templates
								select="//xs:schema[@targetNamespace = $uri]/xs:complexType[@name=$typename]"
								mode="deep"/>
						</xs:element>
					</xsl:when>
					<!-- otherwise just copy it over without any changes -->
					<xsl:otherwise>
						<xsl:copy>
							<xsl:for-each select="@*|namespace::node()">
								<xsl:copy/>
							</xsl:for-each>
							<xsl:apply-templates mode="deep"/>
						</xsl:copy>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- can't find type reference, copy over it as original -->
			<xsl:otherwise>
				<xsl:copy>
					<xsl:for-each select="@*|namespace::node()">
						<xsl:copy/>
					</xsl:for-each>
					<xsl:apply-templates mode="deep"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!--	
	<xsl:template match="xs:complexType[@ref]"
	priority="10"  mode="deep">
	<xsl:comment>Expanded from a reference to <xsl:value-of select="@ref"/></xsl:comment>	
	<xsl:apply-templates select="ancestor::xs:schema/xs:complexType[@name=current()/@ref]"  mode="deep"/>	
	</xsl:template>		
	-->
	
	<!-- ============================================================================= -->
	<!-- ================REMOVE GROUPS ETC============================================ -->
	<!-- ============================================================================= -->
	<xsl:template match="xs:group[@ref]" priority="10" mode="deep">
		<xsl:choose>
			<xsl:when test="contains(@ref,':')">
				<xsl:variable name="prefix" select="substring-before(@ref,':')"/>
				<xsl:variable name="typename" select="substring-after(@ref,':')"/>
				<xsl:variable name="uri" select="namespace-uri-for-prefix($prefix,.)"/>
				<xsl:comment>Found group who reference external group prefix= <xsl:value-of select="$prefix"/></xsl:comment>
				<xsl:comment> typename=	<xsl:value-of select="$typename"/> uri=	<xsl:value-of select="$uri"/></xsl:comment>
				<xsl:comment>Expanded from a reference to <xsl:value-of select="@ref"/></xsl:comment>
				
				
				<xsl:choose>
				   <!-- handle group occurrence on reference by a synthetic sequence -->
				   <xsl:when test="@minOccurs or @maxOccurs">
						<xs:sequence>
							<xsl:if test="@minOccurs">
								<xsl:attribute name="minOccurs"><xsl:value-of select="@minOccurs"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="@maxOccurs">
								<xsl:attribute name="maxOccurs"><xsl:value-of select="@maxOccurs"/></xsl:attribute>
							</xsl:if>

							<xsl:apply-templates
								select="//xs:schema[@targetNamespace = $uri]/xs:group[@name=@typename]"
								mode="deep"/>
				   	     </xs:sequence>
				   </xsl:when>
				   <xsl:otherwise>
		
					<xsl:apply-templates
						select="//xs:schema[@targetNamespace = $uri]/xs:group[@name=@typename]"
						mode="deep"/>		   
				   </xsl:otherwise>
				
		        </xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>Expanded from a reference to <xsl:value-of select="@ref"/></xsl:comment>
				<xsl:choose>
				  <!-- handle group occurrence on reference by a synthetic sequence -->
				   <xsl:when test="@minOccurs or @maxOccurs">
						<xs:sequence>
							<xsl:if test="@minOccurs">
								<xsl:attribute name="minOccurs"><xsl:value-of select="@minOccurs"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="@maxOccurs">
								<xsl:attribute name="maxOccurs"><xsl:value-of select="@maxOccurs"/></xsl:attribute>
							</xsl:if>

							<xsl:apply-templates
								select="ancestor::xs:schema/xs:group[@name=current()/@ref]"
								mode="deep"/>
				   		</xs:sequence>
				   </xsl:when>
				   <xsl:otherwise>
		
					<xsl:apply-templates
						select="ancestor::xs:schema/xs:group[@name=current()/@ref]"
						mode="deep"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="xs:attributeGroup[@ref]" priority="10" mode="deep">
		<xsl:choose>
			<xsl:when test="contains(@ref,':')">
				<xsl:variable name="prefix" select="substring-before(@ref,':')"/>
				<xsl:variable name="typename" select="substring-after(@ref,':')"/>
				<xsl:variable name="uri" select="namespace-uri-for-prefix($prefix,.)"/>
				<xsl:comment>Found attributeGroup who reference external group prefix= <xsl:value-of select="$prefix"/></xsl:comment>
				<xsl:comment> typename=	<xsl:value-of select="$typename"/> uri= <xsl:value-of select="$uri"/></xsl:comment>
				<xsl:comment>Expanded from a reference to <xsl:value-of select="@ref"/></xsl:comment>
				<xsl:apply-templates
					select="//xs:schema[@targetNamespace = $uri]/xs:attributeGroup[@name=@typename]"
					mode="deep"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>Expanded from a reference to <xsl:value-of select="@ref"/></xsl:comment>
				<xsl:apply-templates
					select="ancestor::xs:schema/xs:attributeGroup[@name=current()/@ref]"
					mode="deep"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<!-- Groups get added, just their contents  -->
	<xsl:template match="xs:schema/xs:group[@name] "
		priority="10" mode="deep">
			<xsl:apply-templates mode="deep"/> 
	</xsl:template>
	
	
	<!-- When expanding, remove the name attribute for validity -->
	<xsl:template match="xs:schema/xs:complexType[@name]  | xs:schema/xs:attributeGroup[@name]"
		priority="10" mode="deep">
		<xsl:copy>
			<xsl:for-each select="@*[not(name()='name')] |namespace::node()">
				<xsl:copy/>
			</xsl:for-each>
			<xsl:apply-templates mode="deep"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- Strip out global complex type declarations, group declarations, and attribute group declarations-->
	<xsl:template
		match="xs:schema/xs:complexType[@name] | xs:schema/xs:group[@name] | xs:schema/xs:attributeGroup[@name]"
		priority="5">
		<xsl:comment> <xsl:value-of select="@name"/> stripped out</xsl:comment>
	</xsl:template>
	
	
	
	<!-- ============================================================================= -->
	<!-- ================EXTENSION==================================================== -->
	<!-- ============================================================================= -->
	<!-- TODO -->
	<xsl:template match="xs:simpleContent/xs:extension" mode="deep">
		<xsl:variable name="base-decl"
			select="ancestor::xs:schema/xs:complexType[xs:simpleContent][@name=current()/@base] |
					ancestor::xs:schema/xs:simpleType[@name=current()/@base]"/>
		
		<xsl:variable name="simple-base" select="ancestor::xs:schema/xs:simpleType[@name=current()/@base]"/>
		<xsl:variable name="complex-base" select="ancestor::xs:schema/xs:complexType[xs:simpleContent][@name=current()/@base]"/>
		<xsl:choose>
			<xsl:when test="$simple-base">
				<xsl:variable name="rest" select="$simple-base/xs:restriction"/>
				<xs:apply-templates select="$simple-base" mode="deep"/>
			</xsl:when>
			<xsl:when test="$complex-base">
				<xsl:choose>
					<xsl:when test="$complex-base/xs:simpleContent/xs:extension">
						<xsl:apply-templates select="$complex-base" mode="deep"/>
						<xsl:apply-templates select="xs:attribute | xs:attributeGroup" mode="deep"/>
					</xsl:when>
					<xsl:when test="$complex-base/xs:simpleContent/xs:restriction">
						
					</xsl:when>
					
				</xsl:choose>
			</xsl:when>
			
			<!-- can't find base reference, copy over it as original -->
			<xsl:otherwise>
				<xsl:copy>
					<xsl:for-each select="@*|namespace::node()">
						<xsl:copy/>
					</xsl:for-each>
					<xsl:apply-templates mode="deep"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- TODO: what if the base type also extends from another? need 2 modes - one for elem and one for attrib -->
	<xsl:template match="xs:complexContent/xs:extension" mode="deep">
		<xsl:variable name="base-decl" select="ancestor::xs:schema/xs:complexType[@name=current()/@base]"/>
		
		<xsl:choose>
			<xsl:when test="$base-decl">
				<xs:sequence>
					<xsl:apply-templates select="$base-decl/*[not(self::xs:attribute or self::xs:attributeGroup)]" mode="deep"/>
					<xsl:apply-templates select="*[not(self::xs:attribute or self::xs:attributeGroup)]" mode="deep"/>
				</xs:sequence>
				<xsl:apply-templates select="$base-decl/(xs:attribute | xs:attributeGroup)" mode="deep"/>
				<xsl:apply-templates select="xs:attribute | xs:attributeGroup" mode="deep"/>
			</xsl:when>
			<!-- can't find base reference, copy over it as original -->
			<xsl:otherwise>
				<xsl:copy>
					<xsl:for-each select="@*|namespace::node()">
						<xsl:copy/>
					</xsl:for-each>
					<xsl:apply-templates mode="deep"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- ============================================================================= -->
	<!-- ================DEFAULT====================================================== -->
	<!-- ============================================================================= -->
	
	<!-- for children of schema (that are not matched above) switch mode and reprocess -->
	<xsl:template match="xs:schema/*" priority="1">
		<xsl:apply-templates mode="deep" select="."/>
	</xsl:template>
	
	
	<!-- copy everything else -->
	<xsl:template match="schemas | namespace |xs:schema ">
		<xsl:copy>
			<xsl:for-each select="@*|namespace::node()">
				<xsl:copy/>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- copy everything else -->
	<xsl:template match="*" mode="deep">
		<xsl:copy>
			<xsl:for-each select="@*|namespace::node()">
				<xsl:copy/>
			</xsl:for-each>
			<xsl:apply-templates mode="deep"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>