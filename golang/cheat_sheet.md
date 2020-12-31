- [1. Basics](#1-basics)
	- [1.1. Type alias](#11-type-alias)
	- [1.2. Naked return types.](#12-naked-return-types)
	- [1.3. Short variable declaration](#13-short-variable-declaration)
	- [1.4. Switch without condition](#14-switch-without-condition)
	- [1.5. defer](#15-defer)
	- [1.6. Functions](#16-functions)
		- [1.6.1. Generic functions](#161-generic-functions)
		- [1.6.2. Variadic functions](#162-variadic-functions)
	- [1.7. Structs](#17-structs)
		- [1.7.1. Different ways to call a constructor](#171-different-ways-to-call-a-constructor)
		- [1.7.2. Inheritance](#172-inheritance)
	- [1.8. Arrays and slices](#18-arrays-and-slices)
	- [1.9. Zero vals](#19-zero-vals)
	- [1.10. Heap operations](#110-heap-operations)
	- [1.11. Maps](#111-maps)
	- [1.12. Closure](#112-closure)
	- [1.13. Methods](#113-methods)
	- [1.14. Interface](#114-interface)
	- [1.15. Errors](#115-errors)
	- [1.16. Channel](#116-channel)
	- [1.17. Strings and runes](#117-strings-and-runes)
	- [1.18. Loops](#118-loops)
	- [1.19. Panic and recover](#119-panic-and-recover)
	- [1.20. Naming conventions](#120-naming-conventions)



# 1. Basics


## 1.1. Type alias 

You can define a type alias via e.g. `type myint int`. 

## 1.2. Naked return types. 

Return named parameters. Do this only in short functions

```golang
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}
```

## 1.3. Short variable declaration

Declaration using `:=` is only available on function level. Outside of function level you have to use `var`

```golang
var i int = 1

func doStuff() {
    x := 5
}
```

## 1.4. Switch without condition

Useful to simplify long if else blocks

```golang
func main() {
	t := time.Now()
	switch {
	case t.Hour() < 12:
		fmt.Println("Good morning!")
	case t.Hour() < 17:
		fmt.Println("Good afternoon.")
	default:
		fmt.Println("Good evening.")
	}
}
```

## 1.5. defer

`defer` statements are executed after the function returns. You can stack defer statements

```golang
func main() {
	for i := 0; i < 5; i++ {
		defer fmt.Println(i) // prints 4 3 2 1 0
	}
}
```

You can change named return values in the `defer` statement

```golang
func f() (ret int) { // will return 1
	defer func ()  {
		ret++
	}()
	return 0
}
```

## 1.6. Functions

### 1.6.1. Generic functions

There are no generic functions. You can get the same effect by doing the following. Let's say you want to write a sort function that works on slices

1. Define an interface

```Golang
type Sorter interface {
	Len() int			// length of slice
	Less(i, j int) bool // compare at index i and j
	Swap(i, j int) bool // swap at index i and j
}
```
2. Define custom types, e.g.

```Golang
type X []int
type Y []string
```

3. Implement the methods defined in your interface, e.g.


```golang
func (x X) Less(i int, j int) { return x[i] < x[j] }
```

4. Define your sort function 

```golang
func Sort(s *Sorter) {
	// use s.Less and s.Swap here
}
```

### 1.6.2. Variadic functions

You can pass a variable number of args to a function with a variadic argument. If you do not define the type it defaults to an **empty interface**

```golang
func f(arg ...int) {} 	// slice of ints
func f(arg ...) {} 		// slice of interface{}
```

## 1.7. Structs

All members in a struct that start with an upper-case rune are exported (can be used outside the package). Lower-case names are not exported. 

### 1.7.1. Different ways to call a constructor

```golang
type Vertex struct {
	X, Y int
}

var (
	v1 = Vertex{1, 2}  // has type Vertex
	v2 = Vertex{X: 1}  // Y:0 is implicit
	v3 = Vertex{}      // X:0 and Y:0
	p  = &Vertex{1, 2} // has type *Vertex
)
```

### 1.7.2. Inheritance

Be aware that if you do `type myT someStruct`, `myT` will have an empty method set, meaning that none of the methods of `someStruct` are available in `myT`.

If you define `myT` as `type mT struct { someStruct }`, `someStruct` will be an anonymous filed of `mT` and `mT` will inherit all methods of `someStruct`

```golang
// Mutex has the methods Lock() and Unlock()

// NewMutex has no methods
type NewMutex Mutex 

// OtherMutex inherits Lock() and Unlock() from Mutex
type OtherMutex { Mutex }
```

## 1.8. Arrays and slices

An **array** is a fixed size, fixed type datastructure. If you pass an array to a function you will **pass it by copy**

```golang
arr := [...]{1,2,3,4,5} // array length auto counted
```

A **slice** is a view/reference on a part of an array. Second parameter is exclusive. A slice literal will create an array and then reference it via a slice. When slicing, you may omit the high or low bounds to use their defaults instead. The default is zero for the low bound and the length of the slice for the high bound.

```golang
primes := [6]int{2, 3, 5, 7, 11, 13}
var s []int = primes[1:4] // 3, 5, 7
r := []bool{true, false} // creates slice literal
var t []int = primes[:3] // 2, 3, 5
var u []int = primes[3:] // 7, 11, 13
len(s) // 3
cap(s) // 6 // len of underlying array
var s []int // Default value of slice is nil
```

## 1.9. Zero vals

Maps and slices both have `nil` as their zero value

## 1.10. Heap operations

`new(T)` **allocates** a zerod variable of type `T` and returns `*T`. Zeroing is transitive, meaning that a `struct` will also be allocated with all its members zeroed. This is why the expression `new(File)` and `&File{}` are equivalent

You need `make` to **initialize** a `map`, a `slice` or a `channel`. `make(T)` returns an initialized/non-zeroed object of type `T`. `make` returns `T` and not `*T`, because under the hood it returns a data structure, which contains the pointers to your data. E.g. a slice is a data structure with 3 pointers (pointer to data, capacity and length each)

It is okay to return a pointer to a local variable

## 1.11. Maps 

```golang
m := make(map[string]int)
m["a"] = 1
delete(m, "a")
val, ok := m["a"] 				 	// 0, false
var funcs = map[int]func() int { 	// mapping from int to a function
	1: func() int { return 10 },
	2: func() int { return 20 }
}
```



## 1.12. Closure

Code below will return the fibonacci numbers if you run the function in a loop

```golang
func fibonacci() func() int {
	num1, num2 := 1, 1
	c := func() int {
		tmp := num1
		num1 = num2
		num2 += tmp
		return tmp
	}
	return c
}
```

## 1.13. Methods

You do not define methods inside the `type` declaration. You define them outside of it

Methods always accept either pointers or values, regardless what their declaration says. This is different from functions, which are strict about this

All methods of a type should either be implemented as a value or a pointer receiver. Do not mix. Use pointer receiver if you wanna modify the receiver (object) or want to avoid copying

```Golang
type Vertex struct {
	X, Y float64
}
// use with v.Abs()
func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}
```

## 1.14. Interface

Is a listing of methods. Any `type` that has these methods, implements the interface. An interface may include another interface, like 

```golang
type Inter interface {
	sort.Interface 		// another interface
	SomeMethod() int
}
```

Think about an `interface` as a map, mapping values to a concrete type, which implements that interface `(value, type)`. 

A function with accepts an **empty interface** `interface{}` can accept values of any type

```golang
type I interface {
	M()
}

type T struct {
	S string
}

// T implements I implicitly
func (t T) M() {
	fmt.Println(t.S)
}
```

If you call a method which accepts an interface with an **uninitialized variable**, you will call the method with `nil`. This is not an error!

```golang
type I interface { M() }

type T struct { S string }

func (t *T) M() {
	if t == nil {
		fmt.Println("<nil>")
		return
	}
	fmt.Println(t.S)
}

func main() {
	var i I
	var t *T
	i = t
	i.M() // "<nil>"
}
```

Calling a method on a **nil interface** gives you a run-time error, since there is no concrete type backing up the interface

```golang
type I interface { M() }

func main() {
	var i I		// nil interface without concrete types
	describe(i) // (<nil>, <nil>)
	i.M() 		// run-time error 
}

func describe(i I) { fmt.Printf("(%v, %T)\n", i, i) }
```

You can do **type assertions** and **type switches** like this

```golang
var i interface{} = "hello"
s, ok := i.(string) 	// hello, true
f, ok := i.(float64)	// 0, false

switch t := i.(type) {
case int: 
	// handle int
default:
	// unable to handle type t
}
```

## 1.15. Errors

Simple structs that store a message. You can wrap errors `fmt.Errorf`. You can unwrap errors using `Unwrap`. 

Use `if errors.Is(err, SomeErrT)` instead of `if err == SomeErrT`, since the former succeeds if `err` wraps an error of type `SomeErrT`. The same holds for `error.As`

## 1.16. Channel

Typed communication between routines. 

By default sending and receiving data via channels blocks execution until channel is done. You can avoid this with the help of **buffered channels**. A buffered channel will only block, if the buffer is full

A sender `closes` a channel to indicate to the receiver that no more data will be send

```golang
func main() {
	ch := make(chan int, 2) // buffered channel with a buffer of size 2
	ch <- 1					
	ch <- 2					// write to ch does not block, because of buffer
	fmt.Println(<-ch)
	fmt.Println(<-ch)
	close(ch)
	data, ok := <-ch		// 0, false
	if !ok {
		fmt.Println("not okay")
	}
}
```

You can write a function that processes the data of two different channels. It will process the one which gives it data first

```golang
func fibonacci(c, quit chan int) {
	x, y := 0, 1
	for {
		// select the routine with is available first
		// or at random, if both available
		select {			
		case c <- x:		// read from c
			x, y = y, x+y	// calc fibonnacci
		case <-quit:	    // read from quit
			fmt.Println("quit")
			return
		}
	}
}

func main() {
	c := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++ {	// get 10 ints from channel c
			fmt.Println(<-c)
		}	
		quit <- 0					// write 0 to channel quit
	}()								// run unnamed function
	fibonacci(c, quit)
}

```

Executing a routine with an unnamed function

```golang
	go func() {
		// do stuff
	}()
```

Use `default` to try a **channel without blocking**

```golang
select {
case i := <-c:
	// use i if c is ready
case j := <-d:
	// use j i if d is ready
default:
    // handle if neither c or d are ready
}
```

Write a **game loop** go-style

```golang
func main() {
	tick := time.Tick(100 * time.Millisecond)
	for {
		select {
		case <-tick:
			// execute ever 100 ms		
	}
}

```

## 1.17. Strings and runes

**Difference between char and runes** is that a char is an 8-bit character. A rune is utf-8 encoded, which is up to 32 bits long

You cannot change a char in a string. Strings are immutable. You'd have to convert the string to a slice of runes first

```golang
s := "some string"
r := []rune(s)
r[0] = 'a'
```


## 1.18. Loops

Exit a nested loop 

```golang
Outer:	for i := 0; i < 5; i++ {
			for j := 0; j < 5; j++ {
				break Outer
			}
		}
```

## 1.19. Panic and recover

**Panic** does the following thing:

- Caused by a call to `panic` or by a runtime error
- Stops the execution of function `f`
- Executes the deferred statements of `f` 
- Behaves like a panic to the caller of `f`
- If this program reaches the top function of the current routine the program crashes

**Recover** is a builtin function that does the following thing:

- In normal execution `recover` returns `nil`
- You have to put `recover` in a deferred function
- If `recover` is called by `panic`, panic returns the value given to `recover` and resumes normal execution


## 1.20. Naming conventions

**package** names are one word names. The package name `package` is in `path/to/package/`.

Upper-case **functions** are exported and lower-case functions are not exported. If you define converters call them `String` not `ToString`

Use short names for **structs**. It is `Reader` not `BuffReader`, because you use the reader via `bufio.Reader`

**In general** use short names. If you want to describe something complicated, put it in the documentation, not the naming

One method **interfaces** have an er suffix, e.g. Reader or Writer. 