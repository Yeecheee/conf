#!/bin/bash

# 获取主机名
hostname=$(hostname)
# 获取当前日期
date=$(date +%Y%m%d)
# 设置密钥文件名
key_filename="${hostname}_${date}"

# 1. 允许 root 登录
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 2. 允许密码登录
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 3. 允许密钥登录
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# 4. 重新加载 SSH 服务
systemctl reload sshd

# 5. 生成 SSH 密钥（不需要用户进行操作）
ssh-keygen -t rsa -b 2048 -f ~/.ssh/${key_filename} -N ""

# 6. 创建 .ssh 目录并设置权限
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 7. 将公钥复制到 authorized_keys 并设置权限
cat ~/.ssh/${key_filename}.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 8. 显示私钥
echo "============================================================"
echo "Your private key is:"
echo "============================================================"

echo ""
cat ~/.ssh/${key_filename}
echo ""

# 提示用户保存公钥
echo "============================================================"
echo "Your public key is located at ~/.ssh/${key_filename}.pub"
echo "============================================================"
