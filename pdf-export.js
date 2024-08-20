import { promises as fs } from 'fs'
import * as path from 'path'
import { cwd } from 'process'
import * as theme from 'jsonresume-theme-even'
import * as theme_ats from '@jsonresume/jsonresume-theme-class'
import puppeteer from 'puppeteer'
import { render } from 'resumed'

const resume = JSON.parse(await fs.readFile('resume.json', 'utf-8'))
const html = await render(resume, theme)
const html_ats = await render(resume, theme_ats)

const browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox']
})
const page = await browser.newPage()

//await page.setContent(html, { waitUntil: 'networkidle0' })
await page.goto(`file:${path.join(cwd(), 'index.html')}`, {waitUntil: 'load', timeout: 0})
await page.pdf({ path: 'resume.pdf', format: 'letter', printBackground: true })
await page.goto(`file:${path.join(cwd(), 'matthew-nestor.html')}`, {waitUntil: 'load', timeout: 0})
await page.pdf({ path: 'matthew-nestor.pdf', format: 'letter', printBackground: true })
await browser.close()