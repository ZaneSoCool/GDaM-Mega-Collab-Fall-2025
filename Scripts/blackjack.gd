extends Control

#Made by Elisa, Garner, Zane, and Christopher

#external variables
@export var dealer_max_vitality : int
@export var minimumBet = 5
@export var AI_hit_stop = 17
@export var AI_randomness = 1 #number of hit range where it may randomly hit
@export var next_scene : String

#internal variables
var playerHand = 0
var dealerHand = 0
var playerCards : Array[Card] = []
var dealerCards : Array[Card] = []
var passivePowerups = []

var deck : Array[Array] = []
var currentBet : int

var twentyOne := 21

#references
	#cards
@onready var player_cards_visualized: HBoxContainer = $PlayerHand/PlayerCardsVisualized
@onready var dealer_cards_visualized: HBoxContainer = $DealerHand/DealersCardsVisualized
@onready var player_hand_value: Label = $PlayerHand/PlayerHandValue
	#interface
@onready var play_buttons: HBoxContainer = $playButtons
@onready var bet_buttons: HBoxContainer = $betButtons
@onready var line_edit: LineEdit = $betButtons/LineEdit
	#data
@onready var current_bet_label: Label = $Data/CurrentBet
@onready var minimum_bet_label: Label = $Data/MinimumBet
@onready var twenty_one_label: Label = $Data/TwentyOne
	#vitality
@onready var player_vitality_bar: ProgressBar = $playerVitalityBar
@onready var dealer_vitality_bar: ProgressBar = $dealerVitalityBar
@onready var player_vitality_bar_label: Label = $playerVitalityBar/Label
@onready var dealer_vitality_bar_label: Label = $dealerVitalityBar/Label


	#powerups
@onready var power_ups: GridContainer = $LeftBar/PowerUps

@onready var winandlose: Label = $winandlose

var cardScene = preload("res://Scenes/Card.tscn")

#setup
func _ready() -> void:
	#-----------init scene-----------
	
	dealer_max_vitality = roundi(dealer_max_vitality * Global.dealer_health_scalar)
	
	#sets up dealer health
	if Global.current_dealer_vitality <= 0:
		Global.current_dealer_vitality = dealer_max_vitality
	
	#setup bet and bet text stuff
	minimum_bet_label.text = "Minimum Bet: " + str(minimumBet)
	currentBet = minimumBet
	current_bet_label.text = "Current Bet: " + str(currentBet)
	line_edit.text = str(currentBet)

	#setup player health bar
	player_vitality_bar.value = Global.vitality
	player_vitality_bar.max_value = Global.max_vitality
	player_vitality_bar_label.text = str(player_vitality_bar.value) + " / " + str(player_vitality_bar.max_value)
	
	#sets up the dealers max vitality if this is the first match against this dealer (this is the case if dealer vitality is <=0)
	if Global.current_dealer_vitality <= 0:
		Global.current_dealer_vitality = dealer_max_vitality
		
	#setup dealer health bar
	dealer_vitality_bar.max_value = dealer_max_vitality
	dealer_vitality_bar.value = Global.current_dealer_vitality
	dealer_vitality_bar_label.text = str(dealer_vitality_bar.value) + " / " + str(dealer_vitality_bar.max_value)
	
	#setup powerUps
	for powerUpKey in Global.powerUpQuantityDictionary:
		if Global.powerUpQuantityDictionary[powerUpKey] > 0:
			var powerUp = load(Global.powerUpRefDictionary[powerUpKey]).instantiate()
			power_ups.add_child(powerUp)
			
			if powerUp.isPassive == true:
				passivePowerups.append(powerUp)
				
	#make correct buttons visible
	play_buttons.visible = false
	
	#init deck
	for i in 4:
		for j in 13:
			deck.append([j + 1, i + 1])
	deck.shuffle()
	
## Deals cards at the start of a new round
func dealCards():
	#deal cards
	dealCard(true, true)
	dealCard(true, true)
	dealCard(false, true)
	dealCard(false, false)

	play_buttons.visible = true

## Endgame logic for a Blackjack round.
func endGame():
	play_buttons.visible = false
	
	if dealerHand > twentyOne or (playerHand > dealerHand and playerHand <= twentyOne):
		Global.current_dealer_vitality -= currentBet
		Global.vitality += currentBet
		
		if Global.vitality > Global.max_vitality: #update max vitality if vitality surpasses it
			Global.max_vitality = Global.vitality
	
		flipAllCards()
		if Global.current_dealer_vitality <= 0:
			dealerLose()

		else:
			transitionNextScene("Hand Won")
		
	else:
		Global.vitality -= currentBet
		flipAllCards()

		if Global.vitality <= 0:
			transitionNextScene("Game Over", "res://Scenes/Menu.tscn")
		else:
			transitionNextScene("Hand Lost")

## Updates dealer's health multiplier, and transitions to the next round
func dealerLose(): # Lowkey unneeded imho
	Global.current_dealer_vitality = 0 
	Global.dealer_health_scalar *= 1.5
	transitionNextScene("Round Won", next_scene)
	
## Shows inputted text onto screen, and transitions to the next scene, if inputted.
##
## [param nextScene] is a filepath, stored as a string. If no scene is inputted, the current scene will reload.
func transitionNextScene(roundText: String, nextScene = null):
	winandlose.text = roundText
	winandlose.visible = true
	await(get_tree().create_timer(2.0).timeout)
	if nextScene != null:
		SceneTransition.change_scene_to(nextScene)
	else:
		SceneTransition.reload_current_scene()
	
	
#------------Game/Round Logic------------#

