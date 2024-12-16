# Atividade 2 - Criação do Load Balancer para recursos da aplicação Front-end.

Este projeto configura um Load Balancer para distribuir requisições entre 5 nós executando uma aplicação ReactJs. O ambiente utiliza Nginx e Docker.

## Estrutura do Projeto

- **build/**: Contém a aplicação ReactJs compilada.
- **nginx/**: Configurações do Nginx (`nginx.conf` e `default.conf`).

## Configuração

#### 1. Compile a aplicação ReactJs e mova os arquivos para `build/`.

   ````bash
    npm run build
   ````

### 2. Copiar a pasta build para o diretório

Copie a pasta build para o diretório onde será feita a configuração para o balanceamento de carga.

### 3. Configurar o arquivo `nginx.conf`

Configure o arquivo `nginx.conf` com as definições necessárias.

#### Arquivo `nginx.conf`

```nginx
user  nginx;                                                                                                           
worker_processes  auto;                                                                                                
                                                                                                                       
error_log  /var/log/nginx/error.log notice;                                                                            
pid        /var/run/nginx.pid;                                                                                         
                                                                                                                       
                                                                                                                       
events {                                                                                                               
    worker_connections  1024;                                                                                          
}                                                                                                                      
                                                                                                                       
                                                                                                                       
http {                                                                                                                 
    include       /etc/nginx/mime.types;                                                                               
    default_type  application/octet-stream;                                                                            
                                                                                                                       
    log_format  main  '$http_x_real_ip - $remote_user [$time_local] "$request" '                                       
                      '$status $body_bytes_sent "$http_referer" '                                                      
                      '"$http_user_agent" "$http_x_forwarded_for"';                                                    
                                                                                                                       
    access_log  /var/log/nginx/access.log  main;                                                                       
                                                                                                                       
    sendfile        on;                                                                                                
    #tcp_nopush     on;                                                                                                
                                                                                                                       
    keepalive_timeout  65;                                                                                             
                                                                                                                       
    #gzip  on;                                                                                                         
                                                                                                                       
    include /etc/nginx/conf.d/*.conf;
                                                                            
}
```

### 4. Configurar o arquivo `default.conf`

Configure o arquivo `default.conf` conforme descrito abaixo.

#### Arquivo `default.conf`

```nginx
upstream nodes {
    server 172.17.0.2;
    server ip_node2;
    server ip_node3;
    server ip_node4;
    server ip_node5;
} 

server {
    listen 80;
    server_name localhost;
    location / {
        proxy_pass http://nodes;
        proxy_set_header X-Real-IP $remote_addr; 
    }

    access_log /var/log/nginx/access.log  main;
}
```

### 5. Para criar os nós execute os comandos abaixo no terminal:

```sh
   docker run -it -v ./build:/usr/share/nginx/html -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node1 nginx:alpine /bin/sh
   docker run -it -v ./build:/usr/share/nginx/html -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node2 nginx:alpine /bin/sh
   docker run -it -v ./build:/usr/share/nginx/html -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node3 nginx:alpine /bin/sh
   docker run -it -v ./build:/usr/share/nginx/html -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node4 nginx:alpine /bin/sh
   docker run -it -v ./build:/usr/share/nginx/html -v ./nginx.conf:/etc/nginx/nginx.conf -v ./app.conf:/etc/nginx/conf.d/default.conf --name node5 nginx:alpine /bin/sh
   ```

#### 6. O comando acima abrirá o shell para cada nó criado. No shell de cada nó obtenha o ip e cole-o no arquivo default do projeto:
   
 ```nginx
     hostname -i
   ```

#### 7. Agora vamos criar o nosso balanceador. No terminal do projeto execute o comando abaixo:
   
  ```sh
    docker run -it -p 80:80 -v ./default.conf:/etc/nginx/conf.d/default.conf --name loadbalancer nginx:alpine
  ```
    
**Agora pode visualizar a aplicação disponível no localhost/**
