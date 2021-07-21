# Approach to dynamic programming

Taken from [What Is Dynamic Programming and How To Use It](https://www.youtube.com/watch?v=vYquumk4nWw).

Example task: Calculate fibonacci of n. 1,1,2,3,5,8 fib(3) =, fib(5) = 5

1. Come up with recursive solution
   
   ```python
    def fib(n):
        if n <= 2:
            result = 1
        else:
            result = fib(n-1) + fib(n-2)
        return result
   ```

   This has a runtime of O(2^n)

2. Cache results (memorization)

   ```python
    def fib(n, cache):
        if cache[n] != None:
            return cache[n]
        if n <= 2:
            result = 1
        else:
            result = fib(n-1) + fib(n-2)
        cache[n] = result
        return result
   ```

   This has a runtime of O(n). Top-down approach


3. Come up with bottom up approach

    Now fill the cache bottom-up

    ```python
    def fib(n):
        if fib <= 2:
            return 1
        cache = new int[n+1]
        cache[1] = 1
        cache[2] = 1
        for i from 3 to n:
            cache[i] = cache[i-1] + cache[i-2]
        return cache[n]
    ```

    This has a runtime of O(n)