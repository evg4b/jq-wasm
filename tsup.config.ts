import { copy } from 'esbuild-plugin-copy';
import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/index.ts'],
  splitting: false,
  sourcemap: true,
  clean: true,
  dts: false,
  target: 'es6',
  format: ['cjs', 'esm'],
  tsconfig: './tsconfig.json',
  esbuildPlugins: [
    copy({
      resolveFrom: 'cwd',
      assets: { from: './tmp/*.wasm', to: './dist' },
    }),
    copy({
      resolveFrom: 'cwd',
      assets: { from: './package.json', to: './dist/package.json' },
    }),
  ],
});
