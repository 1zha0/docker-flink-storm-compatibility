## Flink image with Storm support

Basic [Docker](https://www.docker.com/) image to run [Flink](https://flink.apache.org/) with [Storm](http://storm.apache.org/) compabilitity mode enabled.
This image is:
- Based on [flink:\<version\>-alpine](https://hub.docker.com/r/_/flink/)
- With Strom related jars added to `/opt/flink/libs` folders per [Storm Compatibility Beta](https://ci.apache.org/projects/flink/flink-docs-stable/dev/libs/storm_compatibility.html)

### Versions/tags

| software     | version      |
|--------------|--------------|
| Flink        | `1.6.1`      |
| Scala        | `2.11`       |
| Storm        | `1.0.0`      |


### Tags

Latest Flink with variant Hadoop support:
* `latest`
* `latest-hadoop24`
* `latest-hadoop26`
* `latest-hadoop27`
* `latest-hadoop28`


### Usage

You can run a JobManager (master).

    docker run --name flink_jobmanager -d -t makingsense/flink-storm-support jobmanager

You can also run a TaskManager (worker). Notice that workers need to register with the JobManager directly or via ZooKeeper so the master starts to send them tasks to execute.

    docker run --name flink_taskmanager -d -t makingsense/flink-storm-support taskmanager
