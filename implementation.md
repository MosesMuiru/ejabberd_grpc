## Ejabberd messaging implementation

## (ejabberd + core_svc) Logging process and Ejabberd registration of users
During login we check if the user already register to ejabberd, NB: this is async -> 
    if not 
        register user to ejabberd
    if yes -> login should happen normally without interference

## (ejabberd + frontend) initiating a session for unique user 
    During login - then initiate session


