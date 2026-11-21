// Vendor the Font Awesome Free SVGs the frontend uses into src/assets/fontawesome/,
// so `<wa-icon>` never fetches from the Font Awesome CDN (TwiCC must work offline).
// See src/utils/localIconLibrary.js for the resolver that serves them.
//
// Icon names are often dynamic (`:name="x ? 'a' : 'b'"`, `icon: 'foo'` in JS maps,
// `h('wa-icon', { name })`…), so the scan is deliberately generous: every quoted
// kebab-case string literal in src/ that is a Font Awesome Free icon name is kept,
// per family (solid, regular, brands). A few extra icons cost a few hundred bytes.
//
//   npm run icons:sync    rewrite src/assets/fontawesome/ from the current sources
//   npm run icons:check   fail if a used icon is not vendored (CI / node --test)
import { mkdir, readdir, readFile, rm, writeFile } from 'node:fs/promises'
import { join, relative } from 'node:path'
import { fileURLToPath } from 'node:url'

const frontendDir = fileURLToPath(new URL('../', import.meta.url))
const srcDir = join(frontendDir, 'src')
export const vendorDir = join(srcDir, 'assets', 'fontawesome')
const faDir = join(frontendDir, 'node_modules', '@fortawesome', 'fontawesome-free', 'svgs')
export const FAMILIES = ['solid', 'regular', 'brands']

const SKIP_DIRS = new Set(['locales', 'assets', '__tests__'])
const SOURCE_FILE = /\.(vue|js|mjs|ts)$/
const LITERAL = /(['"`])([a-z0-9]+(?:-[a-z0-9]+)*)\1/g

async function sourceFiles(dir) {
    const files = []
    for (const entry of await readdir(dir, { withFileTypes: true })) {
        const path = join(dir, entry.name)
        if (entry.isDirectory()) {
            if (!SKIP_DIRS.has(entry.name)) files.push(...await sourceFiles(path))
        } else if (SOURCE_FILE.test(entry.name) && !/\.test\./.test(entry.name)) {
            files.push(path)
        }
    }
    return files
}

async function svgNames(dir) {
    try {
        return new Set((await readdir(dir)).filter(n => n.endsWith('.svg')).map(n => n.slice(0, -4)))
    } catch {
        return new Set()
    }
}

/** Every Font Awesome Free icon name used (or possibly used) by src/, per family. */
export async function usedIcons() {
    const literals = new Set()
    for (const file of await sourceFiles(srcDir)) {
        for (const match of (await readFile(file, 'utf8')).matchAll(LITERAL)) literals.add(match[2])
    }
    const used = {}
    for (const family of FAMILIES) {
        const available = await svgNames(join(faDir, family))
        if (!available.size) throw new Error(`Font Awesome Free not installed (${relative(frontendDir, faDir)}); run npm ci`)
        used[family] = [...literals].filter(name => available.has(name)).sort()
    }
    return used
}

/** Used icons that are not vendored yet, as "family/name". */
export async function missingIcons() {
    const used = await usedIcons()
    const missing = []
    for (const family of FAMILIES) {
        const vendored = await svgNames(join(vendorDir, family))
        for (const name of used[family]) if (!vendored.has(name)) missing.push(`${family}/${name}`)
    }
    return missing
}

async function sync() {
    const used = await usedIcons()
    await rm(vendorDir, { recursive: true, force: true })
    for (const family of FAMILIES) {
        await mkdir(join(vendorDir, family), { recursive: true })
        for (const name of used[family]) {
            const svg = await readFile(join(faDir, family, `${name}.svg`), 'utf8')
            await writeFile(join(vendorDir, family, `${name}.svg`), svg.trimEnd() + '\n')
        }
    }
    const license = await readFile(join(faDir, '..', 'LICENSE.txt'), 'utf8')
    await writeFile(join(vendorDir, 'LICENSE.txt'), license)
    console.log(FAMILIES.map(f => `${f}: ${used[f].length}`).join(', '))
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
    if (process.argv.includes('--check')) {
        const missing = await missingIcons()
        if (missing.length) {
            console.error(`Icons used but not vendored (run \`npm run icons:sync\`):\n  ${missing.join('\n  ')}`)
            process.exit(1)
        }
        console.log('All used Font Awesome icons are vendored.')
    } else {
        await sync()
    }
}
