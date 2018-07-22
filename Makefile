all: html5 itch
osx:
	godot project.godot --export "Mac OSX" artifacts/prototype.dmg
html5: 
	godot project.godot --export HTML5 artifacts/prototype/index.html
itch: 
	cd artifacts; butler push prototype murph-makes-games/waypoint2:html5	

