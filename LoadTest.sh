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

# 결과 출력
show_result() {
    show_logo
    echo -e "${BLUE}===== 퀴즈 결과 =====${NC}"
    echo ""
    echo -e "총 문제 수: ${total}문제"
    echo -e "${GREEN}정답: ${correct}개${NC}"
    echo -e "${RED}오답: $((total - correct))개${NC}"
    
    if [ $total -gt 0 ]; then
        percentage=$((correct * 100 / total))
        echo ""
        echo -e "정답률: ${percentage}%"
        
        if [ $percentage -ge 80 ]; then
            echo -e "${GREEN}🎉 훌륭해요!${NC}"
        elif [ $percentage -ge 60 ]; then
            echo -e "${YELLOW}👍 잘했어요!${NC}"
        else
            echo -e "${YELLOW}💪 조금만 더 힘내요!${NC}"
        fi
    fi
    
    echo ""
    echo -n "계속하려면 Enter를 누르세요..."
    read dummy < /dev/tty
}

# 문제 출제
ask_question() {
    local question=$1
    local answer=$2
    local category_name=$3
    
    echo ""
    echo -e "${BLUE}[${category_name}] 문제${NC}"
    echo -e "${YELLOW}${question}${NC}"
    echo ""
    
    # /dev/tty로 직접 입력받기
    echo -n "답: "
    read user_answer < /dev/tty
    
    # 정답 확인 (띄어쓰기 제거 후 비교)
    user_answer=$(echo "$user_answer" | tr -d ' ')
    answer=$(echo "$answer" | tr -d ' ')
    
    total=$((total + 1))
    
    if [ "$user_answer" = "$answer" ]; then
        echo -e "${GREEN}✓ 정답입니다!${NC}"
        correct=$((correct + 1))
        result="정답"
    else
        echo -e "${RED}✗ 오답입니다. 정답은 '${answer}'입니다.${NC}"
        result="오답"
    fi
    
    sleep 2
}