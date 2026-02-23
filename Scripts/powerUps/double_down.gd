extends PowerUp

#doubles round goal

func localUse():
	blackJackScene.twentyOne *= 2
	blackJackScene.AI_hit_stop = blackJackScene.twentyOne - ((blackJackScene.twentyOne/2) - blackJackScene.AI_hit_stop)

	blackJackScene.twenty_one_label.text = "Goal : " + str(blackJackScene.twentyOne)

func canUse():
	return true
