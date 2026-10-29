# Backseat

Static YouTube viewers for GitHub Pages. No build step.

| File | What it is |
|---|---|
| `index.html` | Backseat: big-button YouTube search + player, with daily quota/usage stats. The **A\|B** button opens Interleave. |
| `interleave.html` | Plays two videos on alternating frames (odd = A, even = B) with custom patterns, rates, sync and audio controls. Local-file mode is frame-exact and can record the result. |
| `viewer.html` | Embed Lab: compares four ways to present one video (iframe, facade, thumbnail loop, frame sequence). |
| `extract-frames.sh` | Local tool (needs ffmpeg) that makes the WebP frames + `manifest.json` that `viewer.html`'s frame-sequence panel plays. |

## Setup

1. Repo **Settings → Pages → Build and deployment**: Source = *Deploy from a branch*, Branch = `main` / `/ (root)`.
2. Site is at `https://<user>.github.io/<repo>/`.
3. YouTube search needs a YouTube Data API v3 key. Add it via ⚙︎ in Backseat (Interleave reads the same saved key).
   Restrict the key in Google Cloud to website `https://<user>.github.io/*` and API = YouTube Data API v3.

Pasting a YouTube link works everywhere without a key.

## Frame sequences (optional)

```bash
./extract-frames.sh my-video.mp4 <youtube_id> 1 480 60
git add frames && git commit -m "Add frames" && git push
```
Then open `viewer.html?v=<youtube_id>`.

## Warning

Interleave alternates images rapidly. Press **H** or **Esc** to stop the flicker.
