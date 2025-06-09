import { betterAuth } from "better-auth";
// import { nextCookies } from "better-auth/next-js";
import { reactStartCookies } from "better-auth/react-start";
import { admin, createAuthMiddleware } from "better-auth/plugins";
import { db } from "./db";
import { mongodbAdapter } from "better-auth/adapters/mongodb";
import { Db } from "mongodb";
/**
 * 检查数据库连接是否正常
 * @throws {Error} 如果数据库未连接
 */
if (!db) {
  throw new Error("Database not connected");
}

/**
 * 认证系统配置对象
 * @type {import('better-auth').AuthConfig}
 * @property {import('better-auth/adapters/mongodb').MongoDBAdapter} database - MongoDB 适配器
 * @property {Object} emailAndPassword - 邮箱密码认证配置
 * @property {boolean} emailAndPassword.enabled - 是否启用邮箱密码认证
 * @property {Object} hooks - 认证钩子
 * @property {Function} hooks.before - 前置认证中间件
 * @property {Object} account - 账户配置
 * @property {Array} plugins - 认证插件列表
 * @property {Object} databaseHooks - 数据库操作钩子
 * @property {Object} databaseHooks.session - 会话相关钩子
 * @property {Object} databaseHooks.session.create - 创建会话钩子
 * @property {Function} databaseHooks.session.create.before - 创建会话前执行
 * @property {Object} databaseHooks.user - 用户相关钩子
 * @property {Object} databaseHooks.user.update - 更新用户钩子
 * @property {Function} databaseHooks.user.update.before - 更新用户前执行
 * @property {Function} databaseHooks.user.update.after - 更新用户后执行
 * @property {Object} socialProviders - 社交登录提供商配置
 * @property {Object} socialProviders.github - GitHub 登录配置
 * @property {string} socialProviders.github.clientId - GitHub 客户端 ID
 * @property {string} socialProviders.github.clientSecret - GitHub 客户端密钥
 * @property {Object} socialProviders.google - Google 登录配置
 * @property {string} socialProviders.google.clientId - Google 客户端 ID
 * @property {string} socialProviders.google.clientSecret - Google 客户端密钥
 * @property {Object} socialProviders.twitter - Twitter 登录配置
 * @property {string} socialProviders.twitter.clientId - Twitter 客户端 ID
 * @property {string} socialProviders.twitter.clientSecret - Twitter 客户端密钥
 */
export const auth = betterAuth({
  database: mongodbAdapter(db as unknown as Db),
  emailAndPassword: {
    enabled: true,
  },
  hooks: {
    // biome-ignore lint/correctness/noUnusedVariables: <explanation>
    before: createAuthMiddleware(async (ctx) => {}),
  },
  account: {},
  plugins: [admin(), reactStartCookies()],
  databaseHooks: {
    session: {
      create: {
        before: async (session) => {
          console.log("session create", session);
        },
      },
    },
    user: {
      update: {
        before: async (session) => {
          console.log("session update before", session, session);
        },
        after: async (session) => {
          console.log("session update after", session);
        },
      },
    },
  },
  socialProviders: {
    github: {
      clientId: process.env.GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    },
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
    twitter: {
      clientId: process.env.TWITTER_CLIENT_ID!,
      clientSecret: process.env.TWITTER_CLIENT_SECRET!,
    },
  },
});

/**
 * 用户会话类型
 * @typedef {typeof auth.$Infer.Session} UserSession
 */
export type UserSession = typeof auth.$Infer.Session;

/**
 * 用户类型
 * @typedef {UserSession['user']} User
 */
export type User = UserSession["user"];

/**
 * 会话类型
 * @typedef {UserSession['session']} Session
 */
export type Session = UserSession["session"];
