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
 
}