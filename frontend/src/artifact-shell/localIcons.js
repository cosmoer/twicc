// Offline icons for the shell: only the two glyphs the consent prompt's callout
// shows (ArtifactBrokerPrompt.vue), not the SPA's whole vendored set.
import { registerLocalIconLibrary } from '../utils/localIconLibrary'

registerLocalIconLibrary(import.meta.glob('../assets/fontawesome/solid/{circle-info,triangle-exclamation}.svg', { eager: true, query: '?raw', import: 'default' }))
