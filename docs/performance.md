# Performance Workflow

Use this workflow when checking UI jank or validating a performance change.

## Run In Profile Mode

```bash
flutter run --profile -d 127.0.0.1:6555 --dart-define=SHOW_PERFORMANCE_OVERLAY=true
```

For a physical device, replace the device id and provide the correct API host:

```bash
flutter run --profile \
  -d <device-id> \
  --dart-define=API_BASE_URL=http://<host-ip>:7000/api/v1 \
  --dart-define=SOCKET_URL=http://<host-ip>:7000 \
  --dart-define=SHOW_PERFORMANCE_OVERLAY=true
```

Do not rely on the repo's default dev IP for perf checks. Always pass
`API_BASE_URL` and `SOCKET_URL` explicitly so profile-mode runs are repeatable
across emulators, physical devices, and other machines.

## Core Scenarios

Validate these flows after a performance-sensitive change:

1. Cold launch to the authenticated home screen.
2. Wait for the home screen to settle.
3. Scroll the home feed vertically.
4. Scroll the featured jobs carousel horizontally.
5. Tap the home filter chips several times.
6. Open login and register pages and return.
7. Navigate home -> jobs -> profile/chat -> back.

## What To Watch

- Flutter performance overlay:
  - top graph is raster time
  - bottom graph is UI thread time
  - persistent bottom-graph spikes usually indicate build/layout/compositing jank
- Android frame stats:

```bash
adb -s 127.0.0.1:6555 shell dumpsys gfxinfo com.example.jobhub_flutter reset
adb -s 127.0.0.1:6555 shell dumpsys gfxinfo com.example.jobhub_flutter framestats
```

- DevTools timeline:
  - use when a single interaction still looks bad after overlay/gfxinfo checks
  - inspect slow frames for layout/build-heavy work before assuming raster issues

## Acceptance Bar

- Home screen steady-state scroll should keep raster comfortably under budget.
- UI-thread spikes should be occasional, not repeated during normal scrolling.
- Login/register transitions should not visibly hitch.
- Route transitions in and out of home, jobs, profile, and chat should feel smooth.
