import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import vue from '@vitejs/plugin-vue';
import path from 'path';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue({
      include: [/\.vue$/],
      template: {
        compilerOptions: {
          compatConfig: {
            MODE: 2
          }
        }
      }
    })
  ],
  optimizeDeps: {
    include: ['vue', '@vue/compat']
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './app/javascript/src'),
      '@channels': path.resolve(__dirname, './app/javascript/channels'),
      'vue': '@vue/compat/dist/vue.esm-bundler.js',
      '/images': path.resolve(__dirname, './public/images'),
      '/img': path.resolve(__dirname, './public/img')
    }
  },
  build: {
    rollupOptions: {
      external: [
        /^\/images\//,
        /^\/img\//
      ]
    }
  },
  define: {
    '__VUE_OPTIONS_API__': 'true',
    '__VUE_PROD_DEVTOOLS__': 'false',
    '__VUE_PROD_HYDRATION_MISMATCH_DETAILS__': 'false'
  }
})
