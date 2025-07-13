#!/bin/bash

# 测试用的目标网址
SITES=(
  "https://ipinfo.io"
  "https://huggingface.co"
  "https://github.com"
  "https://pypi.org"
  "https://www.google.com"
  "https://www.bing.com"
  "https://www.baidu.com"
  "https://www.youtube.com"
  "https://www.facebook.com"
  "https://www.instagram.com"
  "https://www.twitter.com"
  "https://www.linkedin.com"
  "https://www.reddit.com"
  "https://www.pinterest.com"
)

echo "🌐 [1] 当前 IP 信息："
curl -s --max-time 5 https://ipinfo.io || echo "❌ 无法访问 ipinfo.io"
echo

echo "🔎 [2] 逐个测试常用网站："
for site in "${SITES[@]}"; do
  echo -n "→ $site ... "
  if curl -s --head --max-time 5 "$site" | grep -q "HTTP/"; then
    echo "✅ 可访问"
  else
    echo "❌ 无法访问"
  fi
done
echo

echo "🧪 [3] 当前是否走代理？（检测出口 IP 国家）"
IPINFO=$(curl -s --max-time 5 https://ipinfo.io/country)
if [[ "$IPINFO" == "CN" ]]; then
  echo "🔒 当前出口 IP 属于中国（可能未走代理）"
else
  echo "🚀 当前出口 IP 国家: $IPINFO（已走代理）"
fi
