;ADE_VERSION_INFO = "models version 1.14"
;printf("\nLoading %s\n",ADE_VERSION_INFO)

; The current PDK model path, used to retrieve it if the path changed by user.
;ADE_PDK_MODEL_PATH = getShellEnvVar("CAD_MODEL_PATH")

; Files that need to be included at the top level, i.e., using the
; ADE Setup->Simulation Files->Definition Files field.  This is usually just user defined functions.
; Multiple def files can be specified: list( "def1.scs"  "def2.scs")

;IC61_DEFINITION_FILES = list( list(t "au1dti_definitions.scs") list(t "au1dti_assertsComp.scs") list(nil "au1dti_assertsTubs.scs") list(nil "au1dti_assertsFatal.scs") )
;ADE_DEFINITION_FILES = list( "au1dti_definitions.scs" "au1dti_assertsComp.scs")

; To add corners to the GUI add list() elements to ADE_CORNERS_ONE and ADE_CORNERS_TWO
; Include sections defining worst case process corners.
; Sections will be netlisted in the order given here.
; Section in model file MUST consist of name and corner joined by "_" (eg. res_l, nbf_h ..)

; Default model GUI
ADE_CORNERS_CRYO = list(

    list(
        nil 
        'name         "MODEL_TYPE"
        'choices      list( "models" )
        'default      "models"
        'modelfile    "design_wrapper.lib"
        'invisible    t
    )
    list(
        nil 
        'name         "FET"
        'choices      list( "tt_fet"  "ff_fet"  "ss_fet"  "fs_fet"  "sf_fet" )
        'default      "tt_fet"
        'modelfile    "design_wrapper.lib"
    )
    list(
        nil 
        'name         "Cell_FET"
        'choices      list( "tt_cell"  "ff_cell"  "ss_cell"  "fs_cell"  "sf_cell" )
        'default      "tt_cell"
        'modelfile    "design_wrapper.lib"
    )
)

; Alternate model GUI
ADE_CORNERS_STD = list(

    list(
        nil 
        'name         "MODEL_TYPE"
        'choices      list( "standard"  "mc"  "leak_fet" "wafer_fet" )
        'default      "standard"
        'modelfile    "design_wrapper.lib.scs"
    )
    list(
        nil 
        'name         "FET"
        'choices      list( "tt_fet"  "ff_fet"  "ss_fet"  "fs_fet"  "sf_fet" )
        'default      "tt_fet"
        'modelfile    "design_wrapper.lib.scs"
    )
    list(
        nil 
        'name         "Cell_FET"
        'choices      list( "tt_cell"  "ff_cell"  "ss_cell"  "fs_cell"  "sf_cell" )
        'default      "tt_cell"
        'modelfile    "design_wrapper.lib.scs"
    )
    list(
        nil 
        'name         "NPN"
        'choices      list( "npn_t"  "npn_f"  "npn_s" )
        'default      "npn_t"
        'modelfile    "design_wrapper.lib.scs"
    )
    list(
        nil 
        'name         "Linear_Device"
        'choices      list( "tt_rc"  "lh_rc"  "hl_rc" "ll_rc" "hh_rc" )
        'default      "tt_rc"
        'modelfile    "design_wrapper.lib.scs"
    )
    list(
        nil 
        'name         "parRC"
        'choices      list( "tt_parRC"  "lh_parRC"  "hl_parRC" )
        'default      "tt_parRC"
        'modelfile    "design_wrapper.lib.scs"
    )
)

ADE_CORNERS = (list
   nil
   'cryo     ADE_CORNERS_CRYO
   'standard ADE_CORNERS_STD
)



ADE_MC_PROCESS_SECTIONS = list(
)

ADE_GUI_README = "MODEL_TYPE:\n \
   standard : standard models \n \
   mc       : Monte Carlo \n \
   leak_fet : worst case FET leakage \n \
   wafer_fet: wafer corners \n \
Corners Descriptions: \n \
   FET          : FET and PNP corners \n \
   Cell_FET     : Cell FET corners \n \
   NPN          : NPN corners \n \
   Linear_Device: Linear devices (resistor and capacitor) corners\n \
   parRC        : parasitic resistor and capacitor corners "
