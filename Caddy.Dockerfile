FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/lolPants/caddy-requestid \
    --with github.com/caddyserver/cache-handler

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
