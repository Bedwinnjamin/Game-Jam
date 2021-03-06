extends Node2D

signal start_work
signal stop_work
signal selected

export (int) var crew_id

var speed = 1
var station = -1
var is_moving = false
var destX
var destY

#
func _go_to_station(station_position, station_id):
	emit_signal("stop_work", station, crew_id)
	station = station_id
	destX = station_position[0]
	destY = station_position[1]
	is_moving = true
	#print(station_position)

#
func _physics_process(_delta):
	if (is_moving):
		if (self.position[1] != destY):
			if self.position[0] != 0:
				if (self.position[0] > 0):
					$Walk.flip_h = true
				else:
					$Walk.flip_h = false
				$Stand.hide()
				$Walk.show()
				$Climb.hide()
				_move_toward_ladder()
			else:
				$Stand.hide()
				$Walk.hide()
				$Climb.show()
				_move_toward_floor()
		elif (self.position[0] != destX):
			if (destX < 0):
				$Walk.flip_h = true
				$Stand.flip_h = true
			else:
				$Walk.flip_h = false
				$Stand.flip_h = false
			$Stand.hide()
			$Walk.show()
			$Climb.hide()
			_move_toward_dest()
		else:
			is_moving = false
			$Stand.show()
			$Walk.hide()
			$Climb.hide()
			emit_signal("start_work", station, crew_id)

#
func _move_toward_ladder():
	if self.position[0] > speed:
		self.position[0] -= speed
	elif self.position[0] < -speed:
		self.position[0] += speed
	else:
		self.position[0] = 0

#
func _move_toward_floor():
	if self.position[1] > destY + speed:
		self.position[1] -= speed
	elif self.position[1] < destY - speed:
		self.position[1] += speed
	else:
		self.position[1] = destY

#
func _move_toward_dest():
	if self.position[0] > destX + speed:
		self.position[0] -= speed
	elif self.position[0] < destX - speed:
		self.position[0] += speed
	else:
		self.position[0] = destX

# Check to see if the crew is LEFT CLICKED
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("selected", self)
