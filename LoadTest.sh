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
    
    
    # 최종 결과
    show_result
}