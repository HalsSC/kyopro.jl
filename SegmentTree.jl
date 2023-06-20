# --------Segment-Tree--------
import Base:get
struct SegmentTree{T}
    op::Function        # 演算子
    ide::T              # 単位元
    node::Vector{T}     # 木
    len::Int            # sz ≤ lenとなる最小の2の累乗
end



"""
SegmentTree{T}(a::Array{T}, op::Function, ide::T) where T

単位元をideとする演算子opのセグメント木を配列aから構築するコンストラクタ
"""
function SegmentTree{T}(a::Array{T}, op::Function, ide::T) where T
    len::Int = 2^ndigits(length(a), base=2)
    node::Vector{T} = fill(ide, 2len - 1)
    @inbounds for (i, val) = enumerate(a)
        node[i + len - 1] = val
    end
    @inbounds for i = len - 1:-1:1
        node[i] = op(node[2i], node[2i + 1])
    end
    SegmentTree{T}(op, ide, node, len)
end



"""
SegmentTree{T}(n::Int, op::Function, ide::T) where T

単位元をideとする演算子opの長さnのセグメント木を構築するコンストラクタ
"""
function SegmentTree{T}(n::Int, op::Function, ide::T) where T
    len::Int = 2^ndigits(n, base=2)
    SegmentTree{T}(op, ide, fill(ide, 2len - 1), len)
end



"""
set!(seg::SegmentTree{T}, i::Int, x::T) where T

O(logN)
a[i]にxを代入
"""
function set!(seg::SegmentTree{T}, i::Int, x::T) where T
    i += seg.len - 1
    seg.node[i] = x
    while i > 1
        i ÷= 2
        seg.node[i] = seg.op(seg.node[2i], seg.node[2i + 1])
    end
end



"""
update!(seg::SegmentTree{T}, i::Int, x::T) where T

O(logN)
a[i]をop(a[i], x)に置き換える
"""
function update!(seg::SegmentTree{T}, i::Int, x::T) where T
    i += seg.len - 1
    seg.node[i] = seg.op(seg.node[i], x)
    while i > 1
        i ÷= 2
        seg.node[i] = seg.op(seg.node[2i], seg.node[2i + 1])
    end
end



"""
get(seg::SegmentTree, i::Int)

O(1)
a[i]を返す
"""
get(seg::SegmentTree, i::Int) = seg.node[i + seg.len - 1]
    


"""
prod(seg::SegmentTree, l::Int, r::Int)

O(logN)
op(a[l],a[l+1],...,a[r-1])を計算して返す
"""
function prod(seg::SegmentTree, l::Int, r::Int)
    l += seg.len - 1
    r += seg.len - 1
    vl, vr = seg.ide, seg.ide
    while l < r
        if l % 2 == 1
            vl = seg.op(vl, seg.node[l])
            l += 1
        end
        if r % 2 == 1
            r -= 1
            vr = seg.op(vr, seg.node[r])
        end
        l >>= 1
        r >>= 1
    end
    seg.op(vl, vr)
end



"""
all_prod(seg::SegmentTree)

O(1)
op(a[1],...,a[end])を返す
"""
all_prod(seg::SegmentTree) = seg.node[1] 
# ----------------------------
