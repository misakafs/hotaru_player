import { defineConfig } from 'vite'
import solid from 'vite-plugin-solid'
import { viteSingleFile } from 'vite-plugin-singlefile'

export default defineConfig(({ mode }) => {
    const base: string = mode === 'flutter' ? '' : '/'
    const outDir: string = mode === 'flutter' ? '../../lib/assets' : 'dist'
    return {
        plugins: [solid(), viteSingleFile()],
        base: base,
        build: {
            outDir: outDir,
            emptyOutDir: true
        }
    }
})
