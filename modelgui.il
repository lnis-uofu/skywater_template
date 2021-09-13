MODGUI_STATE_FILE = "./.modelGuiLast"  ; saving the last state of model GUI

; ===================== main callBack ================================
;procedure( ADE_modelGUI()
;   (ADE_modelSetupGUI )
;) ; end modelGUI()


; ===================== Setting up GUI ================================

;procedure( ADE_modelSetupGUI() 
procedure( ADE_modelGUI() 
   (let (x) 

   ssid = asiGetSession( getCurrentWindow() )
   ssid   ||   { popUpMissingADE()   (error "ADE Window has to be opened first. ") }

   userModel = readStateFile()      ; read the last state of model GUI

   CORNER_TYPE = 'standard
   guiTitle = "Model GUI ADE Simulation Setup"
 
   guifields = '()
   tmp_invis = nil

   yloc = 1
   modelpath = "/MODELS/SPECTRE/s8phirs_10r/Models"

   x = (list list(hiCreateStringField(?name 'modelPathInput   ?prompt "Model Path"   ?value strcat(getShellEnvVar("PDK_HOME") modelpath)  ) 12:yloc 550:15 70))
   guifields = (append guifields x)

   ylocation = yloc + 35
   txt = "Models History"
   x = (list list(hiCreateButton(?name 'modelREADME ?buttonText txt ?callback "ADE_modelReadmeCB('standard)") 5:ylocation 100:40))
   guifields = (append guifields x)

   txt = "Models Versus E-Test"
   x = (list list(hiCreateButton(?name 'modelEtest ?buttonText txt ?callback "ADE_modelEtestCB()") 120:ylocation 160:40))
   guifields = (append guifields x)

   ylocation = yloc + 85
   txt = ADE_GUI_README
   x = (list list(hiCreateMLTextField(?name 'mcInfoNom ?value txt ?invisible tmp_invis ?editable nil ?hasVerticalScrollbar t ?hasHorizontalScrollbar t) 10:ylocation 400:150))
   guifields = (append guifields x)


   yloc = yloc + 60
   txt = "For process Monte Carlo, set Corners to nominal"
   x = (list list(hiCreateLabel(?name 'modelInfo ?labelText txt ) 415:yloc 140:15))
   guifields = (append guifields x)

   yloc = yloc + 20
   ylocation = yloc
   ;x = ADE_makeCorners(!tmp_invis)
   x = ADE_makeCorners(nil)
   guifields = (append guifields x)

   ;yloc = yloc + 20

   hiCreateAppForm(
        ?name           'modelSetupFH
        ?formTitle      guiTitle
        ?fields         guifields
        ?buttonLayout   'OKCancelApply
        ?initialSize    t
        ?callback       "ADE_modelSetupCB( hiGetCurrentForm())"
        )
   (hiDisplayForm 'modelSetupFH)



)) 

; ===================== model setup Callback ================================

procedure( ADE_modelSetupCB(theForm)
   (let (simType  modelFiles globalFiles designVars ssid getDefaultCornerP globalSections
      modInclude userIncFile modelpath)

   ;;; Check if ADE window exists
   ssid = asiGetSession(getCurrentWindow())
   ssid   ||   { popUpMissingADE()   (error "ADE Windows not found") }

   ;; Setting the model path
   modelpath = trimSpaces( getFormField(theForm "modelPathInput") )
   setShellEnvVar( strcat("CAD_MODEL_PATH=" modelpath ) )

   ;;; Set up Include Path and Definition files
   asiSetEnvOptionVal(ssid 'includePath         (getShellEnvVar "CAD_MODEL_PATH"))
   ;asiSetEnvOptionVal(ssid 'definitionFiles     ADE_DEFINITION_FILES)


  ;;; Assume only 2 simulation types: 'Corner Case'  or   'Monte Carlo'
   ;simType = (getFormField theForm "mc_type")
   simType = "Process Only"
   simType = trimTrailingSpaces(simType)

   getDefaultCornerP = nil
;   getDefaultCornerP = t
;   globalSections = ADE_CORNER_SECTIONS
   globalSections = ADE_MC_PROCESS_SECTIONS

;   if( simType == "Mismatch Only" then
;      globalSections = ADE_MC_MM_SECTIONS
;   else if( simType == "Process Only" then
;      globalSections = ADE_MC_PROCESS_SECTIONS
;      getDefaultCornerP = t
;   else if( simType == "Mismatch+Process" then
;      globalSections = ADE_MC_MM_PROCESS_SECTIONS
;       getDefaultCornerP = t
;   )))


   ;;; Set ADE model libraries (worst case)
   modelFiles = '()
   isKeepLoop = t   ; used to exit when found
   foreach( devcorner (get ADE_CORNERS CORNER_TYPE)
       print(devcorner->name)
       selectedradio = getDevCornerFromGUI( theForm devcorner->name getDefaultCornerP)
       if( selectedradio == "leak_fet"  then
          if( isKeepLoop then
             isKeepLoop = nil
             modInclude = list( devcorner->modelfile
                           getDevCornerFromGUI( theForm devcorner->name getDefaultCornerP)
                     )
             modelFiles = cons( modInclude modelFiles )
             modInclude = list( devcorner->modelfile "leak_cell")
             modelFiles = cons( modInclude modelFiles )
             modInclude = list( devcorner->modelfile
                           getDevCornerFromGUI( theForm "parRC" getDefaultCornerP)
                     )
             modelFiles = cons( modInclude modelFiles )
          )
       else if( selectedradio == "wafer_fet"  then
          if( isKeepLoop then
             isKeepLoop = nil
             modInclude = list( devcorner->modelfile
                           getDevCornerFromGUI( theForm devcorner->name getDefaultCornerP)
                     )
             modelFiles = cons( modInclude modelFiles )
             modInclude = list( devcorner->modelfile "wafer_cell")
             modelFiles = cons( modInclude modelFiles )
             modInclude = list( devcorner->modelfile
                           getDevCornerFromGUI( theForm "parRC" getDefaultCornerP)
                     )
             modelFiles = cons( modInclude modelFiles )
          )
       else if( selectedradio == "mc"  then
          modInclude = list( devcorner->modelfile "mc")
          modelFiles = cons( modInclude modelFiles )
          isKeepLoop = nil
       else if(isKeepLoop then
          if( selectedradio != "standard" then
             modInclude = list( devcorner->modelfile
                           getDevCornerFromGUI( theForm devcorner->name getDefaultCornerP)
                     )
             modelFiles = cons( modInclude modelFiles )
       )))))
;       print(modInclude)
   )
   modelFiles = reverse(modelFiles)
   ;print(modelFiles)

   ;;; Set ADE model libraries (global sections, always include)
   ;globalFiles = '()
   ;foreach(ix globalSections globalFiles = cons( list(ix->modelfile ix->section) globalFiles))

   ;;; Add user Include file
   ;userIncFile = trimSpaces( getFormField(theForm "userInclude") )
   ;when( userIncFile != ""    globalFiles = cons( list(userIncFile)  globalFiles ))
   ;globalFiles =  reverse(globalFiles)

   ;print(globalFiles)

   asiSetEnvOptionVal(ssid 'modelFiles append(modelFiles globalFiles))


   ;print(globalFiles)


))

; ==================================

procedure( ADE_model_option(modeloption)
   (let (ix)
   if( modeloption=="Cryo" then
      hiGetCurrentForm()->modelPathInput->value = strcat(getShellEnvVar("PDK_HOME") "/MODELS/SPECTRE/c9fp-3r/CryoModels") 
   else
      hiGetCurrentForm()->modelPathInput->value = strcat(getShellEnvVar("PDK_HOME") "/MODELS/SPECTRE/c9fp-3r/Models") 
   )
))

; ==================== GUI setups ========================================

procedure( ADE_makeCorners(invis)
;;; Generate list of file/section pair to include in the GUI
(let (alist ix)
   alist
   foreach(ix (get  ADE_CORNERS CORNER_TYPE)
       alist = cons( list(ADE_createRadioButton(ix invis) 420:ylocation 100:15 90) alist)
       ylocation = ylocation + 25
   )
   reverse(alist)
)) ; end ADE_makeCorners()

; ======================================

procedure( ADE_createRadioButton(x invis)
   let( (ssid l_model_setup eachsetup defvalue)

   ssid = asiGetSession(getCurrentWindow())
   l_model_setup = asiGetEnvOptionVal( ssid 'modelFiles )

   defvalue = x->default

   if(l_model_setup then
      foreach( eachsetup l_model_setup      ; Corner cases
         if( nth(1 eachsetup)  then
            tmp_name = nth(0 parseString(nth(1 eachsetup) "_"))
            if( tmp_name == nil then tmp_name = " " )

            if( strcmp(x->name tmp_name)==0 then
                defvalue = nth(1 parseString(nth(1 eachsetup) "_"))
                print(defvalue)
            )
           ;if( strncmp(x->name nth(1 eachsetup) strlen(x->name))==0 then
           ; defvalue = substring(nth(1 eachsetup) strlen(x->name)+2)
           ;)) 
         )
      )
   )

   cornername = stringToSymbol(x->name)
;   print(cornername)
;   print(x->choices)

   hiCreateRadioField(
;      ?name     'cornertype
      ?name     stringToSymbol(x->name)
      ?choices  x->choices
      ?prompt   x->name
      ?value    defvalue
      ?defValue x->default
      ;?invisible invis
      ?invisible x->invisible
      ?callback (list "ADE_Corner_Visible(hiGetCurrentForm())")
   )
)) ; end ADE_createRadioButton()

; ======================================

procedure( ADE_Corner_Visible(cornerselection)
   (let (ix)
;   print(cornerselection->MODEL_TYPE->value)
   if( cornerselection->MODEL_TYPE->value == "leak_fet" || cornerselection->MODEL_TYPE->value == "wafer_fet" then
      hiGetCurrentForm()->FET->invisible = t
      hiGetCurrentForm()->Cell_FET->invisible = t
      hiGetCurrentForm()->Linear_Device->invisible = t
      hiGetCurrentForm()->NPN->invisible = t
      hiGetCurrentForm()->parRC->invisible = nil
   else 
      if( cornerselection->MODEL_TYPE->value == "mc" then
         hiGetCurrentForm()->FET->invisible = t
         hiGetCurrentForm()->Cell_FET->invisible = t
         hiGetCurrentForm()->Linear_Device->invisible = t
         hiGetCurrentForm()->NPN->invisible = t
         hiGetCurrentForm()->parRC->invisible = t
      else
         if( hiGetCurrentForm()->FET->invisible then
            hiGetCurrentForm()->FET->invisible = nil
            hiGetCurrentForm()->Cell_FET->invisible = nil
            hiGetCurrentForm()->Linear_Device->invisible = nil
            hiGetCurrentForm()->NPN->invisible = nil
         )
   ))
))

; ======================================

procedure( getDevCornerFromGUI( theForm fieldname defaultp )
   let( (x)
   x = list(
;      fieldname
;      "_"
      (getFormField theForm fieldname ?getdefault defaultp)
   )
;   print(x)
   ;x = strcat(fieldname "_" (getFormField theForm fieldname ?getdefault defaultp))

   buildString(x "")
)) ; end getDevCornerFromGUI()

; ======================================

procedure( ADE_modelReadmeCB(cornertype)
    ;;; Open a window for README file
    (let (readmefields  x fidin fline readmepath)
    readmefields = '()

;    readmepath = strcat((getShellEnvVar "PDK_HOME") "/MODELS/SPECTRE/README_changes") 
    (case cornertype
       ('cryo  readmepath = strcat((getShellEnvVar "PDK_HOME") "/MODELS/SPECTRE/c9fp-3r/CryoModels/README") )
       ;('one  readmepath = strcat((getShellEnvVar "CAD_MODEL_PATH") "/skill/ADE_modelgui_default.readme") )
       ('standard  readmepath = strcat((getShellEnvVar "PDK_HOME") "/MODELS/SPECTRE/README_changes") )
       ;('two  readmepath = strcat((getShellEnvVar "CAD_MODEL_PATH") "/skill/ADE_modelgui_advance.readme") )
    )

;    printf("Corner type = %L\n" readmepath)


    fidin = infile(readmepath)
    txt = ""
    while( gets(fline fidin) != nil
       txt = strcat(txt fline)
    )
    close(fidin)

    x = hiCreateMLTextField(?name 'ReadmeInfo ?value txt ?editable nil)

    hiCreateAppForm(
       ?name 'modelReadmeFH ?formTitle "ADE Sim Setup README" ?buttonLayout 'Close
       ?fields list( list(x 1:1 800:600) )
       ?attachmentList list( hicTopPositionSet|hicLeftPositionSet|hicRightPercentSet|hicBottomPercentSet )
       ?initialSize list( 800 600)
    )
    (hiDisplayForm 'modelReadmeFH)
)) ; end ADE_modelReadmeCB()

; ==================== Model Vs. Etest =========================================

procedure( ADE_modelEtestCB()
   (let (htmlpath)
   htmlpath = strcat("file://" (getShellEnvVar "PDK_HOME") "/MODELS/SPECTRE/qa/netlist/Models-versus-Specs.html")
   hiLaunchBrowser(htmlpath)
))


; ==================== State File =========================================

procedure( readStateFile()
let( (iFile modFile myStateFile)
   myStateFile = MODGUI_STATE_FILE
   if( isFile(myStateFile) && (iFile = infile(myStateFile)) && gets( curStr iFile) then
      modFile = trimTrailingCarryReturn( curStr )
   else
      modFile = ""
   )
   iFile   &&   close(iFile)
   modFile
)) ; end readStateFile()


procedure( writeStateFile(x)
let( (oFile myStateFile)
   myStateFile = MODGUI_STATE_FILE
   oFile = outfile(myStateFile)
   fprintf(oFile "%s" x)
   close(oFile)
)) ; end writeStateFile()


; ==================== Misc procedures =====================================

procedure( trimSpaces( x )
    rexCompile(" +")
    rexReplace(x "" 0)
) ; end trimSpaces()

procedure( trimTrailingSpaces( x )
    rexCompile(" +$")
    rexReplace(x "" 0)
) ; end trimTrailingSpaces()

procedure( getFormField(form fieldname @key (getdefault nil))
    if( getdefault then
        get(form fieldname)->defValue
    else
        get(form fieldname)->value
    )
) ; end getFormField()


