#include "cacheconfig.h"
#include "utils.h"

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
    /**
     * TODO
     * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
     */

    // BLOCK_SIZE = CACHE_SIZE / (ASSOCIATIVITY * NUM_SETS)
    // CACHE_SIZE = NUM_BLOCKS * BLOCK_SIZE
    // NUM_BLOCKS = ASSOCIATIVITY * NUM_SETS

    uint32_t bscp = block_size;
    uint32_t acp = _size / (_block_size * associativity);
    int countup1 = 1, countup2 = 1;

    helper(countup1, bscp, block_size);
    _num_block_offset_bits = (bscp) ? countup1 : 0;

    if (!_block_size || !associativity) return;

    helper(countup2, acp, block_size);
    _num_index_bits = (acp) ? countup2 : 0;

    _num_tag_bits = 32 - _num_block_offset_bits - _num_index_bits;
}

void CacheConfig::helper(int &cu, uint32_t &cp, uint32_t &limiter) {
    for (int i = 0; i < limiter; i ++) {
        if (cp / 2 != 1) { cu ++; cp /= 2; }
        else return;
    }
}
