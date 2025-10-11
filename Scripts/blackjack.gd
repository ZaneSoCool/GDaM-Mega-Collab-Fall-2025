extends Control

#Made by Elisa, Garner, and Zane

#external variables
@export var minimumBet = 5
@export var AI_hit_stop = 17
@export var AI_randomness = 1 #number of hit range where it may randomly hit

#internal variables
var playerHand = 0
var dealerHand = 0
var playerCards = []
var dealerCards = []

var deck : Array[Array] = []
var playing : bool = true
var currentBet : int

#references
@onready var player_cards_visualized: HBoxContainer = $PlayerCardsVisualized
@onready var dealer_cards_visualized: HBoxContainer = $DealerCardsVisualized
@onready var play_buttons: HBoxContainer = $playButtons
@onready var bet_buttons: HBoxContainer = $betButtons
@onready var line_edit: LineEdit = $betButtons/LineEdit
@onready var current_bet_label: Label = $VBoxContainer/CurrentBet
@onready var minimum_bet_label: Label = $VBoxContainer/MinimumBet
@onready var vitality_label: Label = $VBoxContainer/Vitality

var cardScene = preload("res://Scenes/Card.tscn")

#--------------Edge Cases---------------#

#setup
func _ready() -> void:
	#init scene
	currentBet = minimumBet
	current_bet_label.text = "Current Bet: " + str(currentBet)
	line_edit.text = str(currentBet)
	minimum_bet_label.text = "Minimum Bet: " + str(minimumBet)
	vitality_label.text = "Vitality: " + str(Global.vitality)
	
	play_buttons.visible = false
	
	#init deck
	for i in 4:
		for j in 13:
			deck.append([j + 1, i + 1])
	deck.shuffle()
	
func startGame():
	#deal cards
	dealCard(true, true)
	dealCard(true, true)
	dealCard(false, true)
	dealCard(false, false)
	
	play_buttons.visible = true
	
func endGame():
	playing = false
	play_buttons.visible = false
	
	if playerHand > dealerHand and playerHand <= 21:
		Global.vitality += currentBet
		print("PlayerWins")
	else:
		Global.vitality -= currentBet
		print("PlayerLost")
	
#------------Game/Round Logic------------#

func dealerTurn():
	play_buttons.visible = false
	
	while playing:
		var randomness = randi_range(-AI_randomness, AI_randomness)
		if dealerHand < (AI_hit_stop + randomness):
			dealCard(false, true)
		else:
			endGame()

func dealCard(forPlayer : bool, faceUp : bool):
	var card = cardScene.instantiate()
	
	var card_info = deck[deck.size()-1]
	deck.remove_at(deck.size()-1)
	
	card.card_id = card_info[0]
	card.card_suite = card_info[1]
	card.faceUp = faceUp
	
	if forPlayer:
		playerCards.append(card)
		totalHand(forPlayer, card_info)
		player_cards_visualized.add_child(card)
	else:
		dealerCards.append(card)
		totalHand(forPlayer, card_info)
		dealer_cards_visualized.add_child(card)

#sums up hand for stuff
func totalHand(forPlayer : bool, card_info : Array):
	if forPlayer:
		if card_info[0] > 10:
			playerHand += 10
		elif card_info[0] == 1:
			if playerHand + 11 > 21:
				playerHand += 1
			else:
				playerHand += 11
		else:
			playerHand += card_info[0]
			
		if playerHand > 21:
			endGame()
	else:
		if card_info[0] > 10:
			dealerHand += 10
		elif card_info[0] == 1:
			if dealerHand + 11 > 21:
				dealerHand += 1
			else:
				dealerHand += 11
		else:
			dealerHand += card_info[0]
		
		if dealerHand >= 21:
			endGame()

#------------- Buttons Pressed -------------

#Hit
func _on_hit_pressed() -> void:
	dealCard(true, true)

#Stand
func _on_stand_pressed() -> void:
	dealerTurn()

#Double Down
func _on_double_down_pressed() -> void:
	if currentBet * 2 > Global.vitality:
		return
	else:
		currentBet *= 2
		dealCard(true, true)
		dealerTurn()

func _on_submit_pressed() -> void:
	var bet = int(line_edit.text)
	if bet < minimumBet or bet > Global.vitality:
		return
		
	currentBet = bet
	current_bet_label.text = "Current Bet: " + str(bet)
	bet_buttons.visible = false
	
	startGame()
