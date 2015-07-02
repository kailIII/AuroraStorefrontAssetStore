<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="GENERATOR" content="IBM Software Development Platform" />
<!-- Style sheets -->
<link rel="stylesheet" href="/wcsstore/AuroraStorefrontAssetStore/css/common1_1.css" type="text/css" media="screen"/>
<!-- Style sheet for print -->
<link rel="stylesheet" href="/wcsstore/AuroraStorefrontAssetStore/css/print.css" type="text/css" media="print"/>
<!-- Style sheet for RWD -->
<link rel="stylesheet" href="/wcsstore/AuroraStorefrontAssetStore/css/styles.css" type="text/css" />
<!--[if IE 8]>
<link rel="stylesheet" href="/wcsstore/AuroraStorefrontAssetStore/css/stylesIE8.css" type="text/css" />
<![endif]-->

<%@ include file="Common/JSTLEnvironmentSetup.jspf"%>
<!-- Javascripts -->
<script type="text/javascript" charset="UTF-8" src="/wcsstore/dojo18/dojo/dojo.js" djConfig="parseOnLoad: true, isDebug: false,  modulePaths: {storetext: '/wcsstore/AuroraStorefrontAssetStore/'}, useCommentedJson: true,locale: 'es-mx' "></script>
<script type="text/javascript" charset="UTF-8" src="/wcsstore/dojo18/dojo/dojodesktop-rwd.js" djConfig="parseOnLoad: true, isDebug: false,  modulePaths: {storetext: '/wcsstore/AuroraStorefrontAssetStore/'}, useCommentedJson: true,locale: 'es-mx' "></script>

<script type="text/javascript" src="/wcsstore/AuroraStorefrontAssetStore/javascript/MessageHelper.js"></script>
<script type="text/javascript" src="/wcsstore/AuroraStorefrontAssetStore/javascript/StoreCommonUtilities.js"></script>
<script type="text/javascript" src="/wcsstore/AuroraStorefrontAssetStore/javascript/Responsive.js"></script>
<script type="text/javascript" src="/wcsstore/AuroraStorefrontAssetStore/javascript/Widgets/Search.js"></script>
<script type="text/javascript" src="/wcsstore/AuroraStorefrontAssetStore/javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"></script>
<script type="text/javascript" src="/wcsstore/AuroraStorefrontAssetStore/javascript/Widgets/Department/Department.js"></script>
<script type="text/javascript" src="/wcsstore/AuroraStorefrontAssetStore/javascript/Common/ShoppingActions.js"></script>
<script type="text/javascript" src="/wcsstore/AuroraStorefrontAssetStore/javascript/Common/ShoppingActionsServicesDeclaration.js"></script>
<script type="text/javascript" src="/wcsstore/Widgets_701/Common/javascript/WidgetCommon.js"></script>

<script>
	dojo.require("wc.service.common");
	dojo.require("dojo.number");
	dojo.require("dojo.has");
</script>
<title>Monedero PAYBACK</title>
</head>

<!-- SECTION 2 -->

<fmt:setLocale value="en" />
<fmt:setBundle basename="${sdb.directory}/TutorialNLS" var="tutorial" />

<!-- END OF SECTION 2 -->

<body>
<!-- Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
<div id="container_MyAccountDisplayB2B" class="rowContainer">	
	<div class="row margin-true">					
		<div class="col4 acol12 ccol3">
			<%out.flush();%>
				<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
			<%out.flush();%>		
		</div>
		<div class="col8 acol12 ccol9 right puntos_payback_contenedorsote">			
            <div id="WC_MyAccountCenterLinkDisplay_div_6" class="info">					
                
                <div id="WC_MyAccountCenterLinkDisplay_div_3" class="texto_izquierdo_payback">
                    <h2><fmt:message bundle="${storeText}" key="PAYBACK_SECTION_TITLE"/></h2>
                    <fmt:message bundle="${storeText}" key="PAYBACK_SECTION_TEXTO1"/>
				</div>
                
                <div id="WC_MyAccountCenterLinkDisplay_div_3" class="texto_derecho_payback">					
                    <span><fmt:message bundle="${storeText}" key="PAYBACK_SECTION_TEXTO2"/></span>
                    <span>20,000</span>
                    <span><fmt:message bundle="${storeText}" key="PAYBACK_SECTION_PUNTOS_TITULO"/></span>
                    <span><fmt:message bundle="${storeText}" key="PAYBACK_SECTION_TEXTO3"/></span>
                    <span><fmt:message bundle="${storeText}" key="PAYBACK_SECTION_TEXTO4"/></span>
                    <span>$200</span>
                    <span><fmt:message bundle="${storeText}" key="PAYBACK_SECTION_TEXTO6"/></span>
                    <p><fmt:message bundle="${storeText}" key="PAYBACK_SECTION_CONSULTA_OTROS"/></p>
                </div>
					
			</div>
            
            
            
            <!-- Vertical Recommendations Widget -->
            <div class="widget_recommended_position" id="widget_recomendaciones_payback">
                <%out.flush();%>
                    <c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
                        <c:param name="emsName" value="ShoppingCartRight_CatEntries"/>
                        <c:param name="widgetOrientation" value="vertical"/>
                        <c:param name="pageSize" value="2"/>
                    </c:import>
                <%out.flush();%>
             </div>
            
            
		</div>
		
		
		
	</div>	
</div>
</body>
</html>