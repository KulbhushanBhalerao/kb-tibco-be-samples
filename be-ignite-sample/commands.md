
rsu-ignite-sample: 

**Sample triggers: **
Note: During startup BE engine creates 10 sample concepts in cache. 

Get calls using curl

get

getRSUByNumber: 
Input: RSUNumber
Uses: Native query
curl -v -X GET http://localhost:9292/Channels/Incoming/getRSUByNumber?RSUNumber=3001

getRSUByNumberCompareBQLTypes: 
Input: RSUNumber
Uses: Native query and non-native query
Outcome: In logs you see the difference in time to fetch the same record
curl -v -X GET http://localhost:9292/Channels/Incoming/getRSUByNumberCompareBQLTypes?RSUNumber=3001

getRSUByTimeCreated: 
Input: 2 optional fields 
       DateTime: If not null, it will query using this. 
       DateTimeMillis: If not null it will query using this.
       If both are not null it will try both queries with datetime and datetime millis and show results. 
Uses: Native query
Date: 1719928293231
curl -v -X GET http://localhost:9292/Channels/Incoming/getRSUByTimeCreated?dateCreatedMillis=1719928293231

**Enbale BQL Console: **
To enable BQL Console refer: 
file:///opt/tibco/be/be/6.3/examples/event_stream_processing/bql/readme.html
> make sure bql.jar is copied to BE's lib folder, restart studio.

You can run it from the stdio also using run config.
- Create one run config for inteference agent e.g. default
    - Make sure processing unit for query-agent is also present
    - Add query-class as an agent to the inference agent 
        - If you want to enable the console: Make sure to add property be.agent.query.console=query-class in Agent-classes for query class. 
- Create another run config for cache
- Run cache from run config
- Run inference agent from the run config
- If you want to override log files, in run config in common tab, specify absolute path to a log file. 
- Once you run BQL console will pop up

Via Console: 
```console
cd BE_HOME/bin
Syntax: 
BE_HOME/bin/be-engine --propFile be-engine.tra -c <CDD file> -u <processing unit id> <EAR file>
```

```console
cd /opt/tibco/be/be/6.3/bin/
./be-engine --propFile /opt/tibco/be/be/6.3/bin/be-engine.tra -c /Users/kbhalera/data/ws/be630hf05-ignite/rsu-ignite-sample/Deployments/rsuIgniteSample.cdd -u default /Users/kbhalera/git/kb-tibco-be-samples/be-ignite-sample/rsuIgniteSample.ear
```

