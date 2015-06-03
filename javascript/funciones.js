
$( document ).ready(function() {

	
	$(".asistenciaTienda").hover(function(){
	    $(".asistenciaLista").toggle();
	});



});




if ($(window).width() > 952) {
	var claseMenu = "";
console.log("mayor a 952");
	$(".menuLink").hover(
		function () {
			claseMenu = $(this).attr('rel');			
			$("."+claseMenu).html();
	   		$('div.'+claseMenu).slideDown(1);
		}, 
		function () {
			claseMenu = $(this).attr('rel');
		   $('div.'+claseMenu).slideUp(1);
		}
	);
	

}
else {
   console.log('Less than 960');   
}
