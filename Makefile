html5: 
	godot project.godot --export HTML5 artifacts/prototype/index.html
itch: html5
	butler push artifacts/prototype/ murph-makes-games/waypoint2:html5	

