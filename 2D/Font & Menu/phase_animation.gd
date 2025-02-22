class_name PhaseAnimation
extends Node2D

@export var pictures: Array[Texture2D]

# Its 12 AM and im too lazy to code this better
func play(index: int = 0) -> void:
    $Sprite.texture = pictures[index]
    $Sprite/AnimationPlayer.play("woosh")
    await $Sprite/AnimationPlayer.animation_finished
