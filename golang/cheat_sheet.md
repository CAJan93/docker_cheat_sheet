# Snippets

## Naked return types. 

Return named parameters. Do this only in short functions

```golang
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}
```

## Short variable declaration

Declaration using `:=` is only available on function level. Outside of function level you have to use `var`

```golang
var i int = 1

func doStuff() {
    x := 5
}
```

## Switch without condition

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

## Stacking defers

`defer` statements are executed after the function returns. You can stack defer statements

```golang
func main() {
	for i := 0; i < 5; i++ {
		defer fmt.Println(i) // prints 4 3 2 1 0
	}
}
```

## Different ways to call a constructor

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

## Slices

View/reference on a part of an array. Second parameter is exclusive. A slice literal will create an array and then reference it via a slice. When slicing, you may omit the high or low bounds to use their defaults instead. The default is zero for the low bound and the length of the slice for the high bound.

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

## Zero vals

Maps and slices both have `nil` as their zero value

## Maps 

```golang
m := make(map[string]int)
m["a"] = 1
delete(m, "a")
val, ok := m["a"] // 0, false
```

## Closure

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

## Methods

You do not define methods inside the `type` declaration. You define them outside of it

Methods always accept either pointers or values, regardless what their declaration says. This is different from functions, which are strict about this

```Golang
type Vertex struct {
	X, Y float64
}

func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}
// use with v.Abs()
```