# ohmyfetch - 轻量级系统信息获取工具（fastfetch兼容）

`ohmyfetch` 是一个用 Bash 编写的轻量级系统信息获取工具，兼容 `fastfetch` 的配置文件格式。它可以在终端中显示系统信息，并支持自定义 ASCII 艺术字、图标和模块布局，适合用于终端欢迎屏或系统状态快速查看。

---

## ✨ 功能特点

- 轻量快速，纯 Bash 实现
- 兼容 `fastfetch` JSON 配置文件格式
- 支持 Nerd Font 图标显示
- 可自定义 ASCII 艺术字
- 模块化显示：CPU、内存、磁盘、IP、GPU、DE 等
- 支持配置文件热加载
- 自动生成默认配置文件

---

## ⚙️  使用说明

### 1. 安装

```bash
# 1. 克隆仓库
git clone https://github.com/Oiiai/oh-my-fetchhhhh.git
cd oh-my-fetchhhhh

# 2. 安装脚本
sudo install -Dm755 myfetch.sh /usr/local/bin/ohmyfetch
```

### 2. 配置

```bash
# 1. 设置别名 (zsh方法)
nano ~/.zshrc

# 在结尾添加：
alias omf='ohmyfetch'

# 按^O Enter ^X保存并退出

# 2. 生成配置文件
ohmyfetch --generate-cfg
omf --generate-cfg         # 如果你设置了别名
```

### 3. 使用

```bash
ohmyfetch

# 生成配置文件
ohmyfetch --generate-cfg

# 查看帮助
ohmyfetch --help

# 查看版本
ohmyfetch --version
```
## 🎨 配置文件说明

### 编辑 `~/.config/ohmyfetch/config.jsonc` 文件

可直接复制 `fastfetch` 的配置文件，稍作修改即可直接使用

### 编辑 `~/.config/ohmyfetch/ascii.cfg` 文件

格式如下

```bash
"${RED}  __            ___                ${NC}\n"
"${ORANGE} /  )/  /|/|   (_  _ _/_ / / / / / ${NC}\n"
"${YELLOW}(__//) /   |(/ /  (- /( /)/)/)/)/) ${NC}\n"
"${GREEN}            /                      ${NC}\n"
```

支持的颜色变量：
- `${RED}` `${ORANGE}` `${YELLOW}` `${GREEN}` `${CYAN}` `${BLUE}` `${PURPLE}`
- 无颜色 `${NC}`

## 截图
![](https://github.com/Oiiai/oh-my-fetchhhhh/blob/main/screenshot_1.png?raw=true)

## 鸣谢
- 灵感来源于 fastfetch
- 制作 [deepseek](https://deepseek.com/)
