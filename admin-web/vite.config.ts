import { defineConfig } from 'vite';
import { cloudflare } from '@cloudflare/vite-plugin';
import react from '@vitejs/plugin-react';
import { fileURLToPath } from 'node:url';

const generatedPrismaClient = fileURLToPath(
  new URL('../server/node_modules/.prisma/client/wasm.js', import.meta.url),
);
const prismaWasmLoader = fileURLToPath(
  new URL('../server/node_modules/.prisma/client/wasm-worker-loader.mjs', import.meta.url),
);

export default defineConfig(({ command }) => ({
  plugins: [react(), ...(command === 'build' ? [cloudflare()] : [])],
  resolve: {
    alias: [
      { find: /^@prisma\/client$/, replacement: generatedPrismaClient },
      { find: /^#wasm-compiler-loader$/, replacement: prismaWasmLoader },
    ],
  },
  server: {
    port: 5174,
    proxy: {
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true,
      },
    },
  },
}));
