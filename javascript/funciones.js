
$( document ).ready(function() {

	
	$(".asistenciaTienda").hover(function(){
	    $(".asistenciaLista").toggle();
	});


});




function menuF(){
	
	if ($(window).width() > 952) {
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