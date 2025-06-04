#!/bin/b
# 判断是否存在 packages/ui 目录，如果存在，则删除
if [ -d "packages/ui" ]; then
  rm -rf packages/ui
fi

echo "集成 ui.shadcn 组件库"
sleep 1
echo "创建 ui 组件库项目"
mkdir -p packages/ui
mkdir -p packages/ui/src
mkdir -p packages/ui/src/components
mkdir -p packages/ui/src/hooks
mkdir -p packages/ui/src/lib
mkdir -p packages/ui/src/styles
touch packages/ui/package.json
cat << EOF >| packages/ui/package.json
{
  "name": "@pkg/ui",
  "version": "0.0.0",
  "type": "module",
  "private": true,
  "scripts": {
    "ui-add": "pnpm dlx shadcn@latest add"
  },
  "dependencies": {
    "@radix-ui/react-avatar": "^1.1.10",
    "@radix-ui/react-collapsible": "^1.1.11",
    "@radix-ui/react-dialog": "^1.1.14",
    "@radix-ui/react-dropdown-menu": "^2.1.15",
    "@radix-ui/react-separator": "^1.1.7",
    "@radix-ui/react-slot": "^1.1.2",
    "@radix-ui/react-tooltip": "^1.2.7",
    "class-variance-authority": "^0.7.1",
    "clsx": "^2.1.1",
    "lucide-react": "^0.475.0",
    "next-themes": "^0.4.4",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "tailwind-merge": "^3.0.1",
    "tw-animate-css": "^1.2.4",
    "zod": "^3.24.2"
  },
  "devDependencies": {
    "@tailwindcss/postcss": "^4.0.8",
    "@types/node": "^20",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "@pkg/tsconfig": "workspace:*",
    "tailwind-scrollbar": "^4.0.2",
    "tailwindcss": "^4.0.8",
    "typescript": "^5.7.3"
  },
  "exports": {
    "./globals.css": "./src/styles/globals.css",
    "./postcss.config": "./postcss.config.mjs",
    "./lib/*": "./src/lib/*.ts",
    "./components/*": "./src/components/*.tsx",
    "./hooks/*": "./src/hooks/*.ts"
  }
}
EOF
touch packages/ui/tsconfig.json
cat << EOF >| packages/ui/tsconfig.json
{
  "extends": "@pkg/tsconfig/internal-package.json",
  "compilerOptions": {
    "jsx": "preserve",
    "baseUrl": ".",
    "paths": {
      "@pkg/ui/*": ["./src/*"]
    },
    "lib": ["dom", "esnext"]
  },
  "include": ["."],
  "exclude": ["node_modules", "dist"]
}
EOF
echo "创建 shadcn 组件管理配置文件 components.json"
sleep 1
touch packages/ui/components.json
cat << 'EOF' > packages/ui/components.json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "src/styles/globals.css",
    "baseColor": "neutral",
    "cssVariables": true
  },
  "iconLibrary": "lucide",
  "aliases": {
    "components": "@pkg/ui/components",
    "utils": "@pkg/ui/lib/utils",
    "hooks": "@pkg/ui/hooks",
    "lib": "@pkg/ui/lib",
    "ui": "@pkg/ui/components"
  }
}
EOF

touch packages/ui/src/lib/utils.ts
cat << EOF >| packages/ui/src/lib/utils.ts
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

EOF
touch packages/ui/src/hooks/use-mobile.ts
cat << 'EOF' >| packages/ui/src/hooks/use-mobile.ts
import * as React from "react"

const MOBILE_BREAKPOINT = 768

export function useIsMobile() {
  const [isMobile, setIsMobile] = React.useState<boolean | undefined>(undefined)

  React.useEffect(() => {
    const mql = window.matchMedia(`(max-width: ${MOBILE_BREAKPOINT - 1}px)`)
    const onChange = () => {
      setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
    }
    mql.addEventListener("change", onChange)
    setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
    return () => mql.removeEventListener("change", onChange)
  }, [])

  return !!isMobile
}

EOF
# tailwindcss V4
echo "集成 tailwindcss V4"
sleep 1
echo "创建 postcss.config.mjs 文件"
sleep 1
touch packages/ui/postcss.config.mjs
cat << EOF >| packages/ui/postcss.config.mjs
/** @type {import('postcss-load-config').Config} */
const config = {
    plugins: { "@tailwindcss/postcss": {} },
};

export default config;
EOF
echo "创建全局可共享的样式文件 globals.css"
sleep 1
touch packages/ui/src/styles/globals.css
cat << EOF >| packages/ui/src/styles/globals.css
@import "tailwindcss";
@source "../../../apps/**/*.{ts,tsx}";
@source "../../examples/**/*.{ts,tsx}";
@source "../../../components/**/*.{ts,tsx}";
@source "../**/*.{ts,tsx}";

