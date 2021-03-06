// Playground - noun: a place where people can play

import UIKit
import XCPlayground

//: ![Functions Part 2](banner.png)

//: # Functions Part 2

//: This playground is designed to support the materials of the lecure "Functions 2".

//: ## Functions have type
//: Swift Functions are actually a special case of "Closure", and are sometimes known as a "Named Closure". These are not simply function points, but better thought of as data structures, much like an instance of a class. 
//: * Swift functions have a type, and are in fact *reference types* (again, like the instance of a class).
//: * Swift functions are in fact **First Class Types**. You treat them like other types (e.g. Array, String, Int, instances of NSArray etc..).

//: The following function takes two labelled paramters, and returns an Optional that wraps a Double.
//: It's type is `(Int,Int)->Double?`

func divide(#numberator : Int, #denominator : Int) -> Double? {
    if (denominator == 0) {
        return nil
    } else {
        let y = Double(numberator) / Double(denominator)
        return y
    }
}

//: Like any other type, we can declare and define variables and constants with function types. Here for example, is an explicitely typed constant of type `(Int,Int)->Double?`
let mathFunction : (num: Int, den: Int) -> Double?

//: Again, like any other type, we can simply assign this constant to an object of the same type. Here it is assigned to the divide function.
mathFunction = divide

//: We can invoke the function using the newly assigned constant
for n in 1...4 {
    for m in n...4 {
        if let y = mathFunction(num: n, den: m) {
            println("\(n) / \(m) = \(y) ")
        }
    }
}

//: This takes some getting used to. I found it helped to think of function types are objects. I don't know the implementation specifics of Swift functions, but other languages do indeed use data structures to represent Closures (of which Swift functions are a variant)

//: ## Passing functions as parameters
//: As functions have a type, and are first-class types, they can be passed as parameters like
//: any other.
//:

//: ### Example 1 - Distance between points
//: In this example, I shall write a function to calculate the distance between
//: two 2D points using different metrics of distance. I try to avoid code replication
//: by writing the common code in a higher-order function, and passing in the specific
//: functionality via a parameter.

//: To make the code cleaner, I shall use `typealias` and create
//: a new type for a 2D point called Point2D. This type is a Tuple. I've used labels
//: to also make the code more self-explanitory.
typealias Point2D = (x: Double, y: Double)    //Type Point is a tuple (with labels)


//: Now I write some functions for different distance metrics, measuring the distance of a 2D point from the origin (0,0). Don't worry if you don't understand the maths. What is important here is I've writing two functions that take the same type of parameters and return the same type. Both a measures of line length essentially.

//Euclidean Distance (based on Pythagoras theorem) from the origin (0,0)
func euclidean(p : Point2D) -> Double {
    return sqrt(p.x*p.x + p.y*p.y)
}

//Maximum distance from the origin (0,0)
func maxAbsolute(p : Point2D) -> Double {
    return max(fabs(p.x) , fabs(p.y))
}

//: Now I create another new type "DistanceMetric". This is a *function type*, that takes a point argument and returns a Double. By default this would be the distance from the origin (0,0).
typealias DistanceMetric = Point2D -> Double

//: The following **higher-order function** calculates the 'distance' *between* two points using a provided DistanceMetric. Note that this function contains the common code for the different methods used. Note the third parameter is a function. It returns a Double, which represents the distance between the points p1 and p2
func distanceBetweenPoint(p1 : Point2D,  andPoint p2 : Point2D, usingMetric metric : DistanceMetric) -> Double {
    
    //The following three lines are common to many distance measures
    let dx = p1.x - p2.x        //Difference between x coordinates
    let dy = p1.y - p2.y        //Difference between y coordinates
    let delta = (x: dx, y: dy)  //Wrap in a tuple (with labelled elements)

    //: It is the next line is what differentiates the different distance metrics
    let distance = metric(delta)//Apply provided distance metric
    
    return distance
}

//: Ok, let's test using a couple points
let p1 : Point2D = (x: 1.0, y: 5.0)           //Point in 2D
let p2 : Point2D = (x: 2.0, y: 3.0)           //And again

//: Calculate using two different distance metrics
distanceBetweenPoint(p1, andPoint: p2, usingMetric: euclidean)
distanceBetweenPoint(p1, andPoint: p2, usingMetric: maxAbsolute)
//: These values are different because the distance metrics used are different.

//: ### Comments
//:
//: The above shows how a function can be passed as a parameter to another higher-order function in order to customise/adapt behaviour.
//: We see another example of this in the standard library, with functions such as `sort`, `map`, `filter` and `reduce`

//: ### Example - `sort`
//: In this example, I used the Swift standard library `sort` function. This is a higher-order function that allows custom sorting behaviour using bespoke criteria.

//: Start with some integer values
let arrayOfNumbers = [1, 15, -5, 10, 22]

//: Calculate the mean ( *don't worry if you don't understand this code* )
let mean = arrayOfNumbers.reduce(0, combine: + )            //Sum all elements in the array
let fMean = Double(mean) / Double(arrayOfNumbers.count)     //Divide to obtain arithmetic mean

