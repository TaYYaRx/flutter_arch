# flutter_arch

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Controller → Request / Response
Service    → Kurallar / İş mantığı
Repository → DB işlemleri burada iş kuralı yok sadece kaynakla konuşur.

lib/
├── core/
│   ├── database/
│   │   └── database_service.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── api_endpoints.dart
│   └── constants/
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── models/
│       │   │   ├── dto/          # API'den gelen modeller
│       │   │   └── entity/       # Local DB modelleri
│       │   ├── datasources/
│       │   │   ├── remote_datasource.dart
│       │   │   └── local_datasource.dart
│       │   └── repositories/
│       │       └── repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   └── repositories/
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           └── widgets/
└── main.dart

lib/
├── data/
│   ├── models/           # JSON-Object dönüşüm sınıfları
│   ├── repositories/     # UI ile Veri kaynağı arasındaki köprü
│   └── services/         # API isteklerinin yapıldığı yer (Dio/Http)
├── logic/                # State Management (Bloc, Riverpod veya Provider)
├── ui/
│   ├── screens/          # Sayfalar
│   └── widgets/          # Küçük bileşenler
└── core/                 # Sabitler, temalar, hata yakalama mekanizmaları
