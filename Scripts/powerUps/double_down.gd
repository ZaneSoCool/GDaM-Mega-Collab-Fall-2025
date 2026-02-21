extends PowerUp

#makes round goal 42 instead of 21

func localUse():
	blackJackScene.twentyOne *= 2
	blackJackScene.AI_hit_stop = blackJackScene.twentyOne - ((blackJackScene.twentyOne/2) - blackJackScene.AI_hit_stop)

	blackJackScene.twenty_one_label.text = "Goal : " + str(blackJackScene.twentyOne)

func canUse():
	return true
