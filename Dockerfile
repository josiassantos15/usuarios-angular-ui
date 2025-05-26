# Stage 1: build da aplicação
FROM node:18-alpine AS builder

WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala dependências
RUN npm ci

# Copia todo o código
COPY . .

# Gera build de produção
RUN npm run build -- --configuration production

# Stage 2: serve com Nginx
FROM nginx:alpine

# Remove configuração default do Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia build para o diretório do Nginx
COPY --from=builder /app/dist/usuarios-angular-ui /usr/share/nginx/html

# Copia um nginx.conf customizado (opcional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80
EXPOSE 80

# Inicia o Nginx em primeiro plano
CMD ["nginx", "-g", "daemon off;"]
