#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  Qt6 Version Compatibility Fix${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Проверяем, запущен ли скрипт от root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: Do not run this script as root!${NC}"
    echo "Run as regular user, the script will ask for sudo when needed."
    exit 1
fi

# Функция для определения дистрибутива
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION_CODENAME=$VERSION_CODENAME
        VERSION_ID=$VERSION_ID
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
        VERSION_CODENAME="unknown"
        VERSION_ID="unknown"
    elif [ -f /etc/redhat-release ]; then
        DISTRO="rhel"
        VERSION_CODENAME="unknown"
        VERSION_ID="unknown"
    else
        DISTRO="unknown"
        VERSION_CODENAME="unknown"
        VERSION_ID="unknown"
    fi
}

# Функция исправления версии Qt6 для Ubuntu/Debian
fix_qt_version_debian() {
    echo -e "${YELLOW}Fixing Qt6 version compatibility for Debian/Ubuntu...${NC}"
    
    # Обновляем список пакетов
    sudo apt update
    
    # Устанавливаем более новую версию Qt6
    echo -e "${YELLOW}Installing newer Qt6 version...${NC}"
    
    # Добавляем репозиторий Qt6 если доступен
    if ! command -v qmake6 &> /dev/null; then
        echo -e "${YELLOW}Qt6 not found, installing...${NC}"
        sudo apt install -y qt6-base-dev qt6-base-dev-tools
    fi
    
    # Проверяем текущую версию
    CURRENT_VERSION=$(qmake6 -query QT_VERSION 2>/dev/null || echo "unknown")
    echo -e "${BLUE}Current Qt6 version: $CURRENT_VERSION${NC}"
    
    # Пытаемся установить более новую версию
    if [[ "$CURRENT_VERSION" < "6.5" ]]; then
        echo -e "${YELLOW}Qt6 version is too old. Trying to update...${NC}"
        
        # Устанавливаем последнюю доступную версию
        sudo apt install -y \
            libqt6core6 \
            libqt6widgets6 \
            libqt6network6 \
            libqt6svg6 \
            libqt6gui6 \
            libqt6dbus6 \
            qt6-base-dev \
            qt6-base-dev-tools
        
        # Проверяем новую версию
        NEW_VERSION=$(qmake6 -query QT_VERSION 2>/dev/null || echo "unknown")
        echo -e "${BLUE}New Qt6 version: $NEW_VERSION${NC}"
        
        if [[ "$NEW_VERSION" < "6.5" ]]; then
            echo -e "${YELLOW}Still using old Qt6 version. Trying alternative approach...${NC}"
            
            # Пытаемся найти более новые версии в других репозиториях
            if apt-cache search qt6 | grep -q "qt6-base"; then
                echo -e "${YELLOW}Found Qt6 packages, installing...${NC}"
                sudo apt install -y qt6-base qt6-base-dev
            fi
        fi
    fi
    
    # Создаем символические ссылки для совместимости версий
    echo -e "${YELLOW}Creating version compatibility symlinks...${NC}"
    
    # Находим библиотеки Qt6
    QT_LIB_DIR="/usr/lib/x86_64-linux-gnu"
    
    if [ -d "$QT_LIB_DIR" ]; then
        cd "$QT_LIB_DIR"
        
        # Создаем ссылки для совместимости версий
        for lib in libQt6Core.so libQt6Widgets.so libQt6Network.so libQt6Svg.so libQt6Gui.so libQt6DBus.so; do
            if [ -f "$lib.6" ]; then
                # Получаем текущую версию
                CURRENT_VER=$(readlink "$lib.6" | sed 's/.*\.so\.//')
                echo -e "${BLUE}Found $lib version: $CURRENT_VER${NC}"
                
                # Создаем ссылку для версии 6.9 если нужно
                if [[ "$CURRENT_VER" < "6.9" ]]; then
                    echo -e "${YELLOW}Creating compatibility link for $lib.6.9${NC}"
                    sudo ln -sf "$lib.6" "$lib.6.9"
                fi
            fi
        done
        
        # Возвращаемся в исходную директорию
        cd - > /dev/null
    fi
    
    # Обновляем кэш библиотек
    sudo ldconfig
}

