/*Script telmexianos /Pixseles*/


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
		hoverMainMenu();
})


$( document ).ready(function() {

	$(".asistenciaTienda").hover(function(){
	    $(".asistenciaLista").toggle();
	});

	responsiveMenu();
	menuF()
	hoverMainMenu();
});



/*Función hover lista categorias escritorio*/
function menuF(){
	
	var menuCont =$('#departmentsMenu');
	var menuCategorias = $('.menuCategorias');
	
	if (checkWidth() > 952) {
	var claseMenu = "";
	var hasSize = false;
	
	
	/*Grow the menu respect at list of categories*/
	if(hasSize == false){
		menuCategorias.mousedown(function(){
			setTimeout(function(){
				var categoryMenu =$('.categoryList').find('>li');
				categoryMenu.each(function(){
					 var scope = $(this);
					 var totalHeight;
					
					 if(scope.find('img').length > 0){
						 if($('.telmexMenuImage').height()> scope.find('.subMenuPage').outerHeight()){
							 totalHeight = $('.telmexMenuImage').height();
						 }else{
							 totalHeight = scope.find('.subMenuPage').outerHeight();
						 }
					 }else{
						 totalHeight = scope.find('.subMenuPage').outerHeight()
					 }
					 
					 if(totalHeight < $('.categoryList').outerHeight()){
						 scope.find('.subMenuPage').outerHeight($('.categoryList').outerHeight()+ 5);
					 }else{
						 scope.find('.subMenuPage').height('auto');
					 }
					 
					 if(scope.find('img').length > 0){
						  	scope.find('ul.subcategoryList').width('550px');
						  	scope.find('.telmexMenuImage').css('display','inline-block');
					 }
				})
				hasSize = true;
			}, 500);
		});
	}
	
	/*Categorias Hover*/ 
		$("li.menuLink").hover(
			function () {
				var scope = $(this);
				if($(this).find('li').length > 0){
					claseMenu = $(this).attr('rel');
					//Show childs
					$(this).find('div.subMenuPage').show();
					
					//Set border radius;
					$('.departmentMenu.active').css('borderBottomRightRadius', '0px ');
				
					 var index = $( "li.menuLink" ).index( this );
					
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
		
		$('.subMenuPage').each(function(){
			$(this).height('auto');
		});
		
		$('.menuCategorias').unbind('mousedown');

	}
}


var hoverMainMenu = function(){
	var menuCont =$('#departmentsMenu');
	var elemFirst = menuCont.find('>li');
	
	
		elemFirst.each(function(){
			var scope = $(this);
			var images = scope.find('.spotVida');
			var time;
			
			if (checkWidth() > 952) {
				
			scope.mouseenter(function(){
				clearTimeout(time);
				if(images.length > 0){
						scope.css('box-shadow', 'inset 0px -4px 0px 0px #1b83ff');
						scope.unbind('click');
						images.show();
						$('.departmentMenu').removeClass('active');
						$('.departmentButton').removeClass('selected');
						
				}
			}).mouseleave(function(){
				time= setTimeout(function(){
					if(images.length > 0){
						images.hide();
						scope.css('box-shadow', 'none');
					}
				},300);
			});
			
			}else{
				images.show();			
			}
		});
		
		if(checkWidth() < 953){
			elemFirst.unbind('mouseenter mouseleave');
			elemFirst.bind('click');
		} 
}

var responsiveMenu = function(){
	var thFunction = $(this);
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
		returnBtn.text('Regresar a Menu principal' );
		$('.contentEstilos').hide();
		
		//Click function
		elemClick.click(function(e){	
			e.stopPropagation();
			
			var clickScope = $(this);
			var siblingsElem = $(this).parent('ul').find('>li');
			var ulParent = $(this).find('ul')
			var childUl = $(this).find('ul').eq(0);
			var textParent=$(this).find('.menuLink').eq(0).text();
			var divParent = childUl.closest('div');
			var imageDisplay = clickScope.find('.spotVida');
	
			if(divParent.css('display')== "none"){
				divParent.show();
			}
			$(this).find('div').not('.estiloVida').height('auto').css('top','0px');
		
			if(ulParent.length > 1 && imageDisplay.length == 0){
				e.preventDefault();
				siblingsElem.not(this).hide();
				childUl.show();
				childUl.find('li').show();
				childUl.find('ul').hide();
				$(this).parent('#departmentsMenu').prepend(returnBtn);
			}else{
				if(ulParent.find('li').length > 0 && imageDisplay.length == 0){
					siblingsElem.not(this).each(function(){
						$(this).find('ul').slideUp();
					})
					childUl.slideToggle();
					e.preventDefault();
				}else if(imageDisplay.length > 0){
					siblingsElem.not(clickScope).each(function(){
					    $(this).find('.contentEstilos').slideUp();
					})
					imageDisplay.find('.contentEstilos').slideToggle();
					//e.preventDefault();
				}
			}
			
		});
		
		/*Click para cerrar menú*/
		menuCont.on('click', '.menuReturn', function(e){
			e.stopPropagation();
			var childLevel = $(this).parents('ul').length;
			var elemFirst = menuCont.find('>li');
			elemFirst.each(function(){
				$(this).show();
				$(this).find('ul').hide();
			})
			
			$('.contentEstilos').hide();
			returnBtn.remove();
		})

	}else{
		menuCont.show();
		$('.contentEstilos').show();
		var elemFirst = menuCont.find('>li');
		var allElems = elemFirst.find('li');
		var listMen = menuCont.find('ul').show();
		
			
		elemFirst.each(function(index){
			var eachScope = $(this);
			var imgContainer = $(this).find('.spotVida');
			var imageCont = $(this).find('.estiloVida');
			
			eachScope.css('display','inline-block');
			
			if(eachScope.find('.spotVida').length > 0){
				var imageNumber = imageCont.find('>img').length;
				var imageSize = imageCont.outerWidth();
				var newSize = (imageSize+5)*imageNumber;
				
				imgContainer.outerWidth(newSize);
				
				var centerSpace = -newSize/2 + (eachScope.outerWidth()/2)
				var menuContmiddle = menuCont.width()/2
				
				if(menuContmiddle > eachScope.position().left + eachScope.outerWidth()){
					if(centerSpace < -eachScope.position().left + eachScope.outerWidth()){
						imgContainer.css('left', centerSpace + ((newSize/2)-eachScope.position().left)-(eachScope.outerWidth()/2));
					}else{
						imgContainer.css('left', centerSpace);
					}
				}else{
					if(-centerSpace > menuCont.width()-eachScope.position().left){
						imgContainer.css('left', centerSpace - ((newSize/2)-(menuCont.width()-eachScope.position().left))-(eachScope.outerWidth()/2));
					}else{
						imgContainer.css('left', centerSpace);
					}
				}
			}
		})
		
		
		$('.departmentMenu').each(function(){
			var thisDiv = $(this);
			if(thisDiv.hasClass('spotVida')== false){																																																																		
				thisDiv.css('top', '100%');
			}else{
				thisDiv.css('top', '110%');
			}
		})
		allElems.each(function(){
			$(this).show();
		})

		menuCont.find('li').unbind('click');
		
		menuCont.off('click', '.menuReturn');

		$('.menuReturn').remove();
	}
	

}

