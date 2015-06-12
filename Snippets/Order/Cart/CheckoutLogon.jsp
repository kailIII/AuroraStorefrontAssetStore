<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN CheckoutLogon.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
 
<!-- Start - JSP File Name:  CheckoutLogon.jsp -->
<wcf:url var="OrderCalculateURL" value="OrderShippingBillingView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />						
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="shipmentType" value="single" />
</wcf:url>

<c:set var="guestUserURL" value="${OrderCalculateURL}"/>
<c:if test="${userType eq 'G'}">
	<c:set var="validAddressId" value=""/>
	<%-- The below getdata statment for UsableShippingInfo can be removed if the order services can return order details and shipping details in same service call --%>
	<wcf:rest var="orderUsableShipping" url="store/{storeId}/cart/@self/usable_shipping_info" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="1"/>
		<wcf:param name="pageNumber" value="1"/>
	</wcf:rest>
	<c:forEach var="usableAddress" items="${orderUsableShipping.usableShippingAddress}">
		<c:if test="${!empty usableAddress.nickName && usableAddress.nickName != profileBillingNickname}" >
			<c:set var="validAddressId" value="true"/>
		</c:if>
	</c:forEach>
	<c:if test="${empty validAddressId && order.x_isPersonalAddressesAllowedForShipping && (!env_contractSelection || (env_contractSelection && WCParam.guestChkout == '1'))}" >
		<wcf:url var="guestUserURL" value="UnregisteredCheckoutView" type="Ajax">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
	</c:if>
</c:if>

<wcf:url var="PhysicalStoreSelectionURL" value="CheckoutStoreSelectionView">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="fromPage" value="ShoppingCart" />
</wcf:url>

<c:if test="${userType != 'G'}">
	<%-- See if this user has quick checkout profile created or not, if quick checkout enabled --%>
	<flow:ifEnabled feature="quickCheckout">
		<wcf:rest var="quickOrder" url="store/{storeId}/order/byStatus/{status}">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:var name="status" value="Q"/>
		</wcf:rest>
		<c:if test="${!empty quickOrder.Order}">
			<c:choose>
				<c:when test="${isBrazilStore}">
					<%-- See if this user has more info in the quick checkout profile than just the CPF number --%>
					<c:set var="person" value="${requestScope.person}"/>
					<c:if test="${empty person || person==null}">
						<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
							<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
						</wcf:rest>
					</c:if>
					<c:if test="${!empty person.checkoutProfile[0].protocolData[1].value}">
						<c:set var="quickCheckoutProfile" value="true"/>
					</c:if>
				</c:when>
				<c:otherwise>
					<c:set var="quickCheckoutProfile" value="true"/>
				</c:otherwise>
			</c:choose>
		</c:if>
	</flow:ifEnabled>
</c:if>

