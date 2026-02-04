# Angular Migration Guide - Angular 9 to Angular 19

## Общ преглед

Фронтенд приложението е ъпдейтнато от **Angular 9.0** (февруари 2020) до **Angular 19.1** (януари 2026).

## Основни промени

### 1. Зависимости (Dependencies)

#### Ъпдейтнати Angular пакети:
- `@angular/*` пакетите: `~9.0.0` → `^19.1.0`
- `zone.js`: `~0.10.2` → `^0.15.0`
- `rxjs`: `~6.5.4` → `^7.8.1`
- `typescript`: `~3.7.5` → `~5.7.2`

#### SignalR промяна:
- `@aspnet/signalr` е заменен с `@microsoft/signalr@^8.0.7`
- **Важно**: Ще трябва да се променят импортите в кода от `@aspnet/signalr` на `@microsoft/signalr`

#### Премахнати пакети:
- `ngx-strongly-typed-forms` - премахнат (може да се използва нативният Typed Forms на Angular)
- `@angular/language-service` - вече не е нужен
- `@types/jasminewd2` - вече не се използва
- `codelyzer` - заменен с ESLint
- `protractor` - заменен с по-модерни testing решения
- `ts-node` - вече не е необходим
- `jasmine-spec-reporter` - премахнат

### 2. Build система

Angular 19 използва нов application builder вместо browser builder:
- **Преди**: `@angular-devkit/build-angular:browser`
- **Сега**: `@angular-devkit/build-angular:application`

#### Промени в angular.json:
- `main` → `browser`
- `polyfills` е сега масив: `["zone.js"]`
- Премахнати остарели опции: `extractCss`, `vendorChunk`, `buildOptimizer`, `aot`

### 3. TypeScript конфигурация

#### tsconfig.json - Нови опции:
- `strict: true` - строг режим
- `moduleResolution: "bundler"` (вместо "node")
- `target: "ES2022"` (вместо "es2015")
- `module: "ES2022"` (вместо "esnext")
- `useDefineForClassFields: false` - за съвместимост с Angular
- Добавени нови strict флагове

#### Премахнати файлове:
- `src/polyfills.ts` - вече не е необходим (polyfills се задават директно в angular.json)
- `src/test.ts` - вече не е необходим

### 4. Linting - TSLint → ESLint

- **Премахнат**: `tslint.json` и `tslint` пакет
- **Добавен**: ESLint с Angular ESLint пакети
- **Нов файл**: `.eslintrc.json`

#### Нови пакети:
- `@angular-eslint/builder`
- `@angular-eslint/eslint-plugin`
- `@angular-eslint/eslint-plugin-template`
- `@typescript-eslint/eslint-plugin`
- `@typescript-eslint/parser`
- `eslint`

### 5. Testing

#### Karma:
- `karma-coverage-istanbul-reporter` → `karma-coverage`
- Обновен `karma.conf.js` с нова конфигурация

## Стъпки за миграция

### 1. Инсталиране на зависимости

```bash
cd Client
npm install
```

### 2. Промяна на SignalR импорти

Намерете всички файлове с импорти от `@aspnet/signalr` и ги променете на `@microsoft/signalr`:

**Преди:**
```typescript
import * as signalR from '@aspnet/signalr';
```

**След:**
```typescript
import * as signalR from '@microsoft/signalr';
```

### 3. Проверка за strongly-typed forms

Ако се използва `ngx-strongly-typed-forms`, преминете към нативния Angular Typed Forms API:
- Angular 14+ има вграден Typed Reactive Forms
- Документация: https://angular.io/guide/typed-forms

### 4. Стартиране на приложението

```bash
npm start
```

### 5. Проверка за грешки

След стартиране проверете за:
- TypeScript грешки (поради новите strict настройки)
- Runtime грешки в конзолата
- Тестове: `npm test`

## Важни забележки

### Breaking Changes:

1. **Strict Mode**: TypeScript strict режимът може да открие грешки, които преди не се виждаха
2. **RxJS 7**: Малки промени в API-то (но повечето са backward compatible)
3. **Zone.js**: Нова версия с по-добра производителност
4. **Модулна система**: `moduleResolution: bundler` е оптимизиран за Angular 19

### Препоръки за по-нататъшно развитие:

1. **Standalone Components**: Помислете за преминаване към standalone components (Angular 14+)
2. **Signals**: Използвайте новото Signals API (Angular 16+)
3. **Inject function**: Преминете към функционалното dependency injection
4. **Control Flow**: Използвайте новия `@if`, `@for` синтаксис вместо `*ngIf`, `*ngFor` (Angular 17+)

## Производителност

Angular 19 идва с:
- По-бързи build времена
- По-малък bundle size
- Подобрена runtime производителност
- По-добър TypeScript LSP performance

## Допълнителни ресурси

- [Angular Update Guide](https://update.angular.io/)
- [Angular 19 Release Notes](https://blog.angular.io/)
- [Microsoft SignalR Docs](https://docs.microsoft.com/aspnet/core/signalr/)
