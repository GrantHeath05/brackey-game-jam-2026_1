extends Control
# Functions play fade animation then signal the main script when finished
func fade_in() -> Signal:
	$Fade_to_Black.play("fade_in")
	return $Fade_to_Black.animation_finished

func fade_out() -> Signal:
	$Fade_to_Black.play("fade_out")
	return $Fade_to_Black.animation_finished
