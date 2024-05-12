FROM python:3.12-slim

# Install Node.js

# Update and install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common curl python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# Copy over the local NPM package
# this is why the Dockerfile is in the root folder
WORKDIR /usr/src/noodl-cloudservice
COPY ./packages/noodl-cloudservice .
RUN npm install && \
    npm run build &&

WORKDIR /usr/src/app
COPY packages/noodl-cloudservice-docker .
RUN npm install --install-links

RUN npm install -g @ironclad/rivet-node

# Install Python packages
RUN pip install --upgrade pip
RUN pip install -r requirements.txt  


EXPOSE 3000
CMD [ "node", "./src/index.js" ]

