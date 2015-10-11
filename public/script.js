
$(document).ready(function(){
console.log("here I am...")
$("#post").keyup(function(){
	var v = 150 - $("#post").val().length;
	$("#char").text(v + " chars left")

});

});

function loggedIn(){
		$("#logged-in").fadeIn();
		$("#logged-out").fadeOut();
	}

function loggedOut(){
		$("#logged-in").fadeOut();
		$("#logged-out").fadeIn();
	}