# Функция исправления версии Qt6 для RHEL/CentOS/Fedora
fix_qt_version_rhel() {
    echo -e "${YELLOW}Fixing Qt6 version compatibility for RHEL/CentOS/Fedora...${NC}"
    
    if command -v dnf &> /dev/null; then
        sudo dnf update -y
        sudo dnf install -y qt6-qtbase qt6-qtbase-devel qt6-qtnetworkauth qt6-qtsvg
    elif command -v yum &> /dev/null; then
        sudo yum update -y
        sudo yum install -y qt6-qtbase qt6-qtbase-devel qt6-qtnetworkauth qt6-qtsvg
    fi
    
    # Создаем символические ссылки для совместимости
    echo -e "${YELLOW}Creating version compatibility symlinks...${NC}"
    
    QT_LIB_DIR="/usr/lib64"
    if [ -d "$QT_LIB_DIR" ]; then
        cd "$QT_LIB_DIR"
        
        for lib in libQt6Core.so libQt6Widgets.so libQt6Network.so libQt6Svg.so libQt6Gui.so libQt6DBus.so; do
            if [ -f "$lib.6" ]; then
                CURRENT_VER=$(readlink "$lib.6" | sed 's/.*\.so\.//')
                echo -e "${BLUE}Found $lib version: $CURRENT_VER${NC}"
                
                if [[ "$CURRENT_VER" < "6.9" ]]; then
                    echo -e "${YELLOW}Creating compatibility link for $lib.6.9${NC}"
                    sudo ln -sf "$lib.6" "$lib.6.9"
                fi
            fi
        done
        
        cd - > /dev/null
    fi
    
    sudo ldconfig
}

# Функция исправления версии Qt6 для Arch Linux
fix_qt_version_arch() {
    echo -e "${YELLOW}Fixing Qt6 version compatibility for Arch Linux...${NC}"
    
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm qt6-base qt6-base-devel qt6-networkauth qt6-svg
    
    # Создаем символические ссылки для совместимости
    echo -e "${YELLOW}Creating version compatibility symlinks...${NC}"
    
    QT_LIB_DIR="/usr/lib"
    if [ -d "$QT_LIB_DIR" ]; then
        cd "$QT_LIB_DIR"
        
        for lib in libQt6Core.so libQt6Widgets.so libQt6Network.so libQt6Svg.so libQt6Gui.so libQt6DBus.so; do
            if [ -f "$lib.6" ]; then
                CURRENT_VER=$(readlink "$lib.6" | sed 's/.*\.so\.//')
                echo -e "${BLUE}Found $lib version: $CURRENT_VER${NC}"
                
                if [[ "$CURRENT_VER" < "6.9" ]]; then
                    echo -e "${YELLOW}Creating compatibility link for $lib.6.9${NC}"
                    sudo ln -sf "$lib.6" "$lib.6.9"
                fi
            fi
        done
        
        cd - > /dev/null
    fi
    
    sudo ldconfig
}

# Функция создания переменной окружения для переопределения версии
create_qt_environment() {
    echo -e "${YELLOW}Creating Qt6 environment override...${NC}"
    
    # Создаем файл с переменными окружения
    cat > /tmp/qt6_env.sh << 'EOF'
#!/bin/bash
# Qt6 version compatibility override
export QT_VERSION_OVERRIDE=6.4.2
export QT_QPA_PLATFORM=xcb
export QT_DEBUG_PLUGINS=0

# Override library search path
export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

# Force Qt6 to use system libraries
export QT_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/qt6/plugins"
export QT_QPA_PLATFORM_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/qt6/plugins/platforms"
EOF
    
    # Копируем в системную папку
    sudo cp /tmp/qt6_env.sh /etc/profile.d/qt6_compat.sh
    sudo chmod 644 /etc/profile.d/qt6_compat.sh
    
    echo -e "${GREEN}✓ Qt6 environment override created${NC}"
}

