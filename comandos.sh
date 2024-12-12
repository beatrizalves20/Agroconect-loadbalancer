# subir o lb
docker run -it -p 80:80 -v ./default.conf:/etc/nginx/conf.d/default.conf --name loadbalancer nginx:alpine

#subir os nós
docker run -d --name node1 nginx:alpine
docker run -d --name node2 nginx:alpine
docker run -d --name node3 nginx:alpine
docker run -it --name node1 nginx:alpine