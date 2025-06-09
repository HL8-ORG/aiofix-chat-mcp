import mongoose from "mongoose";

/**
 * 数据库连接缓存类型定义
 * @property {mongoose | null} conn - Mongoose 连接实例
 * @property {Promise<mongoose> | null} promise - Mongoose 连接 Promise
 */
type dbCache = {
  conn: typeof mongoose | null;
  promise: Promise<typeof mongoose> | null;
};

/**
 * 全局对象扩展，添加 mongoose 缓存属性
 */
const mongoGlobal = global as typeof globalThis & {
  mongoose: dbCache;
};

/**
 * 从环境变量获取 MongoDB 连接字符串
 * @throws {Error} 如果未定义 DATABASE_URL 环境变量
 */
const MONGODB_URI = process.env.DATABASE_URL as string;

if (!MONGODB_URI) {
  throw new Error("Please define the DATABASE_URL environment variable");
}

/**
 * 获取或初始化全局缓存对象
 */
const cached = mongoGlobal.mongoose ?? { conn: null, promise: null };
mongoGlobal.mongoose = cached;

/**
 * 连接 MongoDB 数据库
 * @returns {Promise<mongoose>} Mongoose 连接实例
 * @description 实现数据库连接的单例模式，避免重复连接
 */
async function dbConnect(): Promise<typeof mongoose> {
  // 如果已有连接，直接返回
  if (cached.conn) {
    return cached.conn;
  }

  // 如果没有正在进行的连接，创建新的连接
  if (!cached.promise) {
    const opts = {
      bufferCommands: false,
    };

    cached.promise = mongoose.connect(MONGODB_URI, opts).then((mongoose) => {
      return mongoose;
    });
  }

  try {
    // 等待连接完成
    cached.conn = await cached.promise;
  } catch (e) {
    // 连接失败时清除缓存
    cached.promise = null;
    throw e;
  }

  return cached.conn;
}

// 建立数据库连接
const conn = await dbConnect();
// 获取数据库实例
const db = conn.connection.db;
export { db };
