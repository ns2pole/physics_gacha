#!/usr/bin/env bash
# App Store screenshots via STORE_SHOTS tour + simctl.
# Usage: tools/capture_store_shots.sh <udid> <iphone|ipad13> <ja|en>
# Compatible with macOS bash 3.2. Uses --profile (no DEBUG banner).
set -euo pipefail
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

UDID="${1:?udid}"
DEVICE_KIND="${2:?iphone|ipad13}"
LOCALE="${3:?ja|en}"
ROOT="docs/store/screenshots"
OUT="$ROOT/$DEVICE_KIND/$LOCALE"
mkdir -p "$OUT"
rm -f "$OUT"/*.png

LOG="${TMPDIR:-/tmp}/store_shot_${DEVICE_KIND}_${LOCALE}.log"
: >"$LOG"

echo "[capture] device=$UDID kind=$DEVICE_KIND locale=$LOCALE out=$OUT"

xcrun simctl terminate "$UDID" com.joyphysics.physicsGacha 2>/dev/null || true

# debug + STORE_SHOTS hides the DEBUG banner in MaterialApp
flutter run -d "$UDID" --debug \
  --dart-define=STORE_SHOTS=true \
  --dart-define=STORE_LOCALE="$LOCALE" \
  >"$LOG" 2>&1 &
FLUTTER_PID=$!

cleanup() {
  kill "$FLUTTER_PID" 2>/dev/null || true
  wait "$FLUTTER_PID" 2>/dev/null || true
}
trap cleanup EXIT

echo "[capture] flutter pid=$FLUTTER_PID log=$LOG"

SHOTS="01_home 02_calculator 03_hint 04_answer 05_problem_list 06_ask_ai"
taken_count=0
deadline=$((SECONDS + 1800))

shot_taken() {
  test -f "$OUT/${1}.png"
}

# Capture as soon as each marker appears (one per loop).
while (( SECONDS < deadline )); do
  if ! kill -0 "$FLUTTER_PID" 2>/dev/null; then
    echo "[capture] flutter exited early" >&2
    tail -150 "$LOG" >&2 || true
    exit 1
  fi

  for id in $SHOTS; do
    if shot_taken "$id"; then
      continue
    fi
    if grep -q "STORE_SHOT ready:$id" "$LOG" 2>/dev/null; then
      # tiny settle only — tour holds 8s so capture ASAP
      sleep 0.35
      path="$OUT/${id}.png"
      xcrun simctl io "$UDID" screenshot "$path"
      taken_count=$((taken_count + 1))
      echo "[capture] saved $path"
      # only one new shot per poll to stay in sync
      break
    fi
  done

  if grep -q "STORE_SHOT done" "$LOG" 2>/dev/null; then
    sleep 0.5
    for id in $SHOTS; do
      if ! shot_taken "$id" && grep -q "STORE_SHOT ready:$id" "$LOG" 2>/dev/null; then
        path="$OUT/${id}.png"
        xcrun simctl io "$UDID" screenshot "$path"
        taken_count=$((taken_count + 1))
        echo "[capture] saved $path (late)"
      fi
    done
    echo "[capture] tour finished ($taken_count shots)"
    ls -la "$OUT"
    if (( taken_count < 5 )); then
      echo "[capture] too few shots" >&2
      exit 1
    fi
    exit 0
  fi
  sleep 0.25
done

echo "[capture] timeout" >&2
tail -150 "$LOG" >&2 || true
exit 1
