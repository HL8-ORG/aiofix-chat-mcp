#!/bin/bash
# 删除当前目录下除外 scripts 目录和 README.md 文件的所有文件
find . -mindepth 1 -maxdepth 1 ! -name 'scripts' ! -name 'README.md' -exec rm -rf {} +

# 获取系统时间
current_time=$(date "+%Y-%m-%d %H:%M:%S")

# 获取当前目录名
current_dir_name=$(basename $(pwd))

# 创建 package.json 文件
touch package.json
cat << EOF >| package.json
{
  "name": "$current_dir_name",
  "version": "0.0.0",
  "description": "这是一个 monorepo 创建于 $current_time",
  "main": "index.js",
  "scripts": {
    "repo:build": "bash scripts/build.sh",
    "repo:init": "bash scripts/init.sh",
    "repo:git": "bash scripts/git.sh",
    "repo:tooling": "bash scripts/tooling.sh",
    "repo:ui": "bash scripts/ui.sh",
    "repo:demo": "bash scripts/demo.sh",
    "repo:all-in-one": "bash scripts/all-in-one.sh"
  }
}
EOF

echo "我已经生成 package.json 文件，你可以根据 scripts 脚本进行操作"