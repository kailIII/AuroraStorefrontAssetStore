<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ include file= "../../Common/EnvironmentSetup.jspf" %>

<c:set var="departmentId" value="${param.categoryId}"/>

<c:set var="subcategoryLimit" value="10"/>
<c:set var="depthAndLimit" value="${subcategoryLimit + 1},${subcategoryLimit + 1}"/>
<wcf:rest var="categoryHierarchy" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/categoryview/@top" >
	<c:if test="${!empty WCParam.langId}">
	<wcf:param name="langId" value="${WCParam.langId}"/>
	</c:if>
	<c:if test="${empty WCParam.langId}">
	<wcf:param name="langId" value="${langId}"/>
	</c:if>

	<wcf:param name="responseFormat" value="json"/>		
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="depthAndLimit" value="${depthAndLimit}"/>
	<c:forEach var="contractId" items="${env_activeContractIds}">
		<wcf:param name="contractId" value="${contractId}"/>
	</c:forEach>
</wcf:rest>


<jsp:useBean id="categoryURLMap" class="java.util.HashMap"/>

<c:forEach var="department" items="${categoryHierarchy.catalogGroupView}">
	<wcf:url var="categoryURL" value="Category3" patternName="CanonicalCategoryURL">
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="catalogId" value="${catalogId}"/>		
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="urlLangId" value="${urlLangId}"/>
		<wcf:param name="categoryId" value="${department.uniqueID}"/>
		<wcf:param name="pageView" value="${env_defaultPageView}"/>
		<wcf:param name="beginIndex" value="0"/>
	</wcf:url>
	<c:set target="${categoryURLMap}" property="${department.uniqueID}" value="${categoryURL}"/>
	<c:forEach var="category" items="${department.catalogGroupView}">
		<wcf:url var="categoryURL" value="Category3" patternName="CategoryURL">
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="urlLangId" value="${urlLangId}"/>
			<wcf:param name="categoryId" value="${category.uniqueID}"/>
			<wcf:param name="top_category" value="${department.uniqueID}"/>
			<wcf:param name="pageView" value="${env_defaultPageView}"/>
			<wcf:param name="beginIndex" value="0"/>
		</wcf:url>
		<c:set target="${categoryURLMap}" property="${department.uniqueID}_${category.uniqueID}" value="${categoryURL}"/>
		<c:forEach var="subcategory" items="${category.catalogGroupView}">
			<wcf:url var="categoryURL" value="Category3" patternName="CategoryURLWithParentCategory">
				<wcf:param name="storeId" value="${storeId}"/>
				<wcf:param name="catalogId" value="${catalogId}"/>
				<wcf:param name="langId" value="${langId}"/>
				<wcf:param name="urlLangId" value="${urlLangId}"/>
				<wcf:param name="categoryId" value="${subcategory.uniqueID}"/>
				<wcf:param name="parent_category_rn" value="${category.uniqueID}"/>
				<wcf:param name="top_category" value="${department.uniqueID}"/>
				<wcf:param name="pageView" value="${env_defaultPageView}"/>
				<wcf:param name="beginIndex" value="0"/>
			</wcf:url>
			<c:set target="${categoryURLMap}" property="${department.uniqueID}_${category.uniqueID}_${subcategory.uniqueID}" value="${categoryURL}"/>
		</c:forEach>
	</c:forEach>
</c:forEach>


