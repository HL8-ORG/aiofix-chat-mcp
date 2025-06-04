#!/bin/bash
echo "创建 typescript 配置"
sleep 2
mkdir -p tooling/typescript
touch tooling/typescript/base.json
touch tooling/typescript/internal-package.json
touch tooling/typescript/package.json
touch tooling/typescript/README.md
cat << EOF >| tooling/typescript/package.json
{
  "name": "@pkg/tsconfig",
  "version": "0.1.0",
  "private": true,
  "files": [
    "*.json"
  ]
}
EOF
echo "创建 写入 typescript 的基础配置"
cat << 'EOF' >| tooling/typescript/base.json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "compilerOptions": {
    "esModuleInterop": true,
    "skipLibCheck": true,
    "target": "ES2022",
    "lib": ["ES2022"],
    "allowJs": true,
    "resolveJsonModule": true,
    "moduleDetection": "force",
    "isolatedModules": true,
    "incremental": true,
    "disableSourceOfProjectReferenceRedirect": true,
    "tsBuildInfoFile": "${configDir}/.cache/tsbuildinfo.json",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "checkJs": true,
    "module": "Preserve",
    "moduleResolution": "Bundler",
    "noEmit": true
  },
  "exclude": ["node_modules", "build", "dist", ".next", ".expo"]
}
EOF
echo "创建 写入内部依赖项目的 typescript 配置"
cat << 'EOF' >| tooling/typescript/internal-package.json
{
  "$schema": "https://json.schemastore.org/tsconfig",
  "extends": "./base.json",
  "compilerOptions": {
    "declaration": true,
    "declarationMap": true,
    "emitDeclarationOnly": true,
    "noEmit": false,
    "outDir": "${configDir}/dist"
  }
}
EOF
echo "创建 写入Typescript配置说明"
cat << EOF >| tooling/typescript/README.md
# TypeScript配置

## 基础配置

tooling/typescript/base.json

## 内部依赖项目配置

tooling/typescript/internal-package.json
EOF

# git 
git add .
git commit -m "feat: created @pkg/tsconfig"