extends Node2D

func quest_finished(monster_type, amount):
	for children in self.get_children():
		if children.quest_monster_type == monster_type and children.amount == int(amount):
			children.can_finish_quest()
