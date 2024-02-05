local Main = require(script.Main)
local Action = require(script.Action)
local ButtonInfo = require(script.Action.ButtonInfo)

---------------

export type Input = Main.Input
export type Action = Action.Action
export type Trigger = Action.Trigger
export type TriggerType = Action.TriggerType
export type ButtonInfo = ButtonInfo.ButtonInfo

---------------

return {
    Main = Main,
    Action = Action,
    ButtonInfo = ButtonInfo,
}