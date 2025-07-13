# Ubuntu服务器科学上网配置

## 📋 目录
- [安装步骤](#安装步骤)
- [配置代理](#配置代理)
- [测试连接](#测试连接)
- [管理工具](#管理工具)
- [常用命令](#常用命令)

## 🚀 安装步骤

### 1. 创建并进入安装目录
```bash
mkdir ~/easy-clash-server
cd ~/easy-clash-server
```

### 2. 下载 mihomo 二进制文件
进入 [mihomo GitHub 仓库](https://github.com/MetaCubeX/mihomo/releases)，寻找最新和适配的版本

下载适用于 Linux amd64 的二进制文件：
```bash
wget https://github.com/MetaCubeX/mihomo/releases/download/v1.19.11/mihomo-linux-amd64-v1.19.11.gz
```

### 3. 解压并设置权限
```bash
gunzip mihomo-linux-amd64-v1.19.11.gz
mv mihomo-linux-amd64-v1.19.11 clash
chmod +x clash
```

### 4. 创建配置目录
```bash
mkdir -p ./.config/clash
```

### 5. 上传配置文件
将你的 `config.yaml`（从科学上网提供商购买）上传到服务器：
```bash
scp -P <Port> config.yaml <Username>@<your-server>:~/easy-clash-server/.config/clash/config.yaml
```

> **注意：** 确保文件格式正确，删除特殊字符

### 6. 配置环境变量
```bash
export PATH="$HOME/easy-clash-server:$PATH"
echo 'export PATH="$HOME/easy-clash-server:$PATH"' >> ~/.bashrc
source ~/.bashrc
echo 'export PATH="$HOME/easy-clash-server:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## 🔧 配置代理

### 启动 clash
```bash
clash -d ~/easy-clash-server/.config/clash
```

> **提示：** 建议使用 tmux 等后台工具来保持服务运行

### 安装必要工具
```bash
sudo apt update
sudo apt install jq -y
```

### 设置密钥
在 `config.yaml` 里面设置你的 secret 密码：
```bash
export CLASH_SECRET=set-your-secret
```

## 🌐 测试连接

### 配置代理端口
```bash
export http_proxy=http://127.0.0.1:7897
export https_proxy=http://127.0.0.1:7897
```

### 测试连接
```bash
curl https://www.google.com
curl https://huggingface.co
# 可以添加其他想测试的网址
```

## 🛠️ 管理工具

### 查看节点信息
```bash
curl -s -H "Authorization: Bearer <set-your-secret>" http://127.0.0.1:9097/proxies/<group-name> | jq
```
> **说明：** 查看 `now` 字段即可了解当前选择的节点

### 切换节点
```bash
bash switch_proxy.sh <group-name> <node-name>
```

### 测试连通性
```bash
bash connection_test.sh
```

### 列出可用节点
```bash
bash list_nodes.sh <group-name>
```

## 📝 常用命令

### 清除代理环境变量
```bash
unset http_proxy
unset https_proxy
```

### 查看当前连通模式
```bash
curl -s -H "Authorization: Bearer set-your-secret" http://127.0.0.1:9097/configs | jq '.mode'
```
> **说明：** 返回 `direct`、`rule` 或 `global`

### 切换连通模式
直接修改 `config.yaml` 然后重新启动 clash

---

## 📌 注意事项

- **Controller API 端口：** 注意我的 controller API 放在了 9097，需要根据 config 中的 `external-controller` 来判断
- **配置文件：** 确保 `config.yaml` 格式正确，避免特殊字符
- **后台运行：** 建议使用 tmux 或 systemd 来管理 clash 服务
- **端口配置：** 根据你的配置文件调整代理端口（默认 7897）

## 🔐 SSH 配置（使用443端口）

### 创建SSH配置文件
```bash
mkdir -p ~/.ssh
touch ~/.ssh/config
```

### 编辑SSH配置
```bash
nano ~/.ssh/config
```

### 添加以下配置内容
```
Host github.com
    Hostname ssh.github.com
    Port 443
    User git
    IdentityFile ~/.ssh/id_rsa
```

### 测试SSH连接
```bash
ssh -T git@github.com
```

> **说明：** 使用443端口可以绕过一些网络限制，提高SSH连接的稳定性





