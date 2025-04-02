build:
	docker build -t ejabberd . 

start:
	iex -S mix

protocompile:
	protoc -I ./proto --elixir_out=generate-descriptors=true,plugins=grpc:./lib/pb/ ./proto/*.proto

# use the on below
protoc: 
	protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib/pb --proto_path=proto proto/*.proto
