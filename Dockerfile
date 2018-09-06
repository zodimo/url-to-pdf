FROM node:8-slim
# Environment variables
ENV NODE_ENV=development PORT=9000 ALLOW_HTTP=true

RUN apt-get update && \
apt-get install -yq  \
# Google chrome.. requirements..
libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
libxi6 libxtst6 libnss3 libcups2 libxss1 libxrandr2 libasound2 \
libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 \
fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
git \
&& \
apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*


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