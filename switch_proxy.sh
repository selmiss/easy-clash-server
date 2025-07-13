#!/bin/bash

# 用法: ./switch_proxy.sh "代理组名" "节点名"
GROUP="$1"
NODE="$2"

# 设置你的 Secret（根据 config.yaml 中设置的 secret 字段）
SECRET="set-your-secret"

# Clash 控制端口地址（本地运行）
CONTROLLER="127.0.0.1:9097"

if [ -z "$GROUP" ] || [ -z "$NODE" ]; then
  echo "用法: $0 <代理组名> <节点名>"
  exit 1
fi


STATUS=$(curl -o /dev/null -s -w "%{http_code}" -X PUT \
  "http://$CONTROLLER/proxies/$GROUP" \
  -H "Authorization: Bearer $SECRET" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"$NODE\"}")

# 判断状态码
if [ "$STATUS" == "204" ]; then
  echo "✅ 节点已成功切换为: $NODE"
else
  echo "❌ 切换失败，请检查节点名称，状态码: $STATUS"
fi
