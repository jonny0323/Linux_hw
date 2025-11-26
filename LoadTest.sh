start_quiz() {
    local num_questions=5
    
    # 전체 문제 수 확인
    local total_questions=$(wc -l < "$QUIZ_FILE")
    total_questions=$(echo $total_questions | tr -d ' ')
    
    echo "총 문제 수: $total_questions"
    
    if [ $total_questions -lt $num_questions ]; then
        num_questions=$total_questions
    fi
    
    # 이미 출제된 문제 번호 저장
    local used_lines=""
    local question_num=0
    
    while [ $question_num -lt $num_questions ]; do
        # 랜덤 라인 번호 생성 (1부터 시작)
        local rand_line=$((RANDOM % total_questions + 1))
        
        # 이미 사용한 라인인지 확인
        if echo "$used_lines" | grep -q "^${rand_line}$"; then
            continue
        fi
        
        # 사용한 라인에 추가
        used_lines="${used_lines}${rand_line}"$'\n'
        question_num=$((question_num + 1))
        
        # sed로 특정 라인 추출
        local line=$(sed -n "${rand_line}p" "$QUIZ_FILE")
        
        # 빈 줄이면 건너뛰기
        if [ -z "$line" ]; then
            question_num=$((question_num - 1))
            continue
        fi
        
        # 파이프로 파싱
        local question=$(echo "$line" | cut -d'|' -f1)
        local answer=$(echo "$line" | cut -d'|' -f2)
        local category_name=$(echo "$line" | cut -d'|' -f3)
        
        show_logo
        echo -e "${GREEN}점수: ${correct}/${total}${NC}"
        echo -e "${YELLOW}문제 ${question_num}/${num_questions}${NC}"
        
        ask_question "$question" "$answer" "$category_name"
    done
    
    # 최종 결과
    show_result
}