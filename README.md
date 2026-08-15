# User Management App

Rubyのみを使ってユーザー管理アプリケーションを構築する。

このプロジェクトでは、ユーザー管理のCRUDアプリケーションを完成させることではなく、以下を実践的に学習することを目的とする。

* Rubyのオブジェクト指向プログラミング
* Clean Architecture
* SOLID原則
* Dependency Injection
* Dependency Inversion
* テスト可能な設計
* 責務の分離
* リファクタリング

RailsなどのWebフレームワークは使用せず、Rubyと標準的なライブラリを中心に実装する。

---

## 1. Purpose

このプロジェクトの目的は、Rubyでオブジェクト指向設計を実践しながら、Clean Architectureの考え方を理解することである。

特に以下を重視する。

* オブジェクトに適切な責務を持たせる
* クラス同士の依存関係を適切に設計する
* ビジネスルールを外部の技術から分離する
* インターフェースを利用して依存関係を逆転させる
* テストしやすい設計を実現する
* 実装後に設計を振り返り、リファクタリングする

---

## 2. Requirements

### Runtime

* Ruby
* Ruby標準ライブラリ

### Restrictions

学習目的のため、以下は使用しない。

* Rails
* SinatraなどのWebフレームワーク
* ORM
* 外部のWebフレームワーク

最初のバージョンではデータベースも使用せず、インメモリでデータを管理する。

---

## 3. Application Overview

ユーザーを管理するCLIアプリケーションを構築する。

ユーザーには以下の情報を持たせる。

* ID
* 名前
* 年齢
* メールアドレス

### Initial Features

* ユーザー登録
* ユーザー取得
* ユーザー一覧
* ユーザー削除

### Future Features

必要に応じて以下を追加する。

* ユーザー更新
* メールアドレス変更
* 入力値のバリデーション
* 永続化
* HTTP API
* データベースへの変更

---

## 4. Architecture

Clean Architectureの考え方を参考に、アプリケーションを以下の層に分割する。

```text
┌──────────────────────────────┐
│        Presentation          │
│             CLI              │
└──────────────┬───────────────┘
               │
               ↓
┌──────────────────────────────┐
│        Application           │
│          Use Cases           │
└──────────────┬───────────────┘
               │
               ↓
┌──────────────────────────────┐
│           Domain             │
│       Entities / Rules       │
└──────────────────────────────┘
               ↑
               │
┌──────────────┴───────────────┐
│       Infrastructure         │
│   Repository Implementations  │
└──────────────────────────────┘
```

### Layers

#### Domain

アプリケーションのビジネスルールを表現する。

外部の技術に依存しない。

例：

* Entity
* Value Object
* Domain Rule

#### Application

アプリケーションが提供するユースケースを実装する。

例：

* CreateUser
* FindUser
* ListUsers
* DeleteUser

#### Infrastructure

外部技術との接続を担当する。

今回の初期実装では、インメモリRepositoryを実装する。

#### Presentation

ユーザーとのインターフェースを担当する。

初期実装ではCLIを使用する。

---

## 5. Dependency Rule

このプロジェクトでは、依存関係の方向を重要な設計ルールとする。

基本的なルールは以下の通り。

```text
Presentation
     ↓
Application
     ↓
Domain

Infrastructure
     ↓
Application / Domain
```

### Rules

* DomainはApplicationに依存しない
* DomainはInfrastructureに依存しない
* DomainはPresentationに依存しない
* Applicationは具体的なInfrastructure実装に依存しない
* PresentationはApplicationのUse Caseを利用する
* InfrastructureはApplicationが定義した抽象に従う

特に、

> 内側の層が外側の層を知らない

ことを重要なルールとする。

---

## 6. Directory Structure

```text
user_app/
├── app/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── user.rb
│   │   │
│   │   └── value_objects/
│   │
│   ├── application/
│   │   ├── use_cases/
│   │   │   ├── create_user.rb
│   │   │   ├── find_user.rb
│   │   │   ├── list_users.rb
│   │   │   └── delete_user.rb
│   │   │
│   │   └── repositories/
│   │       └── user_repository.rb
│   │
│   ├── infrastructure/
│   │   └── repositories/
│   │       └── in_memory_user_repository.rb
│   │
│   └── presentation/
│       └── cli/
│           └── user_cli.rb
│
├── test/
│   ├── domain/
│   │   └── entities/
│   │       └── user_test.rb
│   │
│   ├── application/
│   │   └── use_cases/
│   │       ├── create_user_test.rb
│   │       ├── find_user_test.rb
│   │       ├── list_users_test.rb
│   │       └── delete_user_test.rb
│   │
│   └── infrastructure/
│       └── repositories/
│           └── in_memory_user_repository_test.rb
│
├── config/
│   └── dependencies.rb
│
├── main.rb
├── Gemfile
└── README.md
```

---

## 7. Domain Model

中心となるEntityとして`User`を定義する。

```text
User
├── id
├── name
├── age
└── email
```

Userは自身の状態と、それに関連するビジネスルールを管理する。

Userは以下のような外部技術を知らない。

* Database
* Repository
* CLI
* HTTP
* Rails

---

## 8. Use Cases

