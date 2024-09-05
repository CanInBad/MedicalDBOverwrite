extends Module

func _init():
    id = "MedicalDBOverwrite"
    author = "CanInBad"

    events = [
        "res://Modules/MedicalDBOverwrite/Events/DatabaseButton.gd",
        ]
    scenes = [
        "res://Modules/MedicalDBOverwrite/Scenes/Database.gd"
    ]