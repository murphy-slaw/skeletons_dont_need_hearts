all: build itch
build: html5 osx windows
osx:
	godot project.godot --path src/ --export "Mac OSX" ../artifacts/skeletons.dmg
html5: 
	mkdir -p artifacts/html5
	godot project.godot --path src/ --export "HTML5" ../artifacts/html5/index.html
windows:
	mkdir -p artifacts/windows
	godot project.godot --path src/ --export-debug "Windows Desktop" ../artifacts/windows/skeletons.exe

itch: itch-osx itch-html5 itch-windows
itch-osx: 
	cd artifacts; butler push skeletons.dmg murphy-slaw/skeletons-dont-need-hearts-or-do-they:osx
itch-html5: 
	cd artifacts; butler push  html5 murphy-slaw/skeletons-dont-need-hearts-or-do-they:html5
itch-windows: 
	cd artifacts; butler push windows murphy-slaw/skeletons-dont-need-hearts-or-do-they:win
clean:
	find artifacts -type f -exec rm {} \;
