# Customer Web Portal

This Vite + React application provides the public LiqPass/LeverSafe experience.

## Local Development

```bash
npm install
npm run dev
```

The dev server serves `index.html` and the `/help` entry point defined in
`vite.config.ts`. Adjust environment variables via `.env` files beginning with
`VITE_` (see `env/templates/customer-web.env.example`).

## Production Build

```bash
npm run build
npm run preview
```

Use the generated `dist/` artefacts for manual deployments as described in
`docs/10-processes/release.md`.

## Notes

- All UI copy lives in `src/content/`.
- Runtime configuration is handled via `src/runtime/` modules.
- Keep components typed (see `src/types/`).
