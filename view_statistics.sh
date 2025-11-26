view_statistics() {
    show_logo

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
    echo -e "${BLUE}===== 카테고리별 피드백 =====${NC}"
    echo ""
    
    # 각 카테고리별 피드백
    for cat in "수학" "국어" "영어"; do
        total_cat=$(grep "|${cat}|" "$LOG_FILE" 2>/dev/null | wc -l)
        total_cat=$(echo $total_cat | tr -d ' ')
        correct_cat=$(grep "|${cat}|.*|정답$" "$LOG_FILE" 2>/dev/null | wc -l)
        correct_cat=$(echo $correct_cat | tr -d ' ')
        
        if [ $total_cat -gt 0 ]; then
            percentage=$((correct_cat * 100 / total_cat))
            
            # 정답률 구간별 피드백 (20% 단위)
            if [ $percentage -ge 80 ]; then
                feedback="🎉 훌륭해요! 완벽하게 이해하고 있어요!"
                color="${GREEN}"
            elif [ $percentage -ge 60 ]; then
                feedback="👍 잘했어요! 조금만 더 연습하면 완벽해요!"
                color="${GREEN}"
            elif [ $percentage -ge 40 ]; then
                feedback="💪 조금만 더 힘내요! 복습이 필요해요!"
                color="${YELLOW}"
            elif [ $percentage -ge 20 ]; then
                feedback="📚 더 열심히 공부해요! 기초를 다져요!"
                color="${YELLOW}"
            else
                feedback="✏️ 처음부터 다시 공부해요! 화이팅!"
                color="${RED}"
            fi
            
            echo -e "${color}[${cat}] ${feedback}${NC}"
        fi
    done
    
    echo ""
    echo -n "계속하려면 Enter를 누르세요..."
    read dummy < /dev/tty
    }