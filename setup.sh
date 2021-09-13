#!/bin/tcsh
source /uusoc/facility/cad_tools/Cadence/cadence_setup.sh
source /uusoc/facility/cad_tools/Mentor/mentor_setup.sh
source /uusoc/facility/cad_tools/Synopsys/synopsys_setup.sh

#Create the folders in case they don't exist yet
mkdir -p calibre
mkdir -p calibre/lvs
mkdir -p calibre/drc
mkdir -p calibre/pex
mkdir -p calibre/runsets
mkdir -p simulations
mkdir -p libs

setenv RUNSET_DIR "$PWD/calibre/runsets"

############################################
# Site-specific PDK Installation Variables #
############################################
setenv SW_PDK_ROOT "/uusoc/facility/cad_common/skywater-src-nda"
setenv PDK_HOME "$SW_PDK_ROOT/s8/V2.0.1"
setenv METAL_STACK "s8phirs_10r"
setenv SW_IP_HOME "$SW_PDK_ROOT/s8_ip/"

###################################
# Set S8 specific variables
####################################
setenv PDK_MODEL_HOME "$PDK_HOME"
setenv DEVICELIB_ROOT "PDK_HOME"/VirtuosoOA/libs

setenv TECHDIR "$PDK_HOME"
setenv TECHDIR_DRC "$PDK_HOME"/DRC/Calibre
setenv TECHDIR_LVS "$PDK_HOME"/LVS/Calibre

###################################
# Recommended Cadence env variables
####################################
setenv CDS_Netlisting_Mode Analog
setenv CDS_AUTO_64BIT ALL
setenv CDS_AHDLCMI_ENABLE YES
setenv CDS_QUIET 0
setenv CALIBRE_DISABLE_RHEL5_WARNING 1
