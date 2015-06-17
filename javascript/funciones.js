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
	menuF();
});



/*Función hover menú escritorio*/
function menuF(){
	
	var menuCont =$('#departmentsMenu');
	
	if (checkWidth() > 952) {
	var claseMenu = "";
	

		
	/*Menu Hover*/
		$("li.menuLink").hover(
			function () {
				if($(this).find('li').length > 0){
					claseMenu = $(this).attr('rel');
					//Show childs
					$(this).find('div').show();
					
					//Set border radius;
					$('.departmentMenu.active').css('borderBottomRightRadius', '0px ');
					
					 var index = $( "li.menuLink" ).index( this );
					
					 //Menu Same Height of select
					$('.subMenuPage').outerHeight($('.categoryList').outerHeight()+ 6);
					
					//Position of the div menu
					var topItem = 0
					for(var i=0; i<index; i++){
						var thisSize = $('li.menuLink').eq(i).outerHeight();
						topItem = topItem + thisSize;
					}
					$(this).find('.subMenuPage').css('top', -topItem-45);	
				}else{
				    $('.departmentMenu.active').css('borderBottomRightRadius', '5px ');
				    $(this).find('.subMenuPage').css('display','none');
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



var responsiveMenu = function(){
	var activeButton= $('#departmentsButton');
	var menuCont =$('#departmentsMenu');
	var ibmBtn = menuCont.find('span[role="presentation"]');
	activeButton.unbind('click');
	
	$('.categoryList').hide();
	
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
			$(this).find('div').height('auto').css('top','0px');
			
			
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
				}
			}
			$(this).parent('#departmentsMenu').prepend(returnBtn);
		});
		
		$(document).on('click', returnBtn, function(){
			var childLevel = $(this).parents('ul').length;
			console.log(childLevel)
			
			var elemFirst = menuCont.find('>li');
			console.log(elemFirst.length);
			
			elemFirst.each(function(){
				$(this).show();
				$(this).find('ul').hide();
			})
			
			returnBtn.remove();
		})

	}else{
		menuCont.show();
		var elemFirst = menuCont.find('>li');
		var allElems = elemFirst.find('li');
		var listMen = menuCont.find('ul').show();
		elemFirst.each(function(){
			$(this).css('display','inline-block');
		})
		
		$('.departmentMenu').css('top', '100%');
		allElems.each(function(){
			$(this).show();
		})
		menuCont.find('li').unbind('click');
		$('.menuReturn').remove();
		
	}
	

}