<c:if test="${userType == 'G'  && !empty order.orderItem}">	
	<wcf:url var="orderMove" value="RESTMoveOrderItem" type="Ajax">		
		<wcf:param name="toOrderId" value="."/>
		<flow:ifEnabled feature="MultipleActiveOrders">
			<wcf:param name="deleteIfEmpty" value="."/>
			<wcf:param name="fromOrderId" value="."/>
		</flow:ifEnabled>
		<flow:ifDisabled feature="MultipleActiveOrders">
			<wcf:param name="deleteIfEmpty" value="*"/>
			<%-- MultipleActiveOrders is disabled. Order merging behavior should be the same as B2C --%>
			<wcf:param name="fromOrderId" value="*"/>
		</flow:ifDisabled>	
		<wcf:param name="continue" value="1"/>
		<wcf:param name="createIfEmpty" value="1"/>
		<wcf:param name="calculationUsageId" value="-1"/>
		<wcf:param name="updatePrices" value="0"/>
	</wcf:url>
		
	<wcf:url var="ForgetPasswordURL" value="ResetPasswordGuestErrorView">
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		<wcf:param name="state" value="forgetpassword" />
	</wcf:url>	

	<form method="post" name="AjaxLogon" id="AjaxLogon" action="Logon">
		<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}"/>" id="WC_RememberMeLogonForm_FormInput_storeId_In_AjaxLogon_1"/>
		<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}"/>" id="WC_RememberMeLogonForm_FormInput_catalogId_In_AjaxLogon_1"/>
		<input type="hidden" name="URL" value="" id="WC_AccountDisplay_FormInput_URL_In_Logon_1" />
		<c:choose>
			<c:when test="${!empty WCParam.ErrorCode && WCParam.ErrorCode == '2430'}">						
				<script type="text/javascript">
				document.location.href = "ResetPasswordForm?storeId="
						+ <c:out value="${WCParam.storeId}"/> + "&catalogId=" + <c:out value="${WCParam.catalogId}"/>
						+ "&langId=" + <c:out value="${langId}"/> + "&errorCode=" + <c:out value="${WCParam.ErrorCode}"/>;
				</script>
			</c:when>
			<c:otherwise>
				<input type="hidden" name="reLogonURL" value="AjaxOrderItemDisplayView" id="WC_RememberMeLogonForm_FormInput_reLogonURL_In_AjaxLogon_1"/>
			</c:otherwise>
		</c:choose>
		<input type="hidden" name="errorViewName" value="AjaxOrderItemDisplayView" id="WC_RememberMeLogonForm_FormInput_errorViewName_In_AjaxLogon_1"/>	

		<div class="top_border" id="WC_CheckoutLogonf_div_0">
			<div id="customers_new_or_returning">
				<div class="new" id="WC_CheckoutLogonf_div_1">
					<h2><fmt:message bundle="${storeText}" key="SHOPCART_NEW_CUSTOMER"/></h2>
					<p><fmt:message bundle="${storeText}" key="SHOPCART_CHECKOUT_WITHOUT_SIGNING"/></p>
					<br />
					<p><fmt:message bundle="${storeText}" key="SHOPCART_TEXT1"/></p>
					<br />
					<p><fmt:message bundle="${storeText}" key="SHOPCART_TEXT2"/></p>
					<div class="new_returning_button" id="WC_CheckoutLogonf_div_2">
						<div class="button_align" id="WC_CheckoutLogonf_div_3">
							<a href="#" role="button" class="button_primary" id="guestShopperContinue" onclick="javascript:if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){TealeafWCJS.processDOMEvent(event);ShipmodeSelectionExtJS.guestShopperContinue('<c:out value='${guestUserURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
								<div class="left_border"></div>
								<div class="button_text"><fmt:message bundle="${storeText}" key="SHOPCART_CONTINUE" /></div>
								<div class="right_border"></div>
							</a>
						</div>
					</div>
				</div>			

				<div class="returning" id="WC_CheckoutLogonf_div_4">
					<div class="message-returning"><h2 class="usuarioRegistrado"><fmt:message bundle="${storeText}" key="SHOPCART_TEXT3"/></h2></div>
					<div class="message-returning"><p class="subheader"><fmt:message bundle="${storeText}" key="SHOPCART_TEXT4"/></p></div>
					<br />
					<%-- Daniel Torres <p><label for="WC_CheckoutLogon_FormInput_logonId"><fmt:message bundle="${storeText}" key="SHOPCART_USERNAME"/></label></p> --%>
					<p>
						<input id="WC_CheckoutLogon_FormInput_logonId" placeholder="ej. 5566778899" name="logonId" type="text" size="25" onchange="javaScript:TealeafWCJS.processDOMEvent(event);" onkeypress="if(event.keyCode==13){javascript:if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}}" />
					</p>
					<br />
					<%-- Daniel Torres <p><label for="WC_CheckoutLogon_FormInput_logonPassword"><fmt:message bundle="${storeText}" key="SHOPCART_PASSWORD"/></label></p> --%>
					<p>
						<input id="WC_CheckoutLogon_FormInput_logonPassword" placeholder="Contrase&ntilde;a" name="logonPassword" type="password" autocomplete="off" size="25" onchange="javaScript:TealeafWCJS.processDOMEvent(event);" onkeypress="if(event.keyCode==13){javascript:if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}}" />
					</p>
					
					<div class="new_returning_button" id="WC_CheckoutLogonf_div_5">
						
							<a href="#" role="button" class="button_primary" id="guestShopperLogon" onclick="javascript:TealeafWCJS.processDOMEvent(event);if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
								<div class="left_border"></div>
								<div class="button_text"><fmt:message bundle="${storeText}" key="SHOPCART_SIGNIN" /></div>
								<div class="right_border"></div>
							</a>
						
					</div>
					
					<p><a href="<c:out value="${ForgetPasswordURL}"/>" class="myaccount_link hover_underline" id="WC_CheckoutLogonf_links_1"><fmt:message bundle="${storeText}" key="SHOPCART_FORGOT"/></a></p>
				</div>
			</div>
		</div>
	 	<br clear="all" />
	 	<br />
	</form>
