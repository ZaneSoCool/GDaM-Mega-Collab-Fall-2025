extends PowerUp

#If dealer draws 21, it is treated as 20.

func localUse():
	blackJackScene.dealerHand = 20

func checkUse():
	#check if dealer has 21
	if blackJackScene.dealerHand == 21:
		use()
