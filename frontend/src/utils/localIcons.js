// Register every vendored Font Awesome Free icon as the default <wa-icon>
// library (no CDN request). Import before anything that wraps the default
// library (utils/brandRobotIcon.js).
import { registerLocalIconLibrary } from './localIconLibrary'

registerLocalIconLibrary(import.meta.glob('../assets/fontawesome/*/*.svg', { eager: true, query: '?raw', import: 'default' }))
