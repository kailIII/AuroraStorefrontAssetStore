/*Script telmexianos*/


/*Función para checar el ancho de la pantalla.  Incorrecto poner $(window).width ya que difiere del usado por media queries*/
function checkWidth(){
		var e = window, a = 'inner';
		if(!('innerWidth' in window)){
			a = 'client';
			e = document.documentElement || document.body;
		}
		var widthD = e[a+'Width'];
		return widthD		
}

checkWidth();

/*Resize window*/
$(window).resize(function(){
		responsiveMenu();
		menuF();
})


$( document ).ready(function() {

	
	$(".asistenciaTienda").hover(function(){
	    $(".asistenciaLista").toggle();
	});

	responsiveMenu();
	
});



/*Función hover menú escritorio*/
function menuF(){
	
	if (checkWidth() > 952) {
	var claseMenu = "";
	//console.log("mayor a 952");
		$(".menuLink").hover(
			function () {
				if($(this).find('li').length > 0){
					claseMenu = $(this).attr('rel');			
					$(this).find('div').show();
				}
			}, 
			function () {
				claseMenu = $(this).attr('rel');
			   $('div.'+claseMenu).hide(1);
			}
		);
		

	}
	else {
		
	   $('.menuLink').unbind('mouseenter mouseleave');
	   
	   console.log('Less than 960');
	}
}

menuF();

var responsiveMenu = function(){
	var activeButton= $('#departmentsButton');
	var menuCont =$('#departmentsMenu');
	var ibmBtn = menuCont.find('span[role="presentation"]');
	activeButton.unbind('click');
	
	ibmBtn.closest('a').hide();
	
	if(checkWidth() < 953){
		
		menuCont.css('display', 'none');
		activeButton.removeClass('selected');
		
		var isActive = $('.menuCategorias').find('active').length;

		
		activeButton.click(function(e){
			e.stopPropagation()
			menuCont.animate({width: 'toggle'});
			if($(this).hasClass('selected')){
				activeButton.removeClass('selected');
			}else{
				activeButton.addClass('selected');
			}
		})
		
		var elemClick = menuCont.find('li')
		elemClick.unbind('click');
		var returnBtn = $('<div class="menuReturn"></div>')
		elemClick.click(function(e){
			
			e.stopPropagation();
			var siblingsElem = $(this).parent('ul').find('>li');
			var ulParent = $(this).find('ul')
			var childUl = $(this).find('ul').eq(0);
			var textParent=$(this).find('.menuLink').eq(0).text();
			var divParent = childUl.closest('div');
			
			if(divParent.css('display')== "none"){
				divParent.show();
			}
			
			
			if(ulParent.length > 1){
				e.preventDefault();
				siblingsElem.not(this).hide();
				childUl.show();
				childUl.find('li').show();
				childUl.find('ul').hide();
				returnBtn.text('Regresar a Menu principal' );
			}else{
				if(ulParent.find('li').length > 0){
					siblingsElem.not(this).each(function(){
						$(this).find('ul').slideUp();
					})
					childUl.slideToggle();
					e.preventDefault();
				}else{
					
				}
			}
			//$(this).parent('#departmentsMenu').prepend(returnBtn);
		});
		
		returnBtn.click(function(){
			var childLevel = $(this).parents('ul').length;
			console.log(childLevel)
			var elemFirst = menuCont.find('>li');
			console.log(elemFirst.length);
			
			elemFirst.each(function(){
				$(this).show();
				$(this).find('ul').hide();
			})
			
		})
		
		
		
	}else{
		menuCont.show();
		var elemFirst = menuCont.find('>li');
		var allElems = elemFirst.find('li');
		var listMen = menuCont.find('ul').show();
		elemFirst.each(function(){
			$(this).css('display','inline-block');
		})
		
		allElems.each(function(){
			$(this).show();
		})
		menuCont.find('li').unbind('click');
		$('.menuReturn').remove();
		
	}
	

}

