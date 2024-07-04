## rsu-ignite-sample

This is a BE project which tries out various BQL queries run against Apache Ignite as an in-memory cache provider. 

The goal of this sample to understand, native-query, have a feeling of syntax and sort of visual perperformance. 

This sample is created in context with trains. RSU's means Rolling stock units. It is just an object with number and type and some dates in DateTime and dateTimeInMillis to try different queries.

Only 1 concept is used which is persisted in cache only. Rest of the events are memory only.

### Scripts to run: 
```
be-ignite-sample/run-rsuIgniteSample-IAasCache.sh
```
For starting BE inference engine also as a cache provider. 
Note: Make sure in CDD, Processing unit setting you have selected Enable Cache Storage.

Once the engine is running, you can run following script to bulk create RSUs.
```
ns_rsus.sh 
```

```
Note: For running sample from Studio, create Run/Debug configurations for engine and cache and then you can run from the studio as well.
```

For packaging in docker and running in kubernetes or as a docker image, you can refer be_tools github repo provided by TIBCO.

## Sample API triggers

Note: During startup BE engine creates 10 sample concepts in cache from 30000 + 1 .... + 10 .

### createRSU

Input: RSUNumber, RSUType

Uses: Native query

```bash
curl -v -X GET --url "http://localhost:9292/Channels/Incoming/createRSU?RSUNumber=99999&RSUType=SLT"
```

### getRSUByNumber

Input: RSUNumber

Uses: Native query

```bash
curl -v -X GET http://localhost:9292/Channels/Incoming/getRSUByNumber?RSUNumber=30001
```

### getRSUByType

Input: RSUType

Uses: Native query

```bash
curl -v -X GET http://localhost:9292/Channels/Incoming/getRSUByType?RSUType=ICNG
```

### getRSUByNumberCompareBQLTypes

Input: RSUNumber

Uses: Native query and non-native query

Outcome: In logs you see the difference in time to fetch the same record

```bash
curl -v -X GET http://localhost:9292/Channels/Incoming/getRSUByNumberCompareBQLTypes?RSUNumber=30001
```

### getRSUByTimeCreated

Input: 2 optional fields
- DateTime: If not null, it will query using this.
- DateTimeMillis: If not null it will query using this.
- If both are not null it will try both queries with datetime and datetime millis and show results.

Uses: Native query

dateCreatedMillis=1720010770966
dateCreated=2024-07-03T14:46:10.10Z

```bash
curl -v -X GET http://localhost:9292/Channels/Incoming/getRSUByTimeCreated?dateCreatedMillis=1720010770966
curl -v -X GET http://localhost:9292/Channels/Incoming/getRSUByTimeCreated?dateCreated=2024-07-03T14:46:10.10Z
```

## Enable BQL Console while running sample:

To enable BQL Console refer: [readme.html](file:///opt/tibco/be/be/6.3/examples/event_stream_processing/bql/readme.html)

> Make sure bql.jar is copied to BE's lib folder, restart studio.

### Running sample in studio 
You can run it from the stdio also using debug/run configuration.

- Create one run config for inteference agent e.g. default
    - Make sure processing unit for query-agent is also present
    - Add query-class as an agent to the inference agent
        - If you want to enable the console: Make sure to add property be.agent.query.console=query-class in Agent-classes for query class.
- Create another run config for cache
- Run cache from run config
- Run inference agent from the run config
- If you want to override log files, in run config in common tab, specify absolute path to a log file.
- Once you run BQL console will pop up

### Running sample using scripts or Via Console:

```bash
cd BE_HOME/bin
Syntax: 
BE_HOME/bin/be-engine --propFile be-engine.tra -c <CDD file> -u <processing unit id> <EAR file>
```

```bash
cd /opt/tibco/be/be/6.3/bin/
./be-engine --propFile /opt/tibco/be/be/6.3/bin/be-engine.tra -c /Users/kbhalera/data/ws/be630hf05-ignite/rsu-ignite-sample/Deployments/rsuIgniteSample.cdd -u default /Users/kbhalera/git/kb-tibco-be-samples/be-ignite-sample/rsuIgniteSample.ear
```

More structured run via cli as, e.g. as a shell script (on linux/mac) - windows below
```bash
#!/bin/bash

BE_HOME="/opt/tibco/be/be/6.3/"
CDD="/Users/kbhalera/git/kb-tibco-be-samples/be-ignite-sample/rsu-ignite-sample/Deployments/rsuIgniteSample.cdd"
EAR="/Users/kbhalera/git/kb-tibco-be-samples/be-ignite-sample/rsuIgniteSample.ear"
TRA="$BE_HOME/bin/be-engine.tra"

name="IAactAsCacheServer"
PU="default"

echo "Running $name"
cd $BE_HOME/bin/
./be-engine --propFile "$TRA" -u "$PU" -c "$CDD" "$EAR" -n "$name"

echo "Done $name"

#Pause
read -p "Press [Enter] key to continue..."
```
Or windows: (is bit different than the above shell script version)
```bat
call setEnv.bat

set name=IAactAsCacheServer
set PU=default

title %name%
%BE_HOME%\bin\be-engine.exe --propFile %TRA% -u %PU% -c %CDD% %EAR% -n %name%
pause
```

where, setEnv.bat
```bash
set BE_HOME="c:\tibco\be\6.3"
set CDD="..\rsu-ignite-sample\Deployments\rsuIgniteSample.cdd"
set EAR="rsuIgniteSample.ear"
set TRA=%BE_HOME%\bin\be-engine.tra
```


**Query Changes against in-memory ignite cache**

**BQL Query development Guide**

[BE 6.3 Query Developers Guide](https://docs.tibco.com/pub/businessevents-enterprise/6.3.0/doc/pdf/TIB_businessevents-enterprise_6.3.0_esp-query-developers.pdf)

[Querying Cache using BQL](https://docs.tibco.com/pub/businessevents-enterprise/6.3.0/doc/html/Developers/Query-the-Cache-Using-BQL-Queries.htm)

```
Note: BQL has native-query and non-native-query. 
```
native-query is usually faster. Also first call is bit slow bit consecutive calls are faster for all types of queries.

And example of native-query: 

```java
String sWhere = " where cp.RSUNumber='" + ersu.RSUNumber + "'";
String sQuery = "native-query: select _EXTID from be_gen_concepts_cRSU cp" + sWhere;
```

Example of non-native BQL query:

```java
sWhere = " where cp.RSUNumber=" + ersu.RSUNumber + "";
sQuery = "select cp.RSUNumber from /Concepts/cRSU as cp" + sWhere;
```

### Using BQL without Apache Ignite and with AS2 cache

You can use BQL native query still with AS2. As it is a generic querying mechanism. 
