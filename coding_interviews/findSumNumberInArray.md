Given an array and a target, return two indexes in array whose numbers sum up to target

Array: 1,4,2,4,7,3
Target: 6

- Sort array
- 1,2,3,4,4,7
- Do two pointers
- 1,2,3,4,4,7
  |         |

p1 = 0 
p2 = len(arr) -1
while (p1 < p2) {

    if arr[p1] + arr[p2] > target {
        p2--
    } else if arr[p1] + arr[p2] == target {
        // result found
    } else {
        p1++
    }
} 

1,2,3,4,4,7     sum = 8
|         |
1,2,3,4,4,7     sum = 5
|       |
1,2,3,4,4,7     sum = 6
  |     |