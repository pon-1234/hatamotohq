import esbuild from 'esbuild';
import path from 'path';

const args = process.argv.slice(2);
const watch = args.includes('--watch');

const config = {
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  format: 'esm',
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
  },
  external: [
    '*.vue'  // Temporarily exclude Vue files
  ],
  plugins: [
    {
      name: 'vue-stub',
      setup(build) {
        // Stub Vue files temporarily
        build.onResolve({ filter: /\.vue$/ }, args => {
          return { 
            path: args.path,
            namespace: 'vue-stub',
            external: true 
          };
        });
      }
    }
  ]
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