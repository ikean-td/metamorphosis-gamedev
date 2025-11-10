extends Node
var roomholder: Node2D
var undo: Array
var roomstates: Dictionary #contains all box positions for reloading

var move_time = 0.1 #how fast you move
var remission = 8 #how many turns until you switch back to man
