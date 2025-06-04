#! /bin/bash

echo "配置开发工具 tooling"
git clone git@github.com:HL8-ORG/pkg-tooling.git --depth 1 tooling
rm -rf tooling/.git

# 安装 typescript
pnpm add -D typescript -w

# 安装 biome
pnpm add -D @biomejs/biome -w
pnpm add -D @biomejs/biome -w
echo "向 package.json 添加 lint 命令，如果提示是否覆写，请输入 yes"
sleep 2
jq '.scripts += { "check": "biome check ./ --fix","format": "biome format ./ --fix", "lint": "biome lint ./", "lint:fix": "biome lint ./ --fix", }' package.json > temp.json && mv temp.json package.json
touch biome.json
cat << 'EOF'>| biome.json
{
	"$schema": "https://biomejs.dev/schemas/1.9.4/schema.json",
	"extends": ["./tooling/biome/library.json"],
	"files": {
		"ignore": [
			"**/node_modules/**",
			"**/.next/**",
			"**/dist/**",
			"**/.turbo/**",
			"./packages/ui/components.json",
			"./commitlint.config.js",
		]
	}
}
EOF



# git
git add .
git commit -m "feat: created tooling include biome and typescript"