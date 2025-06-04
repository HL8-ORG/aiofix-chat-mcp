#! /bin/bash

echo "安装并配置 biome"
sleep 2
pnpm add -D @biomejs/biome -w
echo "向 package.json 添加 lint 命令，如果提示是否覆写，请输入 yes"
sleep 2
jq '.scripts += { "check": "biome check ./ --fix","format": "biome format ./ --fix", "lint": "biome lint ./", "lint:fix": "biome lint ./ --fix", }' package.json > temp.json && mv temp.json package.json
touch biome.json
cat << 'EOF'>| biome.json
{
	"$schema": "https://next.biomejs.dev/schemas/2.0.0-beta.2/schema.json",
	"vcs": {
		"enabled": true,
		"clientKind": "git",
		"useIgnoreFile": true
	},
	"files": {
		"ignoreUnknown": true
	},
	"css": {
		"assist": {
			"enabled": true
		},
		"formatter": {
			"enabled": true
		}
	},
	"formatter": {
		"enabled": true,
		"indentStyle": "tab"
	},
	"linter": {
		"enabled": true,
		"rules": {
			"recommended": true
		}
	},
	"javascript": {
		"formatter": {
			"quoteStyle": "double"
		}
	},
	"assist": {
		"enabled": true,
		"actions": {
			"source": {
				"organizeImports": "on"
			}
		}
	}
}
EOF

