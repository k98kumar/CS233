#include "simplecache.h"

#include <vector>
#include <iterator>

int SimpleCache::find(int index, int tag, int block_offset) {
    // read handout for implementation details
    // _cache : std::map< int, std::vector< SimpleCacheBlock > >
    std::vector<SimpleCacheBlock> &vec = _cache[index];
    for (std::vector<SimpleCacheBlock>::iterator it = vec.begin(); it != vec.end(); ++ it) {
        if (it->valid() && (it->tag() == tag)) return it->get_byte(block_offset);
    }
    return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
    // read handout for implementation details
    // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
    std::vector<SimpleCacheBlock> &vec = _cache[index];
    for (std::vector<SimpleCacheBlock>::iterator it = vec.begin(); it != vec.end(); ++ it) {
        if (!it->valid()) {
            it->replace(tag, data);
            return;
        }
    }
    vec[0].replace(tag, data);
}
