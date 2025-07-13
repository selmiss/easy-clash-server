#!/bin/bash

# 用法: ./list_nodes.sh "代理组名"
GROUP="$1"
SECRET="set-your-secret"
CONTROLLER="127.0.0.1:9097"

if [ -z "$GROUP" ]; then
  echo "用法: $0 <代理组名>"
  exit 1
fi

# URL 编码组名
ENC_GROUP=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$GROUP'''))")

# 请求并列出节点
echo "📦 代理组 [$GROUP] 的可选节点："
curl -s -H "Authorization: Bearer $SECRET" \
     http://$CONTROLLER/proxies/$ENC_GROUP | jq '.all'
