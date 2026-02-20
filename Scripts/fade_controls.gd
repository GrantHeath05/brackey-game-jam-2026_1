extends Control


# Functions play fade animation then signal the main script when finished
func fade_in() -> Signal:
	self.visible = true
	# print_debug("Fade is visible and playing now")
	$FadeTimer.start()
	$Fade_to_Black.play("fade_in")
	return $Fade_to_Black.animation_finished

func fade_out() -> Signal:
	self.visible = true
	$FadeTimer.start()
	# print_debug("unfading screen now")
	$Fade_to_Black.play("fade_out")
	return $Fade_to_Black.animation_finished
