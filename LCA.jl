"""
LCA (Lowest Common Ancestor) Algorithm

This program implements the Lowest Common Ancestor (LCA) algorithm for finding the lowest common ancestor of two nodes in a tree.

Algorithm:
- The program uses a preprocessing step based on the doubling technique to calculate the ancestors of each node.
- Given two nodes u and v, the LCA algorithm finds their lowest common ancestor using a binary lifting approach.

Time Complexity:
- The preprocessing step has a time complexity of O(N log N), where N is the number of nodes in the tree.
- The LCA query has a time complexity of O(log N).

Author: hals
Date: 2023/6/21

# ABC014D(https://atcoder.jp/contests/abc014/tasks/abc014_4)で使うとMLEするのでいい感じに展開してください
# ACコード: https://atcoder.jp/contests/abc014/submissions/42770707

"""

# LCA algorithm implementation goes here...
mutable struct LCA
    n::Int
    depth::Int
    dp::Matrix{Int}
    dis::Vector{Int}

    function LCA(n::Int, edges::Vector{Vector{Int}})
        depth = floor(Int, log2(n)) + 1
        dp = zeros(Int, n, depth)
        dis = fill(-1, n)
        con = [[] for _ = 1:n]
        for (u, v) = edges
            push!(con[u], v)
            push!(con[v], u)
        end
        dis[1] = 0
        function dfs(now::Int, p::Int)
            for next = con[now]
                if next != p
                    dp[next, 1] = now
                    dis[next] = dis[now] + 1
                    dfs(next, now)
                end
            end
        end
        dfs(1, 0)
        for k = 1:depth-1
            for v = 1:n
                if dp[v, k] > 0
                    dp[v, k+1] = dp[dp[v, k], k]
                end
            end
        end
        new(n, depth, dp, dis)
    end
end

function find_lca(lca::LCA, u::Int, v::Int)
    if lca.dis[u] < lca.dis[v]
        u, v = v, u
    end
    for k = lca.depth:-1:1
        if lca.dis[u] - lca.dis[v] >= 2^(k - 1)
            u = lca.dp[u, k]
        end
    end
    u == v && return u
    for k = lca.depth:-1:1
        if lca.dp[u, k] != lca.dp[v, k]
            u = lca.dp[u, k]
            v = lca.dp[v, k]
        end
    end
    lca.dp[u, 1]
end

get_dis(lca::LCA, u::Int, v::Int) = lca.dis[u] + lca.dis[v] - 2 * lca.dis[find_lca(lca, u, v)]


# example:
function main()
    n = 6
    edges = [[1, 2], [1, 3], [3, 4], [4, 5], [4, 6]]
    lca = LCA(n, edges)
    println("LCA of 2 and 3 is ", find_lca(lca, 2, 3), " (distance:$(get_dis(lca, 2, 3)))") # LCA:1, dis:2
    println("LCA of 4 and 6 is ", find_lca(lca, 4, 6), " (distance:$(get_dis(lca, 4, 6)))") # LCA:4, dis:1
    println("LCA of 2 and 6 is ", find_lca(lca, 2, 6), " (distance:$(get_dis(lca, 2, 6)))") # LCA:1, dis:4
end

if Main == Base.MainInclude
    main()
end

# --------input func----------
input() = readline()
inputs() = split(readline())
int(s::AbstractChar) = parse(Int, s)
int(s::AbstractString) = parse(Int, s)
int(v::AbstractArray) = map(x -> parse(Int, x), v)
