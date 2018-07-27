all: build itch
build: html5 osx windows
osx:
	sh -c 'pushd src; godot project.godot --export "Mac OSX" ../artifacts/prototype.dmg; popd'
html5: 
	mkdir -p artifacts/prototype
	sh -c 'pushd src; godot project.godot --export HTML5 ../artifacts/prototype/index.html; popd'
windows:
	sh -c 'pushd src; godot project.godot --export "Windows Desktop" ../artifacts/prototype.exe; popd'

itch: itch-osx itch-html5 itch-windows
itch-osx: 
	cd artifacts; butler push prototype.dmg murphy-slaw/skeletons-dont-need-hearts-or-do-they:osx
itch-html5: 
	cd artifacts; butler push prototype murphy-slaw/skeletons-dont-need-hearts-or-do-they:html5
itch-windows: 
	cd artifacts; butler push prototype.exe murphy-slaw/skeletons-dont-need-hearts-or-do-they:win
clean:
	find artifacts -type f -exec rm {} \;
