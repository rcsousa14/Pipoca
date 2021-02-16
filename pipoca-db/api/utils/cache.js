import NodeCache from 'node-cache';

class Cache {
    constructor(ttlSeconds) {
        this.cache = new NodeCache({ stdTTL: ttlSeconds, checkperiod: ttlSeconds * 0.2, useClones: false });
    }

    get(key) {
        const value = this.cache.get(key);
        if (value) {
            return value;
        }


    }
    set(key, json){
        this.cache.set(key, json);
    }
    del(keys) {
        this.cache.del(keys);
    }
    delStartWith(startStr = '') {
        if (!startStr) {
            return
        }
        const keys = this.cache.keys();
        for (const key of keys) {
            if (key.indexOf(startStr) === 0) {
                this.del(key);
            }
        }
    }
    flush() {
        this.cache.flushAll();
    }

}

export default Cache; 