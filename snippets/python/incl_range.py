def incl_range(a, b, step=1):
    e = 1 if step > 0 else -1
    return range(a, b + e, step)
