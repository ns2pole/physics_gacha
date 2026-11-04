#!/bin/sh
# Play 用の AAB を作る。pubspec の版を 1.0.0+1 から 1.0.1+2 のように、
# パッチと versionCode を 1 ずつ上げてからビルドする。失敗したときは版を戻す。
set -eu
cd "$(dirname "$0")/.."

version_line=$(grep -E '^version: ' pubspec.yaml)
current=${version_line#version: }
name=${current%%+*}
code=${current##*+}
major=$(printf '%s' "$name" | cut -d. -f1)
minor=$(printf '%s' "$name" | cut -d. -f2)
patch=$(printf '%s' "$name" | cut -d. -f3)
patch=$((patch + 1))
code=$((code + 1))
next="${major}.${minor}.${patch}+${code}"

built=0
restore() {
  if [ "$built" != 1 ]; then
    sed -i '' "s/^version: .*/version: ${current}/" pubspec.yaml
  fi
}
trap restore EXIT

sed -i '' "s/^version: .*/version: ${next}/" pubspec.yaml
echo "version ${current} -> ${next}"
flutter build appbundle --release
built=1

# AAB の版と git の版を揃える。ビルド成功後に pubspec だけ commit / push する。
git add pubspec.yaml
git commit -m "Bump version to ${next} for Play AAB."
git push origin HEAD
echo "pushed version ${next}"
