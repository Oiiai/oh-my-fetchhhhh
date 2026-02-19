#!/bin/bash

CONFIG_DIR="$HOME/.config/ohmyfetch"
CONFIG_FILE="$CONFIG_DIR/config.jsonc"
ASCII_FILE="$CONFIG_DIR/ascii.cfg"
DEFAULT_ASCII_FILE="/usr/local/share/ohmyfetch/exam-ascii-config.cfg"

# 颜色定义
RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
MAGENTA='\033[1;35m'
NC='\033[0m'

# 图标定义（Nerd Font）
ICON_OS=""
ICON_HOST=""
ICON_KERNEL=""
ICON_UPTIME=""
ICON_PACKAGES=""
ICON_SHELL=""
ICON_TERMINAL=""
ICON_CPU=""
ICON_MEMORY=""
ICON_DISK=""
ICON_USER=""
ICON_LOAD=""
ICON_IP=""
ICON_GPU="󰍹"
ICON_DE="󰇄"
ICON_NETWORK="󰩟"
ICON_COLORS=""

# 显示帮助信息
show_help() {
    echo "ohmyfetch - 一个轻量级的系统信息获取工具 (fastfetch兼容)"
    echo ""
    echo "用法:"
    echo "  ohmyfetch [选项]"
    echo ""
    echo "选项:"
    echo "  --generate-cfg    生成默认配置文件到 ~/.config/ohmyfetch/"
    echo "  --help            显示此帮助信息"
    echo "  --version         显示版本信息"
    echo ""
    echo "配置文件位置:"
    echo "  ~/.config/ohmyfetch/config.jsonc  - 主配置文件 (与fastfetch兼容)"
    echo "  ~/.config/ohmyfetch/ascii.cfg     - ASCII字符画文件"
}

# 显示版本信息
show_version() {
    echo "ohmyfetch version 1.1.1 (fastfetch兼容)"
}

# 生成默认配置文件
generate_config() {
    mkdir -p "$CONFIG_DIR"
    
    # 生成默认ASCII字符画文件
    if [ ! -f "$ASCII_FILE" ] && [ -f "$DEFAULT_ASCII_FILE" ]; then
        cp "$DEFAULT_ASCII_FILE" "$ASCII_FILE"
        echo "✓ 已创建默认ASCII字符画文件: $ASCII_FILE"
    elif [ ! -f "$ASCII_FILE" ]; then
        cat > "$ASCII_FILE" << 'EOF'
"${RED}  __            ___                ${NC}\n"
"${ORANGE} /  )/  /|/|   (_  _ _/_ / / / / / ${NC}\n"
"${YELLOW}(__//) /   |(/ /  (- /( /)/)/)/)/) ${NC}\n"
"${GREEN}            /                      ${NC}\n"
EOF
        echo "✓ 已创建默认ASCII字符画文件: $ASCII_FILE"
    fi
    
    # 生成默认配置文件
    cat > "$CONFIG_FILE" << 'EOF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "small",
        "padding": {
            "top": 1
        }
    },
    "display": {
        "separator": " "
    },
    "modules": [
        {
            "key": "╭───────────╮",
            "type": "custom"
        },
        {
            "key": "│  user    │",
            "type": "title",
            "format": "{user-name}"
        },
        {
            "key": "│ 󰇅 hname   │",
            "type": "title",
            "format": "{host-name}"
        },
        {
            "key": "│ 󰅐 uptime  │",
            "type": "uptime"
        },
        {
            "key": "│ {icon} distro  │",
            "type": "os"
        },
        {
            "key": "│  kernel  │",
            "type": "kernel"
        },
        {
            "key": "│ 󰇄 desktop │",
            "type": "de"
        },
        {
            "key": "│  term    │",
            "type": "terminal"
        },
        {
            "key": "│  shell   │",
            "type": "shell"
        },
        {
            "key": "│ 󰍛 cpu     │",
            "type": "cpu"
        },
        {
            "key": "│ 󰍹 gpu     │",
            "type": "gpu"
        },
        {
            "key": "│ 󰉉 disk    │",
            "type": "disk",
            "folders": "/"
        },
        {
            "key": "│  memory  │",
            "type": "memory"
        },
        {
            "key": "│ 󰩟 network │",
            "type": "localip"
        },
        {
            "key": "├───────────┤",
            "type": "custom"
        },
        {
            "key": "│  colors  │",
            "type": "colors",
            "symbol": "circle"
        },
        {
            "key": "╰───────────╯",
            "type": "custom"
        }
    ]
}
EOF
    
    echo "✓ 已创建默认配置文件: $CONFIG_FILE"
    echo ""
    echo "配置文件说明:"
    echo "  - 此配置文件与 fastfetch 完全兼容"
    echo "  - 可以直接复制 fastfetch 的配置文件到此目录"
    echo "  - 自定义 ASCII 字符画位于: $ASCII_FILE"
}

