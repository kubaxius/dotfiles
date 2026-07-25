-- This is AI generated, not all of this is correct. Please verify before using it.

---@meta

---@class HyprlandLua
---@field dsp HyprlandDispatch
local HyprlandLua = {}

---@param monitor HyprlandMonitor
function HyprlandLua.monitor(monitor) end

---@param event string
---@param callback fun()
function HyprlandLua.on(event, callback) end

---@return string
function HyprlandLua.get_current_submap() end

---@param key string
---@param value string
function HyprlandLua.env(key, value) end

---@param command string
function HyprlandLua.exec_cmd(command) end

---@param dispatcher any
function HyprlandLua.dispatch(dispatcher) end

---@param config HyprlandConfig
function HyprlandLua.config(config) end

---@param name string
---@param curve HyprlandCurve
function HyprlandLua.curve(name, curve) end

---@param animation HyprlandAnimation
function HyprlandLua.animation(animation) end

---@param gesture HyprlandGesture
function HyprlandLua.gesture(gesture) end

---@param device HyprlandDevice
function HyprlandLua.device(device) end

---@param bind string
---@param dispatcher any
---@param options? HyprlandBindOptions
---@return HyprlandHandle
function HyprlandLua.bind(bind, dispatcher, options) end

---@overload fun(name: string, reset_to: string, callback: fun())
---@param name string
---@param callback fun()
function HyprlandLua.define_submap(name, callback) end

---@param rule HyprlandWindowRule
---@return HyprlandHandle
function HyprlandLua.window_rule(rule) end

---@param rule HyprlandLayerRule
---@return HyprlandHandle
function HyprlandLua.layer_rule(rule) end

---@param rule HyprlandWorkspaceRule
function HyprlandLua.workspace_rule(rule) end

---@param path string
---@param permission string
---@param policy string
function HyprlandLua.permission(path, permission, policy) end

---@class HyprlandDispatch
---@field window HyprlandWindowDispatch
---@field workspace HyprlandWorkspaceDispatch
---@field exec_cmd fun(command: string): any
---@field focus fun(options: table): any
---@field layout fun(layout: string): any
---@field send_shortcut fun(options: HyprlandSendShortcutOptions): any
---@field submap fun(name: string): any

---@class HyprlandWindowDispatch
---@field close fun(): any
---@field kill fun(): any
---@field float fun(options?: table): any
---@field pseudo fun(): any
---@field move fun(options: table): any
---@field drag fun(): any
---@field resize fun(): any

---@class HyprlandWorkspaceDispatch
---@field toggle_special fun(name: string): any

---@class HyprlandSendShortcutOptions
---@field mods string
---@field key string
---@field window? string

---@class HyprlandHandle
---@field set_enabled fun(self: HyprlandHandle, enabled: boolean)

---@class HyprlandMonitor
---@field output string
---@field mode string
---@field position string
---@field scale string

---@class HyprlandConfig
---@field ecosystem? HyprlandEcosystemConfig
---@field general? HyprlandGeneralConfig
---@field decoration? HyprlandDecorationConfig
---@field animations? HyprlandAnimationsConfig
---@field dwindle? HyprlandDwindleConfig
---@field master? HyprlandMasterConfig
---@field scrolling? HyprlandScrollingConfig
---@field misc? HyprlandMiscConfig
---@field input? HyprlandInputConfig
---@field xwayland? HyprlandXwaylandConfig

---@class HyprlandEcosystemConfig
---@field enforce_permissions? boolean

---@class HyprlandGeneralConfig
---@field gaps_in? integer
---@field gaps_out? integer
---@field border_size? integer
---@field col? HyprlandGeneralColors
---@field resize_on_border? boolean
---@field allow_tearing? boolean
---@field layout? string

---@class HyprlandGeneralColors
---@field active_border? string|HyprlandGradientColor
---@field inactive_border? string

---@class HyprlandGradientColor
---@field colors string[]
---@field angle? number

---@class HyprlandDecorationConfig
---@field rounding? integer
---@field rounding_power? integer
---@field active_opacity? number
---@field inactive_opacity? number
---@field shadow? HyprlandShadowConfig
---@field blur? HyprlandBlurConfig

---@class HyprlandShadowConfig
---@field enabled? boolean
---@field range? integer
---@field render_power? integer
---@field color? integer|string

---@class HyprlandBlurConfig
---@field enabled? boolean
---@field size? integer
---@field passes? integer
---@field vibrancy? number

---@class HyprlandAnimationsConfig
---@field enabled? boolean

---@class HyprlandDwindleConfig
---@field preserve_split? boolean

---@class HyprlandMasterConfig
---@field new_status? string

---@class HyprlandScrollingConfig
---@field fullscreen_on_one_column? boolean

---@class HyprlandMiscConfig
---@field force_default_wallpaper? integer
---@field disable_hyprland_logo? boolean

---@class HyprlandXwaylandConfig
---@field force_zero_scaling? boolean

---@class HyprlandInputConfig
---@field kb_layout? string
---@field kb_variant? string
---@field kb_model? string
---@field kb_options? string
---@field kb_rules? string
---@field kb_file? string
---@field numlock_by_default? boolean
---@field follow_mouse? integer
---@field sensitivity? number
---@field touchpad? HyprlandTouchpadConfig

---@class HyprlandTouchpadConfig
---@field natural_scroll? boolean

---@class HyprlandCurve
---@field type "bezier"|"spring"|string
---@field points? number[][]
---@field mass? number
---@field stiffness? number
---@field dampening? number

---@class HyprlandAnimation
---@field leaf string
---@field enabled boolean
---@field speed number
---@field bezier? string
---@field spring? string
---@field style? string

---@class HyprlandGesture
---@field fingers integer
---@field direction string
---@field action string

---@class HyprlandDevice
---@field name string
---@field sensitivity? number

---@class HyprlandBindOptions
---@field mouse? boolean
---@field locked? boolean
---@field repeating? boolean
---@field click? boolean
---@field drag? boolean
---@field device? HyprlandBindDeviceOptions
---@field submap_universal? boolean

---@class HyprlandBindDeviceOptions
---@field inclusive? boolean
---@field list? string[]

---@class HyprlandWindowRule
---@field name string
---@field match table
---@field suppress_event? string
---@field no_focus? boolean
---@field workspace? string
---@field move? string
---@field float? boolean
---@field border_size? integer
---@field rounding? integer

---@class HyprlandLayerRule
---@field name string
---@field match table
---@field no_anim? boolean

---@class HyprlandWorkspaceRule
---@field workspace string
---@field persistent? boolean
---@field gaps_out? integer
---@field gaps_in? integer

---@type HyprlandLua
hl = HyprlandLua
