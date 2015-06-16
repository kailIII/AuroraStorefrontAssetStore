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
	
	if ($(window).width() >= 952) {
	var claseMenu = "";
	console.log("mayor a 952");
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
		activeButton.click(function(e){
			e.stopPropagation()
			menuCont.animate({width: 'toggle'});
			/*if(menuCont.hasClass('open')== false){
			   menuCont.stop().animate({width: 'toggle'},1000,function(){$(this).addClass('open')});
			}else{
			menuCont.stop().animate({width: '0px'},1000,function(){
				$(this).removeClass('open')
			});
			}*/
		})
	}else{
		menuCont.css('display', 'block');
	}
	

}

