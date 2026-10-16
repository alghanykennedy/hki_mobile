# HKI Mobile

Flutter starter project using Clean Architecture and GetX. The starter includes
a small counter feature to show how presentation, domain, and data layers work
together. Replace or remove it when adding the first product feature.

## Requirements

- Flutter SDK compatible with Dart `^3.5.3`

## Run

```sh
flutter pub get
flutter run
```

## Architecture

```text
lib/
  core/
    routes/                 GetX route names and page registry
    theme/                  Shared app theme
  features/
    counter/
      data/                 Repository implementation and data sources
      domain/               Entities, repository contracts, use cases
      presentation/         GetX binding/controller and UI
  main.dart                 Application entry point
```

Dependencies point inward: presentation uses domain use cases, data implements
domain repository contracts, and domain does not depend on Flutter or GetX.
Feature dependencies are composed in the feature's GetX binding.

## Adding a feature

1. Add entities, repository contracts, and use cases under
   `features/<feature>/domain/`.
2. Implement those contracts under `features/<feature>/data/`.
3. Add a GetX controller, binding, and pages under
   `features/<feature>/presentation/`.
4. Register the page and route in `core/routes/`.
5. Add unit and widget tests under `test/`.

The in-memory counter repository is an example implementation, not persistent
storage. Replace it with an appropriate data source when integrating a backend
or local database.
