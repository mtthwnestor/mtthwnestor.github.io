import { promises as fs } from "fs";
import * as path from "path";
import * as glob from "glob";
import JSONMergePatch from "json-merge-patch";
import { render } from "resumed";
import * as theme_ats from "@jsonresume/jsonresume-theme-class";
import * as theme_main from "jsonresume-theme-jacrys";

const themes = [theme_ats, theme_main];

const json_patches = glob.sync("resume-*.json");

for (const theme of themes) {
  // Read, render and write our main resume.
  const json_base = JSON.parse(await fs.readFile("resume.json", "utf-8"));
  const base_resume = await render(json_base, theme);
  const filename = "resume" + themes.indexOf(theme) + ".html";
  await fs.writeFile(filename, base_resume);

  // Apply patches, render, and write variants.
  for (const json_patch of json_patches) {
    const json_base = JSON.parse(await fs.readFile("resume.json", "utf-8"));
    const json_patched = JSONMergePatch.apply(
      json_base,
      JSON.parse(await fs.readFile(json_patch, "utf-8")),
    );

    const patched_resume = await render(json_patched, theme);
    const filename =
      path.parse(json_patch).name + themes.indexOf(theme) + ".html";
    await fs.writeFile(filename, patched_resume);
  }
}
