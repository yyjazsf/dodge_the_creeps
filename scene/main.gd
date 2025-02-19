extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Hud.show_game_over()
	
func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$music.play()
	$StartTimer.start()
	$Hud.update_score(score)
	$Hud.show_message("Get Ready")


func _on_score_timer_timeout() -> void:
	score+=1
	$Hud.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	


func _on_mob_timer_timeout() -> void:
#	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
#	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
#	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Add some randomness to the direction.
	mob.rotation = direction + randf_range(-PI / 4, PI / 4)
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