# 读取ASCII字符画
read_ascii() {
    if [ -f "$ASCII_FILE" ] && [ -s "$ASCII_FILE" ]; then
        # 文件存在且不为空
        local has_content=0
        while IFS= read -r line; do
            # 跳过空行
            if [ -n "$(echo "$line" | tr -d ' \n\r\t')" ]; then
                has_content=1
                line=$(echo "$line" | sed 's/^"//;s/"$//')
                eval "printf \"$line\""
            fi
        done < "$ASCII_FILE"
        
        # 如果文件没有有效内容，使用默认ASCII
        if [ $has_content -eq 0 ]; then
            printf "${RED}  __            ___                ${NC}\n"
            printf "${ORANGE} /  )/  /|/|   (_  _ _/_ / / / / / ${NC}\n"
            printf "${YELLOW}(__//) /   |(/ /  (- /( /)/)/)/)/) ${NC}\n"
            printf "${GREEN}            /                      ${NC}\n"
        fi
    else
        # 文件不存在或为空，使用默认ASCII
        printf "${RED}  __            ___                ${NC}\n"
        printf "${ORANGE} /  )/  /|/|   (_  _ _/_ / / / / / ${NC}\n"
        printf "${YELLOW}(__//) /   |(/ /  (- /( /)/)/)/)/) ${NC}\n"
        printf "${GREEN}            /                      ${NC}\n"
    fi
    echo
}

