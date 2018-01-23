#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
    // TODO
    uint32_t offset_bits = _cache_config.get_num_block_offset_bits();
    uint32_t index_bits = _cache_config.get_num_index_bits();
    // uint32_t tag_bits = _cache_config.get_num_tag_bits();
    uint32_t ret = get_tag();

    ret = ((ret << index_bits) + _index);
    return (ret << offset_bits);
}
