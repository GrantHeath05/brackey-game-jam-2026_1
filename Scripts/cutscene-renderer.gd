extends VideoStreamPlayer

func play_cutscene(filename: String) -> void:
    var path := "cutscenes/%s.ogv" % filename
    print_debug("Attempting to run " + path)

    
    var video = load(path)
    if video == null:
        push_warning("Cutscene not found: " + path)
        return
    # if video is found save and run it
    stream = video
    play()

    # Wait until the video finishes
    await finished