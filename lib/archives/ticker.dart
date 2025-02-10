// import 'dart:async';

// class Ticker {
//   Ticker({
//     double speed = 1.0,
//     this.shouldResetTicksOnIntervalUpdate = false,
//     this.autoStart = true,
//   }) : _speed = speed {
//     _calculateInterval();
//     if (autoStart) {
//       start();
//     }
//   }

//   late final listen = watch().listen;
//   late Timer _timer; // Timer instance
//   late Duration _interval; // Tick interval
//   bool _isRunning = false; // Tracks if ticker is running
//   bool
//       shouldResetTicksOnIntervalUpdate; // Whether ticks reset on interval update
//   bool autoStart; // Auto-start ticker
//   int _tickCount = 0; // Tick counter
//   double _speed; // Current speed multiplier
//   final StreamController<TickerEvent> _streamController =
//       StreamController.broadcast();

//   // Default interval duration (at 1x speed)
//   static const Duration defaultInterval = Duration(seconds: 1);

//   // Getters
//   Stream<TickerEvent> watch() =>
//       _streamController.stream; // Expose ticker events as a stream
//   double get speed => _speed; // Get current speed
//   int get tickCount => _tickCount; // Get tick count
//   bool get isRunning => _isRunning; // Is the ticker running?
//   Duration get interval => _interval; // Get interval duration

//   // Calculate the interval based on speed
//   void _calculateInterval() {
//     _interval = Duration(
//       milliseconds: (defaultInterval.inMilliseconds / _speed).toInt(),
//     );
//   }

//   // Start the ticker
//   void start() {
//     if (_isRunning) return;
//     _timer = Timer.periodic(_interval, (timer) {
//       _tickCount++;
//       final event = TickerEvent(
//         tickCount: _tickCount,
//         interval: _interval,
//         speed: _speed,
//         isRunning: _isRunning,
//       );
//       // onTick(event); // Emit event to callback
//       _streamController.add(event); // Emit event to stream
//     });
//     _isRunning = true;
//   }

//   // Pause the ticker
//   void pause() {
//     if (!_isRunning) return;
//     _timer.cancel();
//     _isRunning = false;
//   }

//   // Reset the ticker
//   void reset() {
//     pause();
//     _tickCount = 0;
//     final event = TickerEvent(
//       tickCount: _tickCount,
//       interval: _interval,
//       speed: _speed,
//       isRunning: _isRunning,
//     );
//     _streamController.add(event); // Emit reset event
//   }

//   // Update the speed multiplier
//   void setSpeed(double newSpeed) {
//     if (newSpeed <= 0) {
//       throw ArgumentError('Speed must be greater than zero.');
//     }
//     _speed = newSpeed;
//     _calculateInterval();
//     if (shouldResetTicksOnIntervalUpdate) {
//       reset();
//     } else if (_isRunning) {
//       pause();
//       start();
//     }
//   }

//   // Double the speed
//   void doubleSpeed() {
//     setSpeed(_speed * 2);
//   }

//   // Halve the speed
//   void halveSpeed() {
//     setSpeed(_speed / 2);
//   }

//   // Update the tick reset behavior
//   void configureTickReset(bool resetOnUpdate) {
//     shouldResetTicksOnIntervalUpdate = resetOnUpdate;
//   }

//   // Update the auto-start behavior
//   void configureAutoStart(bool shouldAutoStart) {
//     autoStart = shouldAutoStart;
//   }

//   // Dispose of the ticker
//   void dispose() {
//     if (_isRunning) {
//       _timer.cancel();
//     }
//     _streamController.close(); // Close the stream controller
//   }
// }

// // Event class representing a ticker event
// class TickerEvent {
//   final int tickCount; // Current tick count
//   final Duration interval; // Current interval
//   final double speed; // Current speed multiplier
//   final bool isRunning; // Whether the ticker is running

//   TickerEvent({
//     required this.tickCount,
//     required this.interval,
//     required this.speed,
//     required this.isRunning,
//   });

//   @override
//   String toString() {
//     return '''
// TickerEvent:
//   Ticks: $tickCount
//   Interval: $interval
//   Speed: ${speed.toStringAsFixed(1)}x
//   Is Running: $isRunning
// ''';
//   }
// }
