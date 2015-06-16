/*Script telmexianos*/

function checkWidth(){
	var windowSize = $(window).width();
	return  windowSize;
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




function menuF(){
	
	if ($(window).width() > 952) {
	var claseMenu = "";
	//console.log("mayor a 952");
		$(".menuLink").hover(
			function () {
				
				claseMenu = $(this).attr('rel');			
				$(this).find('div').show();
			}, 
			function () {
				claseMenu = $(this).attr('rel');
			   $('div.'+claseMenu).hide(1);
			}
		);
	}
	else {

	   console.log('Less than 960');
	}
}

menuF();

var responsiveMenu = function(){
	var activeButton= $('#departmentsButton');
	var menuCont =$('#departmentsMenu');
	activeButton.unbind('click');
	
	if(checkWidth() < 953){
		menuCont.css('display', 'none');
		activeButton.removeClass('selected');
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
		
		var returnBtn = $('<div><a class="menuReturn"></a></div>')
		elemClick.click(function(e){
			e.preventDefault();
			e.stopPropagation();
			var siblingsElem = $(this).parent('ul').find('>li');
			var ulParent = $(this).find('ul')
			var childUl = $(this).find('ul').eq(0);
			var textParent=$(this).find('.menuLink').eq(0).text();
			
			
			if(ulParent.length > 1){
				siblingsElem.not(this).hide();
				childUl.show();
				childUl.find('li').show();
				childUl.find('ul').hide();
				returnBtn.text('Regresar a Menu principal' );
			}else{
				siblingsElem.not(this).each(function(){
					$(this).find('ul').slideUp();
				})
				childUl.slideToggle();
			}
			$(this).parent('#departmentsMenu').prepend(returnBtn);
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
			
			//elemClick.eq(childLevel-1).show()
		})
		
		
		
	}else{
		menuCont.css('display', 'block');
	}
	

}

