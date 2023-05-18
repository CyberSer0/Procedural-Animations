extends Node3D

@export var dt : float
@export var Kp : float
@export var Ki : float
@export var Kd : float

var integral : float = 0.0
var prev_err : float = 0.0
var max_integral : float = 200.0

var first_frame_flag : int = 1

func _ready():
	$Timer.set_wait_time(dt)

func _process(delta):
	print("dt: ", dt, " Kp: ", Kp, " Ki: ", Ki, " Kd: ", Kd, " last_err: ", prev_err, " last_int: ", integral)


func calculate(setpoint : float, pv : float):
	var err = setpoint - pv
	if first_frame_flag:
		prev_err = err
		first_frame_flag = 0
	var Pout = Kp * err
	
	integral += err * dt
	var Iout = Kd * integral
	
	var derivative = (err - prev_err) / dt
	var Dout = Kd * derivative
	
	var output = Pout + Iout + Dout
	if integral > max_integral:
		integral = max_integral
	elif integral < -max_integral:
		integral = -max_integral
	prev_err = err
	
	return output

func _on_start_timer():
	$Timer.start()

func _on_stop_timer():
	$Timer.stop()

func reset_integral():
	integral = 0.0

func get_timer():
	return $Timer
