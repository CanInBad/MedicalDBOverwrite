extends SceneBase

var lookedAtUnrelated:bool = false
var rangeStep:int = 0
const rangeAmount:int = 50

func _init():
    sceneID = "MedicalDatabaseOverride"

func _run():
    match state:
        "":
            var additionalTxt = ""
            if lookedAtUnrelated:
                additionalTxt = " She turns the screen back to her, punch some more buttons looking annoyed then turns the screen towards you"
            else:
                additionalTxt = " She quickly punches some buttons and turns the screen towards you."
            addCharacter("nurse")
            saynn("You ask the nurse to show you your database records." + additionalTxt)
            sayn("\tPage: {0}\tCurrently viewing kids for [color={1}]{2}[/color]".format([rangeStep+1,GM.pc.getChatColor(),GM.pc.getName()]))
            if(calculateAmount(true) < 1):
                sayn(" - Nothing found, get to breeding!")
            else:
                saynn("- Total records found "+str(calculateAmount(true))+":")
                printChildrenRange((rangeStep*rangeAmount), ((rangeStep+1)*rangeAmount) ,true)
            
            if rangeStep == 0:
                addDisabledButton("Back","Can't go back any further than this!")
            else:
                addButton("Back","Go back a page", "pcBackAPage")

            if ((rangeStep+1)*rangeAmount) > calculateAmount(true):
                addDisabledButton("Next","Can't go any further than this!")
            else:
                addButton("Next","Go to next page", "pcNextAPage")
            
            addDisabledButtonAt(5, "Your Children", "You are currently looking at your children")
            addButtonAt(6, "Unrelated Children", "Take a look at unrelated children", "unrelated")
            addButtonAt(14, "Exit", "Unfocus from the database records and talk to the nurse", "endScene")
        "unrelated":
            lookedAtUnrelated = true
            saynn("You ask the nurse to show you the unrelated database records. She turns the screen back to her, punch some more keys looking annoyed, and turns the screen toward you")
            sayn("\tPage: {0}\tCurrently viewing kids for unrelated personals".format([rangeStep+1]))
            if calculateAmount(false) == 0:
                sayn(" - Nothing found.")
            else:
                saynn("- Total records found "+str(calculateAmount(false))+":")
                printChildrenRange((rangeStep*rangeAmount), ((rangeStep+1)*rangeAmount), false)
            
            addDisabledButton("Back","Cannot use the page feature while looking at others")

            addDisabledButton("Next","Cannot use the page feature while looking at others")
            
            addButtonAt(5, "Your Children", "Take a look at your children", "")
            addDisabledButtonAt(6, "Unrelated Children", "You are currently looking at unrelated children")
            addButtonAt(14, "Exit", "Unfocus from the database records and talk to the nurse", "endScene")

func _react(_action: String, _args):
    if _action == "pcBackAPage":
        rangeStep -= 1
        setState("")
        return
    if _action == "pcNextAPage":
        rangeStep += 1
        setState("")
        return
    if _action == "endScene":
        endScene()
        runScene("NurseryTalkScene")
        return
    if _action == "" || _action == "unrelated":
        rangeStep = 0
    setState(_action)

func printChildrenRange(_start:int = 0, _stop:int = 49, pcKids:bool = true):
    if !pcKids && _stop != GM.CS.getChildren().size():
        printChildrenRange(0, GM.CS.getChildren().size(), pcKids)
        return

    var resultTable = "[table=8][cell]#[/cell][cell]Name[/cell][cell]Gender[/cell][cell]Species[/cell][cell]Age[/cell][cell]Mother[/cell][cell]Father[/cell][cell]Additional[/cell]"
    var childAll = GM.CS.getChildren()
    var rowCount = 1
    for i in range(_start,_stop):
        if i >= childAll.size():
            break
        var child = childAll[i]

        if(pcKids && child.fatherID != "pc" && child.motherID != "pc"):
            continue
        if(!pcKids && (child.fatherID == "pc" || child.motherID == "pc")):
            continue
            
        var birthDay = child.birthDay
        var daysPassed = GM.main.getDays() - birthDay
        var yearsOld:int = daysPassed / 365
        var daysOld:int = daysPassed - yearsOld * 365
        var ageStr = str(daysOld)+" days"
        if(daysOld == 1):
            ageStr = str(daysOld)+" day"
        
        if(yearsOld < 1):
            pass
        elif(yearsOld == 1):	
            ageStr = "1 year "+ageStr
        else:
            ageStr = str(yearsOld)+" years "+ageStr
        
        resultTable += "[cell]" + str(rowCount) + "[/cell]"

        resultTable += "[cell]"+child.name+"[/cell]"
        resultTable += "[cell]"+"[color="+NpcGender.getColorString(child.gender)+"]"+ NpcGender.getVisibleName(child.gender)+"[/color]"+"[/cell]"
        resultTable += "[cell]"+Util.getSpeciesName(child.species)+"[/cell]"
        resultTable += "[cell]"+ageStr+"[/cell]"
        resultTable += "[cell]"+child.getMotherName()+"[/cell]"
        resultTable += "[cell]"+child.getFatherName()+"[/cell]"
        resultTable += "[cell]"+child.getMonozygotic()+"[/cell]"
        rowCount += 1
    resultTable += "[/table]"
    sayn(resultTable)

func calculateAmount(pcKids = true):
    var amount = 0
    
    for ch in GM.CS.getChildren():
        var child: Child = ch
        if(pcKids && child.fatherID != "pc" && child.motherID != "pc"):
            continue
        if(!pcKids && (child.fatherID == "pc" || child.motherID == "pc")):
            continue
        amount += 1
    return amount