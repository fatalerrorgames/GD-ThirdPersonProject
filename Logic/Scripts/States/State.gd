#Base script for all other states
extends Node
class_name State

signal Transitioned #call this to leave the state

#on transition to this state
func Enter():
	pass

#when leaving this state
func Exit():
	pass

#update every frame
func Update(_delta: float):
	pass

#update every physics tick
func Physics_Update(_delta: float):
	pass
