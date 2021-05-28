# btcd-node

## Docker volumes

**Special diskspace hint**: The following examples are using a Docker managed volume. The volume is named *btcd-data* This will use a lot of disk space, because it contains the full Bitcoin blockchain. Please make yourself familiar with [Docker volumes](https://docs.docker.com/storage/volumes/).

The *btcd-data* volume will be reused, if you upgrade your *docker-compose.yml* file. Keep in mind, that it is not automatically removed by Docker, if you delete the btcd container. If you don't need the volume anymore, please delete it manually with the command:

```bash
docker volume ls
docker volume rm btcd-data
```

For binding a local folder to your *btcd* container please read the [Docker documentation](https://docs.docker.com/). The preferred way is to use a Docker managed volume.

## Known error messages when starting the btcd container

We pass all needed arguments to *btcd* as command line parameters in our *docker-compose.yml* file. It doesn't make sense to create a *btcd.conf* file. This would make things too complicated. Anyhow *btcd* will complain with following log messages when starting. These messages can be ignored:

```bash
Error creating a default config file: open /sample-btcd.conf: no such file or directory
...
[WRN] BTCD: open /root/.btcd/btcd.conf: no such file or directory
```

## Username Password and SSL Cert

Copy `./rpc.cert` to `/root/.btcd/rpc.cert` in the machine of rpc client for rpc cert. At the same time, use rpcuser=shuttleflow, and rpcpass=kyloM3zEf8 to auth your rpc request.


## Examples

All following examples uses some defaults:

- container_name: btcd
  Name of the docker container that is be shown by e.g. ```docker ps -a```

- hostname: btcd **(very important to set a fixed name before first start)**
  The internal hostname in the docker container. By default, docker is recreating the hostname every time you change the *docker-compose.yml* file. The default hostnames look like *ef00548d4fa5*. This is a problem when using the *btcd* RPC port. The RPC port is using a certificate to validate the hostname. If the hostname changes you need to recreate the certificate. To avoid this, you should set a fixed hostname before the first start. This ensures, that the docker volume is created with a certificate with this hostname.

- restart: unless-stopped
  Starts the *btcd* container when Docker starts, except that when the container is stopped (manually or otherwise), it is not restarted even after Docker restarts.

```bash
docker-compose up -d(creates and starts a new btcd container)
```

With the following commands you can control *docker-compose*:

```docker-compose down``` (stops and delete the container. **The docker volume btcd-data will not be deleted**)

```docker-compose restart``` (restarts the container)

```docker-compose stop``` (stops the container)

```docker-compose start``` (starts the container)

```docker ps -a``` (list all running and stopped container)

```docker volume ls``` (lists all docker volumes)

```docker logs btcd``` (shows the log )

```docker-compose help``` (brings up some helpful information)


### Running on TESTNET

To run a node on testnet, you need to provide the *--testnet* argument. The ports for testnet are 18333 (p2p) and 18334 (RPC):

```yaml
...
    ports:
      - 18333:18333
      - 18334:18334
    command: [
        "--testnet",
...
```