# Функция создания wrapper скрипта для запуска приложения
create_qt_wrapper() {
    echo -e "${YELLOW}Creating Qt6 compatibility wrapper...${NC}"
    
    # Создаем wrapper скрипт
    cat > /tmp/aok_wrapper.sh << 'EOF'
#!/bin/bash
# Qt6 compatibility wrapper for Academy of Knowledge

# Load Qt6 environment
if [ -f "/etc/profile.d/qt6_compat.sh" ]; then
    source /etc/profile.d/qt6_compat.sh
fi

# Override Qt6 version
export QT_VERSION_OVERRIDE=6.4.2

# Force use of system Qt6 libraries
export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

# Run the application
exec /opt/aok/aok "$@"
EOF
    
    # Копируем wrapper в систему
    sudo cp /tmp/aok_wrapper.sh /opt/aok/aok_wrapper
    sudo chmod +x /opt/aok/aok_wrapper
    
    # Обновляем символическую ссылку
    sudo ln -sf /opt/aok/aok_wrapper /usr/local/bin/aok
    
    # Обновляем desktop файл
    if [ -f "/usr/share/applications/aok.desktop" ]; then
        sudo sed -i 's|Exec=/opt/aok/aok|Exec=/opt/aok/aok_wrapper|g' /usr/share/applications/aok.desktop
    fi
    
    echo -e "${GREEN}✓ Qt6 compatibility wrapper created${NC}"
}

# Функция проверки исправления
verify_fix() {
    echo -e "${YELLOW}Verifying Qt6 version fix...${NC}"
    
    # Проверяем, что приложение установлено
    if [ -f "/opt/aok/aok" ]; then
        echo -e "${GREEN}✓ Application found${NC}"
    else
        echo -e "${RED}✗ Application not found${NC}"
        return 1
    fi
    
    # Проверяем wrapper
    if [ -f "/opt/aok/aok_wrapper" ]; then
        echo -e "${GREEN}✓ Compatibility wrapper found${NC}"
    else
        echo -e "${RED}✗ Compatibility wrapper not found${NC}"
        return 1
    fi
    
    # Проверяем зависимости
    echo -e "${YELLOW}Checking dependencies...${NC}"
    if ldd /opt/aok/aok | grep -q "not found"; then
        echo -e "${RED}✗ Some dependencies are still missing${NC}"
        ldd /opt/aok/aok | grep "not found"
        return 1
    else
        echo -e "${GREEN}✓ All dependencies satisfied${NC}"
    fi
    
    # Проверяем переменные окружения
    if [ -f "/etc/profile.d/qt6_compat.sh" ]; then
        echo -e "${GREEN}✓ Qt6 environment override found${NC}"
    else
        echo -e "${RED}✗ Qt6 environment override not found${NC}"
        return 1
    fi
    
    return 0
}

# Функция показа справки
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  --help, -h        Show this help message"
    echo "  --verify          Verify the fix"
    echo ""
    echo "This script fixes Qt6 version compatibility issues without rebuilding."
    echo "It creates compatibility symlinks and environment overrides."
}

# Основная логика
main() {
    case $1 in
        "--help"|"-h")
            show_help
            exit 0
            ;;
        "--verify")
            verify_fix
            exit $?
            ;;
    esac
    
    echo -e "${BLUE}Starting Qt6 version compatibility fix...${NC}"
    echo ""
    
    # Определяем дистрибутив
    detect_distro
    echo -e "${BLUE}Detected: $DISTRO $VERSION_ID${NC}"
    
    # Исправляем версию Qt6
    case $DISTRO in
        "ubuntu"|"debian"|"linuxmint"|"pop")
            fix_qt_version_debian
            ;;
        "rhel"|"centos"|"fedora"|"rocky"|"alma")
            fix_qt_version_rhel
            ;;
        "arch"|"manjaro"|"endeavouros")
            fix_qt_version_arch
            ;;
        *)
            echo -e "${RED}Unsupported distribution: $DISTRO${NC}"
            exit 1
            ;;
    esac
    
    # Создаем переменные окружения
    create_qt_environment
    
    # Создаем wrapper скрипт
    create_qt_wrapper
    
    # Проверяем исправление
    verify_fix
    
    echo ""
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}  Qt6 Version Fix Completed!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo -e "${BLUE}The application should now work with your Qt6 version.${NC}"
    echo -e "${BLUE}Try running: aok --version${NC}"
    echo ""
    echo -e "${YELLOW}Note: You may need to log out and log back in for environment changes to take effect.${NC}"
}

# Запуск основной функции
main "$@"