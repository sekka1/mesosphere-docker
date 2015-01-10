mesosphere-docker
=================

This project builds a fault tolerant and high availability Mesos Cluster using Docker containers by turning this set of instructions [http://mesosphere.com/docs/getting-started/datacenter/install/](Mesosphere.io - Setting up a Mesosphere Cluster) into containers.

This lets you launch a fault tolerant multi node cluster with about 8 Docker commands.


# Making sure everything works on one node
Running through these steps on a single node will turn up a fully functional Mesos cluster with:

* ZooKeeper
* Meso Master
* Marathon
* Meso Slave

You then can goto the Marathon's web page and submit a job.

1. Export out the local host's IP

         HOST_IP=10.11.31.7

1. Start Zookeeper

          docker run -d \
          -e SERVER_ID=1 \
          -e ADDITIONAL_ZOOKEEPER_1=server.1=1.1.1.1:2888:3888 \
          -e ADDITIONAL_ZOOKEEPER_2=server.2=1.1.1.1:2888:3888 \
          -e ADDITIONAL_ZOOKEEPER_3=server.3=1.1.1.1:2888:3888 \
          -p 2181:2181 \
          -p 2888:2888 \
          -p 3888:3888 \
          garland/zookeeper

1. Start Meso Master

          docker run --net="host" \
          -p 5050:5050 \
          -e "MESOS_HOSTNAME=${HOST_IP}" \
          -e "MESOS_IP=${HOST_IP}" \
          -e "MESOS_ZK=zk://${HOST_IP}:2181/mesos" \
          -e "MESOS_PORT=5050" \
          -e "MESOS_LOG_DIR=/var/log/mesos" \
          -e "MESOS_QUORUM=1" \
          -e "MESOS_REGISTRY=in_memory" \
          -e "MESOS_WORK_DIR=/var/lib/mesos" \
          -d \
          garland/mesosphere-docker-mesos-master

1. Start Marathon

         docker run \
         -d \
         -p 8080:8080 \
         garland/mesosphere-docker-marathon --master zk://${HOST_IP}:2181/mesos --zk zk://${HOST_IP}:2181/marathon

1. Start Meso Slave in a container

         docker run -d \
         --entrypoint="mesos-slave" \
         -e "MESOS_MASTER=zk://${HOST_IP}:2181/mesos" \
         -e "MESOS_LOG_DIR=/var/log/mesos" \
         -e "MESOS_LOGGING_LEVEL=INFO" \
         garland/mesosphere-docker-mesos-master:latest

1. Goto the Meso's Web page

         http://localhost:5050

         ssh -F ssh.config -L 5050:${HOST_IP}:5050 core@${HOST_IP}

1. Goto the Marathon's Web page

         http://localhost:8080

         ssh -F ssh.config -L 5050:${HOST_IP}:5050 -L 8080:${HOST_IP}:8080 core@${HOST_IP}

# Multi-node Setup
For this setup, we will need 2 servers with Docker installed on it.

1. Export out the 2 servers' IP that we will be using on each server

         HOST_IP_1=10.11.31.7
         HOST_IP_2=10.11.33.193

1. Start ZooKeepers

    On host #1

         docker run -d \
         --net="host" \
         -e SERVER_ID=1 \
         -e ADDITIONAL_ZOOKEEPER_1=server.1=${HOST_IP_1}:2888:3888 \
         -e ADDITIONAL_ZOOKEEPER_2=server.2=${HOST_IP_2}:2888:3888 \
         garland/zookeeper

    On host #2

         docker run -d \
         --net="host" \
         -e SERVER_ID=2 \
         -e ADDITIONAL_ZOOKEEPER_1=server.1=${HOST_IP_1}:2888:3888 \
         -e ADDITIONAL_ZOOKEEPER_2=server.2=${HOST_IP_2}:2888:3888 \
         garland/zookeeper

    The only difference is the "SERVER_ID".  You can repeat this for the next X number of ZooKeepers you want to run.

1. Start Mesos Masters

    On host #1

          docker run --net="host" \
          -p 5050:5050 \
          -e "MESOS_HOSTNAME=${HOST_IP_1}" \
          -e "MESOS_IP=${HOST_IP_1}" \
          -e "MESOS_ZK=zk://${HOST_IP_1}:2181,${HOST_IP_2}:2181/mesos" \
          -e "MESOS_PORT=5050" \
          -e "MESOS_LOG_DIR=/var/log/mesos" \
          -e "MESOS_QUORUM=1" \
          -e "MESOS_REGISTRY=in_memory" \
          -e "MESOS_WORK_DIR=/var/lib/mesos" \
          -d \
          garland/mesosphere-docker-mesos-master

    On host #2

          docker run --net="host" \
          -p 5050:5050 \
          -e "MESOS_HOSTNAME=${HOST_IP_2}" \
          -e "MESOS_IP=${HOST_IP_2}" \
          -e "MESOS_ZK=zk://${HOST_IP_1}:2181,${HOST_IP_2}:2181/mesos" \
          -e "MESOS_PORT=5050" \
          -e "MESOS_LOG_DIR=/var/log/mesos" \
          -e "MESOS_QUORUM=1" \
          -e "MESOS_REGISTRY=in_memory" \
          -e "MESOS_WORK_DIR=/var/lib/mesos" \
          -d \
          garland/mesosphere-docker-mesos-master

1. Start Marathon

         docker run \
         -d \
         -p 8080:8080 \
         garland/mesosphere-docker-marathon --master zk://${HOST_IP_1}:2181,${HOST_IP_2}:2181/mesos --zk zk://${HOST_IP_1}:2181,${HOST_IP_2}:2181/marathon

1. Start Meso Slaves in a container

    On host #1

         docker run -d \
         --entrypoint="mesos-slave" \
         -e "MESOS_MASTER=zk://${HOST_IP_1}:2181,${HOST_IP_2}:2181/mesos" \
         -e "MESOS_LOG_DIR=/var/log/mesos" \
         -e "MESOS_LOGGING_LEVEL=INFO" \
         garland/mesosphere-docker-mesos-master:latest

    On host #2

         docker run -d \
         --entrypoint="mesos-slave" \
         -e "MESOS_MASTER=zk://${HOST_IP_1}:2181,${HOST_IP_2}:2181/mesos" \
         -e "MESOS_LOG_DIR=/var/log/mesos" \
         -e "MESOS_LOGGING_LEVEL=INFO" \
         garland/mesosphere-docker-mesos-master:latest

1. Start some jobs

     You can follow the same steps for the single node setup (#6, #7) for starting jobs.

