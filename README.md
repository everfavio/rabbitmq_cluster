# RabbitMQ Cluster

RabbitMQ is a free, open-source and multi-protocol messaging broker software written in the Erlang programming language. A message broker is used to store messages for an application. When an application sends data to another application, the app publishes the message onto the message broker. RabbitMQ supports multiple messaging protocols and can be easily deployed in a distributed configurations. The message broker act as a middleman for various web application and used to reduce loads and delivery time of web application.

### Prerequisites

- Three server running Ubuntu 20.04
- user with sudo permissions on each server

### Getting Started

Before starting, you will need to update your sysyem packages to the lastest version. You can update them by running the following command on each node:

```shell
$ sudo apt-get update -y
```
edit the /etc/hosts file on each node with the following command

```shell
$ nano /etc/hosts
```

Add the following lines:

```config
192.168.40.10   node01
192.168.40.11   node02
192.168.40.12   node03
```

Save and close the file when you are finished. Next, you can proceed to the next step.

### Install RabbitMQ Server

Next, you will need to install the RabbitMQ Server package on each node. You can install it by just running the following command:

```shell
$ sudo apt-get install rabbitmq-server -y
```
Once installed, start the RabbitMQ service and enable it to start at system reboot with the following command:

```shell
$ sudo systemctl start rabbitmq-server
$ sudo systemctl enable rabbitmq-server
```
You can also verify the status of the RabbitMQ service with the following command:

```shell
$ sudo systemctl status rabbitmq-server
```
At this point, the rabbitMQ server is installed and running on each node. You can now proceed to the next step.

### Enable RabbitMQ Management Plugins

The RabbitMQ management plugin provides an HTTP-based API that can be used to minitor and manage RabbitMQ nodes and clusters through a web browser. By default, it is running on the TCP port 15672.

You can enable the RabbitMQ management plugin by running the following command on each node:

```shell
$ sudo rabbitmq-plugins enable rabbitmq_management
```
you should see the following output:

Next, restart the RabbitMQ service to apply the changes:

```shell
$ sudo systemctl restart rabbitmq-server
```

You can verify the listening port with the following command:
```shell
$ sudo netstat -tulpn | grep 15672
```

### Setup RabbitMQ Cluster

RabbitMQ peer nodes and CLI tools use a cookie to determine whether they can communicate with each other. For two nodes to communicate, they must have the same shared secret called the Erlang cookie.

Copy cookie from node01 to each node. If there are other nodes, copy to them too.

Go to node01, open the file and copy all the contents
```shell
$ sudo nano /var/lib/rabbitmq/.erlang.cookie
```

Go to each other node. open the file ad paste content from node01. Then, do that to all other remaining nodes in cases of any.

```shell
$ sudo nano /var/lib/rabbitmq/.erlang.cookie
```
All the other RabbitMQ peer nodes should be reconfigured to join the cluster on the first node ***node01***. This step should be for all nodes except for the first one.

Restart RabbitMq service.

```shell
$ sudo service rabbitmq-server restart
```

Stop the application:
```shell
$ sudo rabbitmqctl stop_app
```

Reset rabbitmq
```shell
$ sudo rabbitmqctl reset
```

Join the node to the cluster.
```shell
$ sudo rabbitmqctl join_cluster rabbit@node01
```

Start the application process.
```shell
$ sudo rabbitmqctl start_app
```

Check the status of the cluster.
```shell
$ sudo rabbitmqctl cluster_status
```

### Configure RabbitMQ Queue Mirroring
Create a HA policy on all the nodes to allow queue mirroring to al lnodes in the cluster. Perform this on all nodes.

```shell
$ sudo rabbitmqctl set_policy ha-all "." '{"ha-mode":"all"}'
```

List configured policies.
```shell
$ sudo rabbitmqctl list_policies
```

### Add Administration account
To access your dashboard form your preferred server, you can add an administrator account to access it.

Default user guest can oly log in via localhost. Create and administrator account to access the dashboard. Make sure you modify the SecurePassword yo your own password.
```shell
$ sudo rabbitmqctl add_user admin <SecurePassword>
$ sudo rabbitmqctl set_user_tags admin administrator
```
After enabling the plugins for the web management portal, you can go to your browser and access the page through ***http://localhost:15672***

### Conclusion

You have now installed RabbitMQ cluster on your server. Your administrator account on all the peer nodes will enable you to have all access privileges to the server. You can now configure your RabbitMQ cluster from the dashboard.

