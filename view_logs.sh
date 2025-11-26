view_logs(){
    show_logo
    
    if [ ! -f "$LOG_FILE" ]; then
        echo -e "${YELLOW}아직 기록이 없습니다.${NC}"
        sleep 2
        return
    fi
    
    echo -e "${BLUE}===== 학습 기록 =====${NC}"
    echo ""
    
    # 헤더
    echo -e "${YELLOW}시간     | 카테고리 | 문제                      | 입력답     | 정답       | 결과${NC}"
    echo "===================================================================================="
    
    # 최근 20개 기록
    tail -20 "$LOG_FILE" | while IFS='|' read -r timestamp cat question user_ans correct_ans result; do
        # 시간 (시:분:초만 추출)
        time_only=$(echo "$timestamp" | cut -c12-19)
        
        # 문제 길이 제한 (24자)
        short_q=$(echo "$question" | cut -c1-24)
        
        # 답변 정리
        user_ans_clean=$(echo "$user_ans" | sed 's/사용자답://')
        correct_ans_clean=$(echo "$correct_ans" | sed 's/정답://')
        short_u=$(echo "$user_ans_clean" | cut -c1-10)
        short_c=$(echo "$correct_ans_clean" | cut -c1-10)
        
        # 결과 색상
        if [ "$result" = "정답" ]; then
            result_display="${GREEN}정답${NC}"
        else
            result_display="${RED}오답${NC}"
        fi
        
        # 구분자로 출력
        echo -e "${time_only} | ${cat}     | ${short_q} | ${short_u} | ${short_c} | ${result_display}"
    done
    
    echo ""
    echo -e "${YELLOW}(최근 20개 기록)${NC}"
    echo ""
    echo -n "계속하려면 Enter를 누르세요..."
    read dummy < /dev/tty
}