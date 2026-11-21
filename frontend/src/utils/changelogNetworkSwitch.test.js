import { test, afterEach } from 'node:test'
import assert from 'node:assert/strict'
import { fetchChangelog, resolveImageGitHubUrl, setRemoteChangelogEnabled } from './changelog.js'

const MARKDOWN = '## [Unreleased]\n\n### Added\n- Next\n\n## [1.0.0] - 2026-01-01\n\n### Added\n- First\n'
const realFetch = globalThis.fetch

function recordFetches() {
    const urls = []
    globalThis.fetch = async url => {
        urls.push(String(url))
        return new Response(MARKDOWN, { status: 200 })
    }
    return urls
}

afterEach(() => {
    globalThis.fetch = realFetch
    setRemoteChangelogEnabled(true)
})

test('the changelog is read from GitHub by default', async () => {
    const urls = recordFetches()
    const versions = await fetchChangelog(false)
    assert.equal(urls.length, 1)
    assert.match(urls[0], /^https:\/\/raw\.githubusercontent\.com\//)
    assert.deepEqual(versions.map(v => v.version), ['1.0.0'])
    assert.match(resolveImageGitHubUrl('frontend/public/a.webp'), /^https:\/\/raw\.githubusercontent\.com\//)
})

test('with the GitHub fetch switched off, the changelog comes from the backend and no GitHub URL is built', async () => {
    setRemoteChangelogEnabled(false)
    const urls = recordFetches()
    const versions = await fetchChangelog(false)
    assert.deepEqual(urls, ['/api/changelog/'])
    // Still a production view: only real releases.
    assert.deepEqual(versions.map(v => v.version), ['1.0.0'])
    assert.equal(resolveImageGitHubUrl('frontend/public/a.webp'), null)
})
