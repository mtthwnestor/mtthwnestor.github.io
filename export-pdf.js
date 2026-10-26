import * as path from "path";
import { cwd } from "process";
import * as glob from "glob";
import puppeteer from "puppeteer";

const html_files = glob.sync("resume*.html");

// Initialize the puppeteer browser.
const browser = await puppeteer.launch({
  args: ["--no-sandbox", "--disable-setuid-sandbox"],
});
const page = await browser.newPage();

for (const html_file of html_files) {
  // Load the full path of local HTML file in puppeteer browser.
  const full_path = path.join(cwd(), html_file);
  await page.goto("file:" + full_path, {
    waitUntil: "load",
    timeout: 0,
  });

  // Generate and save a PDF of the loaded page.
  const filename = path.parse(html_file).name + ".pdf";
  await page.pdf({
    path: filename,
    format: "letter",
    printBackground: true,
  });
}

// Cleanly close the puppeteer browser.
await browser.close();
