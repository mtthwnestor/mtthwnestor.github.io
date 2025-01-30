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

## Updating

To update the images for Node and Puppeteer you should follow these steps:

1. Update the `NODE_IMAGE` variable in `Makefile` to the version of Node you wish to use, e.g. `22`.
1. Run `make node-env` and then run `npm update` within the container. Leave the container with `exit`.
1. Update the `PUPPETEER_IMAGE` variable in `Makefile` to a Puppeteer version that matches the `NODE_IMAGE` major version, e.g. `22.15.0`. Ideally, you should match it with the `"node_modules/puppeteer"` version in `package-lock.json` after you ran `npm update`.
1. Update `.gitlab-ci.yml` and `.github/workflows/gh-pages.yml` to use the same image versions used in `Makefile`.
