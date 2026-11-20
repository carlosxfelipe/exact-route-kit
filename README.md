# Exact Route Kit

Starter template inspired by [expo-route-kit](https://github.com/carlosxfelipe/expo-route-kit), built with **Exact** ([expo/exact](https://github.com/expo/exact)).

## What's included

- **Authentication gate** (`signedIn` at [`app.contract#L31`](./app.contract#L31), `signInCheck` at [`app.ts#L31`](./app.ts#L31)): starts on Login (`Fill Demo` or email/password validation) and switches to the main tabs once signed in. Set `state signedIn = true persist` at [`app.contract#L31`](./app.contract#L31) to skip login during development.
- **Persistent 3-tab navigation (`routes nav`)**:
  - **Home** (`/`): welcome banner, `SummaryCard`, quick-navigation rows, notifications badge with auto-dismiss toast, and push navigation to **Detail** (`/detail/:id`).
  - **Explore** (`/explore`): live search filter, `StatBar`, `DoneMark`, native `select`, `switch`, `input`, empty-state toggle, and native `alertdialog`.
  - **Profile** (`/profile`): user card, **Edit Profile** modal sheet (`/profile/edit`), notifications toggle, **Theme Mode** (`System` / `Light` / `Dark` via `setScheme`), **Color Preset** (`Custom Blue` / `Deep Purple` via `app.forma` axes), and **Sign Out** confirmation dialog.
- **Forma brand theme ([`app.forma`](./app.forma))**: `custom_blue` and `deep_purple` presets with automatic light/dark tokens.
- **Automated tests ([`app.test.contract`](./app.test.contract))**: end-to-end flow tests covering login, tab switching, stack push/back, modal edit, theme switching, and sign out.

## Prerequisites

1. Clone and set up [expo/exact](https://github.com/expo/exact) alongside this project (or set `EXACT=<path-to-exact>`):

```bash
git clone https://github.com/expo/exact.git
cd exact
bun scripts/exact.mjs setup --platform web
```

2. Link or point this project to your Exact checkout (first run creates `.exact/checkout` automatically if `exact` is beside it, or pass `EXACT=../exact`).

## Running locally

```bash
# Start the Web dev server (reloads on save)
bun exact.mjs web

# Run tests on Web
bun exact.mjs test web

# Full verification (tests + light/dark + accessibility tree + largest text size)
bun exact.mjs verify
```

> Note: `exact.mjs` automatically uses `~/.bun-1.4.2/bin/bun` when present. Ensure `~/.cargo/bin` is on your `PATH` if `wasm-bindgen` is needed.
