
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
	   		$('div.'+claseMenu).show(1);
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