<ul id="departmentsMenu" role="menu" data-parent="header"
			aria-labelledby="departmentsButton">
		
		<li class="menuCategorias">
			
			<a id="departmentButton_90001" href="#" class="departmentButton" role="menuitem" aria-haspopup="true" data-toggle="departmentMenu_90001">
				<span> <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_TODAS_CAT" /> </span>
				<div class="arrow_button_icon"></div>	
			</a>
		
		
			
			<div id="departmentMenu_90001" class="departmentMenu" role="menu" data-parent="departmentsMenu" data-id="90001" aria-label="Todas las categorías">
				
				<div class="header">
					<a id="departmentLink_90001" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="Todas las categorías"/></a>
					<a id="departmentToggle_90001" href="#" class="toggle" role="button" data-toggle="departmentMenu_90001" aria-labelledby="departmentLink_90001">
					<span role="presentation"></span></a>
				</div>
				
				
				<ul class="categoryList">
				
				<c:set var="count" value="#{0}" />
				
				
				
			   <c:forEach var="department" items="${categoryHierarchy.catalogGroupView}">
			    
			    <c:set var="count" value="#{count+1}" />
			    
			    <li rel="subMenu${count}" class="menuLink">
				
				<a id="departmentLink_${department.uniqueID}_alt" href="${fn:escapeXml(categoryURLMap[department.uniqueID])}"  role="menuitem" tabindex="-1"><c:out value="${department.name}"/></a>
			           
		           <div class="subMenuPage subMenu${count} menuLink">
				         <ul class="subcategoryList">
                             
                             <c:forEach var="category" items="${department.catalogGroupView}">    
			                    <c:set var="key" value="${department.uniqueID}_${category.uniqueID}"/>
			                     
                                 <li>
                                     <a id="categoryLink_${key}" href="${fn:escapeXml(categoryURLMap[key])}" class="menuLink" role="menuitem" tabindex="-1">
			                         <c:out value="${category.name}"/>
                                     </a>
			                   
                                    <ul class="subcategoryList2">
                                    <c:forEach var="subcategory" items="${category.catalogGroupView}" >
                                        <li>
                                        <c:set var="key" value="${department.uniqueID}_${category.uniqueID}_${subcategory.uniqueID}"/>
                                        <a id="subcategoryLink_${key}" href="${fn:escapeXml(categoryURLMap[key])}" class="menuLink" role="menuitem" tabindex="-1"><c:out value="${subcategory.name}"/></a>
                                         </li>
                                    </c:forEach>
                                    </ul>
        			             </li>
                       
                            </c:forEach>
			              
			             </ul>

			             <div>
			             	<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexMenu_Image" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
			             </div>						 
						 
					</div>
			           
			           
			    </li>
			</c:forEach>

			
			</ul>
			
			</div>
		
		
		</li>	
						
				
				<li class="active">
					<a id="departmentButton_" href="#" class="departmentButton" role="menuitem" aria-haspopup="true" data-toggle="departmentMenu_001">
						<span>  <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_ESTILOS_VIDA" /> </span>
					</a>
					
					<div id="departmentMenu_001" class="departmentMenu" role="menu" data-parent="departmentsMenu" data-id="0001" aria-label="telmex">
						<div class="header">
					<a id="departmentLink_001" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="ESTILO DE VIDA"/></a>
					<a id="departmentToggle_001" href="#" class="toggle" role="button" data-toggle="departmentMenu_001" aria-labelledby="departmentLink_002">
					<span role="presentation"></span></a>
						</div>
						<%out.flush();%>
							<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexHeader_EstiloVidaESP" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
						<%out.flush();%>
					</div>
					
				</li>
				
				<li class="active">
				

					<a id="departmentButton_" href="${fn:escapeXml(categoryURLMap[1])}"   class="departmentButton" role="menuitem" aria-haspopup="true" >
						<span> <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_NOVEDADES" /> </span>
					</a>
					
					<div id="departmentMenu_002" class="departmentMenu" role="menu"  data-parent="departmentsMenu" data-id="002" aria-label="002">
			       <div class="header">
					<a id="departmentLink_002" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="NOVEDADES"/></a>
					<!-- 
					<a id="departmentToggle_002" href="#" class="toggle" role="button" data-toggle="departmentMenu_002" aria-labelledby="departmentLink_002">
					<span role="presentation"></span></a> -->
				   </div>
				   <!-- <%--	   
						<%out.flush();%>
							<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexHeader_NovedadesESP" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
						<%out.flush();%>	
					--%> -->
					</div>
					 
				</li>
				
				<li class="active">
					<a id="departmentButton_" href="${fn:escapeXml(categoryURLMap[1])}"  class="departmentButton" role="menuitem" aria-haspopup="true" >
						<span> <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_EXCLUSIVOS" /> </span>
					</a>
					
					<div id="departmentMenu_003" class="departmentMenu" role="menu"
					data-parent="departmentsMenu" data-id="003"
					aria-label="003">
					<div class="header">
					<a id="departmentLink_003" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="EXCLUSIVOS"/></a>
					<!-- 
					<a id="departmentToggle_003" href="#" class="toggle" role="button" data-toggle="departmentMenu_003" aria-labelledby="departmentLink_003">
					<span role="presentation"></span></a> -->
					</div>
					<!-- <%-- 
						<%out.flush();%>
							<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexHeader_ExlusivosESP" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
						<%out.flush();%>
					--%> -->
					</div>
					
				</li>
				
				<li class="active">
					<a id="departmentButton_" href="${fn:escapeXml(categoryURLMap[1])}"  class="departmentButton" role="menuitem" aria-haspopup="true" >
						<span> <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_GOPRO" /> </span>
					</a>
					
					<div id="departmentMenu_004" class="departmentMenu" role="menu" data-parent="departmentsMenu" data-id="004" aria-label="004">
					<div class="header">
					<a id="departmentLink_004" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="GO PRO"/></a>
					<!-- 
					<a id="departmentToggle_004" href="#" class="toggle" role="button" data-toggle="departmentMenu_004" aria-labelledby="departmentLink_004">
					<span role="presentation"></span></a> -->
					</div>
					<!-- <%--
						<%out.flush();%>
							<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexHeader_GoproESP" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
						<%out.flush();%>
					 --%> -->
					</div>
					
				</li>
				
				<li class="active">
					<a id="departmentButton_" href="${fn:escapeXml(categoryURLMap[1])}"  class="departmentButton" role="menuitem" aria-haspopup="true" >
						<span> <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_APPLE" /> </span>
					</a>
					
					<div id="departmentMenu_005" class="departmentMenu" role="menu" data-parent="departmentsMenu" data-id="005" aria-label="005">
					<div class="header">
					<a id="departmentLink_005" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="APPLE"/></a>
					<!-- 
					<a id="departmentToggle_005" href="#" class="toggle" role="button" data-toggle="departmentMenu_005" aria-labelledby="departmentLink_005">
					<span role="presentation"></span></a> -->
					</div>
					<!-- <%-- 
						<%out.flush();%>
							<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexHeader_AppleESP" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
						<%out.flush();%>
					--%> -->
					</div>
					
				</li>
				
				<li class="active">
					<a id="departmentButton_" href="${fn:escapeXml(categoryURLMap[1])}"  class="departmentButton" role="menuitem" aria-haspopup="true" >
						<span>  <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_NEGOCIO" /> </span>
					</a>
					
					<div id="departmentMenu_006" class="departmentMenu" role="menu" data-parent="departmentsMenu" data-id="006" aria-label="006">
					<div class="header">
					<a id="departmentLink_006" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="NEGOCIO"/></a>
					<!--
					<a id="departmentToggle_006" href="#" class="toggle" role="button" data-toggle="departmentMenu_006" aria-labelledby="departmentLink_006">
					<span role="presentation"></span></a> -->
					</div>
					<!-- <%--
						<%out.flush();%>
							<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexHeader_NegocioESP" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
						<%out.flush();%>
					 --%> -->
					</div>
					
				</li>
				
				<li class="active">
					<a id="departmentButton_" href="${fn:escapeXml(categoryURLMap[1])}"  class="departmentButton" role="menuitem" aria-haspopup="true" >
						<span> <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_OFERTAS_WOW" />  </span>
					</a>
					
					<div id="departmentMenu_007" class="departmentMenu" role="menu" data-parent="departmentsMenu" data-id="007" aria-label="007">
					<div class="header">
					<a id="departmentLink_007" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="OFERTAS WOW"/></a>
					<!--
					<a id="departmentToggle_007" href="#" class="toggle" role="button" data-toggle="departmentMenu_007" aria-labelledby="departmentLink_007">
					<span role="presentation"></span></a>-->
					</div>
					<!-- <%--
						<%out.flush();%>
							<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexHeader_OfertasWOWESP" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
						<%out.flush();%>
					 --%> -->
					</div>
					
				</li>
				
				
					<li class="active">
					<a id="departmentButton_" href="${fn:escapeXml(categoryURLMap[1])}"  class="departmentButton" role="menuitem" aria-haspopup="true" >
						<span> <fmt:message bundle="${storeText}" key="MENU_PRINCIPAL_PAYBACK" />  </span>
					</a>
					
					<div id="departmentMenu_009" class="departmentMenu" role="menu" data-parent="departmentsMenu" data-id="009" aria-label="009">
					<div class="header">
					<a id="departmentLink_009" href="#" class="link menuLink" role="menuitem" tabindex="-1"><c:out value="PAYBACK"/></a>
					<!--
					<a id="departmentToggle_009" href="#" class="toggle" role="button" data-toggle="departmentMenu_009" aria-labelledby="departmentLink_009">
					<span role="presentation"></span></a> -->
					</div>
					<!-- <%-- 
						<%out.flush();%>
							<c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
								<c:param name="emsName" value="telmexHeader_PaybackESP" />
							    <c:param name="catalogId" value="${WCParam.catalogId}" />
							</c:import>
						<%out.flush();%>
					--%> -->
					</div>
					
				</li>
				
	
		</ul>

