import {promises as fs} from "fs";
import * as path from "path";
import {cwd} from "process";
import puppeteer from "puppeteer";

const browser = await puppeteer.launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
});
const page = await browser.newPage();

//await page.setContent(html, { waitUntil: 'networkidle0' })

// resume.pdf
await page.goto(`file:${path.join(cwd(), "index.html")}`, {
    waitUntil: "load", timeout: 0,
});
await page.pdf({path: "resume.pdf", format: "letter", printBackground: true});

// matthew-nestor.pdf
await page.goto(`file:${path.join(cwd(), "matthew-nestor.html")}`, {
    waitUntil: "load", timeout: 0,
});
await page.pdf({
    path: "matthew-nestor.pdf", format: "letter", printBackground: true,
});

// resume-retail.pdf
await page.goto(`file:${path.join(cwd(), "index-retail.html")}`, {
    waitUntil: "load", timeout: 0,
});
await page.pdf({
    path: "resume-retail.pdf", format: "letter", printBackground: true,
});

// matthew-nestor-retail.pdf
await page.goto(`file:${path.join(cwd(), "matthew-nestor-retail.html")}`, {
    waitUntil: "load", timeout: 0,
});
await page.pdf({
    path: "matthew-nestor-retail.pdf", format: "letter", printBackground: true,
});

await browser.close();
