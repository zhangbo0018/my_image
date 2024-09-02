#!/bin/bash

# 判断/root/data文件夹是否存在，如果不存在则新建
if [ ! -d "/root/data" ]; then
  sudo mkdir -p /root/data
fi

# 进入/root/data目录
cd /root/data

# 更新包列表
sudo apt update

# 安装wget
sudo apt install wget -y

# 下载MySQL APT配置包
wget https://repo.mysql.com/mysql-apt-config_0.8.29-1_all.deb

# 预设MySQL APT配置包选项
sudo dpkg -i mysql-apt-config_0.8.29-1_all.deb

# 再次更新包列表以包含MySQL 8的存储库
sudo apt update

# 安装MySQL 8服务器
sudo apt install mysql-server -y

# 启动MySQL服务
sudo systemctl start mysql

# 设置MySQL服务开机自启动
sudo systemctl enable mysql

# 输出MySQL服务状态
sudo systemctl status mysql

# 设置本地root用户密码
LOCAL_ROOT_PASSWORD="123456"
# sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$LOCAL_ROOT_PASSWORD';"

# 创建具有远程访问权限的root用户
REMOTE_ROOT_PASSWORD="test"
sudo mysql -uroot -p$LOCAL_ROOT_PASSWORD -e "CREATE USER 'root'@'%' IDENTIFIED BY '$REMOTE_ROOT_PASSWORD';"
sudo mysql -uroot -p$LOCAL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
sudo mysql -uroot -p$LOCAL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# 开启远程访问
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

# 提示用户进行MySQL安全安装
echo "请运行以下命令进行MySQL安全安装："
echo "sudo mysql_secure_installation"