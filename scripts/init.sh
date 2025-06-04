#!/bin/bash
# 假如存在`.git`目录，则删除
if [ -d ".git" ]; then
  rm -rf .git
fi
# monorepo 初始化
echo "创建 monorepo 项目"
sleep 2
mkdir -p apps
touch apps/.gitkeep
mkdir -p packages
touch packages/.gitkeep
mkdir -p .vscode
touch .vscode/settings.json
cat << EOF >| .vscode/settings.json
{
  "css.lint.unknownAtRules": "ignore"
}
EOF

echo "创建 pnpm-workspace.yaml 文件，用于定义工作空间"
sleep 2
touch pnpm-workspace.yaml
cat << EOF >| pnpm-workspace.yaml
packages:
  - 'apps/*'
  - 'packages/*'
  - 'examples/*'
  - 'tooling/*'
  - '!**/test/**'
EOF
sleep 2



echo "创建 .npmrc 文件，指定 node 版本和淘宝源"
sleep 2
touch .npmrc
cat << EOF >| .npmrc
node-linker=hoisted
link-workspace-packages=true
# 通过pnpm设置本项目使用的node版本
use-node-version=22.14.0
# .npmrc  项目内设置为淘宝源
registry=https://registry.npmmirror.com
EOF

# 创建`git`本地仓库
echo "git 初始化"
sleep 2
git init
git branch -m "main"
echo "创建 .gitignore 文件，用于忽略一些文件"
touch .gitignore
cat << EOF >| .gitignore
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# Dependencies
node_modules
.pnp
.pnp.js

# Local env files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Testing
coverage

# Turbo
.turbo

# Vercel
.vercel

# Build Outputs
.next/
out/
build
dist


# Debug
npm-debug.log*

# Misc
.DS_Store
*.pem
EOF

echo "写入 git 暂存区"
git add .
git commit -m "chore:created monorepo"