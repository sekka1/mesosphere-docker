#!/bin/sh

ZOO_CFG="/opt/zookeeper/conf/zoo.cfg"

# Output server ID
echo "server id (myid): ${SERVER_ID}"
echo "${SERVER_ID}" > /tmp/zookeeper/myid

# Add additional ZooKeeper servers into the zoo.cfg file
echo "${ADDITIONAL_ZOOKEEPER_1}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_2}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_3}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_4}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_5}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_6}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_7}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_8}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_9}" >> ${ZOO_CFG}
echo "${ADDITIONAL_ZOOKEEPER_10}" >> ${ZOO_CFG}

# Start Zookeeper
/opt/zookeeper/bin/zkServer.sh start-foreground
