import 'dart:async';
import 'package:flutter/material.dart';

abstract class UI extends StatefulWidget {
  const UI({super.key});
  @override
  State<UI> createState() => _UI();
  Widget build(BuildContext context);
}

class _UI extends State<UI> {
  final Set<Sparkle> states = {};
  static _UI? state;

  @override
  void dispose() {
    for (final state in states) {
      state.removeListener(_setState);
    }
    super.dispose();
  }

  void _setState() => setState(() {});

  void track(Sparkle<dynamic> state) {
    if (!states.contains(state) && !state._disposed) {
      state.addListener(_setState);
      states.add(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    state = this;
    states.clear();
    final widget = this.widget.build(context);
    state = null;
    return widget;
  }
}

class Sparkle<T> {
  T _state;
  final Set<VoidCallback> _listeners = {};
  final bool Function(T oldState, T newState)? shouldSet;
  final bool autoDispose;
  bool _disposed = false;

  Sparkle(
    this._state, {
    this.shouldSet,
    this.autoDispose = false,
  });

  T get() {
    if (_disposed) {
      throw StateError("Cannot get state from a disposed RM instance");
    }
    if (_UI.state != null) {
      _UI.state!.track(this);
    }
    return _state;
  }

  T call([T? newState]) {
    if (newState != null) set(newState);
    return get();
  }

  void set(T newState) {
    if (_disposed || _state == newState) return;
    if (shouldSet?.call(_state, newState) ?? true) {
      _state = newState;
      _notifyListeners();
    }
  }

  void addListener(VoidCallback listener) {
    if (_disposed) {
      throw StateError("Cannot add listener to disposed RM instance");
    }
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    if (autoDispose && _listeners.isEmpty) {
      dispose();
    }
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _listeners.clear();
  }

  void _notifyListeners() {
    for (final listener in _listeners.toList()) {
      listener();
    }
  }

  Widget build(Widget builder(T state)) => builder(get());
}

class Spark {
  static Sparkle<T> repo<T>(T instance) =>
      Sparkle(instance, autoDispose: false);

  static _TimerRM timer({
    required Duration interval,
    int initialValue = 0,
    bool autoDispose = true,
  }) {
    return _TimerRM(
      interval: interval,
      initialValue: initialValue,
      autoDispose: autoDispose,
    );
  }
}

class _TimerRM extends Sparkle<int> {
  Timer? _timer;
  Duration _interval;

  _TimerRM({
    required Duration interval,
    int initialValue = 0,
    bool autoDispose = true,
  })  : _interval = interval,
        super(
          initialValue,
          autoDispose: autoDispose,
        ) {
    _startTimer();
  }

  // Get the current interval
  Duration get interval => _interval;

  // Set a new interval (restarts the timer with the new interval)
  set interval(Duration newInterval) {
    if (_interval == newInterval) return;
    _interval = newInterval;
    _restartTimer();
  }

  // Start or restart the timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      _interval,
      (_) {
        set(get() + 1); // Increment the state and trigger UI rebuilds
      },
    );
  }

  // Restart the timer with the current interval
  void _restartTimer() {
    _startTimer();
  }

  // Pause the timer
  void pause() {
    _timer?.cancel();
    _timer = null;
  }

  // Resume the timer
  void resume() {
    if (_timer == null) {
      _startTimer();
    }
  }

  // Reset the timer value to 0
  void reset() {
    set(0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
