FROM node:22.3.0-alpine3.20 AS node

FROM node AS builder
WORKDIR /app
COPY . .
ENV NEXT_TELEMETRY_DISABLED 1
RUN npm ci &&\
    npm run build

FROM node
WORKDIR /app
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
ENV NODE_OPTIONS="--max-http-header-size=51200" \
    NEXT_TELEMETRY_DISABLED=1 \
    HOSTNAME="0.0.0.0" \
    PORT=3000

# if you need sharp
# RUN cd /tmp && npm i sharp
# ENV NEXT_SHARP_PATH=/tmp/node_modules/sharp

EXPOSE 3000
ENTRYPOINT [ "node" ]
CMD [ "server.js" ]
