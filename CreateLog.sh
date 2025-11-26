log_result() {
    local category=$1
    local question=$2
    local user_ans=$3
    local correct_ans=$4
    local result=$5
    
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "${timestamp}|${category}|${question}|사용자답:${user_ans}|정답:${correct_ans}|${result}" >> "$LOG_FILE"
}