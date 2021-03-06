FROM node:0.10.41
ENV PORT 3000
EXPOSE 3000
RUN adduser --system --no-create-home --disabled-login app && \
  curl https://install.meteor.com |sh
COPY . /src
RUN cd /src && \
  meteor build --directory / && \
  rm -rf /usr/local/bin/meteor /root/.meteor && \
  cd /bundle/programs/server && \
  npm install && \
  npm cache clear && \
  mv node_modules /bundle && \
  cp /src/package.json /bundle && \
  cd /bundle && \
  npm install && \
  npm cache clear && \
  ln -s /bundle/node_modules /bundle/programs/server && \
  ln -s /bundle/node_modules /bundle/programs/web.browser && \
  rm -rf /src
USER app
WORKDIR /bundle
CMD node main.js
