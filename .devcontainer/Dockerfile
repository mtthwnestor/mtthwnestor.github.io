FROM node:24-trixie

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    pip \
    pandoc \
    git \
    curl \
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
    libxrandr2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Install npm dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the files
COPY . .

# Pre-install Puppeteer Chrome
RUN npx puppeteer browsers install chrome

# Default command
CMD ["npm", "run", "start"]
