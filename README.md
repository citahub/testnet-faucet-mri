# Testnet Faucet

## dependencies

  - postgresql
  - redis
  - imagemagic
  - ghostscript
  - [cita-cli](https://github.com/driftluo/cita-cli)
    
## init project

  - rails db:setup
  - build cita-cli binary and move to system bin path, such as /usr/local/bin, for global access.
  
## config project
  - touch .env.local (config for private key, url and so on...)
  - cp config/database.yml.sample config/database.yml (for database config)
  - touch config/master.key (optional for development and test)
  - cp config/puma.rb.sample config/puma.rb (optional for development and test)
  
## run project
  - rails s
  
