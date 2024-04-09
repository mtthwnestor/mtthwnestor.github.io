# mtthwnestor.github.io

The environment is set up ourselves with these commands:

```bash
npm install --save-dev resumed jsonresume-theme-even
npx resumed --theme jsonresume-theme-even
```

This has been automated with a `Makefile` to simplify the steps to build using Docker containers:

1. Update `resume.json` with your resume data.
1. Open a terminal in the project folder and run the following command:

    ```bash
    make resume
    ```
