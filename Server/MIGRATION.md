# 🚀 Миграция към .NET 9.0

## ✅ Направени промени

Приложението е мигрирано от **.NET Core 3.1** към **.NET 9.0** с централизирано управление на пакети.

### Създадени файлове:

1. **[Directory.Build.props](Directory.Build.props)** - Общи настройки за всички проекти
   - TargetFramework: `net9.0`
   - Enabled: ImplicitUsings, Nullable
   - Централно управление на пакети

2. **[Directory.Packages.props](Directory.Packages.props)** - Централизирани версии на пакети
   - Всички NuGet пакети са дефинирани на едно място
   - Лесна актуализация на версии

### Актуализирани пакети:

| Пакет | Стара версия | Нова версия |
|-------|-------------|-------------|
| Entity Framework Core | 3.1.5 | 9.0.0 |
| ASP.NET Core Identity | 3.1.5 | 9.0.0 |
| MassTransit | 7.0.0 | 8.3.5 |
| Hangfire | 1.7.11 | 1.8.22 |
| AutoMapper | 8.0.0 | 12.0.1 |
| Refit | 5.1.67 | 8.0.0 |
| Health Checks | 3.1.x | 9.0.0 |

## 📦 Следващи стъпки

### 1. Restore на пакети

```powershell
cd Server
dotnet restore
```

### 2. Build на solution

```powershell
dotnet build CarRentalSystem.sln
```

### 3. Проверка за грешки

След restore и build, може да има breaking changes които трябва да се коригират:

#### Често срещани проблеми:

**Nullable Reference Types:**
```csharp
// Стар код
public string Name { get; set; }

// Нов код (.NET 9 с nullable enabled)
public string Name { get; set; } = string.Empty;
// или
public string? Name { get; set; }
```

**Implicit Usings:**
.NET 9 автоматично включва често използвани namespaces. Може да премахнете:
```csharp
// Вече не са нужни
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
```

**MassTransit API Changes (v7 → v8):**
```csharp
// Стар (v7)
services.AddMassTransit(x => {
    x.UsingRabbitMq((context, cfg) => {
        cfg.Host("rabbitmq");
    });
});

// Нов (v8)
services.AddMassTransit(x => {
    x.SetKebabCaseEndpointNameFormatter();
    x.UsingRabbitMq((context, cfg) => {
        cfg.Host("rabbitmq");
        cfg.ConfigureEndpoints(context);
    });
});
```

**MassTransit.AspNetCore пакет е премахнат:**
```csharp
// Вместо
<PackageReference Include="MassTransit.AspNetCore" />

// Използвайте само
<PackageReference Include="MassTransit" />
<PackageReference Include="MassTransit.RabbitMQ" />
```

### 4. Актуализиране на Dockerfiles

✅ **Вече е направено!** Всички Dockerfile файлове са актуализирани:

```dockerfile
# Актуализирани base images
FROM mcr.microsoft.com/dotnet/aspnet:9.0
FROM mcr.microsoft.com/dotnet/sdk:9.0
```

### 5. Тестване

```powershell
# Стартирайте приложението локално
cd Server\CarRentalSystem.Identity
dotnet run

# Или с Docker
docker compose build
docker compose up -d
```

## 🔧 Корекции на кода

След build ще видите грешки които трябва да се коригират ръчно. Основните категории:

### 1. Entity Framework Core 10 Changes
- `UseInternalServiceProvider` е премахнат
- Query filters са малко променени

### 2. ASP.NET Core 10 Features
- Minimal APIs подобрения
- Rate limiting вграден
- Output caching вграден

### 3. C# 13 Features
- Можете да използвате новите features:
  - Params collections
  - Improved nameof scope
  - Semi-auto properties
9 Features
- Native AOT support
- Improved performance
- Better minimal APIs]9](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-9)
- [ASP.NET Core 9 Migration Guide](https://learn.microsoft.com/en-us/aspnet/core/migration/31-to-60)
- [EF Core 9 What's New](https://learn.microsoft.com/en-us/ef/core/what-is-new/ef-core-9)
- [MassTransit v8 Migration](https://masstransit.io/documentation/configuration/transports/rabbitmq)

## ⚠️ Важно

Преди production deployment:
1. ✅ Тествайте всички функционалности
2. ✅ Актуализирайте unit tests
3. ✅ Проверете performance
4. ✅ Актуализирайте CI/CD pipeline
5. ✅ Актуализирайте документация
