build:
	docker build -t ejabberd . 

start:
	iex -S mix
# pgsql: 
# 	git clone https://github.com/processone/p1_pgsql.git; cd p1_pgsql ; make
protoc:
	protoc -I ./proto --elixir_out=generate-descriptors=true,plugins=grpc:./lib/pb/ ./proto/*.proto

proto: 
	protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib/pb --proto_path=proto proto/*.proto
