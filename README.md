# redis-preload
A Redis server container that allows preloading of test data.

Example usage:
```
docker run --rm -itd --name redis-preload -v${PWD}/test_data.d:/test_data.d:ro oozlum/redis-preload
