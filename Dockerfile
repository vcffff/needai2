# Используем официальный Dart SDK
FROM dart:stable AS build

# Устанавливаем Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter \
    && /flutter/bin/flutter doctor

ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Указываем рабочую директорию
WORKDIR /app

# Копируем pubspec и загружаем зависимости
COPY pubspec.* ./
RUN flutter pub get

# Копируем весь проект
COPY . .

# Собираем Web версию
RUN flutter build web

# Используем nginx для хостинга web-приложения
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
