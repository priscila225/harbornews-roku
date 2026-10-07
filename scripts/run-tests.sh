#!/usr/bin/env bash
# Compiles the channel, then runs the plain-BrightScript tests in an interpreter.
# Component and UI behaviour needs a device and is not covered here.
set -euo pipefail
cd "$(dirname "$0")/.."
npx bsc --project bsconfig.json
out=$(perl -e 'alarm 120; exec @ARGV' npx brs-cli \
  build/source/architecture/ObjectUtils.brs \
  build/source/app/RelativeTime.brs \
  tests/helpers.test.brs </dev/null 2>&1) || true
echo "$out"
if echo "$out" | grep -q '^FAIL'; then exit 1; fi
echo "$out" | grep -q 'failures=0' || { echo "test run did not complete"; exit 1; }
