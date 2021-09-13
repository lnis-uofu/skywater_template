procedure( SkyWaterMenu( tmpVar )
  let( (MenuItem0 MenuItem1 MenuItem2)

  MenuItem0 = hiCreateAction(
     ?name       'modelGUI_menu
     ?iconText   "Model GUI"
     ?callback   "menuModelGUICB()"
  )

  hiCreatePulldownMenu(
     'SWPulldownMenu
     "&SkyWater"
     '( MenuItem0 )
  )

  hiInsertBannerMenu(
     hiGetCurrentWindow()
     SWPulldownMenu
     hiGetNumMenus( hiGetCurrentWindow() )
  )
))

procedure( menuModelGUICB()
   let( (item0)
   ADE_modelGUI()
))


load("modelguiconfig.il")
load("modelgui.il")

unless(boundp('SWPulldownMenu)
   deRegUserTriggers("schematic" nil nil 'SkyWaterMenu)
   deRegUserTriggers("explorer" nil nil 'SkyWaterMenu)
   deRegUserTriggers("explorer-schematic" nil nil 'SkyWaterMenu)
   deRegUserTriggers("adexl" nil nil 'SkyWaterMenu)
)

hiSetBindKey("Schematics" "<Key>/" "SkyWaterMenu(t)")

hiSetBindKey("explorer" "<Key>/" "SkyWaterMenu(t)")
hiSetBindKey("assembler" "<Key>/" "SkyWaterMenu(t)")

hiSetBindKey("adegxl" "<Key>/" "SkyWaterMenu(t)")
hiSetBindKey("adexl" "<Key>/" "SkyWaterMenu(t)")
; ADE L
hiRegisterBindKeyPrefix("Artist")
hiSetBindKey("Artist" "<Key>/" "SkyWaterMenu(t)")


