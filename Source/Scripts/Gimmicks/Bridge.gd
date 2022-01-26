extends Node2D

@export var length = 12;
@export var smoothDrop = true; #Turn to false to match sonic 1 bridges
@export var texture: Texture;
var dropIndex = 1;
var maxDepression = 0;

var player = [];
var bridges = [];

func _ready():
	# texture overwrite
	if (texture != null):
		$log.texture = texture;
	$log.rotation -= rotation;
	
	# Set mask positions
	$Bridge/mask.position += Vector2.RIGHT*length*8;
	$Bridge/mask.scale.x = (length);
	$PlayerCheck/mask.position += Vector2.RIGHT*length*8;
	$PlayerCheck/mask.scale.x = (length);
	
	# duplicate log sprites until it matches the length
	for i in range(length-1):
		var newLog = $log.duplicate();
		add_child(newLog);
		bridges.append(newLog)
		$log.position.x += 16;
	bridges.append($log);

func _physics_process(delta):
	if (player.size() > 0):
		$Bridge.position.y = max(floor(length/2)*2-snapped(abs(global_position.x+(length*8)-player[0].position.x)/8,2-int(smoothDrop)),0);
		dropIndex = max(1,floor((player[0].global_position.x-global_position.x)/16)+1);
		if (dropIndex <= length/2):
			maxDepression = dropIndex*2; #Working from the left
		else:
			maxDepression = ((length-dropIndex)+1)*2; #Working from the right
	else:
		# Reset if no player found
		$Bridge.position.y = 0;
		dropIndex = 1;
		maxDepression = 0;
	
	$PlayerCheck/mask.scale.y = (maxDepression/8)+1;
		
	# Loop through all segments to find their y position
	for i in range(bridges.size()):
		# Get difference in position of this log to current log
		var difference = abs((i+1)-dropIndex);
		
		# Get distance from current log to the closest side
		var logDistance = 0;
		if (i < dropIndex):
			logDistance = 1-(difference/dropIndex) # Working from the left
		else:
			logDistance = 1-(difference/((length-dropIndex)+1)) # Working from the right
		
		bridges[i].position.y = floor(maxDepression * sin(90 * deg2rad(logDistance)));
		


func _on_PlayerCheck_body_entered(body):
	player.append(body);


func _on_PlayerCheck_body_exited(body):
	if (player.has(body)):
		player.erase(body);