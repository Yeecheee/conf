#!/bin/bash

# 主菜单函数
main_menu() {
    clear
    echo "主菜单"
    echo "1. 换源"
    echo "2. 安装 Docker"
    echo "3. 安装 zsh 和 oh-my-zsh"
    echo "0. 其他功能"
    echo "q. 退出"
    
    read -p "请选择一个功能: " choice
    case $choice in
        1) execute_remote_script ;;
        2) install_docker ;;
        3) install_zsh_AND_oh_my_zsh ;;

        0) other_function ;;
        q) exit 0 ;;
        *) echo "无效选项，请重新选择." ; read -p "按 Enter 键返回主菜单..." ;main_menu;
    esac
}

# 执行远程脚本
execute_remote_script() {
    echo "正在执行远程脚本..."
    bash <(curl -sSL https://linuxmirrors.cn/main.sh)
    read -p "按任意键返回主菜单..." -n1 -s
    main_menu
}

install_docker() {
    echo "正在运行 Docker 安装脚本"

    curl -fsSL https://get.docker.com -o get-docker.sh

    sudo sh get-docker.sh

    read -p "按任意键返回主菜单..." -n1 -s
    main_menu
}


# 安装 zsh 和 oh-my-zsh
install_zsh_AND_oh_my_zsh() {
    echo "正在安装 zsh 和 oh-my-zsh..."

    # 更新系统包列表
    sudo apt update

    # 安装 zsh
    sudo apt install -y zsh

    # 更改默认 shell 为 zsh
    chsh -s $(which zsh)

    # 安装 oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # 选择主题
    DEFAULT_THEME="suvash"
    read -p "请输入主题名称（默认为 $DEFAULT_THEME）： " theme
    theme=${theme:-$DEFAULT_THEME}
    echo "设置主题为 $theme..."
    sed -i "s/^ZSH_THEME=\".*\"/ZSH_THEME=\"$theme\"/" ~/.zshrc

    # 选择插件
    plugins=("z" "extract" "zsh-completions" "zsh-autosuggestions")
    for plugin in "${plugins[@]}"; do
        read -p "是否启用插件 $plugin？[y/n] (默认为 y): " enable
        enable=${enable:-y}
        if [[ $enable == "y" ]]; then
            echo "安装插件 $plugin..."
            git clone https://github.com/zsh-users/$plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin
            echo "启用插件 $plugin..."
            sed -i "/^plugins=(/ s/)/ $plugin)/" ~/.zshrc
        fi
    done

    # 提示重新启动
    echo "安装完成。请重新启动终端以应用更改。"
    read -p "按任意键返回主菜单..." -n1 -s
    main_menu
}

# 其他功能的示例
other_function() {
    echo "其他功能尚未实现。"
    read -p "按任意键返回主菜单..." -n1 -s
    main_menu
}

# 启动主菜单
main_menu
