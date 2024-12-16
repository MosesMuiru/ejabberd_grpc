build:
	docker build -t ejabberd . 
proto:
	protoc --elixir_out=plugins=grpc:./lib/ ./protos/*.proto
start:
	iex -S mix
# pgsql: 
# 	git clone https://github.com/processone/p1_pgsql.git; cd p1_pgsql ; make
protoc:
	protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib/ ./protos/*.proto
