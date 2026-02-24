FROM node:lts AS build
RUN corepack enable && corepack prepare pnpm@10.6.5 --activate
WORKDIR /app
COPY pnpm-lock.yaml package.json .npmrc ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

FROM nginx:alpine AS runtime
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
