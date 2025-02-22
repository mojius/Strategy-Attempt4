class_name SelectorBTNode
extends BTNode

func run() -> bool:
	for bn: BTNode in get_children():
		var result: bool = await bn.run()
		print("Result from ", bn.name, " is ", result)
		if result == true: 
			print("Selector returns true, aborting")
			return true
	return false
	
