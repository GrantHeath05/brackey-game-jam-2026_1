extends Control

func update_game_tracker_label():
	var completed_count = 0

	if GameManager.tictactoe_complete:
		completed_count +=1
	if GameManager.RPS_complete:
		completed_count +=1
	if GameManager.guess_cup_complete:
		completed_count +=1
		
	$Label.text = "%d/3" % completed_count
	if completed_count >= 3:
		GameManager.all_games_completed = true
