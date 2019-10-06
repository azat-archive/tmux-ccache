#!/usr/bin/awk -f

{
    s[$1] = $2
}

END {
    # cache_hit_rate
    hits  = s["preprocessed_cache_hit"]+s["direct_cache_hit"]
    count = hits+s["cache_miss"]
    rate  = count ? hits/count*100 : 0
    s["cache_hit_rate"] = sprintf("%.2f", rate)

    # status
    s["status"] = icon " " s["cache_hit_rate"]

    if (!key) {
        for (key in s) {
            print(key)
        }
    } else if (key in s) {
        print(s[key])
    }
}
