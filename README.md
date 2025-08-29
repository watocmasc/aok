# Academy of Knowledge (AoK)

Современное приложение для управления библиотекой книг с поддержкой различных форматов, поиска и синхронизации.

## �� Содержание

- [Возможности](#-возможности)
- [Системные требования](#-системные-требования)
- [Быстрая установка](#-быстрая-установка)
- [Подробная установка](#-подробная-установка)
- [Сборка из исходников](#-сборка-из-исходников)
- [Настройка](#-настройка)
- [Использование](#-использование)
- [Устранение неполадок](#-устранение-неполадок)
- [Разработка](#-разработка)
- [Лицензия](#-лицензия)

## ✨ Возможности

- 📚 **Управление библиотекой** - добавление, удаление, организация книг
- 🔍 **Поиск** - быстрый поиск по названию, автору, жанру
- 📖 **Просмотр** - встроенный просмотрщик для PDF, EPUB, FB2
- 🌐 **Синхронизация** - загрузка книг с сервера
- 🎨 **Современный интерфейс** - темная тема, адаптивный дизайн
- �� **Автообновления** - автоматическая проверка и установка обновлений
- 📱 **Кроссплатформенность** - Linux, Windows, macOS

## 💻 Системные требования

### Минимальные требования
- **ОС**: Linux (Ubuntu 20.04+), Windows 10+, macOS 10.15+
- **RAM**: 2 GB
- **Дисковое пространство**: 100 MB
- **Процессор**: 64-bit, 1.5 GHz

### Рекомендуемые требования
- **ОС**: Linux (Ubuntu 22.04+), Windows 11+, macOS 12+
- **RAM**: 4 GB
- **Дисковое пространство**: 500 MB
- **Процессор**: 64-bit, 2.0 GHz

### Зависимости
- Qt6 (Core, Widgets, Network, SVG)
- cURL
- MuPDF (для просмотра PDF)
- Системные библиотеки: freetype, harfbuzz, libjpeg, openjpeg2

## 🚀 Быстрая установка

### Linux (Ubuntu/Debian)
```bash
# Скачайте инсталлятор
wget https://github.com/your-repo/aok/releases/latest/download/aok-installer-linux-x86_64.tar.gz

# Распакуйте
tar -xzf aok-installer-linux-x86_64.tar.gz
cd aok-installer-*

# Установите
chmod +x install_aok.sh
./install_aok.sh
```

### Windows
1. Скачайте `aok-installer-windows-x64.exe`
2. Запустите от имени администратора
3. Следуйте инструкциям установщика

### macOS
```bash
# Скачайте и установите
brew install --cask aok
```

## 📥 Подробная установка

### Linux

#### Ubuntu/Debian
```bash
# Обновите систему
sudo apt update && sudo apt upgrade -y

# Установите зависимости
sudo apt install -y \
    libqt6core6 \
    libqt6widgets6 \
    libqt6network6 \
    libqt6svg6 \
    libcurl4 \
    libfreetype6 \
    libharfbuzz0b \
    libjpeg-turbo8 \
    libopenjp2-7 \
    libgumbo1 \
    libbrotli1

# Скачайте приложение
wget https://github.com/your-repo/aok/releases/latest/download/aok-linux-x86_64.tar.gz

# Распакуйте и установите
tar -xzf aok-linux-x86_64.tar.gz
sudo mv aok-* /opt/aok
sudo ln -sf /opt/aok/aok /usr/local/bin/aok
```

#### Fedora/RHEL/CentOS
```bash
# Установите зависимости
sudo dnf install -y \
    qt6-qtbase \
    qt6-qtbase-gui \
    qt6-qtbase-network \
    qt6-qtsvg \
    libcurl \
    freetype \
    harfbuzz \
    libjpeg-turbo \
    openjpeg2 \
    gumbo-parser \
    brotli

# Скачайте и установите приложение
wget https://github.com/your-repo/aok/releases/latest/download/aok-linux-x86_64.tar.gz
tar -xzf aok-linux-x86_64.tar.gz
sudo mv aok-* /opt/aok
sudo ln -sf /opt/aok/aok /usr/local/bin/aok
```

#### Arch Linux
```bash
# Установите зависимости
sudo pacman -S \
    qt6-base \
    qt6-svg \
    curl \
    freetype2 \
    harfbuzz \
    libjpeg-turbo \
    openjpeg2 \
    gumbo-parser \
    brotli

# Установите из AUR
yay -S aok
```

### Windows

#### Через Chocolatey
```cmd
choco install aok
```

#### Ручная установка
1. Скачайте `aok-windows-x64.zip`
2. Распакуйте в `C:\Program Files\AoK\`
3. Добавьте путь в переменную PATH
4. Создайте ярлык на рабочем столе

### macOS

#### Через Homebrew
```bash
brew install --cask aok
```

#### Ручная установка
1. Скачайте `aok-macos-x64.dmg`
2. Откройте DMG файл
3. Перетащите приложение в Applications
4. Запустите из Applications

## 🔨 Сборка из исходников

### Предварительные требования

#### Linux
```bash
# Установите инструменты разработки
sudo apt install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    qt6-base-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    libjpeg-turbo8-dev \
    libopenjp2-7-dev \
    libgumbo-dev \
    libbrotli-dev
```

#### Windows
1. Установите Visual Studio 2022 Community
2. Установите Qt6 через Qt Installer
3. Установите CMake и Ninja
4. Установите Git

#### macOS
```bash
# Установите инструменты
brew install cmake ninja qt6 git

# Установите Xcode Command Line Tools
xcode-select --install
```

### Клонирование и сборка

```bash
# Клонируйте репозиторий
git clone https://github.com/your-repo/aok.git
cd aok

# Создайте папку сборки
mkdir build && cd build

# Конфигурируйте CMake
cmake -G "Ninja" .. -DCMAKE_BUILD_TYPE=Release

# Соберите проект
ninja

# Установите
sudo ninja install
```

### Альтернативная сборка с Make

```bash
mkdir build && cd build
cmake -G "Unix Makefiles" .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
```

## ⚙️ Настройка

### Первый запуск

1. **Запустите приложение**
   ```bash
   aok
   ```

2. **Настройте библиотеку**
   - Укажите папку для хранения книг
   - Настройте язык интерфейса
   - Подключитесь к серверу синхронизации

### Конфигурационные файлы

#### Linux/macOS
~/.config/aok/settings.json
~/.local/share/aok/books/

#### Windows
%APPDATA%\aok\settings.json
%USERPROFILE%\Documents\aok\books\


#### Пример settings.json
```json
{
    "language": "russian",
    "folder_book": "/home/user/Documents/books",
    "server_url": "https://your-server.com",
    "auto_update": true,
    "theme": "dark"
}
```

### Настройка сервера

1. **Создайте аккаунт** на сервере AoK
2. **Получите API ключ** в настройках профиля
3. **Настройте синхронизацию** в приложении

### Настройка автообновлений

```bash
# Проверьте статус обновлений
aok --check-updates

# Отключите автообновления
echo '{"auto_update": false}' > ~/.config/aok/settings.json
```

## �� Использование

### Основные команды

```bash
# Запуск приложения
aok

# Запуск с указанием библиотеки
aok --library /path/to/books

# Проверка обновлений
aok --check-updates

# Справка
aok --help
```

### Интерфейс

- **Главная страница** - обзор всех книг
- **Библиотека** - локальные книги
- **Поиск** - поиск по различным критериям
- **Настройки** - конфигурация приложения
- **Аккаунт** - управление профилем

### Добавление книг

1. Нажмите "Add Book" на главной странице
2. Выберите файл книги (PDF, EPUB, FB2)
3. Заполните метаданные (название, автор, жанр)
4. Добавьте обложку
5. Сохраните

### Синхронизация

- **Автоматическая** - каждые 30 минут
- **Ручная** - кнопка "Sync" в настройках
- **Выборочная** - синхронизация отдельных книг

## �� Устранение неполадок

### Частые проблемы

#### Приложение не запускается
```bash
# Проверьте зависимости
ldd /usr/local/bin/aok

# Проверьте логи
journalctl -u aok -f

# Запустите в режиме отладки
aok --debug
```

#### Ошибки Qt
```bash
# Переустановите Qt6
sudo apt remove --purge libqt6*
sudo apt install libqt6core6 libqt6widgets6 libqt6network6 libqt6svg6
```

#### Проблемы с MuPDF
```bash
# Проверьте установку MuPDF
pkg-config --exists mupdf && echo "MuPDF OK" || echo "MuPDF missing"

# Переустановите зависимости
sudo apt install --reinstall libfreetype6-dev libharfbuzz-dev
```

#### Ошибки сети
```bash
# Проверьте подключение к серверу
curl -I https://your-server.com

# Проверьте настройки прокси
echo $http_proxy
echo $https_proxy
```

### Логи и отладка

#### Включение подробного логирования
```bash
# Запуск с отладкой
aok --debug --log-level=verbose

# Просмотр логов
tail -f ~/.local/share/aok/aok.log
```

#### Проверка конфигурации
```bash
# Проверьте настройки
cat ~/.config/aok/settings.json

# Проверьте права доступа
ls -la ~/.config/aok/
ls -la ~/.local/share/aok/
```

### Восстановление

#### Сброс настроек
```bash
# Резервная копия
cp ~/.config/aok/settings.json ~/.config/aok/settings.json.backup

# Сброс настроек
rm ~/.config/aok/settings.json
aok --reset-config
```

#### Переустановка
```bash
# Удаление
sudo ./uninstall_aok.sh

# Очистка
rm -rf ~/.config/aok ~/.local/share/aok

# Переустановка
./install_aok.sh
```

## 🛠️ Разработка

### Структура проекта
aok/
├── src/ # Исходный код
│ ├── MainWindow.cpp # Главное окно
│ ├── API.cpp # API клиент
│ └── ...
├── include/ # Заголовочные файлы
├── resources/ # Ресурсы приложения
├── mupdf/ # MuPDF интеграция
├── backend/ # Серверная часть
├── CMakeLists.txt # CMake конфигурация
└── README.md # Документация


### Сборка для разработки

```bash
# Debug сборка
mkdir build-debug && cd build-debug
cmake -G "Ninja" .. -DCMAKE_BUILD_TYPE=Debug
ninja

# Запуск с отладкой
gdb ./aok
```

### Тестирование

```bash
# Запуск тестов
cd build
ninja test

# Запуск конкретного теста
./tests/test_mainwindow
```

### Отладка

```bash
# Запуск с Valgrind
valgrind --leak-check=full ./aok

# Запуск с strace
strace -f ./aok

# Профилирование
perf record ./aok
perf report
```

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для подробностей.

## �� Вклад в проект

Мы приветствуем вклад в развитие проекта! См. [CONTRIBUTING.md](CONTRIBUTING.md) для подробностей.

## �� Поддержка

- **GitHub Issues**: [Создать issue](https://github.com/your-repo/aok/issues)
- **Email**: support@aok.com
- **Telegram**: [@aok_support](https://t.me/aok_support)
- **Документация**: [docs.aok.com](https://docs.aok.com)

## �� Полезные ссылки

- [Официальный сайт](https://aok.com)
- [Документация API](https://api.aok.com/docs)
- [Сообщество](https://community.aok.com)
- [Блог разработчиков](https://blog.aok.com)

---

**Academy of Knowledge** - Открываем мир знаний вместе! 📚✨
