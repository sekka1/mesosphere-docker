FROM garland/mesosphere-docker-base-image

# Installing zookeeper.  Seems to be a dependancy to mesos
# Not going to start it on runtime though
RUN sudo apt-get -y install zookeeperd
RUN echo 1 | sudo dd of=/var/lib/zookeeper/myid

#CMD ["mesos-master"]