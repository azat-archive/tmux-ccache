#!/usr/bin/awk -f
{
    s[$1] = $2
    print
}

END {
    # ccache_hit_rate
    hits  = s["preprocessed_cache_hit"]+s["direct_cache_hit"]
    count = s["preprocessed_cache_hit"]+s["direct_cache_hit"]+s["cache_miss"]
    rate  = count ? hits/count*100 : 0
    printf("cache_hit_rate\t%.2f\n", rate)
}
