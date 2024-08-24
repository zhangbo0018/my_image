#!/bin/bash

# 定义第三方镜像源数组
registry_mirrors=(
  "https://docker.registry.cyou"
  "https://docker-cf.registry.cyou"
  "https://docker.jsdelivr.fyi"
  "https://dockercf.jsdelivr.fyi"
  "https://dockertest.jsdelivr.fyi"
  "https://dockerpull.com"
  "https://dockerproxy.cn"
  "https://hub.uuuadc.top"
  "https://docker.1panel.live"
  "https://hub.rat.dev"
  "https://docker.anyhub.us.kg"
  "https://docker.chenby.cn"
  "https://dockerhub.jobcher.com"
  "https://dockerhub.icu"
  "https://docker.ckyl.me"
  "https://docker.awsl9527.cn"
  "https://docker.hpcloud.cloud"
  "https://docker.m.daocloud.io"
  "https://atomhub.openatom.cn"
)

# 检查daemon.json文件是否存在，如果不存在则创建
if [ ! -f /etc/docker/daemon.json ]; then
  echo "{}" | sudo tee /etc/docker/daemon.json > /dev/null
fi

# 安装jq
sudo apt install jq -y

# 将镜像源数组转换为 JSON 数组字符串
mirrors_json=$(printf '%s\n' "${registry_mirrors[@]}" | jq -R . | jq -s .)

# 创建新的 JSON 配置，直接覆盖原有配置
new_config=$(jq -n --argjson mirrors "$mirrors_json" '{ "registry-mirrors": $mirrors }')

# 将新的配置写回daemon.json文件
echo "$new_config" | sudo tee /etc/docker/daemon.json > /dev/null

# 重启Docker服务以使配置生效
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Docker registry mirrors have been updated and Docker service has been restarted."
