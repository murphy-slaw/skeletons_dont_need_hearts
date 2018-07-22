all: build itch
build: html5 osx windows
osx:
	godot project.godot --export "Mac OSX" artifacts/prototype.dmg
html5: 
	mkdir artifacts/prototype
	godot project.godot --export HTML5 artifacts/prototype/index.html
windows:
	godot project.godot --export "Windows Desktop" artifacts/prototype.exe

itch: 
	cd artifacts; butler push prototype murph-makes-games/waypoint2:html5
clean:
	find artifacts -type f -exec rm {} \;
