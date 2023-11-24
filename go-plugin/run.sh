#!/bin/bash
clear
bat $0 --line-range 5:
echo ""
extism call go-plugin.wasm say_hello \
  --input "😀 Hello World 🌍! (from TinyGo)" \
  --log-level info \
  --wasi
echo ""
