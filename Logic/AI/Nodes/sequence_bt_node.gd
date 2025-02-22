class_name SequenceBTNode
extends BTNode

func run() -> bool:
	for bn: BTNode in get_children():
		var result: bool = await bn.run()
		print("Result from ", bn.name, " is ", result)
		if result == false: 
			print("Sequence returns false, aborting")
			return false
	return true
	
