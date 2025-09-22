-- 创建数据库和用户
CREATE DATABASE IF NOT EXISTS api_service CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE api_service;

-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_full_name ON users(full_name);

-- 插入示例数据
INSERT INTO users (username, email, full_name, phone, address) VALUES
('admin', 'admin@example.com', '系统管理员', '13800138000', '北京市朝阳区'),
('john_doe', 'john.doe@example.com', '张三', '13800138001', '上海市浦东新区'),
('jane_smith', 'jane.smith@example.com', '李四', '13800138002', '广州市天河区'),
('bob_wilson', 'bob.wilson@example.com', '王五', '13800138003', '深圳市南山区');