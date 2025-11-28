ENVwatch

Overview

ENVwatch is a lightweight, surgical Bash utility designed for environment variable forensics and mutation detection.

It operates in two precision modes:

1. baseline — Captures a sorted snapshot of current environment variables and saves them to a .txt file.
2. diff — Prompts for two environment snapshot files and performs a hash-based integrity check. If changes are detected, it produces a color-coded, categorized diff table of added or mutated environment variables.

Usage

chmod +x envwatch.sh

# Create a baseline snapshot: ./envwatch.sh baseline

# Compare two environment snapshot files: ./envwatch.sh diff

During diff, you'll be prompted to provide the full path to two files containing exported environment variables.

Categories include:
- Execution (e.g., PATH, LD_PRELOAD)
- Shell History (e.g., HISTFILE)
- Identity (e.g., USER, HOME)
- Session (e.g., SSH_TTY, DISPLAY)
- Other (fallback for uncategorized variables)

System Requirements

- POSIX-compliant shell (tested on Bash 5.x)
- Coreutils (env, diff, sha256sum, readlink, etc.)

No external dependencies. No internet access required. Runs entirely in offline or hostile environments.

Legal Disclaimer

This script is provided for educational and forensic purposes only.

ENVwatch is intended for use by system administrators, forensic analysts, security professionals, and incident responders on systems they own or have explicit permission to analyze.

Use of this script on unauthorized systems or in violation of applicable laws may be illegal and unethical.

The author(s) are not responsible for any misuse or damage caused by this software.

You assume full responsibility for using this tool.