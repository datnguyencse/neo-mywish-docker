# neo-mywish-docker

This is a convenient way to run a Neo mywish testnet  blockchain.

**Note:** There is also a turnkey Docker image with the initial 100M NEO and 16.6k GAS already claimed in a ready-to-use wallet available here: https://hub.docker.com/r/cityofzion/neo-privatenet

**Note:** If you are running Ubuntu on Windows (WSL), refer to this article to install and operate docker from Ubuntu:
https://medium.com/@sebagomez/installing-the-docker-client-on-ubuntus-windows-subsystem-for-linux-612b392a44c4
  - If copying and pasting the commands from the article ensure you delete and re-enter any quotation marks that you paste.

These instruction reference the official instructions from Docker found here: https://docs.docker.com/install/linux/docker-ce/ubuntu/.

But, the steps following installation (after step 6) are required in order to run docker from Ubuntu.

## Instructions to build the image yourself

Clone the repository and build the Docker image:

    git clone https://github.com/datnguyencse/neo-mywish-docker.git
    cd neo-mywish-docker
    ./docker_build.sh

`docker_build.sh` has a few possible arguments:

* Disable Docker image caching with `docker_build.sh --no-cache`
* Use a custom neo-cli zip file `docker_build.sh --neo-cli <zip-fn>`
* Show the help with `docker_build.sh -h`

After the image is built, you can start the private network like this:

    ./docker_run.sh

_or_, if you prefer `docker-compose`, you can start the nodes with:

    docker-compose up -d

##### For users who use docker machine (i.e Windows Home Edition users without Hyper-V)

 You'll need your docker machine IP. First, get the name of your machine:

    docker-machine ls

And get the ip with:

    docker-machine ip "Nameofyourmachine"

(By default, the machine name is "default"). Use this ip to replace each occurence of 127.0.0.1 in the SeedList array.

## Copy wallets from docker image to neo-gui

Note: You won't need this step if you used `./create_wallet.sh` or `./docker_run_and_create_wallet.sh` in the previous step (The multiparty signature and neo/gas extraction should already be done).

Once your docker image is running, use the following commands to copy each node's wallet to your neo-gui home directory in preparation for multiparty signature and neo/gas extraction.
Note: all four must be copied.

The following will copy each wallet from the docker image to the current working directory.

    docker cp neo-privnet:/opt/node/neo-cli/wallet.json .

## Wallet Passwords

node: one

## Extracting Neo and Gas
Check out the docs at http://docs.neo.org/en-us/node/private-chain.html for instructions on how to claim Neo and Gas
for testing.
