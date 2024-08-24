#!/bin/sh
echo '删除系统自带docker'
sudo apt-get remove -y docker \
   docker-client \
   docker-client-latest \
   docker-ce-cli \
   docker-common \
   docker-latest \
   docker-latest-logrotate \
   docker-logrotate \
   docker-selinux \
   docker-engine-selinux \
   docker-engine
echo '更新 apt-get'
sudo apt-get update

echo '安装docker依赖'
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

echo '添加key'
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -

echo '添加库下载地址'
sudo add-apt-repository \
   "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian \
   $(lsb_release -cs) \
   stable"

echo '安装最新docker'
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# 确认 Docker 安装成功
if ! systemctl list-unit-files | grep -q 'docker.service'; then
    echo "Docker service file not found, installation might have failed."
    exit 1
fi

echo 'docker开机启动'
sudo systemctl enable docker

echo '启动docker'
sudo systemctl start docker

echo 'docker国内源替换'
sudo echo -e '{"registry-mirrors": ["https://docker.registry.cyou"]}' > /etc/docker/daemon.json

echo '重新加载docker配置文件'
sudo systemctl daemon-reload

echo '重启docker'
sudo systemctl restart docker