Application層では、ユーザーに対する操作をUse Caseとして表現する。

### CreateUser

ユーザーを新規作成する。

```text
Input
- name
- age
- email

Process
1. 入力値を確認する
2. Userを生成する
3. Repositoryに保存する

Output
- 作成されたUser
```

### FindUser

IDを指定してユーザーを取得する。

### ListUsers

登録されているユーザーを一覧取得する。

### DeleteUser

指定されたユーザーを削除する。

---

## 9. Repository

Application層でRepositoryの抽象を定義する。

```text
UserRepository

- save
- find
- all
- delete
```

Applicationは具体的な保存方法を知らない。

例えば、

```text
UserRepository
      ↑
      │
InMemoryUserRepository
```

という関係にする。

将来的に、

```text
UserRepository
      ↑
      ├── InMemoryUserRepository
      ├── FileUserRepository
      └── DatabaseUserRepository
```

のように実装を変更できる設計を目指す。

---

## 10. Dependency Injection

具体的なRepositoryの実装はUse Caseの内部で生成しない。

例えば、

```text
Bad:

CreateUser
  └── new InMemoryUserRepository
```

ではなく、

```text
Good:

InMemoryUserRepository
          ↓
      CreateUser
```

のように外部から依存オブジェクトを渡す。

依存関係の組み立ては`config/dependencies.rb`で行う。

---

## 11. Data Flow

ユーザー登録の場合、処理の流れは以下のようにする。

```text
CLI
 ↓
CreateUser
 ↓
User
 ↓
UserRepository
 ↓
InMemoryUserRepository
```

重要なのは、`CreateUser`が`InMemoryUserRepository`を直接知らないことである。

---

## 12. Error Handling

不正な状態や操作に対して、適切なエラーを定義する。

初期段階では必要に応じて以下を検討する。

```text
UserNotFound
InvalidUserName
InvalidAge
InvalidEmail
```

エラーをどの層で扱うべきかについても、実装しながら検討する。

---

## 13. Testing Strategy

各層の責務に応じてテストする。

### Domain

EntityやValue Objectのビジネスルールをテストする。

### Application

Use Caseの振る舞いをテストする。

Repositoryについては、必要に応じてFakeやInMemory実装を利用する。

### Infrastructure

Repositoryの具体的な実装をテストする。

### Presentation

CLIの入出力について必要に応じてテストする。

---

## 14. Development Roadmap

実装は以下の順番で進める。

### Phase 1: Domain

* [ ] User Entityの設計
* [ ] User Entityの実装
* [ ] User Entityのテスト

### Phase 2: Repository

* [ ] UserRepositoryの抽象を設計
* [ ] InMemoryUserRepositoryを実装
* [ ] Repositoryのテスト

### Phase 3: Use Cases

* [ ] CreateUser
* [ ] FindUser
* [ ] ListUsers
* [ ] DeleteUser
* [ ] 各Use Caseのテスト

### Phase 4: Presentation

* [ ] CLIを実装
* [ ] CLIからUse Caseを呼び出す

### Phase 5: Dependency Injection

* [ ] 依存関係を整理
* [ ] Dependency Injectionを実装
* [ ] `dependencies.rb`でオブジェクトを組み立てる

### Phase 6: Refactoring

* [ ] 各クラスの責務を確認
* [ ] 依存関係を確認
* [ ] 重複を削除
* [ ] テストを改善
* [ ] Clean Architectureのルールに違反していないか確認

---

## 15. Learning Goals

このプロジェクトを通して、以下を説明できる状態を目指す。

### Ruby OOP

* ClassとInstanceの違い
* Encapsulation
* Entity
* Value Object
* Inheritance
* Composition
* Polymorphism
* Module

### Design

* Single Responsibility Principle
* Dependency Inversion Principle
* Dependency Injection
* Interface / Abstraction
* Coupling
* Cohesion

### Clean Architecture

* Domainの役割
* Applicationの役割
* Infrastructureの役割
* Presentationの役割
* Dependency Rule
* なぜ依存方向を制御するのか

---

## 16. Future Improvements

基本機能完成後、以下の変更を加えて設計の柔軟性を検証する。

### Persistence

InMemoryからDBへ変更する。

```text
InMemoryUserRepository
        ↓
DatabaseUserRepository
```

この変更によってDomainやUse Caseにどの程度影響があるか確認する。

### Presentation

CLIからHTTP APIへ変更する。

```text
CLI
 ↓
Application
 ↓
Domain
```

から、

```text
HTTP
 ↓
Application
 ↓
Domain
```

へ変更する。

Domain/Applicationへの変更を最小限にすることを目指す。

### Additional Features

* ユーザー更新
* メールアドレス変更
* 認証
* 永続化
* HTTP API

---

## 17. Development Principle

このプロジェクトでは、単に動くコードを書くことを目的としない。

実装するたびに、

1. このクラスの責務は何か
2. この処理はどの層に属するか
3. このクラスは何に依存しているか
4. その依存は本当に必要か
5. テストしやすい設計になっているか
6. 将来の変更に強い設計になっているか

を考える。

最終的には、

> 「なぜこのクラスが存在するのか」
>
> 「なぜこの依存関係になっているのか」

を説明できる状態を目指す。

