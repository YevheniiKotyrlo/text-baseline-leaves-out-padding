#!/usr/bin/env bash
# Reads the last onLayout y each Text logged in a logcat dump (ReproducerApp/App.tsx) and judges it.
# Exit 1 while the two Texts' tops sit level, 0 once A sits 30 below B, 2 when the log cannot tell.
set -u

if [ "$#" -ne 1 ] || [ ! -r "$1" ]; then
    echo "usage: verdict.sh <logcat dump>"
    exit 2
fi

sed -n -E 's/^.*(Text [AB] onLayout: )/\1/p' "$1"

# The y of the last line each Text logged, or nothing where it logged none.
last_y() {
    awk -v name="$1" 'match($0, "Text " name " onLayout: y=[-0-9.e]+") { y = substr($0, RSTART, RLENGTH); sub(/^.*y=/, "", y) } END { print y }' "$2"
}
a="$(last_y A "$1")"
b="$(last_y B "$1")"
if [ -z "${a}" ] || [ -z "${b}" ]; then
    echo "SUMMARY: the log holds no onLayout line for A or B, so it cannot tell"
    exit 2
fi

# Pixel rounding moves a y by less than 1 dp.
offset="$(awk -v a="${a}" -v b="${b}" 'BEGIN { print a - b }')"
if awk -v d="${offset}" 'BEGIN { exit !(d > -1 && d < 1) }'; then
    echo "SUMMARY: A y=${a}, B y=${b}: the tops sit level, so B's baseline leaves out its paddingTop: 30 (expected A y=30, B y=0)"
    exit 1
fi
if awk -v d="${offset}" 'BEGIN { exit !(d > 29 && d < 31) }'; then
    echo "SUMMARY: A y=${a}, B y=${b}: A sits 30 below B, so the A and the B share one baseline"
    exit 0
fi
echo "SUMMARY: A y=${a}, B y=${b}: neither level nor 30 apart, so the log cannot tell"
exit 2
