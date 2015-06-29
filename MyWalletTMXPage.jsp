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
<title>Monedero</title>
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
		
		<c:if test="${messageFail!= null && messageFail != ''}">
			<h1>
				<fmt:message bundle="${storeText}" key="NOT_AVAILABLE_WALLET"/>
			</h1>
		</c:if>
		
		<c:if test="${!(messageFail!= null && messageFail != '')}">
			<div class="col8 acol12 ccol9 right">
				<h2 class="myaccount_header bottom_line">Resumen de Monedero</h2>
				<div id="WC_MyAccountDisplay_div_13" class="body">
					<div id="WC_MyAccountCenterLinkDisplay_div_6" class="info">
					<div id="WC_MyAccountCenterLinkDisplay_div_3">
						</br>
						<span class="header">Numero Telmex: <label id="numeroTelefono">${address.phone1}</label></span>
					</div>
					</br>
					<div class="info_table">
						<div class="row">
							<div class="label">Monto obtenido</div>
							<div class="info_content"> $ <label id="bonosObtenidos">${monedero.totalBonosObtenidos}.00</label> </div>
							<div class="clear_float"></div>
						</div>
							<div class="row">
								<div class="label">Monto utilizado</div>
								<div class="info_content"> $ <label id="bonosUtilizados">${monedero.totalBonosUtilizados}.00</label> </div>
								<div class="clear_float"></div>
							</div>
							<div class="row">
								<div class="label">Monto cancelado</div>
								<div class="info_content"> $ <label id="bonosCancelados">${monedero.totalBonosCancelados}.00</label> </div>
								<div class="clear_float"></div>
							</div>
						</div>
						<div id="WC_MyAccountCenterLinkDisplay_div_3">
							<span class="header">Saldo disponible:</span>
						</div>
					</div>
				</div>
				<h2 class="myaccount_header bottom_line">Detalle de movimientos</h2>
				<div class="">
					
					 <table style="width:75%">
					 <thead>
	  					<tr>
	  						<th><fmt:message bundle="${storeText}" key="WALLET_DATE_INFO"/></th>
	  						<th><fmt:message bundle="${storeText}" key="WALLET_CONCEPT"/></th>
	  						<th><fmt:message bundle="${storeText}" key="WALLET_DUE_DATE"/></th>
	  						<th><fmt:message bundle="${storeText}" key="WALLET_OBTAINED_AMOUNT"/></th>
	    					<th></th>
	  					</tr>
	  				</thead>
	  				<tbody>
	  					<c:forEach var="bonos" items="${monedero.bonos.bono}">
	  						<tr>
		    					<td align="center">${bonos.fechaTransaccion}</td>
		    					<td align="center">${bonos.desTransaccion}</td>
		    					<td align="center">${bonos.fechaVigencia}</td>
		    					<td align="center">${bonos.montoBonoObtenido}</td>
		  					</tr>
	  					</c:forEach>
	  				</tbody>
					</table> 
				</div>
			</div>
		</c:if>
	</div>	
</div>
</body>
</html>