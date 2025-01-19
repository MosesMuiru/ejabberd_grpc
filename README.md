# EjabberdRcp

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ejabberd_rcp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ejabberd_rcp, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ejabberd_rcp>.

## Add deps

```elixir
    mix deps.get 
```

### start ejabberd server + grpc

```elixir

    iex -S mix 

    # grpc server
    port: 5051 
```

### Docker config


```

    
    docker compose build

    docker compose up

    
    envoy port: 8081

```

** Register User first**

```
localhost:8081/{registeruser}

    {
        "user": "bob",
        "host": "example.com",
        "password": "SomEPass44"
    }


```

** sending messages **

```
    localhost:8081/{send message protofile}

    {
        "type": "headline",
        "from": "moses@localhost",
        "to": "kamau@localhost",
        "subject": "Restart",
        "body": "In 5 minutes"
    }

```

** Recieving Messages**

use da-messaging-svc

```
    git clone
    
    envs

    start server

    localhost:{port}/MessageService/Monitor

    {
	"jid": "moses@localhost",
	"server": "localhost:5222",
	"password": "password"
    }

```
invites
https://xmpp.org/extensions/xep-0249.html