# Change Log

All notable changes to this project will be documented in this file.
**AirPlay** adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

### Added

- Detection of AirPlay casting/streaming state (active/inactive)

	It could be defined as `+ isActive: Bool` and used as `AirPlay.isActive`

## [v1.2.1](https://github.com/eMdOS/AirPlay/tree/v1.2.1)

(2016-01-20)

### Fixed

- Crash when removing observer for `AirPlayAvailabilityChangedNotification` in `Example`.

## [v1.2.0](https://github.com/eMdOS/AirPlay/tree/v1.2.0)

(2016-01-15)

### Added

- `isBeingMonitored` class property. Returns `true` or `false` if AirPlay availability is being monitored or not.

	`AirPlay.isBeingMonitored`

### Changed

(Take a look at **Removed** section first)

- The way to check if AirPlay is possible.

	**Now:** `AirPlay.isPossible`

	**Before:** `AirPlay.sharedInstance.isPossible`

- The way to start monitoring AirPlay availability.

	**Now:** `AirPlay.startMonitoring()`

	**Before:** `AirPlay.sharedInstance.startMonitoring(window)`

### Removed

- **Singleton visibility**. AirPlay keeps as singleton, but `sharedInstance` is now private, so the properties and methods are now accesible as `static`/`class`.