//: Function to return **true** if `a` is closer to the mean than `b`
func nearestToMean(a : Int, b : Int) -> Bool {
    let da = fabs(Double(a)-fMean)
    let db = fabs(Double(b)-fMean)
    return da < db
}

//: For example, 9 is closer to the mean than 20
nearestToMean(9, 20)

//: Now sort using this critera. There are two methods: sort (in place) and sorted (returns a sorted array)
let sortedArray = arrayOfNumbers.sorted(nearestToMean)

//Display in assistant-editor timeline
for n in sortedArray {
    XCPCaptureValue("Plot", n)
}

//: ### Example - `map`
//: The standard library higher-order function `map` applies a function to all elements of a collection. In this simple example, I determine if an element is *even* (true) or *odd* (false)

func isEven(val : Int) -> Bool {
    return (val % 2) == 0
}

let evens = arrayOfNumbers.map(isEven)

//: ### Example - `filter`
//: The standard library higher-order function `filter` applies a function to all elements of a collection to test if that element should be retained in the result. In this simple example, I determine if an element is positive or zero.

func isNatural(val : Int) -> Bool {
    return val >= 0
}

let positives = arrayOfNumbers.filter(isNatural)

//: Note the value `-5` is absent from the final result.

//: ### Example - `reduce`
//: The standard library higher-order function `reduce` recursively applies a function to itself and each element of a collection. For example, assume the result of reduce to be `a`. Then for each element x of the array, a <- f(a,x).
//:
//: A common example is to sum all elements of the array.
//:
//: Paramember `a` is the **cumulative result**
//: Paramember `b` is the next value from the array
//: In effect, this will result in _a = a + b_
//:
func f1(a : Int, b : Int) -> Int {
    return a+b
}

let sumOfAllElements = arrayOfNumbers.reduce(0, combine: f1)
//: Initial value s = 0
//:
//: The for each element x[n] of the array, where n is the index, then s = f1(s,x[n]) = s + x[n]


//: ## Nested Functions
//: To start with, these are very useful for reducing or avoiding local code repetition. They can also help make code more expressive and easy to follow. In this example, a use a technique common in functional programming, and that is to make the function recursive. I also use the function parameters to keep track of state (note there are no variables in this function, only constants).


func oddParity(val : UInt, isOddParity : Bool = false) -> Bool {
    
    func xor(a : Bool, b : Bool) -> Bool {
        return (a && !b) || (!a && b)
    }
    
    func lsbIsOne(u : UInt) -> Bool {
        return ( (u & 1) != 0 )
    }
    
    if val == 0 {
        return isOddParity
    } else {
        let bottomBitSet = lsbIsOne(val)
        let shifted = val >> 1
        return oddParity(shifted, isOddParity: xor(isOddParity, bottomBitSet))
    }
}

oddParity(3)
oddParity(7)

//: **I am making no claims about the performance of recursive functions in Swift here**
//: Some will be aware that there are languages that optimise this style of writing (look up tail call optimisation), while other languages will suffer a performance hit due to excessive stack pushes.

//: ## Nested function v2
//:
//: This example 'captures' parameters `val` and `isOddParity` because they exist within the enclosing scope.
//: Therefore the nested function does not need any parameters in this case.
//: I like using functions in this way as it is almost self documenting

func oddParityV2(val : UInt, isOddParity : Bool = false) -> Bool {

    if val == 0 {
        return isOddParity
    } else {
        
        func updatedParity() -> Bool { //Does what it says
            let bit0 = (val & 1) != 0
            return (isOddParity && !bit0) || (!isOddParity && bit0)
        }
        //This recursive call is fairly self explanatory
        return oddParityV2( val >> 1, isOddParity: updatedParity() )
    }
}

oddParityV2(3)
oddParityV2(7)


//: ## Capturing Behaviour

//: It is important to understand 'capturing' with closures (and hence functions). In the example the nested function "captures" the Double variable `acc`. When this function (ok closure) is returned, **encapsulated within is it a copy of this variable* (had `acc` been modified outside the nested function, then it would be a strong reference, although the difference in this case often undetectable).
//: An interesting point here is that you would normally have expected `acc` to be stack based. However, this would cause it to go out of scope as soon as the function `generateAccumulator` exited. 
//: * As far as the developer is concerned, he captured + copied variable `acc` will end up on the heap
//: * You can assume the captured `acc` persists as long as the (returned) nested function persists.
//: * You can leave Swift and ARC to sort out the memory management.

//: ### Capturing arguments and local variables

typealias DoubleTransformFunction = Double -> Double
func generateAccumulator(#initialValue : Double) -> DoubleTransformFunction {
    var acc = initialValue
    
    //Nested function
    func f(value : Double) -> Double {
        //Makes reference to acc, so this is *captured* (and copied) as part of the closure
        //It will persist as long as this nested function perists
        acc += value
        return acc
    }
    //: Return the *function* (ok, named closure)
    return f
}

//: Test - accFunc is a function type, which encasulates the captured variable `acc`
let accFunc = generateAccumulator(initialValue: 5.0)
accFunc(2.0)
accFunc(5.0)
let y = accFunc(8.0)
//: As you can infer by observation, the captured `acc` persists because accFunc persists


