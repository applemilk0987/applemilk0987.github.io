#!/bin/bash

# _sidebar.md 파일 초기화
echo "- [Home](/)" > _sidebar.md
echo "" >> _sidebar.md

# 특정 디렉터리 제외 설정 (img, index.html 등)
EXCLUDE_DIRS=("img" "node_modules" ".git")

# 재귀적으로 파일과 폴더 정리하는 함수
generate_sidebar() {
    local dir_path="$1"
    local indent="$2"

    for entry in "$dir_path"/*; do
        local name=$(basename "$entry")

        # 제외할 디렉터리라면 건너뛴다
        if [[ " ${EXCLUDE_DIRS[*]} " == *" $name "* ]]; then
            continue
        fi

        if [[ -d "$entry" ]]; then
            # 폴더이면 접고 펼칠 수 있도록 처리
            echo "${indent}- **$name**" >> _sidebar.md
            generate_sidebar "$entry" "  $indent"
        elif [[ "$name" == *.md ]]; then
            # 파일이면 링크 추가 (공백은 %20으로 변환)
            local clean_name="${name%.md}"
            local encoded_name=$(echo "$name" | sed 's/ /%20/g')
            echo "${indent}- [$clean_name]($dir_path/$encoded_name)" >> _sidebar.md
        fi
    done
}

# 현재 디렉토리 기준으로 _sidebar.md 생성
generate_sidebar "." ""

echo "✅ _sidebar.md 생성 완료!"