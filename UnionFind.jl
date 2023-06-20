# -----------Union-Find-----------
par = collect(1:n)
siz = ones(Int, n)

function root(x::Int)
    index = par[x]
    while par[index] != index
        index = par[index]
    end
    index
end

function unite!(x::Int, y::Int)
    rx, ry = root(x), root(y)
    rx == ry && return 0
    if rx > ry
        rx, ry = ry, rx
    end
    par[ry] = rx
    siz[rx] += siz[ry]
end

issame(x::Int, y::Int) = isequal(root(x), root(y))
# --------------------------------
