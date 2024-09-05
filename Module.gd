extends Module

func _init():
    id = "MedDatabase"
    author = "CanInBad"

    events = [
        "res://Modules/MedicalDatabaseOverwrite/Events/DatabaseButton.gd",
        ]
    scenes = [
        "res://Modules/MedicalDatabaseOverwrite/Scenes/Database.gd"
    ]