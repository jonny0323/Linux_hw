#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 파일 경로
QUIZ_FILE="problem.txt"
LOG_FILE="log.txt"

# 점수 변수
correct=0
total=0

# 로고 출력
show_logo() {
    clear
    echo -e "${BLUE}"
    echo "================================"
    echo "   초등학생 퀴즈 프로그램 🎓"
    echo "================================"
    echo -e "${NC}"
}


# 프로그램 종료
exit_program() {
    show_logo
    echo -e "${GREEN}공부하느라 수고했어요! 👋${NC}"
    echo ""
    exit 0
}

# 메인 메뉴
main_menu() {
    while true; do
        show_logo
        echo "1. 퀴즈 시작 (랜덤 5문제)"
        echo "2. 학습 기록 보기"
        echo "3. 통계 보기"
        echo "4. 종료"
        echo ""
        echo -n "메뉴 선택 (1-4): "
        read menu_choice < /dev/tty
        
        case $menu_choice in
            1)
                correct=0
                total=0
                start_quiz
                ;;
            2)
                view_logs
                ;;
            3)
                view_statistics
                ;;
            4)
                exit_program
                ;;
            *)
                echo -e "${RED}잘못된 선택입니다!${NC}"
                sleep 1
                ;;
        esac
    done
}

# 파일 존재 확인
if [ ! -f "$QUIZ_FILE" ]; then
    echo -e "${RED}오류: problem.txt 파일이 없습니다!${NC}"
    echo "현재 위치: $(pwd)"
    echo "파일 목록:"
    ls -la *.txt 2>/dev/null || echo "txt 파일이 없습니다."
    exit 1
fi

# 프로그램 시작
main_menu