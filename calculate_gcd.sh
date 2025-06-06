#!/bin/bash

# 引数が2つでなければエラー終了
if [ $# -ne 2 ]; then
  echo "input 2 arguments" >&2
  exit 1
fi

# 両方の引数が自然数か確認（0や負数、非数値を排除）
for arg in "$1" "$2"; do
  if ! [[ "$arg" =~ ^[1-9][0-9]*$ ]]; then
    echo "input natural number" >&2
    exit 1
  fi
done

a=$1
b=$2

# 最大公約数を求める関数
gcd() {
  local m=$1
  local n=$2
  while [ "$n" -ne 0 ]; do
    local r=$((m % n))
    m=$n
    n=$r
  done
  echo "$m"
}

gcd "$a" "$b"
