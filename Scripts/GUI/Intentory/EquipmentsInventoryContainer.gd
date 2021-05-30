extends CenterContainer

onready var equipments_slot_manager = get_node("EquipmentsInventoryTexture/EquipmentSlotContainer")
onready var status_container = get_node("EquipmentsInventoryTexture/StatusContainer")

func _ready():
	equipments_slot_manager.connect("item_equipped", status_container, "update_status")
	
