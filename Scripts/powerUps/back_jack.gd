extends PowerUp

#prevents player from losing when the dealer draws 21

func localUse():
	blackJackScene.dealerHand = 20

func checkUse():
	#check if dealer has 21
	if blackJackScene.dealerHand == 21:
		use()
