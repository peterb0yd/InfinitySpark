<html>
<style>

	#post3-animation-container {
		position:relative;
		width:100%;
		height:400px;
		border-radius:20px;
		border:2px solid rgba(0,0,0,0.8);
	}
	#receiver-arrow, #hitter-arrow {
		display:none;
		position:absolute;
		height:50px;
		/*** origin ***/
		-ms-transform-origin: 100% 0; /* IE 9 */
		-webkit-transform-origin: 100% 0; /* Chrome, Safari, Opera */
		transform-origin: 100% 0;
	}
	#buttons {
		display:table;
		margin:0 auto;
	}
	#buttons li {
		border-radius:5px;
		border:2px solid rgba(0,0,0,0.8);
		display:table-cell;
		width:14%;
		padding:20px 0 20px 0;
		vertical-align: middle;
		text-align:center;
	}
	#buttons li:hover {
		cursor: pointer;
		color:white;
		background:rgba(0,0,0,0.8);
	}
	.start-transition {
		-webkit-transition: all 1s ease-in;
		-moz-transition: all 1s ease-in;
		-o-transition: all 1s ease-in;
		-ms-transition: all 1s ease-in;
	}
	.end-transition {
		-webkit-transition: all 0.5s ease-out;
		-moz-transition: all 0.5s ease-out;
		-o-transition: all 0.5s ease-out;
		-ms-transition: all 0.5s ease-out;
	}
	#play-button, #reset-button {
		margin:10px;
	}


</style>


</html>

<?php  ?>	

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"> </script>
<script type="text/javascript" src="http://jqueryrotate.googlecode.com/svn/trunk/jQueryRotate.js"> </script>
<script> 

$( window ).load(function() {
	var receiver = "#receiver-arrow";
	var hitter = "#hitter-arrow";
	var reset = true;

	function initial_positions() {
		// Set positions
		$(receiver).css("width", "15%");
		$(receiver).css("left", "0%");
		$(receiver).css("top", map( $(receiver).width(), 40, 160, 140, 100));
		$(hitter).css("width", "15%");
		$(hitter).css("left", "80%");
		$(hitter).css("top", "70%");

		// Set rotations
		$(receiver).rotate(60);
		$(hitter).rotate(-178);
	}

	// Set start positions
	initial_positions();
	$(receiver).show();
	$(hitter).show();

	// Play animation
	$("#play-button").click(function() {
		if (reset) {
			// Add transition effects 
			$(receiver).addClass("start-transition");
			$(hitter).addClass("start-transition");

			// Apply receiver logic
			$(receiver).rotate(map( $(receiver).width(), 40, 160, 40, 20 ));
			$(receiver).css("left", "14%");
			$(receiver).css("top", "45%");
			$(receiver).css("width", "20%");

			// Apply hitter logic
			$(hitter).rotate(map( $(hitter).width(), 40, 160, -140, -170 ));
			$(hitter).css("left", "20%");
			$(hitter).css("top", "48%");
			$(hitter).css("width", "35%");

			/*** After collision ***/
			setTimeout( function() {
				// Remove transition effects
				$(receiver).removeClass("start-transition");
				$(hitter).removeClass("start-transition");

	            // Add new transition effects
	    		$(receiver).addClass("end-transition");
	    		$(hitter).addClass("end-transition");

	            // Apply receiver logic
	            $(receiver).rotate(160);
	            $(receiver).css("width", "15%");
	            $(receiver).css("left", "15%");
	            $(receiver).css("top", "50%");

	            // Apply hitter logic
	            $(hitter).rotate(map( $(hitter).width(), 80, 350, -120, -140 ));
	            $(hitter).css("width", "20%");
	            $(hitter).css("left", "15%");
	            $(hitter).css("top", "40%");
	       }, 1000);
			reset = false;
		}
	});

	// Reset animation
	$("#reset-button").click(function() {
		reset = true;

		// Remove transition effects
		$(receiver).removeClass("start-transition");
		$(hitter).removeClass("start-transition");
		$(receiver).removeClass("end-transition");
		$(hitter).removeClass("end-transition");

		// Reset positions
		initial_positions();
	});


	/************** ARROW RESIZE *********************/
	// Set HTML to nothing
	// Resize on start-up
	$("#post3-animation-container img").each(function() { 
		var height = $(this).width() * 0.5;
		$(this).css("height", height);
	});

	// Resize on window resize
	$(window).resize(function() {
		$("#post3-animation-container img").each(function() { 
			var height = $(this).width() * 0.5;
			$(this).css("height", height);
		});
	});

	function map(x, in_min, in_max, out_min, out_max) {
	  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
	}

});

</script>