func dealerTurn():
	play_buttons.visible = false
	
	var randomness = randi_range(-AI_randomness, AI_randomness)
	while dealerHand < (AI_hit_stop + randomness):
		dealCard(false, true)
		randomness = randi_range(-AI_randomness, AI_randomness)
	
	endGame()


## Deals a card.
##
## Set [param forPlayer] to [code]true[/code] if card is for the player, and [code]false[/code] if it's for the dealer
## [br] [param faceUp] dictates whether the given card's value can be seen by the player when dealt
func dealCard(forPlayer : bool, faceUp : bool):
	var card = cardScene.instantiate()
	
	var card_info = deck[deck.size()-1]
	deck.remove_at(deck.size()-1)
	
	card.card_id = card_info[0]
	card.card_suite = card_info[1]
	card.faceUp = faceUp
	card.forPlayer = forPlayer
	
	if forPlayer:
		playerCards.append(card)
		totalHand(forPlayer)
		player_cards_visualized.add_child(card)
	else:
		dealerCards.append(card)
		totalHand(forPlayer)
		dealer_cards_visualized.add_child(card)
		
	checkEndGame()
		
## Deals a sepcific card for the player/dealer, depending on [param forPlayer].
##
## If [param card_id] or [param card_suit] is 0, The dealt card will be random
##[br][br] Editor's note: This is like exactoly the same as [method dealSpecificCard]. 
## [br] [br] What the fuck.
func dealSpecificCard(forPlayer : bool, faceUp : bool, card_id : int, card_suit : int): 
	var card = cardScene.instantiate()
	
	var card_info : Array #finds suitable card
	for i in range(deck.size()):
		if card_info.is_empty():
			var deckCard = deck[i]
			if (card_id == 0 or deckCard[0] == card_id) and (card_suit == 0 or deckCard[1] == card_suit):
				card_info = deckCard.duplicate()
				deck.remove_at(i)
				
	if card_info.is_empty(): #deck has no matching cards
		print("AHH FUCK")
		return
	
	card.card_id = card_info[0]
	card.card_suite = card_info[1]
	card.faceUp = faceUp
	card.forPlayer = forPlayer
	
	if forPlayer:
		playerCards.append(card)
		totalHand(forPlayer)
		player_cards_visualized.add_child(card)
	else:
		dealerCards.append(card)
		totalHand(forPlayer)
		dealer_cards_visualized.add_child(card)
		
	checkEndGame()

## Sums up the total hand value for the player/dealer 
func totalHand(forPlayer : bool):
	if forPlayer:
		playerHand = sumCardHand(playerCards)
	else:
		dealerHand = sumCardHand(dealerCards)
			
	updateHandValue()

## [b][i][u]ACTUALLY[/u][/i][/b]
## sums up the the total hand value for the given player, and returns it.
## [param cards] contains the all of the player's dealt cards.
func sumCardHand(cards: Array[Card]):
	sortCards(cards)
	var handValue = 0
	for card in cards:
		if card.card_id > 10:
			handValue += 10
		elif card.card_id == 1:
			if handValue + 11 > twentyOne:
				handValue += 1
			else:
				handValue += 11
		else:
			handValue += card.card_id
	return handValue

#------------- Buttons Pressed -------------

## Hit button
func _on_hit_pressed() -> void:
	dealCard(true, true)

## Stand button
func _on_stand_pressed() -> void:
	dealerTurn()

## Double Down button (NOT POWERUP)
func _on_double_down_pressed() -> void:
	if currentBet * 2 > Global.vitality:
		return
	else:
		currentBet *= 2
		dealCard(true, true)
		dealerTurn()

func _on_submit_pressed() -> void:
	var bet = int(line_edit.text)
	if bet < minimumBet or bet > Global.vitality or bet > Global.current_dealer_vitality:
		return
		
	currentBet = bet
	current_bet_label.text = "Current Bet: " + str(bet)
	bet_buttons.visible = false
	
	dealCards()

#----------------Extra-Powerup-Logic--------------------

func removeCard(forPlayer : bool, cardIndex : int):
	if forPlayer:
		removeCardHelper(playerCards, playerHand, cardIndex)
		updateHandValue()
	else:
		removeCardHelper(dealerCards, dealerHand, cardIndex)

		
func removeCardHelper(cards: Array[Card], handValue: int, cardIndex: int):
	if cards.is_empty(): return
		
	var cardToRemove = cards[cardIndex]
	var cardValue = cardToRemove.card_id
	
	if cardValue >= 10:
		handValue -= 10
	elif cardValue == 1:
		if handValue - 11 <= 0: ##TODO this check is insufficient
			handValue -= 1
		else:
			handValue -= 11
	else:
		handValue -= cardValue
		
	#get rid of stuff
	cards.remove_at(cardIndex)
	cardToRemove.queue_free()

## Updates hand value for the player
func updateHandValue():
	player_hand_value.text = "Hand Value : " + str(playerHand)

func checkEndGame():
	for powerUp in passivePowerups:
		powerUp.checkUse()
				
	#endgame check
	if playerHand > twentyOne or dealerHand >= twentyOne:
		endGame()
		
## Gets the index for a given card
func getCardIndex(id : int, suite : int):
	for i in playerCards.size():
		var card = playerCards[i]
		if card.card_id == id and card.card_suite == suite:
			return i

## Flips all cards
func flipAllCards():
	var allCards = dealerCards+playerCards
	for card in allCards:
		card.setup_card_texture(card.card_id, card.card_suite)

## Sorts card for the given hand of dealt cards
func sortCards(hand : Array[Card]):
	hand.sort_custom(func(a, b): return a.card_id > b.card_id)
