build:
	docker build -t ejabberd . 
proto:
	protoc --elixir_out=plugins=grpc:./lib/ ./proto/*.proto
start:
	iex -S mix
# pgsql: 
# 	git clone https://github.com/processone/p1_pgsql.git; cd p1_pgsql ; make
protoc:
	protoc -I ./proto --elixir_out=generate-descriptors=true,plugins=grpc:./lib/pb/ ./proto/*.proto

proto: 
	protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=proto proto/*.proto



p:
	mix protobuf.generate --output-path=./lib  --generate-descriptors=true ./protos/*.proto
