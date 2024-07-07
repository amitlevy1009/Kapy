Automated Malware Deployment and Persistence Script

This repository contains a proof-of-concept script designed to demonstrate automated malware deployment and persistence techniques on Linux systems. This script is intended strictly for educational and research purposes to illustrate potential security vulnerabilities and mitigation strategies.

Features:
Remote Server Manipulation:

SSH Server Configuration: Modifies sshd_config to alter SSH server behaviors, including authentication methods and user access controls.
User Management: Adds a specified administrative user with configurable credentials and grants sudo privileges, enhancing access control capabilities.
File Monitoring and Data Exfiltration:

Inotify File Monitoring: Uses inotifywait to monitor a specified file  for modifications.
Data Exfiltration: Automatically retrieves monitored file contents  and other specified data (such as system logs) to a remote server using scp, demonstrating potential data exfiltration techniques.
Automated Task Scheduling and Execution:

Batch Script Generation: Generates Windows batch scripts (*.bat) to automate tasks on compromised Windows systems. Scripts include commands for task scheduling (schtasks) and remote execution of malicious payloads (amit.bat).
Security Evasion and Persistence:

Restricted Shell: Implements a restricted shell environment (restricted_shell.sh) for specified users to limit command execution, enhancing security while maintaining persistence.
Batch File Attributes: Manipulates file attributes (attrib) to hide malicious scripts (*.bat) and maintain persistence on compromised Windows systems.
Usage:
Setup Instructions: Users are prompted to input necessary configuration details such as target IP addresses, usernames, passwords, and private key locations for SSH authentication.
Interactive Prompting: Utilizes interactive prompts to ensure user-provided inputs (e.g., IP addresses, passwords) meet specified criteria (e.g., password complexity, IP address validity).
Disclaimer:
This script is provided as-is for educational purposes only. Use of this script for any malicious or unauthorized activities is strictly prohibited. The author assumes no liability for any misuse or damage caused by the implementation of this script.

Contributing:
Contributions are welcome in the form of suggestions, improvements, or additional features that enhance the educational value of this repository. Please submit pull requests or raise issues for discussion.

License:
This project is licensed under the MIT License - see the LICENSE file for details.
