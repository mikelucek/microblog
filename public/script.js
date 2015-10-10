
$(document).ready(function(){
console.log("here I am...")


});

function loggedIn(){
		$("#logged-in").fadeIn();
		$("#logged-out").fadeOut();
	}

function loggedOut(){
		$("#logged-in").fadeOut();
		$("#logged-out").fadeIn();
	}