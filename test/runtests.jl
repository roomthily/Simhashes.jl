using Simhashes
using Base.Test

# ported tests
@test Simhash(["aaa", "bbb"], 64).value == 8637903533912358349

# distance tests
sh = Simhash("How are you? I AM fine. Thanks. And you?", 64)
sh2 = Simhash("How old are you ? :-) i am fine. Thanks. And you?", 64)
@test distance(sh, sh2) > 0

sh3 = Simhash(sh2, 64)
@test distance(sh2, sh3) == 0

@test distance(Simhash("1", 64), Simhash("2", 64)) != 0

# short tests
shs = [Simhash(s, 64).value for s in ("aa", "aaa", "aaaa", "aaaab", "aaaaabb", "aaaaabbb")]

@testset "Short Strings" begin
  for (i, sh1) in enumerate(shs)
      for (j, sh2) in enumerate(shs)
          if i != j
              @test sh1 != sh2
          end
      end
  end
end

# index tests
data = Dict{Int, String}(1=>"How are you? I Am fine. blar blar blar blar blar Thanks.",
    2=>"How are you i am fine. blar blar blar blar blar than",
    3=>"This is simhash test.",
    4=>"How are you i am fine. blar blar blar blar blar thank1"
)

objs = [("$(k)", Simhash(v, 64)) for (k,v) in collect(data)]

simhash_index = SimhashIndex(objs, 64, 10)

@testset "Get Near Dupes" begin
    s1 = Simhash("How are you i am fine.ablar ablar xyz blar blar blar blar blar blar blar thank", 64)
    dups = get_near_dups(simhash_index, s1)
    @test length(dups) == 3

    delete_from_index(simhash_index, '1', Simhash(data[1], 64))
    dups = get_near_dups(simhash_index, s1)
    @test length(dups) == 2

    delete_from_index(simhash_index, '1', Simhash(data[1], 64))
    dups = get_near_dups(simhash_index, s1)
    @test length(dups) == 2

    add_to_index(simhash_index.bucket, ('1', Simhash(data[1], 64)), simhash_index.offsets)
    dups = get_near_dups(simhash_index, s1)
    @test length(dups) == 3

    add_to_index(simhash_index.bucket, ('1', Simhash(data[1], 64)), simhash_index.offsets)
    dups = get_near_dups(simhash_index, s1)
    @test length(dups) == 3
end
