# redis-preload
A Redis server container that allows preloading of test data from an initial AOF/RDB file and/or a series of Redis command files.

Example usage:
```
docker run --rm -itd --name redis-preload \
         -v${PWD}/test_data.aof:/redis.aof:ro \
         -v${PWD}/test_data.d:/test_data.d:ro \
         oozlum/redis-preload
```
