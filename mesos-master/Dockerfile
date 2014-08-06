FROM garland/mesosphere-docker-base-image

RUN sudo apt-get -y install mesos
RUN sudo mkdir -p /etc/mesos-master
#RUN echo in_memory | sudo dd of=/etc/mesos-master/registry

CMD ["mesos-master"]