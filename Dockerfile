FROM node:8-slim
# Environment variables
ENV NODE_ENV=development PORT=9000 ALLOW_HTTP=true

RUN apt-get update && \
    apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
    libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget git

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
RUN apt-get update && apt-get install -y fontconfig fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /src/*.deb

RUN echo 'deb http://ftp.debian.org/debian stretch main contrib' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -yq --allow-unauthenticated ttf-mscorefonts-installer


# Clone the repo
WORKDIR /usr/src
RUN git clone https://github.com/alvarcarto/url-to-pdf-api.git

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)

RUN scp ../url-to-pdf-api/package*.json  .
RUN npm install

# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
RUN scp -r ../url-to-pdf-api/* .
#COPY . .

EXPOSE 8080
CMD [ "npm", "start" ]