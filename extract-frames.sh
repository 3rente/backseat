#!/usr/bin/env bash
# Extract a WebP frame sequence + manifest.json from a video you own.
# Usage: ./extract-frames.sh <input.mp4> <youtube_id> [fps=1] [width=480] [quality=60] [start=0] [duration=]
# Output: frames/<youtube_id>/f_0001.webp ... + manifest.json
set -euo pipefail

IN="${1:?input video}"; ID="${2:?youtube id}"
FPS="${3:-1}"; W="${4:-480}"; Q="${5:-60}"; SS="${6:-0}"; DUR="${7:-}"
OUT="frames/$ID"

command -v ffmpeg >/dev/null || { echo "ffmpeg not found"; exit 1; }
rm -rf "$OUT"; mkdir -p "$OUT"

ffmpeg -hide_banner -loglevel error -ss "$SS" ${DUR:+-t "$DUR"} -i "$IN" \
  -vf "fps=$FPS,scale=$W:-2" -c:v libwebp -quality "$Q" -compression_level 6 \
  "$OUT/f_%04d.webp"

COUNT=$(ls "$OUT"/f_*.webp | wc -l)
BYTES=$(cat "$OUT"/f_*.webp | wc -c)
H=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$OUT/f_0001.webp")
SRC_BYTES=$(wc -c < "$IN")
SRC_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$IN")

cat > "$OUT/manifest.json" <<EOF
{
  "id": "$ID",
  "fps": $FPS,
  "count": $COUNT,
  "width": $W,
  "height": $H,
  "start": $SS,
  "pattern": "f_%04d.webp",
  "totalBytes": $BYTES,
  "source": { "bytes": $SRC_BYTES, "duration": $SRC_DUR }
}
EOF

printf '%s: %d frames, %.2f MB (source %.2f MB)\n' "$ID" "$COUNT" \
  "$(echo "$BYTES/1048576" | bc -l)" "$(echo "$SRC_BYTES/1048576" | bc -l)"
