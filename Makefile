build:
	docker build -t ejabberd . 
proto:
	protoc --elixir_out=plugins=grpc:./lib/ ./protos/*.proto
start:
	iex -S mix