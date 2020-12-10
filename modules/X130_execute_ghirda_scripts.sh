#!/bin/bash

# emba - EMBEDDED LINUX ANALYZER
#
# Copyright 2020 Siemens AG
#
# emba comes with ABSOLUTELY NO WARRANTY. This is free software, and you are
# welcome to redistribute it under the terms of the GNU General Public License.
# See LICENSE file for usage of this software.
#
# emba is licensed under GPLv3
#
# Author(s): Michael Messner, Pascal Eckmann

# Description:  Module with all available functions and patterns to use
#               Access:
#                 firmware root path via $FIRMWARE_PATH
#                 binary array via ${BINARIES[@]}

# Code Guidelines:
# -----------------------------
# Identation should be 2 spaces (no tab character).
# Comments: use # sign followed by a space. When needed, create a comment block. Blank lines: allowed.
# All functions use snake_case (e.g. test_xyz()). One blank lines between functions.
# Variables should be capitalized, with underscore as word separator (e.g. FILE_EXISTS=1).
# If you use external code, add '# Test source: [LINK TO CODE]' above.
# Use 'local' for variables if possible for better resource management
# Use 'export' for variables which aren't only used in one file - it isn't necessary, but helps for readability
# Boolean: 0=False 1=True, e.g. [[ $VAR -eq 0 ]]

declare -a SCRIPTS

S130_execute_ghirda_scripts() {
  # Initialize module and creates a log file "empty_module_log.txt" in your log folder
  module_log_init "s130_execute_ghirda_scripts"
  # Prints title to CLI and into log
  module_title "Execute ghidra scripts"
  
  if [[ "$GHIDRA" -eq "1" ]]; then
  
    local SCRIPTEXPRESSION
    SCRIPTEXPRESSION=""
    echo "sdf $GHIDRA_PATH/support/analyzeHeadless"
    if [[ $(cat "$GHIDRA_PATH/support/analyzeHeadless") != "" ]]; then
      print_output "[+] Execute Ghidra Scripts"
      SCRIPTS=($(ls "$SCRIPT_PATH" | grep ".java\|.py"))
      echo "Test $(ls "$SCRIPT_PATH" | grep ".java\|.py")"
      for SCRIPT in "${SCRIPTS[@]}"; do
        print_output "$SCRIPT"
        SCRIPTEXPRESSION+="-postscript $SCRIPT_PATH/$SCRIPT "
      done
      print_output "$(ls "$SCRIPT_PATH" | grep ".java\|.py")"
      $GHIDRA_PATH/support/analyzeHeadless $PROJCET_PATH $PROJECT_NAME -import $FIRMWARE_PATH/ -recursive $SCRIPTEXPRESSION
    else
      print_output "[!] Ghidra is disabled!"
    fi
  fi

  # - Usage of `find`: add "${EXCL_FIND[@]}" to exclude all paths (added with '-e' parameter)
  print_output "Execute Scripts finished"
}
