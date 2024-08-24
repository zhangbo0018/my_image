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

# 读取现有的daemon.json文件内容
existing_config=$(sudo cat /etc/docker/daemon.json)

# 使用jq解析现有的配置并添加新的镜像源
# 如果daemon.json文件为空或没有registry-mirrors字段，则创建该字段
# 如果registry-mirrors字段已存在，则合并镜像源数组
new_config=$(echo$existing_config | jq --argjson mirrors "${registry_mirrors[*]}" '. + { "registry-mirrors": ($mirrors | split(" ")) }')

# 将新的配置写回daemon.json文件
echo $new_config | sudo tee /etc/docker/daemon.json > /dev/null

# 重启Docker服务以使配置生效
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Docker registry mirrors have been updated and Docker service has been restarted."
