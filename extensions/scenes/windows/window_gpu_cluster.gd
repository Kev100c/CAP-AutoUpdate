extends "res://scenes/windows/window_gpu_cluster.gd"

const LOG_NAME := "CAP-AutoUpdate:window_gpu_cluster"

var _tick_counter_interval := 30
var _tick_counter := 0
var capAutoUpdate
var cb

func _process(delta: float) -> void:
    if upgrade_maxed: 
        cb.visible = !upgrade_maxed 
        return
    _tick_counter += 1
    if _tick_counter >= _tick_counter_interval:
        _tick_counter = 0
        if capAutoUpdate:
            _add_button()
            _upgrade()
            
func _upgrade() -> void:
    if can_upgrade():
        Globals.currencies["money"] -= upgrade_cost
        upgrade()
        Sound.play("upgrade")
        
func _add_button() -> void:
    if can_purchase():
        Globals.currencies["money"] -= add_cost
        add()
        Sound.play("upgrade")

func _ready() -> void:
    super()
    var container := get_node_or_null("PanelContainer/MainContainer")
    if container == null:
        ModLoaderLog.error("MainContainer nicht gefunden: PanelContainer/MainContainer", LOG_NAME)
        return

    if container.has_node("CAP_AutoUpdateCheck"):
        return

    cb = CheckButton.new()
    cb.name = "CAP_AutoUpdateCheck"
    cb.text = "Auto-Update"
    if capAutoUpdate != null:
        cb.button_pressed = capAutoUpdate
    cb.toggled.connect(_on_cap_auto_update_toggled)
    container.add_child(cb)
    cb.visible = !upgrade_maxed

    ModLoaderLog.info("CheckButton hinzugefügt (Extension _ready).", LOG_NAME)

func _on_cap_auto_update_toggled(on: bool) -> void:
    capAutoUpdate = on
    ModLoaderLog.info("Auto-Update: %s" % str(on), LOG_NAME)
    
func save() -> Dictionary:
    return super ().merged({
        "capAutoUpdate": capAutoUpdate
    })
