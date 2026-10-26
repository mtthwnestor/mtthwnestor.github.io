import { promises as fs } from "fs";
import * as path from "path";
import * as glob from "glob";
import HTMLtoDOCX from "html-to-docx";

const html_files = glob.sync("resume*.html");

const documentOptions = {
  title: "Madison Nestor",
  creator: "Madison Nestor",
  keywords: ["resume", "cv"],
  description: "Madison Nestor's CV.",
  font: "sans-serif",
  fontSize: 24,
};

for (const html_file of html_files) {
  const html_resume = await fs.readFile(html_file, "utf8");

  const docx_resume = await HTMLtoDOCX(html_resume, null, documentOptions);

  const filename = path.parse(html_file).name + ".docx";
  await fs.writeFile(filename, docx_resume);
}
