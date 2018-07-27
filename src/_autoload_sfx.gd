extends Node

func loadDir(var dirPath):
    var resources = Dictionary()
    var dir = Directory.new()
    dir.open(dirPath)
    dir.list_dir_begin()
    var file_name = dir.get_next()

    while(file_name!=""): 
        if dir.current_is_dir() or not file_name.ends_with('wav'):
            pass
        else:
            var path = dirPath + '/' + file_name
            var resource = load(path)
            if resource:
                resources[file_name] = resource
        file_name = dir.get_next()
    return resources
    
var tracks = []
var sounds = []
func _ready():
    tracks = loadDir("res://audio/music")
    sounds = loadDir("res://audio/sounds")
