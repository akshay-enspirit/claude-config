#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
USED=$(echo "$input" | jq -r '(((.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)) / 1000 | floor)')
MAX=$(echo "$input" | jq -r '((.context_window.context_window_size // 0) / 1000 | floor)')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')

echo "${MODEL} | ${USED}k/${MAX}k tokens (${PCT}%)"
