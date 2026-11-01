// Copies the static placeholder site into dist/ (no dependencies required).
import { cpSync, rmSync } from 'node:fs'

rmSync('dist', { recursive: true, force: true })
cpSync('public', 'dist', { recursive: true })
console.log('Built placeholder site to frontend/dist')
