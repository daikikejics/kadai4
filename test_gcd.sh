#!/bin/bash

# 一時ディレクトリの作成
tmpdir="/tmp/test-$$"
mkdir -p "$tmpdir"

# エラー終了関数
error_exit() {
  echo "$1" >&2
  rm -rf "$tmpdir"
  exit 1
}

# 異常系テスト関数
# $1: テストの説明, $2: 期待するエラーメッセージファイル, 残り: テスト引数
check_error() {
  description="$1"
  shift
  expected="$1"
  shift
  ./calculate_gcd.sh "$@" > /dev/null 2> "$tmpdir/result" && error_exit "$description: should have failed"
  diff "$tmpdir/result" "$expected" > /dev/null || error_exit "$description: wrong error message"
}

# 正常系テスト関数
# $1: テストの説明, $2: 期待する出力, 残り: テスト引数
check_output() {
  description="$1"
  expected="$2"
  shift 2
  output=$(./calculate_gcd.sh "$@")
  [ "$output" = "$expected" ] || error_exit "$description: expected $expected, got $output"
}

# エラーメッセージファイルの準備
echo "input 2 arguments" > "$tmpdir/err_args"
echo "input natural number" > "$tmpdir/err_nat"

# --- 異常系テスト ---
check_error "No arguments" "$tmpdir/err_args"
check_error "One argument" "$tmpdir/err_args" 10
check_error "Too many arguments" "$tmpdir/err_args" 1 2 3
check_error "Non-numeric input" "$tmpdir/err_nat" a b
check_error "Negative input" "$tmpdir/err_nat" -1 5
check_error "Zero input" "$tmpdir/err_nat" 0 10

# --- 正常系テスト ---
check_output "GCD of 12 and 18" 6 12 18
check_output "GCD of 100 and 25" 25 100 25
check_output "GCD of 17 and 1" 1 17 1
check_output "GCD of same numbers" 10 10 10
check_output "GCD of 7 and 3" 1 7 3

# 一時ファイル削除と完了表示
rm -rf "$tmpdir"
echo "All tests passed."
