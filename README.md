# mtthwnestor.github.io

My GitHub site. Currently renders and hosts my JSON resume files.

## Development Environment

This is primarily a NodeJS based project. We are using a Dev Container (`.devcontainer/Dockerfile`) running `node:24-trixie` (NodeJS 24 running on Debian 13 trixie). The following system packages are included in the container image to support `puppeteer`/chromium on ARM64 (e.g. Apple Silicon):

```bash
libnspr4 \
libnss3 \
libatk1.0-0t64 \
libatk-bridge2.0-0t64 \
libcups2t64 \
libxkbcommon0 \
libasound2t64 \
libgbm1 \
libxcomposite1 \
libxdamage1 \
libxfixes3 \
libxrandr2
```

Use the `Dev Containers` VSCode extension. From the command palette, run `>Dev Containers: Rebuild Container` to build and use the image.

### Git Credentials (SSH)

To utilize your host's git credentials/SSH keys for authentication you must ensure you are using an SSH agent on the host and configure the SSH daemon to allow agent forwarding. E.g., run `ssh-agent` and modify `/etc/ssh/sshd_config` (restart `sshd` afterwards):

```plaintext
AllowAgentForwarding yes
```

Be sure to add your keys to the agent with e.g. `ssh-add ~/.ssh/id_ed25519`.

## CLI

The environment is set up with `resumed`, a community alternative to the official `resume-cli`:

```bash
npm install --save-dev resumed jsonresume-theme-even
npx resumed --theme jsonresume-theme-even
```

## Updating

1. To update the **Dev Container/Docker image** change the `FROM` property in `.devcontainer/Dockerfile`, if needed, and rebuild the container.
1. To update `resumed`, `puppeteer`, and other NodeJS dependencies run `npm update` within the container.
1. Lastly, update `.github/workflows/gh-pages.yml` with an up-to-date runner, e.g. `ubuntu-26.04` and updated GitHub Workflow Actions versions and settings, e.g. `actions/setup-node@v7` with `node-version: "24"`.

## References

- [Dev Containers: Sharing Git Credentials - SSH Keys](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials#_using-ssh-keys)
- [GitHub Actions: GitHub Hosted Runners](https://docs.github.com/en/actions/reference/runners/github-hosted-runners#standard-github-hosted-runners-for--private-repositories)
- [GitHub Marketplace: Actions](https://github.com/marketplace?type=actions)
- [JSON Resume](https://jsonresume.org/)
