import { promises as fs } from "fs";
import Handlebars from "handlebars";

const resume = JSON.parse(await fs.readFile("resume.json", "utf-8"));
const template = Handlebars.compile(await fs.readFile("wordpress.hb", "utf-8"));
const html = template(resume);

const apiUser = process.env.WP_USERNAME;
const apiKey = process.env.WP_PASSWORD;
const apiUrl = "https://www.kf8hjz.net/wp-json/wp/v2/";
const pageSlug = "resume";
const pageId = await fetch(
  apiUrl + "pages?status=publish,draft&slug=" + pageSlug,
  {
    headers: {
      Authorization: "Basic " + btoa(apiUser + ":" + apiKey),
    },
  },
)
  .then((response) => response.json())
  .then((data) => data[0].id);

const page = {
  status: "draft",
  template: "page-no-title",
  title: resume.basics.name,
  content: html,
};

await fetch(apiUrl + "pages/" + pageId, {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    Authorization: "Basic " + btoa(apiUser + ":" + apiKey),
  },
  body: JSON.stringify(page),
});