@import "tw-animate-css";

@plugin 'tailwind-scrollbar' {
    nocompatible: true;
}

@custom-variant dark (&:is(.dark *));


@layer base {
  * {
    @apply border-border outline-ring/50;
  }
  body {
    @apply bg-background text-foreground;
  }
}

/* scrollbar */
.scrollbar-thin::-webkit-scrollbar-thumb {
  background: var(--scrollbar-thumb);
}
.scrollbar-thin::-webkit-scrollbar-track {
  background: var(--scrollbar-track);
}

/* 自定义样式可以通过 https://tweakcn.com/ 来实现 */

:root {
  --background: oklch(0.9777 0.0041 301.4256);
  --foreground: oklch(0.3651 0.0325 287.0807);
  --card: oklch(1.0000 0 0);
  --card-foreground: oklch(0.3651 0.0325 287.0807);
  --popover: oklch(1.0000 0 0);
  --popover-foreground: oklch(0.3651 0.0325 287.0807);
  --primary: oklch(0.6104 0.0767 299.7335);
  --primary-foreground: oklch(0.9777 0.0041 301.4256);
  --secondary: oklch(0.8957 0.0265 300.2416);
  --secondary-foreground: oklch(0.3651 0.0325 287.0807);
  --muted: oklch(0.8906 0.0139 299.7754);
  --muted-foreground: oklch(0.5288 0.0375 290.7895);
  --accent: oklch(0.9132 0.0503 138.8507);
  --accent-foreground: oklch(0.3394 0.0441 1.7583);
  --destructive: oklch(0.7155 0.1046 19.9705);
  --destructive-foreground: oklch(0.9777 0.0041 301.4256);
  --border: oklch(0.8447 0.0226 300.1421);
  --input: oklch(0.9329 0.0124 301.2783);
  --ring: oklch(0.6104 0.0767 299.7335);
  --chart-1: oklch(0.6104 0.0767 299.7335);
  --chart-2: oklch(0.7889 0.0802 359.9375);
  --chart-3: oklch(0.7321 0.0749 169.8670);
  --chart-4: oklch(0.8540 0.0882 76.8292);
  --chart-5: oklch(0.7857 0.0645 258.0839);
  --sidebar: oklch(0.9554 0.0082 301.3541);
  --sidebar-foreground: oklch(0.3651 0.0325 287.0807);
  --sidebar-primary: oklch(0.6104 0.0767 299.7335);
  --sidebar-primary-foreground: oklch(0.9777 0.0041 301.4256);
  --sidebar-accent: oklch(0.8837 0.0152 260.7287);
  --sidebar-accent-foreground: oklch(0.3394 0.0441 1.7583);
  --sidebar-border: oklch(0.8719 0.0198 302.1690);
  --sidebar-ring: oklch(0.6104 0.0767 299.7335);
  --font-sans: Geist, sans-serif;
  --font-serif: "Lora", Georgia, serif;
  --font-mono: "Fira Code", "Courier New", monospace;
  --radius: 0.5rem;
  --shadow-2xs: 1px 2px 5px 1px hsl(0 0% 0% / 0.01);
  --shadow-xs: 1px 2px 5px 1px hsl(0 0% 0% / 0.01);
  --shadow-sm: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 1px 2px 0px hsl(0 0% 0% / 0.03);
  --shadow: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 1px 2px 0px hsl(0 0% 0% / 0.03);
  --shadow-md: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 2px 4px 0px hsl(0 0% 0% / 0.03);
  --shadow-lg: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 4px 6px 0px hsl(0 0% 0% / 0.03);
  --shadow-xl: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 8px 10px 0px hsl(0 0% 0% / 0.03);
  --shadow-2xl: 1px 2px 5px 1px hsl(0 0% 0% / 0.07);
}

