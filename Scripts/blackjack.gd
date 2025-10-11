extends Node2D

#Made by Elisa

var TotalMoney = 50		#How much total money should the player start with?
var MinimumBet = 5
var CurrentBet = 5
var Vitality = 100 		#the health system ??


#variables that reset every round
var playerHand = 0
var dealerHand = 0
var playerCards = []
var dealerCards = []

var cardsShuffled = {}		#forgot the exact implementation of this T_T queue??


#------------- Game Logic ------------- 
#--- initializing round ---
#Hand higher than the dealers but doesn't total to higher than 21
#place a bet
#one card given to player and dealer face up
#another card given to player, another card given to dealer face down


#--- ONE ROUND LOGIC ---
#IF cards = 21 --> win 1.5x the bet
#ELSE IF cards < 21			#while loop here?
	#IF hit --> give card		#can hit multiple times??
	#IF stand --> exit the loop and continue game 
		#IF dealer cards > 17 --> stay
		#ELSE if cards < 17 ---> +1 card to dealer
			#IF dealer bust --> player wins double bet
			#ELSE
				#IF player hand > dealer hand win double bet
				#ElSE player lose bet	
#ELSE card > 21
	#bust 
	
#--- loop ---
#CONTINUE UNTIL player no money = lose OR dealer no money = win

#------------- Buttons Pressed -------------

#Hit
func _on_hit_pressed() -> void:
	#gives the player another card
	pass # Replace with function body.

#Stand
func _on_stand_pressed() -> void:
	#no more cards wanted; allows game logic to continue
	pass # Replace with function body.

#Double Down
func _on_double_down_pressed() -> void:
	#double initial bet
	if (CurrentBet * 2 < TotalMoney):
		CurrentBet = CurrentBet * 2
	else:
		CurrentBet = TotalMoney
