FROM garland/mesosphere-docker-base-image

RUN echo 1 | sudo dd of=/var/lib/zookeeper/myid
RUN sudo apt-get -y install zookeeperd mesos
RUN sudo mkdir -p /etc/mesos-master
#RUN echo in_memory | sudo dd of=/etc/mesos-master/registry

CMD ["mesos-master"]