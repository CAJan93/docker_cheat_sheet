/*
https://leetcode.com/problems/3sum-closest/
Given an array nums of n integers and an integer target,
find three integers in nums such that the sum is closest to target.
Return the sum of the three integers. You may assume that each input would have exactly one solution.

Example:
Input: nums = [-1,2,1,-4], target = 1
Output: 2
Explanation: The sum that is closest to the target is 2. (-1 + 2 + 1 = 2).
*/
package threesumclosest

import "sort"

/**
Analysis:
- This could be broken down to 2sumcloses + 1 additional number
- Maybe this is a DB problem?
- It can defensibly be implemented recursively
- Hash map does not work, since we are not looking for an exact match, but closest
- Use BST insteadb


Ideas:
Brute force:
- 3 loops comparing each number with each other twice
- O(n^3)

Binary search:
- Solve 2Sum closest
	- Sort array
	- Iterate over each number
	- For each number n find x = target - n via binary search in nums
	- If x not present, use the numbers next to where x would be
- Solve 3Sum closest the same way
	- array = nums X nums
	- sort array
	- Iterate over array, try to find x like above
	- O(n^2), because we have to generate array

Tree search:
- Each number is a possible child node
- Always search for the number which is the closest
- In above example
	nums = -4,-1,1,2
	target = 1
	take = 1
	current_sum = 1

	nums = -4,-1,2
	target = 0 // target -= take
	take = -1
	current_sum = 0

	nums = -4,2
	target = 1
	current_sum = 2

	resulting in output [1,-1,2]

Dynamic programming
- Another solution to 2Set problem
- aka. Subset-sum (see note book)
- Create a DB table
- The idea from the book does not quite work, since it searches for any subset sum with any number of elements


Backtracking solution:
Driver:
arr = []
solution = []
bestdiff = INT_MAX

def backtrack():
	// return next unused number

def driver():
	while x = nextElement():
		if len(arr) = 3:
			if |sum(arr) - target| < bestdiff:
				solution = arr
				bestdiff = sum(arr)
			else:
				// no more solutions here, backtrack
		else:
			// add next number







**/

func dist(i int, j int) int {
	diff := i - j
	if diff < 1 {
		return -1 * diff
	}
	return diff
}

func smallerDist(i int, j int, target int) int {
	if dist(i, target) < dist(j, target) {
		return i
	}
	return j
}

func searchClosest(nums []int, target int) int {
	lower := 0
	upper := len(nums)
	middle := -1
	for lower < upper-1 { // ?
		middle = (upper - lower) / 2
		if nums[middle] == target {
			return target
		}
		if nums[middle] > target {
			// go left
			upper = middle
		} else {
			// go right
			lower = middle
		}
	}
	if middle-1 == -1 {
		return nums[middle+1]
	}
	if middle+1 == len(nums) {
		return nums[middle-1]
	}
	return (nums[middle-1], nums[middle+1], target)
}

func threeSumClosest(nums []int, target int) int {
	sort.Ints(nums)
	result := searchClosest(nums, target)
	result += 
}
