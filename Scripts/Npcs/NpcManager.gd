extends Node2D

func quest_finished(monster_type, amount):
	for npc in self.get_children():
		if npc.quest_info[0] == monster_type and npc.quest_info[1] == int(amount):
			npc.can_finish_quest()
