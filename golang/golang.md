- [1. Types](#1-types)
	- [1.1. Type alias](#11-type-alias)
	- [1.2. Strings and runes](#12-strings-and-runes)
	- [1.3. Short variable declaration](#13-short-variable-declaration)
	- [1.4. Variable redeclaration](#14-variable-redeclaration)
	- [1.5. Tags](#15-tags)
- [2. Structs](#2-structs)
	- [2.1. Interface](#21-interface)
	- [2.2. Different ways to call a constructor](#22-different-ways-to-call-a-constructor)
	- [2.3. Inheritance](#23-inheritance)
- [3. Control flow](#3-control-flow)
	- [3.1. Naked return types.](#31-naked-return-types)
	- [3.2. Switches](#32-switches)
	- [3.3. defer](#33-defer)
	- [3.4. Loops](#34-loops)
- [4. Functions and methods](#4-functions-and-methods)
	- [4.1. Generic functions](#41-generic-functions)
	- [4.2. Variadic functions](#42-variadic-functions)
	- [4.3. Closure](#43-closure)
	- [4.4. Methods](#44-methods)
- [5. Data structures](#5-data-structures)
	- [5.1. Arrays and slices](#51-arrays-and-slices)
	- [5.2. Zero vals](#52-zero-vals)
	- [5.3. Heap operations](#53-heap-operations)
	- [5.4. Maps](#54-maps)
- [6. Error handling](#6-error-handling)
	- [6.1. Errors](#61-errors)
	- [6.2. Panic and recover](#62-panic-and-recover)
- [7. Concurrency](#7-concurrency)
	- [7.1. Channel](#71-channel)
- [8. Go environment](#8-go-environment)
	- [8.1. Naming conventions](#81-naming-conventions)
	- [8.2. Tooling and help](#82-tooling-and-help)
	- [8.3. Modules](#83-modules)
- [9. Go Tests](#9-go-tests)
	- [9.1. Helpful commands](#91-helpful-commands)
	- [9.2. Introduction to tests](#92-introduction-to-tests)
		- [9.2.1. Folder structure](#921-folder-structure)
		- [9.2.2. What categories of test failure functions are there?](#922-what-categories-of-test-failure-functions-are-there)
		- [9.2.3. Get help about testing](#923-get-help-about-testing)
		- [9.2.4. What is the naming convention for tests?](#924-what-is-the-naming-convention-for-tests)
		- [9.2.5. Test related packages](#925-test-related-packages)
			- [9.2.5.1. Std lib testing](#9251-std-lib-testing)
			- [9.2.5.2. Popular community testing](#9252-popular-community-testing)
	- [9.3. Creating and running tests](#93-creating-and-running-tests)
		- [9.3.1. Table driven test pattern](#931-table-driven-test-pattern)
		- [9.3.2. More helpful functions](#932-more-helpful-functions)
	- [9.4. Benchmarking and profiling](#94-benchmarking-and-profiling)
- [10. Packaging](#10-packaging)
	- [10.1. What types of packages are there?](#101-what-types-of-packages-are-there)
	- [10.2. Which source files does a package use?](#102-which-source-files-does-a-package-use)
	- [10.3. Naming](#103-naming)
		- [10.3.1. What happens when a package is imported?](#1031-what-happens-when-a-package-is-imported)
		- [10.3.2. How to name the content of a package?](#1032-how-to-name-the-content-of-a-package)
	- [10.4. How is a package consumed?](#104-how-is-a-package-consumed)
	- [10.5. Member visibility](#105-member-visibility)
	- [10.6. How to document a package?](#106-how-to-document-a-package)
	- [10.7. How to design packages?](#107-how-to-design-packages)
	- [10.8. Importing packages](#108-importing-packages)
	- [10.9. Alternative import methods](#109-alternative-import-methods)
	- [10.10. What are vendor dirs?](#1010-what-are-vendor-dirs)




# 1. Types

## 1.1. Type alias 

You can define a type alias via e.g. `type myint int`. 

## 1.2. Strings and runes

**Difference between char and runes** is that a char is an 8-bit character. A rune is utf-8 encoded, which is up to 32 bits long

You cannot change a char in a string. Strings are immutable. You'd have to convert the string to a slice of runes first

```golang
s := "some string"
r := []rune(s)
r[0] = 'a'
```

## 1.3. Short variable declaration

Declaration using `:=` is only available on function level. Outside of function level you have to use `var`

```golang
var i int = 1

func doStuff() {
    x := 5
}
```

## 1.4. Variable redeclaration

The following code is legal. 

```golang
i, err := f() // declare i and err
j, err := f() // declare j, but reassign err
```

## 1.5. Tags 

Meta information about a field in a struct. Can be accessed via reflections

```golang
type T struct {
    val int `this is a tag`
}

func main(){
    t := T{1}
    fmt.Println(t.fieldByName("f").Tag) // this is a tag
}
```

Often used to support the serialization of structs

```golang
type T1 struct {
     f int `json:"foo"`
 }
 ```


# 2. Structs

All members in a struct that start with an upper-case rune are exported (can be used outside the package). Lower-case names are not exported. 

## 2.1. Interface

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
	i = t // works, since we set concrete type here
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

## 2.2. Different ways to call a constructor

```golang
type Vertex struct {
	X, Y int
}

var (
	v1 = Vertex{1, 2}  // has type Vertex
	p  = &Vertex{1, 2} // has type *Vertex
	v2 = Vertex{X: 1}  // Y:0 is implicit
	v3 = Vertex{}      // X:0 and Y:0
)
```

## 2.3. Inheritance

Be aware that if you do `type myT someStruct`,   `myT` will have an empty method set, meaning that none of the methods of `someStruct` are available in `myT`

If you define `myT` as `type mT struct { someStruct }`, `someStruct` will be an anonymous filed of `mT` and `mT` will inherit all methods of `someStruct`

```golang
// Mutex has the methods Lock() and Unlock()

// NewMutex has no methods
type NewMutex Mutex 

// OtherMutex inherits Lock() and Unlock() from Mutex
type OtherMutex { Mutex }
```


# 3. Control flow
## 3.1. Naked return types. 

Return named parameters. Do this only in short functions

```golang
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}
```


## 3.2. Switches

Switches **without conditions** are useful to simplify long if else blocks

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

There is no **fallthrough** in go between cases. You can simulate fallthrough like this

```golang
func shouldEscape(c byte) bool {
    switch c {
    case ' ', '?', '&', '=', '#', '+', '%':
        return true
    }
    return false
}
```



## 3.3. defer

Deferred function-calls are executed after the function returns. 

Arguments passed to `defer` are evaluated when `defer` executes, not when the passed function executes, which is why the following gives you simple traces. Calling `a()` prints `entering: a` and `leaving: a`

```golang
func trace(s string) string {
    fmt.Println("entering:", s)
    return s
}

func un(s string) {
    fmt.Println("leaving:", s)
}

func a() {
    defer un(trace("a"))
    fmt.Println("in a")
}
```


You can **stack** defer statements

```golang
func main() {
	for i := 0; i < 5; i++ {
		defer fmt.Println(i) // prints 4 3 2 1 0
	}
}
```
You can change **named return values** in the `defer` statement

```golang
func f() (ret int) { // will return 1
	defer func ()  {
		ret++
	}()
	return 0
}
```

In your defer statement your can call **recover** to catch calls to panic

```golang
func panicHandler() {
	fmt.Println("panicHandler called")
	if r := recover(); r != nil {
		fmt.Printf("recovered with recover message: %v", r)
	}
}

func panicFunc() {
	defer panicHandler()
	panic(fmt.Sprintf("%v", "We are totally panicking right now!"))
}

panicFunc()
// panicHandler called
// recovered with recover message: We are totally panicing right now!
```

## 3.4. Loops

Exit a nested loop 

```golang
Outer:	for i := 0; i < 5; i++ {
			for j := 0; j < 5; j++ {
				break Outer
			}
		}
```

Loops with multiple variables 

```golang
// Reverse a
for i, j := 0, len(a)-1; i < j; i, j = i+1, j-1 {
    a[i], a[j] = a[j], a[i]
}
```

Infinite loop. You should handle an infinite loop in a separate go routine. Provide a timeout for this goroutine, so that you are not stuck in the infinite loop

```golang
func main() {
	go doLoop() // function containing infinite loop
	time.Sleep(5 * time.Second) // 5 seconds timeout
}
```




# 4. Functions and methods

## 4.1. Generic functions

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

## 4.2. Variadic functions

You can pass a variable number of args to a function with a variadic argument. If you do not define the type it defaults to an **empty interface**

```golang
func f(arg ...int) {} 	// slice of ints
func f(arg ...) {} 		// slice of interface{}
```



## 4.3. Closure

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

## 4.4. Methods

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

# 5. Data structures

## 5.1. Arrays and slices

An **array** is a fixed size, fixed type datastructure. If you pass an array to a function you will **pass it by copy**

```golang
arr := [...]{1,2,3,4,5} // array length auto counted
```

A **slice** is a view/reference on a part of an array. Second parameter is exclusive. A slice literal will create an array and then reference it via a slice. When slicing, you may omit the high or low bounds to use their defaults instead. The default is zero for the low bound and the length of the slice for the high bound.

Capacity is the the length of the underlying array, starting with the first element that the slice can access up to the last element of the underlying array

```golang
primes := [6]int{2, 3, 5, 7, 11, 13}
var s []int = primes[1:4] // 3, 5, 7
r := []bool{true, false} // creates slice literal
var t []int = primes[:3] // 2, 3, 5
var u []int = primes[3:] // 7, 11, 13
len(s) // 3	// length of slice
cap(s) // 5 // capacity of slice. Slice starts at 1, array ends at 5. Maximum 5 elements
var s []int // Default value of slice is nil
```

Since slices are **variable-length**, you can have a **2D-slice** where each row has a different number of elements

```golang
text := LinesOfText{
	[]byte("Now is the time"),
	[]byte("for all good gophers"),
	[]byte("to bring some fun to the party."),
}
```

## 5.2. Zero vals

Maps and slices both have `nil` as their zero value




## 5.3. Heap operations

`new(T)` **allocates** a zerod variable of type `T` and returns `*T`. Zeroing is transitive, meaning that a `struct` will also be allocated with all its members zeroed. The expression `new(File)` and `&File{}` are equivalent

You need `make` to **initialize** a `map`, a `slice` or a `channel`. `make(T)` returns an initialized/non-zeroed object of type `T`. `make` returns `T` and not `*T`, because under the hood it returns a data structure, which contains the pointers to your data. E.g. a slice is a data structure with 3 pointers (pointer to data, capacity and length each)

It is okay to return a pointer to a local variable

## 5.4. Maps 

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


# 6. Error handling

## 6.1. Errors

Simple structs that store a message. You can wrap errors `fmt.Errorf`. You can unwrap errors using `Unwrap`. 

Use `if errors.Is(err, SomeErrT)` instead of `if err == SomeErrT`, since the former succeeds if `err` wraps an error of type `SomeErrT`. The same holds for `error.As`

## 6.2. Panic and recover

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


# 7. Concurrency 

## 7.1. Channel

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

`fibonacci` writes to `c`. `c` is blocking. Anonymous function outputs numbers to console

```golang
func fibonacci(c, quit chan int) {
	x, y := 0, 1
	for {
		// select the routine with is available first
		// or at random, if both available
		select {			
		case c <- x:		// write to c
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




# 8. Go environment

## 8.1. Naming conventions

**package** names are one word names. The package name `base64` is in `src/encoding/base64`. It should NOT be named `encodingBase64` or similar. Package names should be one-word and lowercase without - or _. Do not worry about naming collision between packages. If there is a collision, the importing package can define a different local name

Upper-case **functions** are exported and lower-case functions are not exported. If you define converters call them `String` not `ToString`

Use short names for **structs**. It is `Reader` not `BuffReader`, because you use the reader via `bufio.Reader`

**In general** use short names. If you want to describe something complicated, put it in the documentation, not the naming

One method **interfaces** have an er suffix, e.g. Reader or Writer

Use **MixedCaps** or **mixedCaps** for multi-word variables

## 8.2. Tooling and help

- Find additional help in `/usr/local/go/doc/`
- Read docs with `go doc`
- There are additional help options like 
  - `go help buildmode`
  - `go help go.mod` to get info about go modules
- Find various tools with `go tool --help`
  - `go tool cover` to see test coverage
  - `go tool vet` to check source for errors
  - `go tool trace` to see the trace of a test
- `godoc -index` get a searchabele documentation of your code on localhost:6060. Install via `go get -u golang.org/x/tools/...`

## 8.3. Modules

Go consists of [modules](https://golang.org/doc/tutorial/create-module) (like libs) and modules consist of packages. 

Create a module 

```bash
mkdir mymodule 
cd mymodule
go mod init example.com/mymodule 
# above cmd creates go.mod, which contains version, deps and name of module
# create hi.go with package mymodule. All upper-case funcs will be exported
# create func HI() string in hi.go
cd ..
mkdir usingmodule
cd usingmodule
# create using.go which imports "example.com/mymodule"
go build
# above cmd locates module and adds its dep to current build and creates binary

# mymodule/
# |_ go.mod
# |_ hi.go
# usingmodule/
# |_ using.go
```

# 9. Go Tests

## 9.1. Helpful commands

```bash
go test -v --cover -html=cover.html -o cover.html 	# coverage. Open file with go cover
go test -v run TestFuncName 		# wil also run TestFuncName2
go test -v ./path/to/package		# test specific package
go test -v ./path/to/module/...		# test all packages in module
go test {pkg1} {pkg2} 				# test one or more package
go test ./... 						# test everything in current dir and sub dirs
go test -run {regexp}				# test every test matching regexp
```

Test results are cahced. If you want to disable that, you can use `GOCACHE=off`

Use `testdata` folder in package, if you need to store test data in separate files (e.g. csv files)


## 9.2. Introduction to tests


### 9.2.1. Folder structure 

```
code 
	go.mod				// contains somemodule module
	somemodule
		somemodule.go 	// code to test
		main_test.go 	// _test.go suffix for tests and benchmarks
```

- Code and tests have to be part of the same package
  - If you add `_test` to the testing package, it will do blackbox testing instead of whitebox testing
  - Use blackbox testing when you want to test the interface of your package and whitebox testing for internal things
  


Example test function

```golang
func TestSomething(t *testing.T) {
	got := Something()
	expected := 4
	if got != expected {
		t.Errorf("failure")
	}
}
```

### 9.2.2. What categories of test failure functions are there?

- Immediate failures. Stop if this fails
    - `t.FailNow`
	- `t.Fatal` (FailNow with logs)
	- `t.Fatalf` (Fatal with formatting)


- Non-immediate failure. Continue testing, because the failure was not super bad. Functions like above
    - `t.Fail`
    - `t.Error`
    - `t.Errorf`

- Skip tests for debugging
    - `t.SkipNow`
    - `t.Skip`
    - `t.Skipf`




### 9.2.3. Get help about testing

-  `go help test`
- and `go help testflag`

### 9.2.4. What is the naming convention for tests?

- Call the test for the `main` module `main_test`
- `_test.go` suffix for test files
- `TestSomeFunction` for testing `SomeFunction`
  - If a function does not start with `Test` it will not be recognised as a test


### 9.2.5. Test related packages

#### 9.2.5.1. Std lib testing

- Use golang [testing package](https://golang.org/pkg/testing/) from the std lib for testing
- `testing/quick` for writing black-box testing
- `testing/iotest` for io testing
- `net/http/httptest` for network testing


#### 9.2.5.2. Popular community testing

- Testify for assertions
- `GoConvey` for a nice UI
  - `go get -t github.com/smartystreets/goconvey`
  - `$GOPATH/bin/goconvey`
  - go to `http://127.0.0.1:8080`
- `httpexpect` for testing of webservices and REST APIs
- `gomock` for mocking objects
- `go-sqlmock` for mocking sql tests

## 9.3. Creating and running tests

### 9.3.1. Table driven test pattern 

```golang
func TestSomeFunc(t *testing.T) {
	scenarios := []struct{
		input 	string
		output	string
	}{
		{"someInput", "expectedOutput"}
	}
	// iterate over scenarios
		// call someFunc for each scenario
}
```


### 9.3.2. More helpful functions

- Use `t.Run` to call sub-tests from a test
- `t.Parallel` to execute tests in parallel


## 9.4. Benchmarking and profiling

- Use `Benchmark` prefix on functions for benchmarks 
- Use `*testing.B` as parameters
  	- `b.N` number of times this test benchmark should run. Will be set automatically depending on the benchtime
  	- `b.StartTimer`, `b.StopTimer` and `b.ResetTimer` to handle the benchmark timer
  	- `b.RunParallel` to run function in parallel
- Use `go test -bench . -benchtime 10s` to run unittests and benchmarks matching . (all) for max 10 seconds.
- Use `go test -benchmem` to benchmark memory consumption 
- Use `go test -trace trace.out` to record execution traces
- Use `go test -(type)profile {file.out}` for the types `block`, `cover`, `cpu`, `mem` and `mutex` for different types of benchmarks
  - Analyze with go pprof tool



# 10. Packaging

## 10.1. What types of packages are there?

- **Types**:
  - **Library package**: Consume by other package
    - Name of package has to match the dir in which it is in
    - Contains related features
  - **Main package**: Application entry point (`main` function)
    - Can be in any dir
    - Contains app setup


## 10.2. Which source files does a package use?

- A package uses the source files in that dir (not parent or child dirs)

## 10.3. Naming

### 10.3.1. What happens when a package is imported?

- Naming has to be lower case (just like the dir they are ins)
- No underscores
- Use nouns not verbs

### 10.3.2. How to name the content of a package?

- **Avoid duplicates**. E.g. in the package `json`, you can use the function `decode` instead of `jsonDecode`. It will be called via `json.decode` anyways
- **Simplify function names**. E.g. use `time.New` instead of `time.NewTime`


## 10.4. How is a package consumed? 

- 1: Check for **imports of imports**
- 2: Set **variables** to init values
  - Init values are values set in the global scope
- 3: Call `init()` function
  - In each source file, the init function will be called
  - If there are **multiple** `init` functions in the same source file, they will all be called in undefined order. Exception: Any `init` function located in the `main` package will be called after the non-main package init functions
  - You cannot call an `init` function from code 


## 10.5. Member visibility

- **Public scope**: Symbols with an upper case are public and accessible outside the package
- **Internal package**: Parent package can use it, package itself can access it, but it is not public/Can not be consumed by outsiders
  - Purpose: Keep packages clean. Main packages do their thing. They share common functionalities via internal package, without exposing those functionalities
  - Internal packages are defined using import path `some/path/internal/some/package`
  - The folder has to be called `internal`
  - Above package can be accessed from direct parent and its children. Direct parent is `path`	
- **Package scope**: Anything lower case will accessible in the package itself but not outside the package

## 10.6. How to document a package?

- Comments are written before the `package` keywords
- If you are have a long comment use a `doc.go` file, which contains only comments and the `package` at the end of it
- Document the **public members** of your package
  - Use complete sentences
  - Start with the symbol that you are describing
  - Write a short first sentence as a summary

## 10.7. How to design packages?

- A package should be focused on one problem
- Think about the consumer of that package and how they use the public API
  - Provide a consistent API
  - Minimize the external API
    - E.g. take one config object from external consumer. Depending on config, call different implementations internally
    - Or return an interface type, to abstract away changes from consumer
  - Prefer error over panic
- Maximize reusability
  - Reduce number of dependencies. The more dependencies the more breaking changes you may have to do
  - Minimize scope. A package should do one thing and one thing well

## 10.8. Importing packages

- When importing a package with a compound path, you only use the last dir when referring to the package. E.g. `net/http` and `http.ListenAndServe`

## 10.9. Alternative import methods

- **Aliases**: If you have two import suffices twice, you can use an alias
  - E.g. `import someAlias "some/package"`
- **Import for side effects**: Aliasing with ignore
  - E.g. `import _ "some/package"`
  - Calls `init` functions of package
  - Often used with db drivers, which have to init themselves
- **Relative imports**: Import a package relative to your current one
  - Not valid in workspaces or modules. Only good for prototyping
  - Quite rare

## 10.10. What are vendor dirs?

- **Purpose**: For managing multiple versions of same lib
- Apply to workspace ony
- Outdated. Currently go uses **modules**
- If there are **conflicting versions**, the first version wins
- Use folder `vendor` and put dependencies in it
- You can still change the dependencies in the `vendor` directory








