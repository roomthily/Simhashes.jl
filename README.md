# Simhashes

[![Build Status](https://travis-ci.org/roomthily/Simhashes.jl.svg?branch=master)](https://travis-ci.org/roomthily/Simhashes.jl)

This is a Julia port of [leonsim's simhash](https://github.com/leonsim/simhash), a python implementation of the Simhash algorithm. I doubt it's idiomatic Julia and it's not optimized (should there be performance gains in porting it to Julia).

This package is unlikely to be maintained.

### Dependencies

- Nettle 0.2.4
- Iterators 0.2.0
- Formatting 0.2.0

### Examples

Creating a Simhash:

```
using Simhashes

s = Simhash("I am unique.", 64)

s.value

# expected value: 2078868624314847100
```

Comparing two simhashes:

```
# with the same simhash defined above

s1 = Simhash("I am also unique.", 64)

distance(s, s1)

# expected distance = 16
```

Building an index:

```
# start with a collection of strings
data = Dict{Int, String}(
    1=>"I am unique.",
    2=>"I am not unique.",
    3=>"I am unique for a bear.",
    4=>"I am unique?"
)

# generate simhashes for all
objects = [("$(k)", Simhash(v, 64)) for (k,v) in collect(data)]

# create the index
index = SimhashIndex(objects, 64, 10)
```

Checking for near duplicates in the index:

```
test_simhash = Simhash("I am unique!", 64)

duplicates = get_near_dups(index, test_simhash)

# expected: [4, 1, 3]
```

See the original repository and associated Simhash references for information on
the parameters and algorithm.

### License

MIT
