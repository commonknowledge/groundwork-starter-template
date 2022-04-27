import { defineConfig } from "vite";

const BUNDLE_ENTRYPOINTS = {
  main: "./frontend/main.ts",
};

export default defineConfig(() => {
  return {
    base: "/static/bundle/",
    optimizeDeps: {
      entries: Object.values(BUNDLE_ENTRYPOINTS),
    },
    build: {
      manifest: true,
      emptyOutDir: true,
      rollupOptions: {
        output: {
          dir: "dist/bundle/",
        },
        input: BUNDLE_ENTRYPOINTS,
      },
    },
  };
});
