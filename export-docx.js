import * as fs from 'fs';
import HTMLtoDOCX from "html-to-docx";


let html = "test";
await fs.readFile('./index.html', 'utf8', (err, data) => {
    if (err) {
        console.error("An error occurred:", err);
        return;
    }
    html = data; // FIXME: I need to modify the outer "html" variable, but it is out of scope...
});
console.log(html)
const outputPath = "./index.docx";

const htmlString = html;
const documentOptions = {
    title: "Matthew Nestor",
    creator: "Matthew Nestor",
    keywords: ["resume", "cv"],
    description: "Matthew Nestor's CV.",
    font: "sans-serif",
    fontSize: 14
};
const footerHTMLString = "<p></p>";

(async () => {
    const fileBuffer = await HTMLtoDOCX(htmlString, null, documentOptions);

    fs.writeFile(outputPath, fileBuffer, (error) => {
        if (error) {
            console.log('Docx file creation failed');
            return;
        }
        console.log('Docx file created successfully');
    });
})();
