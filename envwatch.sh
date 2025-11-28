#!/bin/bash

# ENVwatch - Environment Mutation Fingerprinter
# Purpose: Baseline and diff environment variables across sessions/snapshots

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_table_header() {
  printf "\n${CYAN}%-30s %-60s %-30s${NC}\n" "CATEGORY" "KEY" "VALUE"
  printf "${CYAN}%s${NC}\n" "$(printf '%0.s-' {1..120})"
}

categorize_var() {
  key="$1"
  case "$key" in
    PATH|LD_*) echo "Execution" ;;
    HISTFILE|HISTSIZE|HISTCONTROL) echo "Shell History" ;;
    PS1|SHELL|USER|HOME|LOGNAME) echo "Identity" ;;
    SSH_*|TERM|XDG_*) echo "Session" ;;
    *) echo "Other" ;;
  esac
}

main_menu() {
  echo -e "\n${CYAN}ENVwatch - Environment Mutation Fingerprinter${NC}"
  echo "1) Create environment variable baseline (in current directory)"
  echo "2) Compare two environment snapshot files"
  echo "q) Quit"
  echo -n "Select an option: "
  read choice

  case "$choice" in
    1)
      outfile="env_baseline_$(date +%Y%m%d_%H%M%S).txt"
      env | sort > "$outfile"
      echo -e "${GREEN}[+] Full environment baseline saved to ./$outfile${NC}"
      ;;

    2)
      echo -n "Enter path to FIRST env file: "
      read base
      echo -n "Enter path to SECOND env file: "
      read comp

      if [[ ! -f "$base" || ! -f "$comp" ]]; then
        echo -e "${RED}[-] One or both files do not exist.${NC}"
        exit 1
      fi

      echo -e "\n${YELLOW}[i] Comparing $base ↔ $comp${NC}"

      # Hash check
      hash1=$(sha256sum "$base" | cut -d' ' -f1)
      hash2=$(sha256sum "$comp" | cut -d' ' -f1)

      if [[ "$hash1" == "$hash2" ]]; then
        echo -e "${GREEN}[+] No changes detected (hash match)${NC}"
        exit 0
      else
        echo -e "${RED}[-] Environment mutation detected (hash mismatch)${NC}"
      fi

      print_table_header

      comm -13 <(cut -d= -f1 "$base" | sort) <(cut -d= -f1 "$comp" | sort) | while read key; do
        value=$(grep "^$key=" "$comp" | cut -d= -f2-)
        category=$(categorize_var "$key")
        printf "${YELLOW}%-30s %-60s %-30s${NC}\n" "$category" "$key" "$value"
      done
      ;;

    q|Q)
      echo -e "${CYAN}Exiting ENVwatch.${NC}"
      exit 0
      ;;

    *)
      echo -e "${RED}Invalid selection. Please choose 1, 2, or q.${NC}"
      ;;
  esac
}

main_menu
