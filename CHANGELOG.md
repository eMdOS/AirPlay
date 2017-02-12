# Change Log

All notable changes to this project will be documented in this file.
**AirPlay** adheres to [Semantic Versioning](http://semver.org/).

## [v3.0.0](https://github.com/eMdOS/AirPlay/tree/v3.0.0)

(2017-02-11)

*I skipped version 2 just to match with the swift language version.*

### Changed

+ Notifications naming.
	- `.airplayAvailabilityChangedNotification`
	
		... was `AirPlayAvailabilityChangedNotification`.
	- `.airplayRouteStatusChangedNotification`

		... was `AirPlayRouteStatusChangedNotification`.

+ Properties naming.
	- `AirPlay.isAvailable`

		... was `AirPlay.isPossible`.

+ Closures naming.

	- `AirPlay.whenAvailable`

		... was `AirPlay.whenPossible`.
	
	- `AirPlay.whenUnavailable`

		... was `AirPlay. whenNotPossible`.
	
	- `AirPlay.whenRouteChanged`

		... was `AirPlay.whenConnectionChanged`.

## [v1.4.0](https://github.com/eMdOS/AirPlay/tree/v1.4.0)

(2016-02-10)

### Added

- Closure syntax to listen availability and connection changes.
    * `AirPlay.whenPossible`
    * `AirPlay.whenNotPossible`
    * `AirPlay.whenConnectionChanged`


## [v1.3.0](https://github.com/eMdOS/AirPlay/tree/v1.3.0)

(2016-01-22)

### Added

- `AirPlayRouteStatusChangedNotification` to observ AirPlay connection route changes.

- `isConnected` class property. Returns `true` or `false` if device is connected or not to a second device via AirPlay. (read-only)

- `connectedDevice` class property. Returns Device's name (as `String`) if connected, if not, it returns `nil`. (read-only)

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