import { test } from 'node:test'
import assert from 'node:assert/strict'
import { missingIcons } from './sync-fa-icons.mjs'

test('every Font Awesome icon used by src/ is vendored (offline icons)', async () => {
    assert.deepEqual(await missingIcons(), [], 'run `npm run icons:sync`')
})
