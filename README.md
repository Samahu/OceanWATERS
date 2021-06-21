# OceanWATERS (unofficial) 
[Overview](#overview) |
[Code Organization](#code-organization) |
[Getting Started](#getting-started) |
[License](#license)

## Overview
OceanWATERS is a physical and visual simulation of a lander on Europa. It is intended as a
testbed to aid in producing software that could fly on lander missions to ocean
worlds, such as Europa and Enceladus.

| OceanWATERS | master | melodic-devel |
|:-----------:|:------:|:-------------:|
| build       | [![build[master]](https://github.com/Samahu/OceanWATERS/workflows/OceanWATERS/badge.svg?branch=master)](https://github.com/Samahu/OceanWATERS/actions?query=workflow%3AOceanWATERS) | [![build[melodic-devel]](https://github.com/Samahu/OceanWATERS/workflows/OceanWATERS/badge.svg?branch=melodic-devel)](https://github.com/Samahu/OceanWATERS/actions?query=workflow%3AOceanWATERS) |
| docker      | [![docker[master]](https://github.com/Samahu/OceanWATERS/workflows/OceanWATERS-docker/badge.svg?branch=master)]((https://hub.docker.com/repository/docker/oceanwaters/oceanwaters)) | [![docker[melodic-devel]](https://github.com/Samahu/OceanWATERS/workflows/OceanWATERS-docker/badge.svg?branch=melodic-devel)](https://hub.docker.com/repository/docker/oceanwaters/oceanwaters) |

<a href="https://scan.coverity.com/projects/samahu-oceanwaters">
  <img alt="Coverity Scan Build Status"
       src="https://img.shields.io/coverity/scan/21872.svg"/>
</a>

## Code Organization

This repository just adds build scripts and other miscellaneous files. OceanWATERS are associated with this repo as git submodules:
- [irg_open](https://github.com/nasa/irg_open)
- [ow_simulator](https://github.com/nasa/ow_simulator)
- [ow_autonomy](https://github.com/nasa/ow_autonomy)
- [ow_europa](https://github.com/nasa/ow_europa)

## Getting Started

* [Running the fully baked OceanWATERS docker images](#running-the-fully-baked-oceanwaters-docker-images)
* [Running the base OceanWATERS docker image for development](#running-the-base-oceanwaters-docker-image-for-development)
* [Instantiate more than one terminal to the same OceanWATERS container instance](#instantiate-more-than-one-terminal-to-the-same-oceanwaters-container-instance)

### Running the fully baked OceanWATERS docker images
If you are merely interested in running the simulation you can do so by running one of the fully baked OceanWATERS docker images:
  - stable channel: `oceanwaters/oceanwaters`         
  - development channel: `oceanwaters/oceanwaters_nightly` 

To run using the base gpu accelerated docker (nvidia) use the following command:
```bash
docker run -it --gpus all -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY -e XAUTHORITY -e NVIDIA_DRIVER_CAPABILITIES=all \
    oceanwaters/oceanwaters:ros-melodic-desktop-full-nvidia
```
By default this would automatically launch the simulation, you can override the default behaviour by specifying the command
to be run as follows:

```bash
docker run --gpus all -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY -e XAUTHORITY -e NVIDIA_DRIVER_CAPABILITIES=all \
    oceanwaters/oceanwaters:ros-melodic-desktop-full-nvidia /bin/bash
```
then once you connect to the docker container you may launch the simulation using:
```bash
roslaunch ow atacama_y1a.launch # or you may use europa_terminator_workspace.launch
```

### Running the base OceanWATERS docker image for development
If you are interested in doing development on the docker image you can use the builder images:
  - stable channel: `oceanwaters/builder`
  - development channel: `oceanwaters/builder_nightly`

The development image doesn't contain the code baked into it, but it has all the required dependencies to build and run
the project regardless of the user current - linux-based - host system.  
So assuming that the oceanwaters workspace is located at `~/oceanwaters_ws` then you can mount the folder into
the docker container as follows:

```bash
docker run -it --rm \
    -v ~/oceanwaters_ws:/oceanwaters_ws \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --gpus all -e DISPLAY -e XAUTHORITY -e NVIDIA_DRIVER_CAPABILITIES=all \
    oceanwaters/builder_nightly:ros-melodic-desktop-full-nvidia
```
Once conntected to the container, you can then build the project as follows:
```bash
cd /oceanwaters_ws  # navigate to the oceanwaters workspace
catkin build        # build the project
```
### Instantiate more than one terminal to the same OceanWATERS container instance
Sometimes you may need to submit commands to connect another terminal to a given OceanWATERS container. 

```bash
docker ps # lists currently running containers in your system
# note down the name or id of the running OceanWATERS container that you want to access from a different terminal
docker exec -it <ow-container-name> /bin/bash # you can supply the container id instead
cd /oceanwaters_ws  # navigate to the oceanwaters workspace
source /ow_env/setup.bash   # source ROS enviroment
source devel/setup.bash     # source your workspace again
# Now you can execute a ROS command to a running instance of the simulation
# for example try: rostopic list
```

## License
OceanWATERS is open source software licensed under the
[NASA Open Source Agreement version 1.3](LICENSE).

## Notices
Copyright © 2020 United States Government as represented by the Administrator of
the National Aeronautics and Space Administration.  All Rights Reserved.

## Disclaimers
No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY OF
ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED
TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL CONFORM TO SPECIFICATIONS, ANY
IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
FREEDOM FROM INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE ERROR
FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM TO THE
SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER, CONSTITUTE AN
ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT OF ANY RESULTS,
RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY OTHER APPLICATIONS
RESULTING FROM USE OF THE SUBJECT SOFTWARE.  FURTHER, GOVERNMENT AGENCY
DISCLAIMS ALL WARRANTIES AND LIABILITIES REGARDING THIRD-PARTY SOFTWARE, IF
PRESENT IN THE ORIGINAL SOFTWARE, AND DISTRIBUTES IT "AS IS."

Waiver and Indemnity:  RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST THE
UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL AS ANY
PRIOR RECIPIENT.  IF RECIPIENT'S USE OF THE SUBJECT SOFTWARE RESULTS IN ANY
LIABILITIES, DEMANDS, DAMAGES, EXPENSES OR LOSSES ARISING FROM SUCH USE,
INCLUDING ANY DAMAGES FROM PRODUCTS BASED ON, OR RESULTING FROM, RECIPIENT'S USE
OF THE SUBJECT SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD HARMLESS THE UNITED
STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL AS ANY PRIOR
RECIPIENT, TO THE EXTENT PERMITTED BY LAW.  RECIPIENT'S SOLE REMEDY FOR ANY SUCH
MATTER SHALL BE THE IMMEDIATE, UNILATERAL TERMINATION OF THIS AGREEMENT.
