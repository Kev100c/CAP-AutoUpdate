extends "res://scenes/windows/window_heat_sink.gd"

const LOG_NAME := "CAP-AutoUpdate:heat_sink"

var _tick_counter_interval := 30
var _tick_counter := 0
var capAutoUpdate
var cb
var newContainer

func _process(delta: float) -> void:
    if maxed:
        if newContainer != null && newContainer.visible == true:
            newContainer.visible = false
        return
    _tick_counter += 1
    if _tick_counter >= _tick_counter_interval:
        _tick_counter = 0
        if capAutoUpdate:
            _upgrade()
            
func _upgrade() -> void:
    if can_upgrade():
        Globals.currencies["money"] -= cost
        upgrade(1)
        Sound.play("upgrade")

func _ready() -> void:
    super()
    var container := get_node_or_null("PanelContainer")
    if container == null:
        ModLoaderLog.error("MainContainer nicht gefunden: PanelContainer", LOG_NAME)
        return

    if container.has_node("CAP_AutoUpdateCheck"):
        return
    
    newContainer = container.duplicate()
    
    newContainer.name = "CAP_AutoUpdateContainer"    
    container.get_parent().add_child(newContainer)
    container.get_parent().move_child(newContainer, 2)
    
    var CAP_MainContainer = newContainer.get_child(0)
    
    for c in CAP_MainContainer.get_children():
        c.queue_free()

    
    cb = CheckButton.new()
    cb.name = "CAP_AutoUpdateCheck"
    cb.text = "Auto-Update"
    if capAutoUpdate != null:
        cb.button_pressed = capAutoUpdate
    cb.toggled.connect(_on_cap_auto_update_toggled)
    CAP_MainContainer.add_child(cb)
    newContainer.visible = !maxed

    ModLoaderLog.info("CheckButton hinzugefügt (Extension _ready).", LOG_NAME)

func _on_cap_auto_update_toggled(on: bool) -> void:
    capAutoUpdate = on
    ModLoaderLog.info("Auto-Update: %s" % str(on), LOG_NAME)
    
func save() -> Dictionary:
    return super ().merged({
        "capAutoUpdate": capAutoUpdate
    })
