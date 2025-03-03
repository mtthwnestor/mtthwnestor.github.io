import * as fs from 'fs';
import HTMLtoDOCX from "html-to-docx";


let html = ""
try {
    html = fs.readFileSync('./index.html', 'utf8');
} catch (err) {
    console.error(err);
}
console.log(html)
const outputPath = "./index.docx";

const htmlString = html;
const documentOptions = {
    title: "Matthew Nestor",
    creator: "Matthew Nestor",
    keywords: ["resume", "cv"],
    description: "Matthew Nestor's CV.",
    font: "sans-serif",
    fontSize: 24
};

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
