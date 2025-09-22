# Java REST API 服务

这是一个基于Spring Boot开发的REST API服务，提供用户管理功能，可以部署到服务器供外部使用。

## 功能特性

- ✅ 用户CRUD操作（创建、读取、更新、删除）
- ✅ 数据验证和错误处理
- ✅ 跨域支持（CORS）
- ✅ API文档（Swagger UI）
- ✅ 健康检查接口
- ✅ 统一响应格式
- ✅ 数据库支持（H2/MySQL）
- ✅ Docker容器化部署
- ✅ Nginx反向代理

## 技术栈

- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Data JPA**
- **H2/MySQL数据库**
- **Maven**
- **Docker**
- **Nginx**

## 快速开始

### 1. 本地开发

#### 环境要求
- Java 17+
- Maven 3.6+

#### 运行步骤

1. **编译项目**
```bash
mvn clean compile
```

2. **运行应用**
```bash
mvn spring-boot:run
```

3. **访问应用**
- API服务: http://localhost:8080
- API文档: http://localhost:8080/swagger-ui.html
- H2控制台: http://localhost:8080/h2-console

### 2. Docker部署

#### 使用Docker Compose（推荐）

1. **构建并启动所有服务**
```bash
docker-compose up -d
```

2. **查看服务状态**
```bash
docker-compose ps
```

3. **停止服务**
```bash
docker-compose down
```

## API接口文档

### 基础信息
- **Base URL**: `http://your-server:8080/api/v1`
- **Content-Type**: `application/json`

### 用户管理接口

#### 1. 创建用户
```http
POST /api/v1/users
Content-Type: application/json

{
  "username": "testuser",
  "email": "test@example.com",
  "fullName": "测试用户",
  "phone": "13800138000",
  "address": "北京市朝阳区"
}
```

#### 2. 获取所有用户
```http
GET /api/v1/users
```

#### 3. 根据ID获取用户
```http
GET /api/v1/users/{id}
```

#### 4. 更新用户
```http
PUT /api/v1/users/{id}
Content-Type: application/json

{
  "username": "updateduser",
  "email": "updated@example.com",
  "fullName": "更新用户"
}
```

#### 5. 删除用户
```http
DELETE /api/v1/users/{id}
```

### 健康检查接口

#### 1. 服务健康检查
```http
GET /api/v1/health
```

#### 2. 简单ping检查
```http
GET /api/v1/health/ping
```

## 响应格式

所有API响应都遵循统一格式：

```json
{
  "success": true,
  "message": "操作成功",
  "data": { ... },
  "timestamp": "2025-01-06T10:30:00",
  "code": 200
}
```

## 部署到服务器

### 方式一：直接部署JAR包

1. **准备服务器环境**
```bash
# 安装Java 17
sudo apt update
sudo apt install openjdk-17-jdk

# 创建应用目录
sudo mkdir -p /opt/api-service
```

2. **上传并运行应用**
```bash
# 上传jar包到服务器
scp target/api-service-1.0.0.jar user@server:/opt/api-service/

# 在服务器上运行
cd /opt/api-service
java -jar api-service-1.0.0.jar --spring.profiles.active=prod
```

### 方式二：Docker部署

1. **安装Docker和Docker Compose**
```bash
# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

2. **部署应用**
```bash
# 上传项目文件到服务器
scp -r . user@server:/opt/api-service/

# 在服务器上启动服务
cd /opt/api-service
docker-compose up -d
```

## 环境变量配置

| 变量名 | 描述 | 默认值 |
|--------|------|--------|
| `SPRING_PROFILES_ACTIVE` | 激活的配置文件 | `default` |
| `DB_USERNAME` | 数据库用户名 | `root` |
| `DB_PASSWORD` | 数据库密码 | `password` |
| `SERVER_PORT` | 服务端口 | `8080` |

## 监控和日志

### 健康检查
- 服务状态: `GET /api/v1/health`
- 简单检查: `GET /api/v1/health/ping`
- Actuator: `GET /actuator/health`

## 故障排除

### 常见问题

1. **端口被占用**
```bash
# 查看端口占用
netstat -tulpn | grep :8080
# 杀死占用进程
sudo kill -9 <PID>
```

2. **数据库连接失败**
- 检查数据库服务是否启动
- 验证连接参数（用户名、密码、URL）
- 确认网络连通性

3. **Docker容器无法启动**
```bash
# 查看容器日志
docker logs api-service
# 检查容器状态
docker ps -a
```

## 安全建议

1. **生产环境配置**
   - 使用强密码
   - 启用HTTPS
   - 配置防火墙规则
   - 定期更新依赖

2. **API安全**
   - 实现认证和授权
   - 添加请求频率限制
   - 输入验证和过滤