//: ## Currying
//:
//: Any function with N paramaters can be broken down into N functions with 1 parameter. 
//: This follows a process of "capture and return".

typealias IntTx = Int -> Int    //Function that takes and Int parameter, and returns an Int

//: Outer function provides the first argument - this is captured by the next level of nesting
func addInt( num1 : Int) ->  IntTx {
    
//: Inner function *captures* the first parameter, and accepts a second
    func addNext( num2 : Int ) -> Int {
        //Capture outer argument num1
        return num1 + num2
    }
    
    return addNext
    
}

//: Invoke with first parameter, then pass second parameter to the returned function
addInt(10)(20)

//: Why do we want to Curry? (I know why I want to eat a curry)
//: Here is an example:
let tx = addInt(100)    //`tx` is a Function that captures 100, and accepts a single parameter. For example:
tx(10)
//: Now consider the higher-order function `map`. 
//: Applied to an array of integers, it accepts a function of type `Int->U`.
//: i.e. a function with **one** Int argument.
let arrayOfInt = [1, 5, 10]
arrayOfInt.map(tx)

//: Looking at the result, each element has 100 added to it.

//: ### Example v1 - Convert a 3 input function to 3x1 Input
func F(m:Double, x:Double, c:Double) -> Double {
    return m*x+c
}

//: It helps to create typealias of the function types
typealias T1 = Double -> Double //Function, Double in, Double Out
typealias T2 = Double -> T1     //Function, Double in, Function Out

//: Curried form of F
func f1(m : Double) -> T2 {
    func f2(x : Double) -> T1 {
        let prod = m*x
        func f3(c : Double) -> Double {
            return prod+c
        }
        return f3
    }
    return f2
}

//Partial evaluation
let F = f1(2.0)(4.0)
//Now we apply the final argument to calculate the final result
F(2)
F(3)

//: ### Example v2 - Convert a 3 input function to 3x1 Input
func ff(m : Double)(x : Double)(c : Double) -> Double {
    return m*x + c
}

let FF = ff(2.0)(x: 4.0)
FF(c: 2.0)

//: ### Example v3 - Convert a 3 input function to 3x1 Input
func fff(m : Double)(x : Double) -> (Double -> Double) {
    let prod = m*x
    func fff2(c : Double) -> Double {
        return prod + c
    }
    return fff2
}

let FFF = fff(2.0)(x: 4.0)
FFF(2.0)



//: ## Custom Operators

//: ### Prefix operators
prefix operator ∑ { }
prefix func ∑ (u : [Double]) -> Double {
    return u.reduce(0.0, combine: +) //Sum all elements
}

let vec = [1.0, 3.0, 6.0]
let sum = ∑vec

prefix operator - {}
prefix func -(u:[Double]) -> [Double] {
    var v = u.map({-$0})
    return v
}

let negVec = -[1.0, -3.0]

//: ### Postfix operator
postfix operator % {}
postfix func %(val : Double) -> Double {
    return val/100.0
}

79%

//: ### Infix and Associativity

//: Infix functions take two arguments, one either side of the operator.
//: First, let's look at a left-associative function

infix operator -- { associativity left precedence 140 } //Same as +
func --(left : Double, right : Double) -> Double {
    return (left - right)
}

3 -- 2 -- 1

//: Now, let's compare with a right-associative function
infix operator --- { associativity right precedence 140 } //Same as +
func ---(left : Double, right : Double) -> Double {
    return (left - right)
}

//: Note the associativity impacts on the result
3 --- 2 --- 1

//: Same as `3 -- (2 -- 1)`

//: Another example - power
infix operator ** { associativity left precedence 160 } // Same as << and >>, greater than multiply
func ** (a : Double, b: Double) -> Double {
    return pow(a, b)
}

4.0 ** 3.0 ** 2.0

//: Custom operators are often considered ambiguous, so use sparingly.


//: ## Generic Functions

//: Consider the following function
func swapInt( tupleValue : (Int, Int) ) -> (Int, Int) {
    let y = (tupleValue.1, tupleValue.0)
    return y
}

let u2 = (2,3)
let v2 = swapInt( u2 )

//: This function only works with type Int. It cannot be used for other types. This is where Generics come in. The compiler will generate alternative versions using the required types (where appropriate).

//: ### Generic Functions without constraints
func swap<U,V>( tupleValue : (U, V) ) -> (V, U) {
    let y = (tupleValue.1, tupleValue.0)
    return y
}

swap( (1, "Fred") )


//: ### Generic Functions with constraints
func compareAnything<U:Equatable>(a : U, b : U) -> Bool {
    return a == b
}

compareAnything(10, 10)

//: ### Generic Functions with custom constraints
protocol CanMultiply {
    func *(left: Self, right: Self) -> Self
}
extension Double : CanMultiply {}
extension Int : CanMultiply {}
extension Float : CanMultiply {}

func cuboidVolume<T:CanMultiply>(width:T, height:T, depth:T) -> T {
    return (width*height*depth)
}

cuboidVolume(2.1, 3, 4)