.dark {
  --background: oklch(0.2166 0.0215 292.8474);
  --foreground: oklch(0.9053 0.0245 293.5570);
  --card: oklch(0.2544 0.0301 292.7315);
  --card-foreground: oklch(0.9053 0.0245 293.5570);
  --popover: oklch(0.2544 0.0301 292.7315);
  --popover-foreground: oklch(0.9053 0.0245 293.5570);
  --primary: oklch(0.7058 0.0777 302.0489);
  --primary-foreground: oklch(0.2166 0.0215 292.8474);
  --secondary: oklch(0.4604 0.0472 295.5578);
  --secondary-foreground: oklch(0.9053 0.0245 293.5570);
  --muted: oklch(0.2560 0.0320 294.8380);
  --muted-foreground: oklch(0.6974 0.0282 300.0614);
  --accent: oklch(0.3181 0.0321 308.6149);
  --accent-foreground: oklch(0.8391 0.0692 2.6681);
  --destructive: oklch(0.6875 0.1420 21.4566);
  --destructive-foreground: oklch(0.2166 0.0215 292.8474);
  --border: oklch(0.3063 0.0359 293.3367);
  --input: oklch(0.2847 0.0346 291.2726);
  --ring: oklch(0.7058 0.0777 302.0489);
  --chart-1: oklch(0.7058 0.0777 302.0489);
  --chart-2: oklch(0.8391 0.0692 2.6681);
  --chart-3: oklch(0.7321 0.0749 169.8670);
  --chart-4: oklch(0.8540 0.0882 76.8292);
  --chart-5: oklch(0.7857 0.0645 258.0839);
  --sidebar: oklch(0.1985 0.0200 293.6639);
  --sidebar-foreground: oklch(0.9053 0.0245 293.5570);
  --sidebar-primary: oklch(0.7058 0.0777 302.0489);
  --sidebar-primary-foreground: oklch(0.2166 0.0215 292.8474);
  --sidebar-accent: oklch(0.3181 0.0321 308.6149);
  --sidebar-accent-foreground: oklch(0.8391 0.0692 2.6681);
  --sidebar-border: oklch(0.2847 0.0346 291.2726);
  --sidebar-ring: oklch(0.7058 0.0777 302.0489);
  --font-sans: Geist, sans-serif;
  --font-serif: "Lora", Georgia, serif;
  --font-mono: "Fira Code", "Courier New", monospace;
  --radius: 0.5rem;
  --shadow-2xs: 1px 2px 5px 1px hsl(0 0% 0% / 0.01);
  --shadow-xs: 1px 2px 5px 1px hsl(0 0% 0% / 0.01);
  --shadow-sm: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 1px 2px 0px hsl(0 0% 0% / 0.03);
  --shadow: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 1px 2px 0px hsl(0 0% 0% / 0.03);
  --shadow-md: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 2px 4px 0px hsl(0 0% 0% / 0.03);
  --shadow-lg: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 4px 6px 0px hsl(0 0% 0% / 0.03);
  --shadow-xl: 1px 2px 5px 1px hsl(0 0% 0% / 0.03), 1px 8px 10px 0px hsl(0 0% 0% / 0.03);
  --shadow-2xl: 1px 2px 5px 1px hsl(0 0% 0% / 0.07);
}

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --color-card: var(--card);
  --color-card-foreground: var(--card-foreground);
  --color-popover: var(--popover);
  --color-popover-foreground: var(--popover-foreground);
  --color-primary: var(--primary);
  --color-primary-foreground: var(--primary-foreground);
  --color-secondary: var(--secondary);
  --color-secondary-foreground: var(--secondary-foreground);
  --color-muted: var(--muted);
  --color-muted-foreground: var(--muted-foreground);
  --color-accent: var(--accent);
  --color-accent-foreground: var(--accent-foreground);
  --color-destructive: var(--destructive);
  --color-destructive-foreground: var(--destructive-foreground);
  --color-border: var(--border);
  --color-input: var(--input);
  --color-ring: var(--ring);
  --color-chart-1: var(--chart-1);
  --color-chart-2: var(--chart-2);
  --color-chart-3: var(--chart-3);
  --color-chart-4: var(--chart-4);
  --color-chart-5: var(--chart-5);
  --color-sidebar: var(--sidebar);
  --color-sidebar-foreground: var(--sidebar-foreground);
  --color-sidebar-primary: var(--sidebar-primary);
  --color-sidebar-primary-foreground: var(--sidebar-primary-foreground);
  --color-sidebar-accent: var(--sidebar-accent);
  --color-sidebar-accent-foreground: var(--sidebar-accent-foreground);
  --color-sidebar-border: var(--sidebar-border);
  --color-sidebar-ring: var(--sidebar-ring);

  --font-sans: var(--font-sans);
  --font-mono: var(--font-mono);
  --font-serif: var(--font-serif);

  --radius-sm: calc(var(--radius) - 4px);
  --radius-md: calc(var(--radius) - 2px);
  --radius-lg: var(--radius);
  --radius-xl: calc(var(--radius) + 4px);

  --shadow-2xs: var(--shadow-2xs);
  --shadow-xs: var(--shadow-xs);
  --shadow-sm: var(--shadow-sm);
  --shadow: var(--shadow);
  --shadow-md: var(--shadow-md);
  --shadow-lg: var(--shadow-lg);
  --shadow-xl: var(--shadow-xl);
  --shadow-2xl: var(--shadow-2xl);
}
EOF

pnpm install
# git
git add .
git commit -m "feat: created @pkg/ui and integrated ui.shadcn and tailwindcss V4"