# 使用OpenJDK 17作为基础镜像
FROM openjdk:17-jdk-slim

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV JAVA_OPTS="-Xms512m -Xmx1024m -Djava.security.egd=file:/dev/./urandom"
ENV SPRING_PROFILES_ACTIVE=prod

# 创建应用用户
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 复制Maven构建的jar文件
COPY target/api-service-1.0.0.jar app.jar

# 创建日志目录
RUN mkdir -p /var/log/api-service && chown -R appuser:appuser /var/log/api-service

# 切换到应用用户
USER appuser

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/api/v1/health/ping || exit 1

# 启动应用
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]