# 解析JSON配置文件
parse_config() {
    local config_file="$1"
    MODULES_LIST=()
    
    if [ ! -f "$config_file" ]; then
        return 1
    fi
    
    # 移除注释和空白行
    local clean_config=$(grep -v '^[[:space:]]*//' "$config_file" | grep -v '^[[:space:]]*$' | grep -v '^[[:space:]]*/\*' | grep -v '^[[:space:]]*\*/' | sed 's/,[[:space:]]*$//')
    
    # 提取modules数组部分
    local in_modules=0
    local module_start=0
    local current_module=""
    local bracket_count=0
    
    while IFS= read -r line; do
        # 跳过空行
        [ -z "$line" ] && continue
        
        # 检测modules数组开始
        if [[ "$line" =~ \"modules\"[[:space:]]*:[[:space:]]*\[ ]]; then
            in_modules=1
            continue
        fi
        
        # 在modules数组内
        if [ $in_modules -eq 1 ]; then
            # 计算括号数量
            open_brackets=$(echo "$line" | grep -o '{' | wc -l)
            close_brackets=$(echo "$line" | grep -o '}' | wc -l)
            bracket_count=$((bracket_count + open_brackets - close_brackets))
            
            # 检测模块开始
            if [[ "$line" =~ ^[[:space:]]*\{ ]] && [ $bracket_count -eq 1 ]; then
                module_start=1
                current_module="$line"
            elif [ $module_start -eq 1 ]; then
                current_module="$current_module"$'\n'"$line"
            fi
            
            # 检测模块结束
            if [ $bracket_count -eq 0 ] && [ $module_start -eq 1 ]; then
                MODULES_LIST+=("$current_module")
                module_start=0
                current_module=""
            fi
            
            # 检测modules数组结束
            if [[ "$line" =~ ^[[:space:]]*\] ]]; then
                break
            fi
        fi
    done <<< "$clean_config"
    
    # 提取logo配置
    LOGO_TYPE="small"
    LOGO_PADDING_TOP=1
    
    if echo "$clean_config" | grep -q '"logo"[[:space:]]*:'; then
        logo_section=$(echo "$clean_config" | sed -n '/"logo"[[:space:]]*:/,/}/p')
        if echo "$logo_section" | grep -q '"type"[[:space:]]*:[[:space:]]*"small"'; then
            LOGO_TYPE="small"
        fi
        padding_top=$(echo "$logo_section" | grep '"top"[[:space:]]*:' | sed 's/.*:[[:space:]]*\([0-9]*\).*/\1/')
        [ -n "$padding_top" ] && LOGO_PADDING_TOP=$padding_top
    fi
    
    # 提取display配置
    DISPLAY_SEPARATOR=" "
    if echo "$clean_config" | grep -q '"display"[[:space:]]*:'; then
        separator=$(echo "$clean_config" | grep '"separator"' | sed 's/.*:[[:space:]]*"\([^"]*\)".*/\1/')
        [ -n "$separator" ] && DISPLAY_SEPARATOR="$separator"
    fi
}

# 获取模块值
get_module_value() {
    local type="$1"
    local format="$2"
    local value=""
    
    case "$type" in
        "title")
            if [ "$format" = "{user-name}" ]; then
                value="$(whoami)"
            elif [ "$format" = "{host-name}" ]; then
                value="$(cat /etc/hostname 2>/dev/null || echo 'localhost')"
            fi
            ;;
        "os")
            # 检测发行版
            if [ -f /etc/os-release ]; then
                value=$(grep "^PRETTY_NAME" /etc/os-release | cut -d'"' -f2)
            else
                value="Arch Linux"
            fi
            ;;
        "kernel")
            value="$(uname -r)"
            ;;
        "uptime")
            if [ -f /proc/uptime ]; then
                uptime_seconds=$(cat /proc/uptime | cut -d' ' -f1 | cut -d'.' -f1)
                uptime_days=$((uptime_seconds / 86400))
                uptime_hours=$(( (uptime_seconds % 86400) / 3600 ))
                uptime_minutes=$(( (uptime_seconds % 3600) / 60 ))
                
                if [ $uptime_days -gt 0 ]; then
                    value="${uptime_days}d ${uptime_hours}h ${uptime_minutes}m"
                elif [ $uptime_hours -gt 0 ]; then
                    value="${uptime_hours}h ${uptime_minutes}m"
                else
                    value="${uptime_minutes}m"
                fi
            fi
            ;;
        "de")
            if [ -n "$XDG_CURRENT_DESKTOP" ]; then
                value="$XDG_CURRENT_DESKTOP"
            elif [ -n "$DESKTOP_SESSION" ]; then
                value="$DESKTOP_SESSION"
            else
                value="Unknown"
            fi
            ;;
        "terminal")
            value="${TERM_PROGRAM:-$TERM}"
            [ -z "$value" ] && value="unknown"
            ;;
        "shell")
            value="$(basename ${SHELL:-unknown})"
            ;;
        "cpu")
            if [ -f /proc/cpuinfo ]; then
                cpu_model=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | sed 's/^[ \t]*//')
                cpu_cores=$(grep -c "^processor" /proc/cpuinfo)
                value="$cpu_model ($cpu_cores cores)"
            else
                value="Unknown CPU"
            fi
            ;;
        "gpu")
            if command -v lspci >/dev/null 2>&1; then
                # 获取所有GPU并合并显示
                gpu_info=$(lspci | grep -E "VGA|3D|Display" | cut -d':' -f3- | sed 's/^[ \t]*//' | tr '\n' ',' | sed 's/,$//' | sed 's/,/ \/ /g')
                value="${gpu_info:-Unknown GPU}"
            else
                value="lspci not found"
            fi
            ;;
        "disk")
            folders="${2:-/}"
            # 处理多个文件夹
            IFS=',' read -ra folder_list <<< "$folders"
            local disk_values=()
            for folder in "${folder_list[@]}"; do
                folder=$(echo "$folder" | tr -d '"' | xargs)
                df_output=$(df -h "$folder" 2>/dev/null | tail -n1)
                if [ -n "$df_output" ]; then
                    disk_used=$(echo "$df_output" | awk '{print $3}')
                    disk_total=$(echo "$df_output" | awk '{print $2}')
                    disk_percent=$(echo "$df_output" | awk '{print $5}')
                    disk_values+=("$disk_used / $disk_total ($disk_percent)")
                fi
            done
            value=$(IFS=' / '; echo "${disk_values[*]}")
            ;;
        "memory")
            if [ -f /proc/meminfo ]; then
                total_mem=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
                available_mem=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}')
                total_mem_mb=$((total_mem / 1024))
                available_mem_mb=$((available_mem / 1024))
                used_mem_mb=$((total_mem_mb - available_mem_mb))
                mem_percent=$((used_mem_mb * 100 / total_mem_mb))
                value="${used_mem_mb}MB / ${total_mem_mb}MB (${mem_percent}%)"
            fi
            ;;
        "localip")
            value=$(ip -4 addr show 2>/dev/null | grep -oE 'inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | grep -v '127.0.0.1' | head -n1 | cut -d' ' -f2)
            [ -z "$value" ] && value="No IP"
            ;;
        "packages")
            if command -v pacman >/dev/null 2>&1; then
                packages=$(pacman -Q 2>/dev/null | wc -l)
                value="$packages (pacman)"
            elif command -v dpkg >/dev/null 2>&1; then
                packages=$(dpkg --get-selections 2>/dev/null | wc -l)
                value="$packages (dpkg)"
            elif command -v rpm >/dev/null 2>&1; then
                packages=$(rpm -qa 2>/dev/null | wc -l)
                value="$packages (rpm)"
            fi
            ;;
        "colors")
            value=""
            if [ -n "$3" ] && [ "$3" = "circle" ]; then
                symbol="●"
            else
                symbol="■"
            fi
            for color in {196,202,208,214,220,226,46,82,118,154,21,27,63,99,135,171}; do
                value="${value}\033[38;5;${color}m${symbol}\033[0m "
            done
            ;;
        "custom")
            value=""
            ;;
    esac
    
    echo -e "$value"
}

