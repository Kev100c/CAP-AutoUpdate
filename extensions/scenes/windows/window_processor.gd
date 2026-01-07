extends "res://scenes/windows/window_processor.gd"


const LOG_NAME := "CAP-AutoUpdate:window_processor"

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
            _on_upgrade_button_pressed()
            _on_add_button_pressed()

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
