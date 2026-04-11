# syntax=docker/dockerfile:1

ARG NODE_VERSION=22.22.2

# Base image
FROM node:${NODE_VERSION}-trixie-slim AS base
WORKDIR /usr/src/app
RUN corepack enable

# Install all dependencies for build
FROM base AS deps
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Build app
FROM deps AS build
COPY tsconfig.json ./
COPY src ./src
RUN yarn build

# Production dependencies only
FROM base AS prod-deps
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production

# Runtime
FROM gcr.io/distroless/nodejs22-debian13:nonroot AS runtime
WORKDIR /usr/src/app

COPY --from=prod-deps /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist
COPY package.json .

ENV NODE_ENV=production

EXPOSE 3000
USER nonroot

CMD ["dist/main.js"]
