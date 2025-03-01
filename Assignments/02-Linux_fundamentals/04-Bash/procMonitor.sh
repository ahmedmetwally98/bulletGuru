#!/usr/bin/bash

#########################################################################
#                                                                       #
# This script monitors the CPU and memory usage of a process.           #
# It sends an email if the usage exceeds a certain threshold.           #
#                                                                       #
#########################################################################
## define some error codes
INVALID_FILE_NAME_ERR_NUM=1
INVALID_THRESHOLD_ERR_NUM=2
INVALID_LOG_FILE_ERR_NUM=3
INVALID_VAR_ERR_NUM=4

user_conf=$1

# check if the user configuration file is provided
if [ -z "$user_conf" ]; then
    echo "Usage: $0 <user_conf>"
    exit 1
fi

# Load the configuration file
if [ ! -f "$user_conf" ]; then
    echo "Configuration file
    $user_conf not found. Exiting..."
    exit $INVALID_FILE_NAME_ERR_NUM
fi

source "$user_conf"

# Function to validate configuration parameters
validate_config() {
    local var_name="$1"
    local var_value="$2"
    local description="$3"

    if [ -z "$var_value" ]; then
        echo "$description is not set. Exiting..."
        exit $INVALID_VAR_ERR_NUM
    fi

    if [[ "$var_name" =~ THRESHOLD$ ]] && ! [[ "$var_value" =~ ^[0-9]+$ ]]; then
        echo "$description is not a valid number. Exiting..."
        exit $INVALID_THRESHOLD_ERR_NUM
    fi
}

# Function to validate the log file
validate_log_file() {
    local log_file="$1"

    if [ ! -f "$log_file" ]; then
        echo "Log file not found. Creating $log_file..."
        touch "$log_file" 2> /dev/null
        if [ $? -ne 0 ]; then
            echo "Failed to create log file. Exiting..."
            exit $INVALID_LOG_FILE_ERR_NUM
        else
            echo "Log file created successfully."
        fi
    fi

    if [ ! -w "$log_file" ]; then
        echo "Log file is not writable. Exiting..."
        read -pr "Do you want to change the log file permission to be writable? (y/n): " choice
        if [ "$choice" == "y" ]; then
            chmod +w "$log_file"
            echo "Log file permission changed to writable."
        else
            echo "Exiting..."
            exit 1
        fi
    fi
}

# Validate configuration parameters
validate_config "PROCESS_LOG_FILE" "$PROCESS_LOG_FILE" "PROCESS_LOG_FILE"
validate_config "CPU_THRESHOLD" "$CPU_ALERT_THRESHOLD" "CPU_THRESHOLD"
validate_config "MEM_THRESHOLD" "$MEMORY_ALERT_THRESHOLD" "MEM_THRESHOLD"

# Validate the log file
validate_log_file "$PROCESS_LOG_FILE"

# Function to list running processes
list_processes() {
    echo "Listing all running processes..."
    ps aux | awk '{print $2, $11, $3, $4}' | column -t
}

# Function to display detailed process information
process_info() {
    read -p "Enter PID: " pid
    echo "Fetching details for PID $pid..."
    ps -p "$pid" -o pid,ppid,user,%cpu,%mem,cmd
}

# Function to kill a process
kill_process() {
    read -p "Enter PID to kill: " pid
    
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "Invalid PID. Please enter a numeric value."
        return
    fi
    kill "$pid"
    if [ $? -eq 0 ]; then
        echo "Process ${pid} killed successfully."
        echo "$(date): Process ${pid} killed successfully" >> "$PROCESS_LOG_FILE"
    else
        echo "Failed to kill process $pid."
    fi
}

# Function to display process statistics
process_stats() {
    echo "Fetching system process statistics..."
    echo "Total processes: $(ps -e | wc -l)"
    echo "Memory usage: $(free -m | grep Mem:)"
    echo "CPU load: $(uptime | awk -F'load average: ' '{print $2}')"
}

# Function for real-time monitoring
real_time_monitoring() {

    echo "Starting real-time monitoring (press Ctrl+C to stop)..."
    trap 'echo "Ctrl+C detected! Return to the menu..."; break' SIGINT
    while true; do
        clear
        list_processes
        sleep 5
    done
    trap - SIGINT
}

# Function to search for processes
search_process() {
    read -p "Enter process name to search: " process_name
    echo "Searching for processes matching '$process_name'..."
    ps aux | grep "$process_name"
}

# Function to check resource usage alerts
resource_alerts() {
    cpu_threshold=50
    mem_threshold=50
    echo "Checking for resource usage alerts..."
    ps aux | awk '{if ($3 > '$cpu_threshold') print "High CPU usage: ", $11, $3; if ($4 > '$mem_threshold') print "High Memory usage: ", $11, $4}'
}

# Main menu using `select`
echo "Welcome to the Process Monitor!"
PS3="Please select an option (1-8): "
options=(
    "List Running Processes"
    "Process Information"
    "Kill a Process"
    "Process Statistics"
    "Real-time Monitoring"
    "Search Process"
    "Resource Usage Alerts"
    "Exit"
)


while true; do

    select opt in "${options[@]}"; do
        case $opt in
            "List Running Processes")
                list_processes
                break
                ;;
            "Process Information")
                process_info
                break
                ;;
            "Kill a Process")
                kill_process
                break
                ;;
            "Process Statistics")
                process_stats
                break
                ;;
            "Real-time Monitoring")
                real_time_monitoring
                break
                ;;
            "Search Process")
                search_process
                break
                ;;
            "Resource Usage Alerts")
                resource_alerts
                break
                ;;
            "Exit")
                echo "Exiting the Process Monitor. Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid option. Please try again."
                break
                ;;
        esac
    done
done