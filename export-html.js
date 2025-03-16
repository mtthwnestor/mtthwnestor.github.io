import { promises as fs } from "fs";
import * as path from "path";
import { cwd } from "process";
import { render } from "resumed";
import * as theme_main from "jsonresume-theme-jacrys";
import * as theme_ats from "@jsonresume/jsonresume-theme-class";

const themes = [theme_main, theme_ats];
const resume_files = [
  "resume.json",
  "resume-writer.json",
  "resume-support.json",
  "resume-retail.json",
];

for (const resume of resume_files) {
  const jsonresume = JSON.parse(await fs.readFile(resume, "utf-8"));

  let theme_num = 0;
  for (const theme of themes) {
    const htmlresume = await render(jsonresume, theme);

    const filename = path.parse(resume).name;
    await fs.writeFile(filename + theme_num + ".html", htmlresume);

    theme_num = theme_num + 1;
  }
}
