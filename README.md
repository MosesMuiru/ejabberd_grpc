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

https://xmpp.org/extensions/xep-0045.html#invite-mediated

***check list for reactions***

    1. create a table for storing reactions
    2. you can only react to an existing message
    3. so sending and invite as a message containing the message id, and the reaction type, 
    4. On the other side i should stream

    reaction the api

    reaction_description
    reaction_emoji
    message_id
    username --> the person who reacted to that message
     
    1. store this to db
    2. 


##Reaction  and Actions
seed the initial reaction to db
 ```
 mix run priv/repo/reactions_seeds.exs 
 ```

 Execute sql file to change permission on users folder i.e
 changing the adding id column and making it a username, 
 ```
 priv/repo/alter_user_table_add_to_id.sql
 ```
 reminder

    insert_to_reminder to db --> insert it to worker
    worker --> fetch the reminder --> send notification by userid
 execution time --> insert to worker
 reminde
 id
 user_id
 message_id


# this is how threading is supposed to work
create thread --> returns a uuid
    user_id
    thread_uuid

then threis sending of messages
    


## Implementation

