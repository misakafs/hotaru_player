import { defineConfig } from 'vite'
import { viteSingleFile } from 'vite-plugin-singlefile'

export default defineConfig(({ mode }) => {
    const base = mode === 'flutter' ? '' : '/'
    const outDir = mode === 'flutter' ? '../lib/assets' : 'dist'
    return {
        plugins: [viteSingleFile()],
        base: base,
        build: {
            outDir: outDir,
            emptyOutDir: true,
            minify: true
//            rollupOptions: {
//                // 禁用摇树优化
//                treeshake: {
//                    enabled: false
//                }
//            }
        },
        esbuild: {
          drop: ["console", "debugger"],
        },
        css: {
            preprocessorOptions: {
              scss: {
                api: 'modern-compiler',
              },
            },
          },
    }
})
