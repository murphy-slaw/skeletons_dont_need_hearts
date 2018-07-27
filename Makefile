all: build itch
build: html5 osx windows
osx:
	godot project.godot --path src/ --export "Mac OSX" ../artifacts/prototype.dmg
html5: 
	godot project.godot --path src/ --export "HTML5" ../artifacts/prototype/index.html
windows:
	godot project.godot --path src/ --export "Windows Desktop" ../artifacts/prototype.dmg

itch: itch-osx itch-html5 itch-windows
itch-osx: 
	cd artifacts; butler push prototype.dmg murphy-slaw/skeletons-dont-need-hearts-or-do-they:osx
itch-html5: 
	cd artifacts; butler push prototype murphy-slaw/skeletons-dont-need-hearts-or-do-they:html5
itch-windows: 
	cd artifacts; butler push prototype.exe murphy-slaw/skeletons-dont-need-hearts-or-do-they:win
clean:
	find artifacts -type f -exec rm {} \;
