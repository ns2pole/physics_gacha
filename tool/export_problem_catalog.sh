#!/bin/sh
# 問題配列から、図・問題文・答え・解説のPDFを書く。
set -eu
cd "$(dirname "$0")/.."
exec flutter test tool/export_problem_catalog.dart
