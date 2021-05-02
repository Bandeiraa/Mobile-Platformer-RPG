extends Node2D

func quest_finished(monster_type):
	for children in self.get_children():
		if children.quest_monster_type == monster_type:
			children.can_finish_quest()
