/**
 * Serve `<wa-icon>` glyphs from SVGs bundled with the app instead of Web
 * Awesome's default resolver, which fetches every icon from the Font Awesome
 * CDN (ka-f.fontawesome.com) — TwiCC must render its icons offline.
 *
 * The SVGs are the Font Awesome Free ones the sources use, vendored under
 * src/assets/fontawesome/<family>/<name>.svg by `npm run icons:sync`
 * (scripts/sync-fa-icons.mjs). Each entry passes its own `import.meta.glob`
 * (eager, `?raw`) so a small bundle can ship only the icons it renders.
 */
import { getIconLibrary, registerIconLibrary } from '@awesome.me/webawesome/dist/components/icon/library.js'

// The folder Web Awesome's default library would use for this family/variant.
// Only the Free folders exist: Pro families (sharp, duotone, …) fall back to solid.
function folderFor(family, variant) {
    if (family === 'brands') return 'brands'
    if ((!family || family === 'classic') && variant === 'regular') return 'regular'
    return 'solid'
}

/**
 * @param {Record<string, string>} svgModules - `import.meta.glob(…/fontawesome/<family>/*.svg, { eager: true, query: '?raw', import: 'default' })`
 */
export function registerLocalIconLibrary(svgModules) {
    const svgs = new Map()
    for (const [path, svg] of Object.entries(svgModules)) {
        const match = path.match(/([^/]+)\/([^/]+)\.svg$/)
        if (match) svgs.set(`${match[1]}/${match[2]}`, svg)
    }
    const urls = new Map()
    const warned = new Set()
    const defaultLibrary = getIconLibrary('default')
    registerIconLibrary('default', {
        // Keep Web Awesome's mutator (duotone handling etc.); only the URL changes.
        ...defaultLibrary,
        resolver: (name, family = 'classic', variant = 'solid') => {
            const key = `${folderFor(family, variant)}/${name}`
            let url = urls.get(key)
            if (url === undefined) {
                const svg = svgs.get(key)
                url = svg ? `data:image/svg+xml;charset=utf-8,${encodeURIComponent(svg)}` : ''
                urls.set(key, url)
                if (!svg && !warned.has(key)) {
                    warned.add(key)
                    console.warn(`[TwiCC] Icon "${key}" is not bundled; run \`npm run icons:sync\` (frontend/scripts/sync-fa-icons.mjs).`)
                }
            }
            return url
        },
    })
}
