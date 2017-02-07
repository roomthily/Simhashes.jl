module Simhashes

    include("simhash.jl")
    include("simhash_index.jl")

    export Simhash, SimhashIndex
    export distance, get_near_dups, delete_from_index, add_to_index

end # module
