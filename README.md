# Plutus-apps Container Image

Since [plutus-starter devcontainer on Dockerhub] is outdated, and I couldn't
figure out how to get it updated, I've built my own.

I hope this can help people who can't set up a Nix environment for whatever reason
to be able to build Plutus dapps easily.

## Image Location

The Docker images are hosted on [Dockerhub](https://hub.docker.com/r/bjing/plutus-apps-container/tags)

Images are tagged with their [plutus-apps] commit hashes.
For example, the image corresponding to plultus-apps
commit hash `13836ecf59649ca522471417b07fb095556eb981` is
`bjing/plutus-apps-container:13836ecf59649ca522471417b07fb095556eb981`.

## Use the Image

We assume your plutus dapp sits under `~/Code/plutus-dapp`

### Local development

During local development, you'll be building and testing your project constantly,
it's best to build and test from within the container.

Start the container:

```sh
docker run -it -v ~/Code/plutus-dapp:/app bjing/plutus-apps-container:latest
```

Since your project is mounted to `/app`, we need to build from there. Under the nix-shell,

```sh
cd /app
cabal build 
# or cabal test
```

Note, you don't have to edit the project from within the container. Work on the project
on your host system, and only build and test your project from within the container.

Note 2, make sure your plutus dapp has the right commit hash specified for
`plutus-app` in its dependency declaration in `cabal.project`.

### Directly Build or Test a Plutus dapp

For building or testing a project on a build pipeline, it's simpler to just run
the build or test command in the container as a one-off:

```sh
# Build project
docker run -it -v ~/Code/plutus-dapp:/app bjing/plutus-apps-container:latest ./build.sh

# Test project
docker run -it -v ~/Code/plutus-dapp:/app bjing/plutus-apps-container:latest ./test.sh
```

### Run Plutus Documentation Server

First time starting the container, it'll take a while because the documentation
needs to be built first.

Run it in detached daemon mode, giving the container a name `plutus-docs`
for easy reference later:

```sh
docker run -d -p 8002:8002 -v ~/Code/plutus-dapp:/app --name plutus-docs bjing/plutus-apps-container:latest ./run-doc-server.sh
```

If you would like to query server logs, for example, to see if the server has
successfully started up, use the following command:

```sh
docker logs --follow --timestamps plutus-docs
```

Then view

- [Pluts and Marlowe docs](http://localhost:8002/)
- [Plutus API docs](http://localhost:8002/haddock)

[plutus-apps]: https://github.com/input-output-hk/plutus-apps
[plutus-starter devcontainer on Dockerhub]: https://hub.docker.com/r/inputoutput/plutus-starter-devcontainer