# 获取模块图标
get_module_icon() {
    local type="$1"
    case "$type" in
        "os") echo "$ICON_OS" ;;
        "host"|"title") echo "$ICON_HOST" ;;
        "kernel") echo "$ICON_KERNEL" ;;
        "uptime") echo "$ICON_UPTIME" ;;
        "packages") echo "$ICON_PACKAGES" ;;
        "shell") echo "$ICON_SHELL" ;;
        "terminal") echo "$ICON_TERMINAL" ;;
        "cpu") echo "$ICON_CPU" ;;
        "memory") echo "$ICON_MEMORY" ;;
        "disk") echo "$ICON_DISK" ;;
        "user") echo "$ICON_USER" ;;
        "loadavg") echo "$ICON_LOAD" ;;
        "localip") echo "$ICON_IP" ;;
        "gpu") echo "$ICON_GPU" ;;
        "de") echo "$ICON_DE" ;;
        "colors") echo "$ICON_COLORS" ;;
        *) echo "•" ;;
    esac
}

# 处理模块
process_module() {
    local module="$1"
    
    # 提取type
    if [[ "$module" =~ \"type\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
        local type="${BASH_REMATCH[1]}"
    else
        return
    fi
    
    # 跳过被注释的模块（通过检查上一行或本行是否有注释标记）
    if [[ "$module" =~ ^[[:space:]]*// ]] || [[ "$module" =~ /\* ]]; then
        return
    fi
    
    # 提取key
    local key=""
    if [[ "$module" =~ \"key\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
        key="${BASH_REMATCH[1]}"
        # 替换图标占位符
        key=$(echo "$key" | sed "s/{icon}/$(get_module_icon "$type")/g")
    fi
    
    # 提取format
    local format=""
    if [[ "$module" =~ \"format\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
        format="${BASH_REMATCH[1]}"
    fi
    
    # 提取folders (for disk)
    local folders="/"
    if [[ "$module" =~ \"folders\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
        folders="${BASH_REMATCH[1]}"
    fi
    
    # 提取symbol (for colors)
    local symbol=""
    if [[ "$module" =~ \"symbol\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
        symbol="${BASH_REMATCH[1]}"
    fi
    
    # 获取值
    local value=""
    case "$type" in
        "disk")
            value=$(get_module_value "$type" "$folders")
            ;;
        "colors")
            value=$(get_module_value "$type" "" "$symbol")
            ;;
        *)
            value=$(get_module_value "$type" "$format")
            ;;
    esac
    
    # 输出
    if [ "$type" = "custom" ]; then
        echo -e "$key"
    elif [ -n "$key" ] && [ -n "$value" ]; then
        # 对齐输出：key固定宽度，value紧接着显示
        printf "%s %s\n" "$key" "$value"
    elif [ -n "$key" ]; then
        echo -e "$key"
    fi
}

# 显示系统信息
show_info() {
    # 解析配置文件
    parse_config "$CONFIG_FILE"
    
    # 显示logo padding
    for ((i=0; i<LOGO_PADDING_TOP; i++)); do
        echo
    done
    
    # 显示ASCII艺术字
    read_ascii
    
    # 如果没有配置文件或解析失败，使用默认显示
    if [ ${#MODULES_LIST[@]} -eq 0 ]; then
        # 默认显示所有信息
        echo -e "${ICON_OS} OS: Arch Linux"
        echo -e "${ICON_HOST} Host: $(cat /etc/hostname 2>/dev/null || echo 'localhost')"
        echo -e "${ICON_KERNEL} Kernel: $(uname -r)"
        
        if [ -f /proc/uptime ]; then
            uptime_seconds=$(cat /proc/uptime | cut -d' ' -f1 | cut -d'.' -f1)
            uptime_days=$((uptime_seconds / 86400))
            uptime_hours=$(( (uptime_seconds % 86400) / 3600 ))
            uptime_minutes=$(( (uptime_seconds % 3600) / 60 ))
            
            if [ $uptime_days -gt 0 ]; then
                uptime="${uptime_days}d ${uptime_hours}h ${uptime_minutes}m"
            elif [ $uptime_hours -gt 0 ]; then
                uptime="${uptime_hours}h ${uptime_minutes}m"
            else
                uptime="${uptime_minutes}m"
            fi
            echo -e "${ICON_UPTIME} Uptime: $uptime"
        fi
        
        if command -v pacman >/dev/null 2>&1; then
            packages=$(pacman -Q 2>/dev/null | wc -l)
            echo -e "${ICON_PACKAGES} Packages: $packages (pacman)"
        fi
        
        echo -e "${ICON_SHELL} Shell: $SHELL"
        echo -e "${ICON_TERMINAL} Terminal: ${TERM:-unknown}"
        
        if [ -f /proc/cpuinfo ]; then
            cpu_model=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | sed 's/^[ \t]*//')
            cpu_cores=$(grep -c "^processor" /proc/cpuinfo)
            echo -e "${ICON_CPU} CPU: $cpu_model ($cpu_cores cores)"
        fi
        
        if [ -f /proc/meminfo ]; then
            total_mem=$(grep "MemTotal" /proc/meminfo | awk '{print $2}')
            available_mem=$(grep "MemAvailable" /proc/meminfo | awk '{print $2}')
            total_mem_mb=$((total_mem / 1024))
            available_mem_mb=$((available_mem / 1024))
            used_mem_mb=$((total_mem_mb - available_mem_mb))
            mem_percent=$((used_mem_mb * 100 / total_mem_mb))
            echo -e "${ICON_MEMORY} Memory: ${used_mem_mb}MB / ${total_mem_mb}MB ($mem_percent%)"
        fi
        
        df_output=$(df -h / 2>/dev/null | tail -n1)
        if [ -n "$df_output" ]; then
            disk_used=$(echo "$df_output" | awk '{print $3}')
            disk_total=$(echo "$df_output" | awk '{print $2}')
            disk_percent=$(echo "$df_output" | awk '{print $5}')
            echo -e "${ICON_DISK} Disk: $disk_used / $disk_total ($disk_percent)"
        fi
        
        echo -e "${ICON_USER} User: $(whoami)"
        
        if [ -f /proc/loadavg ]; then
            loadavg=$(cat /proc/loadavg | awk '{print $1", "$2", "$3}')
            echo -e "${ICON_LOAD} Load: $loadavg"
        fi
        
        ip_addr=$(ip -4 addr show 2>/dev/null | grep -oE 'inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | grep -v '127.0.0.1' | head -n1 | cut -d' ' -f2)
        if [ -n "$ip_addr" ]; then
            echo -e "${ICON_IP} IP: $ip_addr"
        fi
    else
        # 按配置文件顺序显示模块
        for module in "${MODULES_LIST[@]}"; do
            process_module "$module"
        done
    fi
    
    echo
}

# 主程序
case "$1" in
    --generate-cfg)
        generate_config
        ;;
    --help)
        show_help
        ;;
    --version)
        show_version
        ;;
    "")
        show_info
        ;;
    *)
        echo "未知选项: $1"
        echo "使用 'ohmyfetch --help' 查看帮助"
        exit 1
        ;;
esac