</c:if>

    
    
    
<c:if test="${!empty order.orderItem}"><!-- codigo para eliminar el sidebar solamente con el carrito vacio -->
        
<div id="WC_CheckoutLogonf_div_9" class="flotante_side">
    
    
    
    
    
    
    
    
    
    <!-- comenzamos con el movimiento del total al sidebar ================================================================================= -->
    
    
    
    <!-- empieza el codigo de promocion -->

    <form name="PromotionCodeForm" id="PromotionCodeForm" method="post" action="<c:out value="${PromotionCodeManage}"/>" onsubmit="javascript: return false;">
        <%-- the "onsubmit" option in the form tag above is to handle problems when a user apply a promotion code by pressing the Enter key in the promotion code input area:
             1) when in an AJAX checkout flow
             2) when the promotion code is empty in a non-AJAX flow --%>

            <input type="hidden" name="orderId" value="<c:out value="${orderId}"/>" id="WC_PromotionCodeDisplay_FormInput_orderId_In_PromotionCodeForm_1"/>
            <input type="hidden" name="taskType" value="A" id="WC_PromotionCodeDisplay_FormInput_page_In_PromotionCodeForm_1"/>
            <input type="hidden" name="URL" value="" id="WC_PromotionCodeDisplay_FormInput_URL_In_PromotionCodeForm_1"/>
            <input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}"/>" id="WC_PromotionCodeDisplay_FormInput_storeId_In_PromotionCodeForm_1"/>
            <input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}"/>" id="WC_PromotionCodeDisplay_FormInput_catalogId_In_PromotionCodeForm_1"/>
            <input type="hidden" name="langId" value="<c:out value="${WCParam.langId}"/>" id="WC_PromotionCodeDisplay_FormInput_langId_In_PromotionCodeForm_1"/>
            <input type="hidden" name="finalView" value="AjaxOrderItemDisplayView" id="WC_PromotionCodeDisplay_FormInput_finalView_In_PromotionCodeForm_1"/>

                        
            <div class="promotion_code separador_total gris_sidebar" id="WC_PromotionCodeDisplay_div_1">
                <label for="promoCode"><fmt:message bundle="${storeText}" key="PROMOTION_CODE"/></label>
            </div>                   
            

            <div class="promotion_input" id="WC_PromotionCodeDisplay_div_2">
                <input type="text" class="input" size="6" name="promoCode" id="promoCode" onchange="javaScript:TealeafWCJS.processDOMEvent(event);" onkeypress="if(event.keyCode==13) JavaScript:CheckoutHelperJS.applyPromotionCode('PromotionCodeForm','<c:out value='${returnView}'/>')"/>
                <a href="#" role="button" class="button_primary promotion_btn2" id="WC_PromotionCodeDisplay_links_1" aria-labelledby="WC_PromotionCodeDisplay_links_1_ACCE_Label" tabindex="0" onclick="JavaScript:setCurrentId('WC_PromotionCodeDisplay_links_1'); CheckoutHelperJS.applyPromotionCode('PromotionCodeForm','<c:out value='${returnView}'/>');return false;">
                    <div class="button_text tiny"><fmt:message bundle="${storeText}" key="APPLY"/><span id="WC_PromotionCodeDisplay_links_1_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="Checkout_ACCE_promo_code_apply" /></span></div>                    
                </a>
                <c:set var="promoCodeString" value=""/>
            </div>
            
               
                
            <div id="appliedPromotionCodes" class="hover_underline">                                   
                <c:forEach var="promotionCode" items="${promoCodeListBean.promotionCode}" varStatus="status">
                    <c:set var="promoCodeString" value="${promoCodeString},${promotionCode.code}"/>
                    <div class="promotion_used">
                        <c:set var="aPromotionCode" value='${fn:replace(promotionCode.code, "\'", "&#39;")}'/>
                                                                                                         <p>
                                                                                                         <a class="font1" id="promotion_${status.count}" href="#" onclick='JavaScript:setCurrentId("promotion_<c:out value='${status.count}'/>");CheckoutHelperJS.removePromotionCode("PromotionCodeForm",<wcf:json object='${aPromotionCode}'/>,"<c:out value='${returnView}'/>");return false;'>
                        <img src="<c:out value='${jspStoreImgDir}${vfileColor}'/>table_x_delete.png" alt=""/>
                        <fmt:message bundle="${storeText}" key="PROMOTION_CODE_REMOVE" /> <c:out value="${promotionCode.code}"/>
                        </a>
                    <span id="promotionDetailsAcceText_${status.count}" style="display:none">
                        <fmt:message bundle="${storeText}" key='PROMOTION_DETAILS' />
                        <c:set var="emptyDesc" value="true"/>
                        <c:forEach var="desc" items="${promotionCode.associatedPromotion}" varStatus="status2">
                            <c:if test = "${!empty desc}">
                                <c:set var="emptyDesc" value="false"/>
                                <c:out value="${desc.description}" escapeXml="true"/>
                            </c:if>
                        </c:forEach>
                        <c:if test="${emptyDesc}">
                            <fmt:message bundle="${storeText}" key="PROMO_NO_DESC" />
                        </c:if>								
                    </span>

                    <span class="more_info_icon verticalAlign_middle" id="promotion_${status.count}_details" tabindex="0" onmouseover="javascript: this.title = '';" onmouseout="javascript: this.title = document.getElementById('promotionDetailsAcceText_<c:out value='${status.count}'/>').innerHTML;"
                          title="<fmt:message bundle='${storeText}' key='PROMOTION_DETAILS' />
                                 <c:set var="emptyDesc" value="true"/>
                                                                    <c:forEach var='desc' items='${promotionCode.associatedPromotion}' varStatus='status2'>
                                                                    <c:if test = '${!empty desc}'>
                                                                    <c:set var='emptyDesc' value='false'/>
                                                                    <c:out value='${desc.description}' escapeXml='true'/>
                                                                    </c:if>
                                                                    </c:forEach>
                                                                    <c:if test='${emptyDesc}'>
                                                                    <fmt:message bundle='${storeText}' key='PROMO_NO_DESC' />
                                                                    </c:if>
                                                                    ">
                        <img class="info_on" src="<c:out value='${jspStoreImgDir}${vfileColor}icon_info_ON.png'/>" alt=""/>
                        <img class="info_off" src="<c:out value='${jspStoreImgDir}${vfileColor}icon_info.png'/>" alt=""/>
                    </span>
                    <br />
                    </p>
            </div>
            <div id="WC_PromotionCodeDisplay_span_${status.count}" tabindex="0" dojoType="wc.widget.Tooltip" connectId="promotion_${status.count}_details" style="display:none">
                <div id="tooltip_popup_${status.count}" class="widget_site_popup">
                    <div class="top">
                        <div class="left_border"></div>
                        <div class="middle"></div>
                        <div class="right_border"></div>
                    </div>
                    <div class="clear_float"></div>
                    <div class="middle">
                        <div class="content_left_border">
                            <div class="content_right_border">
                                <div class="content">
                                    <div class="header" id="WC_PromotionCodeDisplay_div_6_${status.count}"> 
                                        <span id="WC_PromotionCodeDisplay_div_7_${status.count}"><fmt:message bundle="${storeText}" key="PROMOTION_DETAILS" /></span>
                                        <div class="clear_float"></div>
                                    </div>
                                    <%-- Calculate the height of the tooltip needed. Start with 10px initially (for the space between end of description and footer). (Set Height = length of promotion String /2) --%>
                                        <c:set var="descStringLen" value="10"/> 
                                        <c:forEach var="desc" items="${promotionCode.associatedPromotion}">
                                            <c:set var="descStringLen" value="${fn:length(desc) + descStringLen}"/>
                                        </c:forEach>
                                        <div class="body" style="height:${descStringLen/2}px;overflow:hidden;" id="WC_PromotionCodeDisplay_div_9_${status.count}">
                                            <c:set var="emptyDesc" value="true"/>
                                            <c:forEach var="desc" items="${promotionCode.associatedPromotion}" varStatus="status2">
                                                <c:if test = "${!empty desc}">
                                                    <c:set var="emptyDesc" value="false"/>
                                                    <div id="WC_PromotionCodeDisplay_div_10_${status.count}_${status2.count}">
                                                        <div class="required-field" id="WC_PromotionCodeDisplay_div_11_${status.count}_${status2.count}">*</div>&nbsp;
                                                        <c:out value="${desc.description}"/><br />
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${emptyDesc}">
                                                <div id="WC_PromotionCodeDisplay_div_12_${status.count}">
                                                    <div class="required-field" id="WC_PromotionCodeDisplay_div_13_${status.count}">*</div>&nbsp;
                                                    <fmt:message bundle="${storeText}" key="PROMO_NO_DESC" /><br />
                                                </div>
                                            </c:if>
                                        </div>
                                        </div>
                                </div>
                            </div>
                        </div>
                        <div class="clear_float"></div>
                        <div class="bottom">
                            <div class="left_border"></div>
                            <div class="middle"></div>
                            <div class="right_border"></div>
                        </div>
                        <div class="clear_float"></div>
                    </div>
                </div>
                <script type="text/javascript">
                    dojo.addOnLoad(function() { 
                        parseWidget("WC_PromotionCodeDisplay_span_${status.count}");
                    });
                </script>
                </c:forEach>
            <!--  <input type="hidden" name="newPromoCode" id="newPromoCode" value="${promoCodeString}"/> -->
            </div>
        <br clear="left" />
    </form>
    <!-- termina el codigo de promocion -->
    
    
    
    
    
   
    
    
    
    
    <!-- comenzamos con el resumen de la compra -->    
    <div class="separador_total gris_sidebar" id="WC_PromotionCodeDisplay_div_1">
            <c:import url="${env_jspStoreDir}/include/eMarketingSpotDisplay.jsp">
                <c:param name="emsName" value="Resumen_de_pedido" />
            </c:import>
    </div>
    
    <div id="total_breakdown">
        <table id="order_total2" cellpadding="0" cellspacing="0" border="0" role="presentation">

            <%-- ORDER SUBTOTAL--%>
                <tr>
                    <td class="total_details align_left" id="WC_SingleShipmentOrderTotalsSummary_td_1"><fmt:message bundle="${storeText}" key="MO_ORDERSUBTOTAL" /></td>
                    <td class="total_figures align_right" id="WC_SingleShipmentOrderTotalsSummary_td_2">
                        <c:choose>
                            <c:when test="${!empty order.totalProductPrice}">
                                <fmt:formatNumber value="${order.totalProductPrice}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>

                <%-- DISCOUNT ADJUSTMENTS --%>
                    <tr>
                        <td class="total_details align_left" id="WC_SingleShipmentOrderTotalsSummary_td_11"><fmt:message bundle="${storeText}" key="MO_DISCOUNTADJ" /></td>
                        <td class="total_figures align_right" id="WC_SingleShipmentOrderTotalsSummary_td_12">
                            <c:choose>
                                <c:when test="${!empty order.totalAdjustment}">
                                    <fmt:formatNumber value="${order.totalAdjustment}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
                                </c:when>
                                <c:otherwise>
                                    <fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <%-- TAX --%>
                        <tr>
                            <td class="total_details align_left" id="WC_SingleShipmentOrderTotalsSummary_td_5"><fmt:message bundle="${storeText}" key="MO_TAX" /></td>
                            <td class="total_figures align_right" id="WC_SingleShipmentOrderTotalsSummary_td_6">
                                <c:choose>
                                    <c:when test="${!empty order.totalSalesTax}">
                                        <fmt:formatNumber value="${order.totalSalesTax}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>

                        <%-- SHIPPING CHARGE --%>
                            <tr>
                                <td class="total_details align_left" id="WC_SingleShipmentOrderTotalsSummary_td_7"><fmt:message bundle="${storeText}" key="MO_SHIPPING" /></td>
                                <td class="total_figures align_right" id="WC_SingleShipmentOrderTotalsSummary_td_8">
                                    <c:choose>
                                        <c:when test="${!empty order.totalShippingCharge}">
                                            <fmt:formatNumber value="${order.totalShippingCharge}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <%-- SHIPPING TAX --%>
                                <tr>
                                    <td class="total_details align_left" id="WC_SingleShipmentOrderTotalsSummary_td_14"><fmt:message bundle="${storeText}" key="MO_SHIPPING_TAX" /></td>
                                    <td class="total_figures align_right" id="WC_SingleShipmentOrderTotalsSummary_td_15">
                                        <c:choose>
                                            <c:when test="${!empty order.totalShippingTax}">
                                                <fmt:formatNumber value="${order.totalShippingTax}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td>
                                        <div class="linea_total">
                                        <svg version="1.2" width="100%">
                                            <line x1="0" y1="5.5" x2="244" y2="5.5" stroke="#f2eff0" stroke-width="1" stroke-dasharray="" stroke-linecap="square"></line>
                                        </svg>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="linea_total">
                                        <svg version="1.2" width="100%">
                                            <line x1="0" y1="5.5" x2="244" y2="5.5" stroke="#f2eff0" stroke-width="1" stroke-dasharray="" stroke-linecap="square"></line>
                                        </svg>
                                        </div>
                                    </td>
                                </tr>

                                <%-- ORDER TOTAL --%>
                                    <tr>
                                        <td class="total_details align_left_total" id="WC_SingleShipmentOrderTotalsSummary_td_9"><fmt:message bundle="${storeText}" key="MO_ORDERTOTAL" /></td>
                                        <td class="total_figures align_right_total" id="WC_SingleShipmentOrderTotalsSummary_td_10">
                                            <c:choose>
                                                <c:when test="${order.grandTotal != null}">
                                                    <c:choose>
                                                        <c:when test="${!empty order.grandTotal}">
                                                            <fmt:formatNumber value="${order.grandTotal}" type="currency" maxFractionDigits="${env_currencyDecimal}" currencySymbol="${env_CurrencySymbolToFormat}"/><c:out value="${CurrencySymbol}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td>
                                            <div class="linea_total">
                                                <svg version="1.2" width="100%">
                                                    <line x1="0" y1="5.5" x2="244" y2="5.5" stroke="#f2eff0" stroke-width="1" stroke-dasharray="" stroke-linecap="square"></line>
                                                </svg>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="linea_total">
                                                <svg version="1.2" width="100%">
                                                    <line x1="0" y1="5.5" x2="244" y2="5.5" stroke="#f2eff0" stroke-width="1" stroke-dasharray="" stroke-linecap="square"></line>
                                                </svg>
                                            </div>
                                        </td>
                                    </tr>
                                    </table>
                                
                                </div>
                            
                            <!--termina el codigo del resumen -->
                            
                            
                            
     <!-- terminamos con el movimiento del total al sidebar ================================================================================= -->
                            
                            
                            
                            
                            
                            
                            
    
    
	<c:if test="${userType != 'G'}">
		<div class="left" id="shopcartCheckoutButton">
			<c:choose>
				<c:when test="${requestScope.allContractsValid}">
					<div class="button_align left" id="WC_CheckoutLogonf_div_10">
					<a href="#" role="button" class="button_primary" id="shopcartCheckout" tabindex="0" onclick="javascript:TealeafWCJS.processDOMEvent(event);if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.registeredUserContinue('<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
				</c:when>
				<c:otherwise>
					<div class="disabled left" id="WC_CheckoutLogonf_div_10">
					<a role="button" class="button_primary" id="shopcartCheckout" tabindex="0" onclick="javascript:TealeafWCJS.processDOMEvent(event);setPageLocation('#')">
				</c:otherwise>
			</c:choose>
			<div class="left_border"></div>
			<div class="button_text"><fmt:message bundle="${storeText}" key="SHOPCART_CHECKOUT" /></div>
			<div class="right_border"></div>				
			</a>
			</div>	
			<c:if test="${quickCheckoutProfile}">
				<c:set var="quickOrderId" value="${quickOrder.Order[0].orderId}"/>
				<div class="left" id="quickCheckoutButton">
					<div class="button_align" id="WC_CheckoutLogonf_div_13">
						<a href="#" role="button" class="button_primary button_left_padding" id="WC_CheckoutLogonf_links_2" tabindex="0" onclick="javascript:if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){setCurrentId('WC_CheckoutLogonf_links_2'); ShipmodeSelectionExtJS.updateCartWithQuickCheckoutProfile('<c:out value='${quickOrderId}'/>');}">
							<div class="left_border"></div>
							<div class="button_text"><fmt:message bundle="${storeText}" key="QUICKCHECKOUT" /></div>
							<div class="right_border"></div>
						</a>
					</div>
				</div>
			</c:if>
		</div>
        </c:if><!-- aca terminamos el codigo de Daniel -->
	</c:if>

	<flow:ifDisabled feature="AjaxCheckout">
		<div class="left" id="updateShopCart"> 
			<div class="button_align" id="WC_CheckoutLogonf_div_14">
				<a href="#" role="button" class="button_primary" id="ShoppingCart_NonAjaxUpdate" tabindex="0" onclick="javascript:CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,false);return false;">
					<div class="left_border"></div>
					<div class="button_text"><fmt:message bundle="${storeText}" key="SHOPCART_UPDATE" /></div>
					<div class="right_border"></div>
				</a>
			</div>
		</div>	
		<br/>
		<br/>
	</flow:ifDisabled>
</div>
<%@ include file="CheckoutLogonEIExt.jspf"%>
<!-- END CheckoutLogon.jsp -->
