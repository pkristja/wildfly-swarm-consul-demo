# wildfly-swarm-consul-demo

This git project is used to reproduce strange bug with Wildfly-Swarm and Consul for service discovery where if you start it with parameter `-Djava.net.preferIPv4Stack=true` you get following exception: 
```
2017-09-27 20:02:07,064 ERROR [org.jboss.as] (Controller Boot Thread) WFLYSRV0026: WildFly Swarm 2017.9.4 (WildFly Core 2.2.1.Final) started (with errors) in 1607ms - Started 90 of 105 services (6 services failed or missing dependencies, 18 services are lazy, passive or on-demand)
2017-09-27 20:02:07,066 ERROR [stderr] (main) java.lang.reflect.InvocationTargetException
2017-09-27 20:02:07,066 ERROR [stderr] (main)   at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
2017-09-27 20:02:07,067 ERROR [stderr] (main)   at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
2017-09-27 20:02:07,067 ERROR [stderr] (main)   at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
2017-09-27 20:02:07,067 ERROR [stderr] (main)   at java.lang.reflect.Method.invoke(Method.java:498)
2017-09-27 20:02:07,068 ERROR [stderr] (main)   at org.wildfly.swarm.bootstrap.MainInvoker.invoke(MainInvoker.java:54)
2017-09-27 20:02:07,068 ERROR [stderr] (main)   at org.wildfly.swarm.bootstrap.Main.run(Main.java:133)
2017-09-27 20:02:07,069 ERROR [stderr] (main)   at org.wildfly.swarm.bootstrap.Main.main(Main.java:86)
2017-09-27 20:02:07,069 ERROR [stderr] (main) Caused by: java.lang.RuntimeException: org.jboss.msc.service.StartException in service "swarm.topology.consul": Failed to connect consul at http://127.0.0.1:8500
2017-09-27 20:02:07,070 ERROR [stderr] (main)   at org.wildfly.swarm.spi.api.ClassLoading.withTCCL(ClassLoading.java:45)
2017-09-27 20:02:07,070 ERROR [stderr] (main)   at org.wildfly.swarm.container.runtime.ServerBootstrapImpl.bootstrap(ServerBootstrapImpl.java:114)
2017-09-27 20:02:07,070 ERROR [stderr] (main)   at org.wildfly.swarm.Swarm.start(Swarm.java:375)
2017-09-27 20:02:07,071 ERROR [stderr] (main)   at org.wildfly.swarm.Swarm.main(Swarm.java:631)
2017-09-27 20:02:07,071 ERROR [stderr] (main)   ... 7 more
2017-09-27 20:02:07,071 ERROR [stderr] (main) Caused by: org.jboss.msc.service.StartException in service "swarm.topology.consul": Failed to connect consul at http://127.0.0.1:8500
2017-09-27 20:02:07,071 ERROR [stderr] (main)   at org.wildfly.swarm.topology.consul.runtime.ConsulService.start(ConsulService.java:61)
2017-09-27 20:02:07,072 ERROR [stderr] (main)   at org.jboss.msc.service.ServiceControllerImpl$StartTask.startService(ServiceControllerImpl.java:1948)
2017-09-27 20:02:07,072 ERROR [stderr] (main)   at org.jboss.msc.service.ServiceControllerImpl$StartTask.run(ServiceControllerImpl.java:1881)
2017-09-27 20:02:07,072 ERROR [stderr] (main)   at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
2017-09-27 20:02:07,072 ERROR [stderr] (main)   at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
2017-09-27 20:02:07,072 ERROR [stderr] (main)   at java.lang.Thread.run(Thread.java:748)
2017-09-27 20:02:07,073 ERROR [stderr] (main) Caused by: com.orbitz.consul.ConsulException: Error connecting to Consul
2017-09-27 20:02:07,073 ERROR [stderr] (main)   at com.orbitz.consul.AgentClient.ping(AgentClient.java:72)
2017-09-27 20:02:07,073 ERROR [stderr] (main)   at com.orbitz.consul.Consul.<init>(Consul.java:73)
2017-09-27 20:02:07,073 ERROR [stderr] (main)   at com.orbitz.consul.Consul.<init>(Consul.java:24)
2017-09-27 20:02:07,073 ERROR [stderr] (main)   at com.orbitz.consul.Consul$Builder.build(Consul.java:337)
2017-09-27 20:02:07,073 ERROR [stderr] (main)   at org.wildfly.swarm.topology.consul.runtime.ConsulService.start(ConsulService.java:59)
2017-09-27 20:02:07,074 ERROR [stderr] (main)   ... 5 more
```

## Steps to reproduce bug:

1. Starting local consul image in docker:
```
docker run -d -p 8500:8500 consul:latest
```

2. Clone GIT repo:
```
git clone https://github.com/pkristja/wildfly-swarm-consul-demo.git
```

3. Clean and build project using maven:
```
mvn clean install
```

4. Go to /../target/ and run application:
```
java -jar -Djava.net.preferIPv4Stack=true wildfly-swarm-consul-demo-swarm.jar
```
You will get following exception:
```
2017-09-27 20:02:07,064 ERROR [org.jboss.as] (Controller Boot Thread) WFLYSRV0026: WildFly Swarm 2017.9.4 (WildFly Core 2.2.1.Final) started (with errors) in 1607ms - Started 90 of 105 services (6 services failed or missing dependencies, 18 services are lazy, passive or on-demand)
2017-09-27 20:02:07,066 ERROR [stderr] (main) java.lang.reflect.InvocationTargetException
2017-09-27 20:02:07,066 ERROR [stderr] (main)   at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
2017-09-27 20:02:07,067 ERROR [stderr] (main)   at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
2017-09-27 20:02:07,067 ERROR [stderr] (main)   at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
2017-09-27 20:02:07,067 ERROR [stderr] (main)   at java.lang.reflect.Method.invoke(Method.java:498)
2017-09-27 20:02:07,068 ERROR [stderr] (main)   at org.wildfly.swarm.bootstrap.MainInvoker.invoke(MainInvoker.java:54)
2017-09-27 20:02:07,068 ERROR [stderr] (main)   at org.wildfly.swarm.bootstrap.Main.run(Main.java:133)
2017-09-27 20:02:07,069 ERROR [stderr] (main)   at org.wildfly.swarm.bootstrap.Main.main(Main.java:86)
2017-09-27 20:02:07,069 ERROR [stderr] (main) Caused by: java.lang.RuntimeException: org.jboss.msc.service.StartException in service "swarm.topology.consul": Failed to connect consul at http://127.0.0.1:8500
2017-09-27 20:02:07,070 ERROR [stderr] (main)   at org.wildfly.swarm.spi.api.ClassLoading.withTCCL(ClassLoading.java:45)
2017-09-27 20:02:07,070 ERROR [stderr] (main)   at org.wildfly.swarm.container.runtime.ServerBootstrapImpl.bootstrap(ServerBootstrapImpl.java:114)
2017-09-27 20:02:07,070 ERROR [stderr] (main)   at org.wildfly.swarm.Swarm.start(Swarm.java:375)
2017-09-27 20:02:07,071 ERROR [stderr] (main)   at org.wildfly.swarm.Swarm.main(Swarm.java:631)
2017-09-27 20:02:07,071 ERROR [stderr] (main)   ... 7 more
```

But if you run it without `-Djava.net.preferIPv4Stack=true` parameter it works fine.

