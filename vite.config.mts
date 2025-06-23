import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import vue from '@vitejs/plugin-vue';
import path from 'path';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue({
      include: [/\.vue$/]
    })
  ],
  optimizeDeps: {
    include: ['vue', 'fast-deep-equal']
  },
  publicDir: 'public',
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './app/javascript/src'),
      '@channels': path.resolve(__dirname, './app/javascript/channels'),
      'vue': 'vue/dist/vue.esm-bundler.js'
    }
  },
  css: {
    preprocessorOptions: {
      scss: {
        includePaths: [path.resolve(__dirname, './app/javascript/stylesheets')],
        api: 'legacy'
      }
    }
  },
  build: {
    // Ensure manifest doesn't include static assets
    manifest: true,
    assetsDir: 'assets'
  },
  define: {
    '__VUE_OPTIONS_API__': 'true',
    '__VUE_PROD_DEVTOOLS__': 'false',
    '__VUE_PROD_HYDRATION_MISMATCH_DETAILS__': 'false'
  }
})
