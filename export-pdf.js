import { promises as fs } from "fs";
import * as path from "path";
import { cwd } from "process";
import * as glob from "glob";
import puppeteer from "puppeteer";

const html_files = glob.sync("resume*.html", {});

const browser = await puppeteer.launch({
  args: ["--no-sandbox", "--disable-setuid-sandbox"],
});
const page = await browser.newPage();

//await page.setContent(html, { waitUntil: 'networkidle0' })

for (let file of html_files) {
  await page.goto("file:" + path.join(cwd(), file), {
    waitUntil: "load",
    timeout: 0,
  });
  await page.pdf({
    path: path.parse(file).name + ".pdf",
    format: "letter",
    printBackground: true,
  });
}

await browser.close();
