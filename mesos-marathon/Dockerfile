FROM garland/mesosphere-docker-base-image

# Install mesos.
RUN sudo apt-get -y install mesos marathon deimos

EXPOSE 8080

CMD ["java", "-Xmx512m", "-Djava.library.path=/usr/local/lib", "-Djava.util.logging.SimpleFormatter.format='%2$s %5$s%6$s%n'", "-cp", "/usr/local/bin/marathon", "mesosphere.marathon.Main", "--zk", "$MESOS_ZK", "--master", "$MESOS_MASTER"]