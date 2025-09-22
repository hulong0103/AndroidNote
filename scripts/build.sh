#!/bin/bash

# API服务构建脚本
# 使用方法: ./build.sh [clean|compile|package|docker|all]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查Maven环境
check_maven() {
    if ! command -v mvn &> /dev/null; then
        log_error "Maven未安装，请先安装Maven 3.6+"
        exit 1
    fi
    
    MVN_VERSION=$(mvn -version | head -n 1 | cut -d' ' -f3)
    log_info "Maven版本: $MVN_VERSION"
}

# 检查Docker环境
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker未安装，请先安装Docker"
        exit 1
    fi
    
    DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
    log_info "Docker版本: $DOCKER_VERSION"
}

# 清理项目
clean_project() {
    log_info "清理项目..."
    mvn clean
    log_info "项目清理完成"
}

# 编译项目
compile_project() {
    log_info "编译项目..."
    mvn compile
    log_info "项目编译完成"
}

# 打包项目
package_project() {
    log_info "打包项目..."
    mvn package -DskipTests
    log_info "项目打包完成"
    
    if [ -f "target/api-service-1.0.0.jar" ]; then
        log_info "JAR文件已生成: target/api-service-1.0.0.jar"
        ls -lh target/api-service-1.0.0.jar
    else
        log_error "JAR文件生成失败"
        exit 1
    fi
}

# 构建Docker镜像
build_docker() {
    log_info "构建Docker镜像..."
    
    if [ ! -f "target/api-service-1.0.0.jar" ]; then
        log_warn "JAR文件不存在，先执行打包..."
        package_project
    fi
    
    docker build -t api-service:1.0.0 .
    docker build -t api-service:latest .
    
    log_info "Docker镜像构建完成"
    docker images | grep api-service
}

# 运行测试
run_tests() {
    log_info "运行测试..."
    mvn test
    log_info "测试完成"
}

# 完整构建流程
build_all() {
    log_info "开始完整构建流程..."
    
    check_maven
    clean_project
    compile_project
    run_tests
    package_project
    build_docker
    
    log_info "完整构建流程完成"
    log_info "可用的构建产物:"
    log_info "  - JAR文件: target/api-service-1.0.0.jar"
    log_info "  - Docker镜像: api-service:1.0.0"
    log_info "  - Docker镜像: api-service:latest"
}

# 主函数
main() {
    case "$1" in
        clean)
            check_maven
            clean_project
            ;;
        compile)
            check_maven
            compile_project
            ;;
        package)
            check_maven
            package_project
            ;;
        docker)
            check_docker
            build_docker
            ;;
        test)
            check_maven
            run_tests
            ;;
        all)
            build_all
            ;;
        *)
            echo "使用方法: $0 {clean|compile|package|docker|test|all}"
            echo ""
            echo "命令说明:"
            echo "  clean   - 清理项目"
            echo "  compile - 编译项目"
            echo "  package - 打包项目"
            echo "  docker  - 构建Docker镜像"
            echo "  test    - 运行测试"
            echo "  all     - 完整构建流程"
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"