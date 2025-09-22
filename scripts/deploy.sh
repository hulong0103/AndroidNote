#!/bin/bash

# API服务部署脚本
# 使用方法: ./deploy.sh [start|stop|restart|status|logs]

set -e

APP_NAME="api-service"
APP_JAR="api-service-1.0.0.jar"
APP_DIR="/opt/api-service"
SERVICE_USER="ubuntu"
JAVA_OPTS="-Xms512m -Xmx1024m -Djava.security.egd=file:/dev/./urandom"

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

# 检查Java环境
check_java() {
    if ! command -v java &> /dev/null; then
        log_error "Java未安装，请先安装Java 17+"
        exit 1
    fi
    
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -lt 17 ]; then
        log_error "Java版本过低，需要Java 17+，当前版本: $JAVA_VERSION"
        exit 1
    fi
    
    log_info "Java环境检查通过，版本: $JAVA_VERSION"
}

# 检查应用目录
check_app_dir() {
    if [ ! -d "$APP_DIR" ]; then
        log_info "创建应用目录: $APP_DIR"
        sudo mkdir -p "$APP_DIR"
        sudo chown $SERVICE_USER:$SERVICE_USER "$APP_DIR"
    fi
    
    if [ ! -f "$APP_DIR/$APP_JAR" ]; then
        log_error "应用JAR文件不存在: $APP_DIR/$APP_JAR"
        log_info "请先上传JAR文件到服务器"
        exit 1
    fi
}

# 启动应用
start_app() {
    log_info "启动 $APP_NAME..."
    
    if pgrep -f "$APP_JAR" > /dev/null; then
        log_warn "应用已在运行中"
        return 0
    fi
    
    cd "$APP_DIR"
    nohup java $JAVA_OPTS -jar "$APP_JAR" --spring.profiles.active=prod > app.log 2>&1 &
    
    sleep 3
    
    if pgrep -f "$APP_JAR" > /dev/null; then
        log_info "应用启动成功"
        log_info "PID: $(pgrep -f "$APP_JAR")"
        log_info "日志文件: $APP_DIR/app.log"
    else
        log_error "应用启动失败，请检查日志: $APP_DIR/app.log"
        exit 1
    fi
}

# 停止应用
stop_app() {
    log_info "停止 $APP_NAME..."
    
    if ! pgrep -f "$APP_JAR" > /dev/null; then
        log_warn "应用未运行"
        return 0
    fi
    
    PID=$(pgrep -f "$APP_JAR")
    log_info "停止进程 PID: $PID"
    
    kill $PID
    
    # 等待进程结束
    for i in {1..10}; do
        if ! pgrep -f "$APP_JAR" > /dev/null; then
            log_info "应用已停止"
            return 0
        fi
        sleep 1
    done
    
    # 强制杀死进程
    log_warn "强制停止应用"
    pkill -9 -f "$APP_JAR"
    log_info "应用已强制停止"
}

# 重启应用
restart_app() {
    log_info "重启 $APP_NAME..."
    stop_app
    sleep 2
    start_app
}

# 查看应用状态
status_app() {
    if pgrep -f "$APP_JAR" > /dev/null; then
        PID=$(pgrep -f "$APP_JAR")
        log_info "应用正在运行"
        log_info "PID: $PID"
        log_info "运行时间: $(ps -o etime= -p $PID)"
        log_info "内存使用: $(ps -o rss= -p $PID | awk '{print $1/1024 " MB"}')"
    else
        log_warn "应用未运行"
    fi
}

# 查看应用日志
logs_app() {
    if [ -f "$APP_DIR/app.log" ]; then
        log_info "显示应用日志 (按Ctrl+C退出):"
        tail -f "$APP_DIR/app.log"
    else
        log_error "日志文件不存在: $APP_DIR/app.log"
    fi
}

# 主函数
main() {
    case "$1" in
        start)
            check_java
            check_app_dir
            start_app
            ;;
        stop)
            stop_app
            ;;
        restart)
            check_java
            check_app_dir
            restart_app
            ;;
        status)
            status_app
            ;;
        logs)
            logs_app
            ;;
        *)
            echo "使用方法: $0 {start|stop|restart|status|logs}"
            echo ""
            echo "命令说明:"
            echo "  start   - 启动应用"
            echo "  stop    - 停止应用"
            echo "  restart - 重启应用"
            echo "  status  - 查看应用状态"
            echo "  logs    - 查看应用日志"
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"