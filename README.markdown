# Hound
This is the source code for Hound, the domain portfolio management app thing that I go on about.

## System Dependencies
    libidn

## Gems
    formtastic
    factory_girl
    haml
    authlogic
    less
    idn
    state_machine
    net-dns
    garb

delayed_job
## Useful shit
    http://idn.rubyforge.org/docs/

## Delayed job
Start multiple processes on the server:
    RAILS_ENV=production script/delayed_job -n 2 start
Stop
    RAILS_ENV=production script/delayed_job stop
