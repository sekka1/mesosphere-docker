mesosphere-docker
=================

This project builds a fault tolerant and high availability version of what is described in [http://mesosphere.io/learn/](Mesosphere.io Learn Docs) instead of one VM running all of the services.

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
          -p 2181:2181 \
          -p 2888:2888 \
          -p 3888:3888 \
          garland/zookeeper:3.4.6

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