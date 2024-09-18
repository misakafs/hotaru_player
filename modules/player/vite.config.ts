import { defineConfig } from 'vite'
import solid from 'vite-plugin-solid'
import { viteSingleFile } from 'vite-plugin-singlefile'

export default defineConfig(({ mode }) => {
    const base: string = mode === 'flutter' ? '' : '/'
    const outDir: string = mode === 'flutter' ? '../../lib/assets' : 'dist'
    return {
        plugins: [solid()],
        base: base,
        build: {
            outDir: outDir,
            emptyOutDir: true,
            rollupOptions: {
                output: {
                    // 对于 JavaScript 文件
                    entryFileNames: `index.js`,
                    // 对于 CSS 文件
                    assetFileNames: `index.css`,
                },
            },
        },

    }
})
