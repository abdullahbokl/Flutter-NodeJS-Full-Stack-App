class PerfConfig {
  static const bool showPerformanceOverlay =
      bool.fromEnvironment('SHOW_PERFORMANCE_OVERLAY', defaultValue: false);
}
