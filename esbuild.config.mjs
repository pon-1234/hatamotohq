import esbuild from 'esbuild';
import path from 'path';
import fs from 'fs';

const args = process.argv.slice(2);
const watch = args.includes('--watch');

// Simple Vue plugin that treats .vue files as external for now
const vueExternalPlugin = {
  name: 'vue-external',
  setup(build) {
    build.onResolve({ filter: /\.vue$/ }, args => {
      // For now, we'll treat Vue files as external and handle them separately
      return {
        path: args.path,
        external: true
      };
    });
  }
};

const config = {
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  format: 'iife',
  globalName: 'HatamotoApp',
  outdir: path.join(process.cwd(), 'app/assets/builds'),
  publicPath: '/assets',
  loader: {
    '.png': 'file',
    '.jpg': 'file',
    '.jpeg': 'file',
    '.gif': 'file',
    '.svg': 'file',
    '.woff': 'file',
    '.woff2': 'file',
    '.ttf': 'file',
    '.eot': 'file'
  },
  define: {
    'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
    'process.env.MIX_GOOGLE_MAP_KEY': JSON.stringify(process.env.MIX_GOOGLE_MAP_KEY || ''),
    'process.env.GOOGLE_OAUTH_CLIENT_ID': JSON.stringify(process.env.GOOGLE_OAUTH_CLIENT_ID || ''),
    'process.env.MIX_ROOT_PATH': JSON.stringify(process.env.MIX_ROOT_PATH || ''),
    'global': 'window',
    '__VUE_OPTIONS_API__': 'true',
    '__VUE_PROD_DEVTOOLS__': 'false',
    '__VUE_PROD_HYDRATION_MISMATCH_DETAILS__': 'false'
  },
  alias: {
    '@': path.join(process.cwd(), 'app/javascript/src'),
    '@channels': path.join(process.cwd(), 'app/javascript/channels'),
    'vue': '@vue/compat/dist/vue.esm-bundler.js'
  },
  plugins: [
    vueExternalPlugin
  ],
  // Exclude Vue files from bundling for now
  external: ['*.vue']
};

async function buildOrWatch() {
  try {
    if (watch) {
      const ctx = await esbuild.context(config);
      await ctx.watch();
      console.log('Watching for changes...');
    } else {
      await esbuild.build(config);
      console.log('Build complete');
    }
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

buildOrWatch();