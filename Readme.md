# Docker builds for FreeCAD

> [!CAUTION]
> This repository is in ALPHA, meaning it probably doesn't work. Please check
> back (or subscribe with a star) when there's example usage available!

# Developer notes

We build our own FreeCAD images, as there's not really a good
repository (yet!) for pre-built FreeCAD images. Maybe that is our real
contribution in the end?

## Updating FreeCAD docker images

Docker images are built and uploaded whenever a push is done to the
`docker-builds` branch. 

### Testing the docker build locally

You can use the act platform to test run actions. This will run the github
action for building the docker file for the first matrix entries. You'll need
the right token to actually push successfully though.

```
act -r -s DOCKERHUB_USERNAME=toastedcrumpets -s DOCKERHUB_TOKEN=ASecretImNotSharing
```
