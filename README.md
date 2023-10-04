# Plutus Dev Container Image

Since [plutus-starter devcontainer on Dockerhub] is outdated, and I couldn't
figure out how to get it updated, I've built my own.

I hope this can help people who can't set up a Nix environment for whatever reason
to be able to build Plutus dapps easily.

## Image Location

The Docker images are hosted on [Dockerhub](https://hub.docker.com/r/bjing/plutus-apps-container/tags)

Images are tagged with their generation date/time.
For example, the image tag `20231004T215021` represents `2013-10-04 21:50:21`.

## Use the Image

We assume your plutus dapp sits under `~/Code/plutus-dapp`

### Local development

#### Visual Studio Code

Install extension [DevContainers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

Copy directory [.devcontainer](.devcontainer/) to your Haskell project's root directory. 
Change the docker image tag in [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json) as you see fit.

Bring up Command palette, and run `Dev Containers: Open Folder in Container`.

Now you can build the project in VSCode's terminal using `cabal build`.

#### Command line

If you're using other editors like VIM/Emacs, best way to go about it is to 
1. have an editor open to work on the project, and
2. have a terminal open to work inside the container to build and test.

Start the container:

```sh
docker run -it --name plutus-dev-container -v ~/Code/plutus-dapp:/home/code/app bjing/plutus-dev-container:latest
```

Get inside the container:

```sh
docker exec -it plutus-dev-container bash
```

Since your project is mounted to `/home/code/app`, we need to build from there. 

Inside the container

```sh
cd ~/app
cabal build 
```

### Directly Build or Test a Plutus dapp

For building or testing a project on a build pipeline, it's simpler to just run
the build or test command in the container as a one-off:

```sh
# Build project
docker run -it -v ~/Code/plutus-dapp:/home/code/app bjing/plutus-dev-container:latest ./build.sh

# Test project
docker run -it -v ~/Code/plutus-dapp:/home/code/app bjing/plutus-dev-container:latest ./test.sh
```

[plutus-starter devcontainer on Dockerhub]: https://hub.docker.com/r/inputoutput/plutus-starter-devcontainer
