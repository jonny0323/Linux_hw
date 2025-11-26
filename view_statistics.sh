view_statistics() {
    if [ ! -f "$LOG_FILE" ]; then
        echo -e "${YELLOW}아직 기록이 없습니다.${NC}"
        sleep 2
        return
    fi
    
    echo -e "${BLUE}===== 카테고리별 통계 =====${NC}"
    echo ""
    
    # 헤더
    echo -e "${YELLOW}카테고리 | 총 문제 | 정답  | 오답  | 정답률${NC}"
    echo "================================================"
    
    for cat in "수학" "국어" "영어"; do
        total_cat=$(grep "|${cat}|" "$LOG_FILE" 2>/dev/null | wc -l)
        total_cat=$(echo $total_cat | tr -d ' ')
        correct_cat=$(grep "|${cat}|.*|정답$" "$LOG_FILE" 2>/dev/null | wc -l)
        correct_cat=$(echo $correct_cat | tr -d ' ')
        
        if [ $total_cat -gt 0 ]; then
            wrong_cat=$((total_cat - correct_cat))
            percentage=$((correct_cat * 100 / total_cat))
            
            # 정답률에 따라 색상 변경
            if [ $percentage -ge 80 ]; then
                rate_color="${GREEN}"
            elif [ $percentage -ge 60 ]; then
                rate_color="${YELLOW}"
            else
                rate_color="${RED}"
            fi
            
            # 구분자로 출력
            echo -e "${cat}     | ${total_cat}개     | ${correct_cat}개   | ${wrong_cat}개   | ${rate_color}${percentage}%${NC}"
        fi
    done
    
    echo ""
    }