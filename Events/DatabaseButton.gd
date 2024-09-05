extends EventBase

func _init():
	id = "MedDatabaseButtonOverwrite"

func registerTriggers(es):
	es.addTrigger(self, Trigger.SceneAndStateHook, ["NurseryTalkScene", ""])
	es.addTrigger(self, Trigger.SceneAndStateHook, ["NurseryTalkScene", "children"])

func run(_triggerID, _args):
    if _args == ["NurseryTalkScene", "children"]:
        GM.ui.clearButtons()
        GM.ui.queueUpdate()
        addButton("Database","Take a look at your children", "database")
    if getModuleFlag("MedicalModule", "Nursery_AskedDatabase", false) && _args == ["NurseryTalkScene", ""]:
        var _ok = GM.ui.options.erase(1)
        GM.ui.addButtonAt(1,"Database","Take a look at your children", "EVENTSYSTEM_BUTTON", [self, "database", []])

func onButton(_method, _args):
    if _method == "database":
        var medScene = GM.main.getCurrentScene()
        GM.main.runScene("MedicalDatabaseOverride")
        GM.main.removeScene(medScene)
