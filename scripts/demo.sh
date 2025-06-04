#!/bin/bash

# 判断是否存在 examples/web 目录，如果存在，则删除
if [ -d "examples/web" ]; then
  echo "examples/web 目录已存在，请先删除"
  exit 1
fi

# 判断是否存在 examples/web 目录，如果不存在，则创建
if [ ! -d "examples/web" ]; then
  echo "我将在 examples 目录下创建一个新的子项目"
  git clone https://github.com/HL8-ORG/pkg-examples-web.git --depth 1 examples/web
fi

# 安装依赖
echo "代码下载完成，下一步安装依赖"
pnpm install

# git
git add .
git commit -m "feat: created examples/web"
