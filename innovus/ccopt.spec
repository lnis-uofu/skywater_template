###############################################################
#  Generated by:      Cadence Innovus 20.15-s105_1
#  OS:                Linux x86_64(Host ID lnissrv4)
#  Generated on:      Sun Nov 28 23:32:41 2021
#  Design:            mips
#  Command:           create_ccopt_clock_tree_spec -file ccopt.spec
###############################################################
#-------------------------------------------------------------------------------
# Clock tree setup script - dialect: Innovus
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

if { [get_ccopt_clock_trees] != {} } {
  error {Cannot run clock tree spec: clock trees are already defined.}
}

namespace eval ::ccopt {}
namespace eval ::ccopt::ilm {}
set ::ccopt::ilm::ccoptSpecRestoreData {}
# Start by checking for unflattened ILMs.
# Will flatten if so and then check the db sync.
if { [catch {ccopt_check_and_flatten_ilms_no_restore}] } {
  return -code error
}
# cache the value of the restore command output by the ILM flattening code
set ::ccopt::ilm::ccoptSpecRestoreData $::ccopt::ilm::ccoptRestoreILMState

# The following pins are clock sources
set_ccopt_property cts_is_sdc_clock_root -pin clk true

# Clocks present at pin clk
#   clk (period 6.000ns) in timing_config constraint([../design_compiler/SDC/mips_mapped.sdc])
create_ccopt_clock_tree -name clk -source clk -no_skew_group

# Clock period setting for source pin of clk
set_ccopt_property clock_period -pin clk 6

# Skew group to balance non generated clock:clk in timing_config:constraint (sdc ../design_compiler/SDC/mips_mapped.sdc)
create_ccopt_skew_group -name clk/constraint -sources clk -auto_sinks
set_ccopt_property include_source_latency -skew_group clk/constraint true
set_ccopt_property extracted_from_clock_name -skew_group clk/constraint clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk/constraint constraint
set_ccopt_property extracted_from_delay_corners -skew_group clk/constraint {wc bc}


check_ccopt_clock_tree_convergence
# Restore the ILM status if possible
if { [get_ccopt_property auto_design_state_for_ilms] == 0 } {
  if {$::ccopt::ilm::ccoptSpecRestoreData != {} } {
    eval $::ccopt::ilm::ccoptSpecRestoreData
  }
}

