# merge [left,mid) and [mid,right)
function merge(a, b, left, mid, right)
    i, j = left, mid
    for k = 1:right-left
        if mid <= i
            b[k] = a[j]
            j += 1
        elseif right <= j
            b[k] = a[i]
            i += 1
        elseif a[i] <= a[j]
            b[k] = a[i]
            i += 1
        else
            b[k] = a[j]
            j += 1
        end
    end
    for k = 1:right-left
        a[k+left-1] = b[k]
    end
end

function merge_sort(a, b=zeros(Int, length(a)), left=1, right=length(a) + 1)
    left == right && return
    left == right - 1 && return
    mid = (left + right) ÷ 2
    merge_sort(a, b, left, mid)
    merge_sort(a, b, mid, right)
    merge(a, b, left, mid, right)
end

function example()
    a = rand(1:10, 10)
    println("start: ", " a = ", a)
    println("-"^15 * "merge sort" * "-"^15)
    merge_sort(a)
    println("finish:", " a = ", a)
end

if Main == Base.MainInclude
    example()
end
