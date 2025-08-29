#!/bin/bash

echo "Fixing library version compatibility..."

# Создаем символическую ссылку для gumbo
if [ -f "/usr/lib/x86_64-linux-gnu/libgumbo.so.2" ] && [ ! -f "/usr/lib/x86_64-linux-gnu/libgumbo.so.3" ]; then
    echo "Creating libgumbo.so.3 symlink..."
    sudo ln -sf /usr/lib/x86_64-linux-gnu/libgumbo.so.2 /usr/lib/x86_64-linux-gnu/libgumbo.so.3
fi

# Проверяем версию Qt6
QT_VERSION=$(qmake6 -query QT_VERSION)
echo "Current Qt6 version: $QT_VERSION"

# Если версия Qt6 слишком старая, пытаемся обновить
if [[ "$QT_VERSION" < "6.5" ]]; then
    echo "Qt6 version is too old. Trying to update..."
    
    # Добавляем репозиторий Qt6
    sudo apt update
    
    # Устанавливаем последнюю доступную версию
    sudo apt install -y \
        libqt6core6 \
        libqt6widgets6 \
        libqt6network6 \
        libqt6svg6 \
        libqt6gui6 \
        libqt6dbus6 \
        qt6-base-dev
    
    # Проверяем новую версию
    NEW_QT_VERSION=$(qmake6 -query QT_VERSION)
    echo "New Qt6 version: $NEW_QT_VERSION"
fi

# Обновляем кэш библиотек
sudo ldconfig

echo "Library fixes completed!"