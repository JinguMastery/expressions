import LogicKit

// Numbers:

let d0 = Value (0)
let d1 = Value (1)
let d2 = Value (2)
let d3 = Value (3)
let d4 = Value (4)
let d5 = Value (5)
let d6 = Value (6)
let d7 = Value (7)
let d8 = Value (8)
let d9 = Value (9)

func toNumber (_ n : Int) -> Term {
    var result = List.empty
    for char in String (n).characters.reversed () {
        switch char {
        case "0":
            result = List.cons (d0, result)
        case "1":
            result = List.cons (d1, result)
        case "2":
            result = List.cons (d2, result)
        case "3":
            result = List.cons (d3, result)
        case "4":
            result = List.cons (d4, result)
        case "5":
            result = List.cons (d5, result)
        case "6":
            result = List.cons (d6, result)
        case "7":
            result = List.cons (d7, result)
        case "8":
            result = List.cons (d8, result)
        case "9":
            result = List.cons (d9, result)
        default:
            assert (false)
        }
    }
    return result
}

// Arithmetic:

/*
Syntaxe abstraite
n, p Nat
____________
n + p in Nat

Sémantique
l -N -> lv, r -N -> rv
______________________
l + r -N -> lv +Nat rv
*/
func add (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op": Value("+"), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
n, p Nat
____________
n - p in Nat

Sémantique
l -N -> lv, r -N -> rv, lv >= rv
________________________________
l - r -N -> lv -Nat rv
*/
func subtract (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op": Value("-"), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
n, p Nat
____________
n * p in Nat

Sémantique
l -N -> lv, r -N -> rv
______________________
l * r -N -> lv *Nat rv
*/
func multiply (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op": Value("*"), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
n, p Nat
____________
n - p in Nat

Sémantique
l -N -> lv, r -N -> rv, k -N -> kv, lv = kv * rv
________________________________________________
l / r -N -> lv /Nat rv
*/
func divide (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op": Value("/"), "lhs": lhs, "rhs": rhs]
}

// Booleans:

let t = Value (true)
let f = Value (false)

/*
Syntaxe abstraite
x in B
___________
not(x) in B

Sémantique
b -> f
___________greaterEqual
not(b) -> t

b -> t
___________
not(b) -> f
*/
func not (_ term: Term) -> Map {
    return ["op": Value ("not"), "what": term]
}

/*
Syntaxe abstraite
x, y in B
____________
x and y in B

Sémantique
l -> t, r -> t
______________
l and r -> t

l -> f, r -> f
______________
l and r -> f

l -> f, r -> t
______________
l and r -> f

l -> t, r -> f
______________
l and r -> f
*/
func and (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value ("and"), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
x, y in B
____________
x or y in B

Sémantique
l -> t, r -> t
______________
l or r -> t

l -> f, r -> f
______________
l or r -> f

l -> f, r -> t
______________
l or r -> t

l -> t, r -> f
______________
l or r -> t
*/
func or (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value ("or"), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
x, y in B
____________
x implies y in B

Sémantique
l -> t, r -> t
______________
l implies r -> t

l -> f, r -> f
______________
l implies r -> t

l -> f, r -> t
______________
l implies r -> t

l -> t, r -> f
______________
l implies r -> f
*/
func implies (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value ("implies"), "lhs": lhs, "rhs": rhs]
}

// Comparaisons:

/*
Syntaxe abstraite
n, p Nat
____________
n < p in B

Sémantique
l -N -> lv, r -N -> rv
______________________
l < r -B -> lv <Nat rv
*/
func lessThan (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value ("<"), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
n, p Nat
____________
n <= p in B

Sémantique
l -N -> lv, r -N -> rv
______________________
l <= r -B -> lv <=Nat rv
*/
func lessEqual (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value ("<="), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
n, p Nat
____________
n > p in B

Sémantique
l -N -> lv, r -N -> rv
______________________
l > r -B -> lv >Nat rv
*/
func greaterThan (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value (">"), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
n, p Nat
____________
n >= p in B

Sémantique
l -N -> lv, r -N -> rv
______________________
l >= r -B -> lv >=Nat rv
*/
func greaterEqual (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value (">="), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
n, p Nat
____________
n = p in B

Sémantique
l -N -> lv, r -N -> rv
______________________
l = r -B -> lv =Nat rv
*/
func equal (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value ("="), "lhs": lhs, "rhs": rhs]
}

/*
Syntaxe abstraite
n, p Nat
____________
n != p in B

Sémantique
l -N -> lv, r -N -> rv
______________________
l != r -B -> lv !=Nat rv
*/
func notequal (_ lhs: Term, _ rhs: Term) -> Map {
    return ["op" : Value ("!="), "lhs": lhs, "rhs": rhs]
}

// Evaluation:

func addDigit(_ lhs: Term, _ rhs: Term, _ result: Term, _ rest: Term)-> Goal {     //enables to add digits
    return  (lhs === d0 && result === rhs && rest === d0) ||    // case lhs = 0
            (rhs === d0 && result === lhs && rest === d0) ||

            // case 'lhs = 1'
            ((lhs === d1) && (rhs === d1) && (result === d2) && (rest === d0)) ||
            ((lhs === d1) && (rhs === d2) && (result === d3) && (rest === d0)) ||
            ((lhs === d1) && (rhs === d3) && (result === d4) && (rest === d0)) ||
            ((lhs === d1) && (rhs === d4) && (result === d5) && (rest === d0)) ||
            ((lhs === d1) && (rhs === d5) && (result === d6) && (rest === d0)) ||
            ((lhs === d1) && (rhs === d6) && (result === d7) && (rest === d0)) ||
            ((lhs === d1) && (rhs === d7) && (result === d8) && (rest === d0)) ||
            ((lhs === d1) && (rhs === d8) && (result === d9) && (rest === d0)) ||
            ((lhs === d1) && (rhs === d9) && (result === d0) && (rest === d1)) ||

            // case 'lhs = 2'
            ((lhs === d2) && (rhs === d1) && (result === d3) && (rest === d0)) ||
            ((lhs === d2) && (rhs === d2) && (result === d4) && (rest === d0)) ||
            ((lhs === d2) && (rhs === d3) && (result === d5) && (rest === d0)) ||
            ((lhs === d2) && (rhs === d4) && (result === d6) && (rest === d0)) ||
            ((lhs === d2) && (rhs === d5) && (result === d7) && (rest === d0)) ||
            ((lhs === d2) && (rhs === d6) && (result === d8) && (rest === d0)) ||
            ((lhs === d2) && (rhs === d7) && (result === d9) && (rest === d0)) ||
            ((lhs === d2) && (rhs === d8) && (result === d0) && (rest === d1)) ||
            ((lhs === d2) && (rhs === d9) && (result === d1) && (rest === d1)) ||

            // case 'lhs = 3'
            ((lhs === d3) && (rhs === d1) && (result === d4) && (rest === d0)) ||
            ((lhs === d3) && (rhs === d2) && (result === d5) && (rest === d0)) ||
            ((lhs === d3) && (rhs === d3) && (result === d6) && (rest === d0)) ||
            ((lhs === d3) && (rhs === d4) && (result === d7) && (rest === d0)) ||
            ((lhs === d3) && (rhs === d5) && (result === d8) && (rest === d0)) ||
            ((lhs === d3) && (rhs === d6) && (result === d9) && (rest === d0)) ||
            ((lhs === d3) && (rhs === d7) && (result === d0) && (rest === d1)) ||
            ((lhs === d3) && (rhs === d8) && (result === d1) && (rest === d1)) ||
            ((lhs === d3) && (rhs === d9) && (result === d2) && (rest === d1)) ||

            // case 'lhs = 4'
            ((lhs === d4) && (rhs === d1) && (result === d5) && (rest === d0)) ||
            ((lhs === d4) && (rhs === d2) && (result === d6) && (rest === d0)) ||
            ((lhs === d4) && (rhs === d3) && (result === d7) && (rest === d0)) ||
            ((lhs === d4) && (rhs === d4) && (result === d8) && (rest === d0)) ||
            ((lhs === d4) && (rhs === d5) && (result === d9) && (rest === d0)) ||
            ((lhs === d4) && (rhs === d6) && (result === d0) && (rest === d1)) ||
            ((lhs === d4) && (rhs === d7) && (result === d1) && (rest === d1)) ||
            ((lhs === d4) && (rhs === d8) && (result === d2) && (rest === d1)) ||
            ((lhs === d4) && (rhs === d9) && (result === d3) && (rest === d1)) ||

            // case 'lhs = 5'
            ((lhs === d5) && (rhs === d0) && (result === d5) && (rest === d0)) ||
            ((lhs === d5) && (rhs === d1) && (result === d6) && (rest === d0)) ||
            ((lhs === d5) && (rhs === d2) && (result === d7) && (rest === d0)) ||
            ((lhs === d5) && (rhs === d3) && (result === d8) && (rest === d0)) ||
            ((lhs === d5) && (rhs === d4) && (result === d9) && (rest === d0)) ||
            ((lhs === d5) && (rhs === d5) && (result === d0) && (rest === d1)) ||
            ((lhs === d5) && (rhs === d6) && (result === d1) && (rest === d1)) ||
            ((lhs === d5) && (rhs === d7) && (result === d2) && (rest === d1)) ||
            ((lhs === d5) && (rhs === d8) && (result === d3) && (rest === d1)) ||
            ((lhs === d5) && (rhs === d9) && (result === d4) && (rest === d1)) ||

            // case 'lhs = 6'
            ((lhs === d6) && (rhs === d0) && (result === d6) && (rest === d0)) ||
            ((lhs === d6) && (rhs === d1) && (result === d7) && (rest === d0)) ||
            ((lhs === d6) && (rhs === d2) && (result === d8) && (rest === d0)) ||
            ((lhs === d6) && (rhs === d3) && (result === d9) && (rest === d0)) ||
            ((lhs === d6) && (rhs === d4) && (result === d0) && (rest === d1)) ||
            ((lhs === d6) && (rhs === d5) && (result === d1) && (rest === d1)) ||
            ((lhs === d6) && (rhs === d6) && (result === d2) && (rest === d1)) ||
            ((lhs === d6) && (rhs === d7) && (result === d3) && (rest === d1)) ||
            ((lhs === d6) && (rhs === d8) && (result === d4) && (rest === d1)) ||
            ((lhs === d6) && (rhs === d9) && (result === d5) && (rest === d1)) ||

            // case 'lhs = 7'
            ((lhs === d7) && (rhs === d0) && (result === d7) && (rest === d0)) ||
            ((lhs === d7) && (rhs === d1) && (result === d8) && (rest === d0)) ||
            ((lhs === d7) && (rhs === d2) && (result === d9) && (rest === d0)) ||
            ((lhs === d7) && (rhs === d3) && (result === d0) && (rest === d1)) ||
            ((lhs === d7) && (rhs === d4) && (result === d1) && (rest === d1)) ||
            ((lhs === d7) && (rhs === d5) && (result === d2) && (rest === d1)) ||
            ((lhs === d7) && (rhs === d6) && (result === d3) && (rest === d1)) ||
            ((lhs === d7) && (rhs === d7) && (result === d4) && (rest === d1)) ||
            ((lhs === d7) && (rhs === d8) && (result === d5) && (rest === d1)) ||
            ((lhs === d7) && (rhs === d9) && (result === d6) && (rest === d1)) ||

            // case 'lhs = 8'
            ((lhs === d8) && (rhs === d0) && (result === d8) && (rest === d0)) ||
            ((lhs === d8) && (rhs === d1) && (result === d9) && (rest === d0)) ||
            ((lhs === d8) && (rhs === d2) && (result === d0) && (rest === d1)) ||
            ((lhs === d8) && (rhs === d3) && (result === d1) && (rest === d1)) ||
            ((lhs === d8) && (rhs === d4) && (result === d2) && (rest === d1)) ||
            ((lhs === d8) && (rhs === d5) && (result === d3) && (rest === d1)) ||
            ((lhs === d8) && (rhs === d6) && (result === d4) && (rest === d1)) ||
            ((lhs === d8) && (rhs === d7) && (result === d5) && (rest === d1)) ||
            ((lhs === d8) && (rhs === d8) && (result === d6) && (rest === d1)) ||
            ((lhs === d8) && (rhs === d9) && (result === d7) && (rest === d1)) ||

            // case 'lhs = 9'
            ((lhs === d9) && (rhs === d0) && (result === d9) && (rest === d0)) ||
            ((lhs === d9) && (rhs === d1) && (result === d0) && (rest === d1)) ||
            ((lhs === d9) && (rhs === d2) && (result === d1) && (rest === d1)) ||
            ((lhs === d9) && (rhs === d3) && (result === d2) && (rest === d1)) ||
            ((lhs === d9) && (rhs === d4) && (result === d3) && (rest === d1)) ||
            ((lhs === d9) && (rhs === d5) && (result === d4) && (rest === d1)) ||
            ((lhs === d9) && (rhs === d6) && (result === d5) && (rest === d1)) ||
            ((lhs === d9) && (rhs === d7) && (result === d6) && (rest === d1)) ||
            ((lhs === d9) && (rhs === d8) && (result === d7) && (rest === d1)) ||
            ((lhs === d9) && (rhs === d9) && (result === d8) && (rest === d1))

}

func reverse(_ list: Term, _ reversed: Term) -> Goal {    //enables to reverse a list
    return reverseAcc(list, List.empty, reversed)
}

func reverseAcc(_ list: Term, _ acc: Term, _ reversed: Term) -> Goal {    //this is the recursive part of the previous function
    return (list === List.empty && reversed === acc) ||
        freshn {t in
            let head = t ["head"]
            let tail = t ["tail"]
            return list === List.cons(head, tail) && delayed(reverseAcc(tail, List.cons(head, acc), reversed))
    }
}

func notZero(_ term : Term) -> Goal {     //checks if the digit 'term' is non null
    var goal : Goal = (term === Value(1))
    for i in 2...9 {
        goal = goal || (term === Value(i))
    }
    return goal
}

func evalPlus (_ lhs: Term, _ rhs: Term, _ result : Term) -> Goal {    //determines if the number 'result' is equal to the sum of the 2 numbers 'lhs' and 'rhs'
    return  freshn{ t in
            let lhs_reversed = t ["lhs_reversed"]
            let rhs_reversed = t ["rhs_reversed"]
            let result_reversed = t ["result_reversed"]
            return  reverse(lhs, lhs_reversed) && reverse(rhs, rhs_reversed) &&
                    evalPlusRec(lhs_reversed, rhs_reversed, result_reversed) &&
                    reverse(result_reversed, result)
      }
}

func evalPlusRec (_ lhs: Term, _ rhs: Term, _ result: Term) -> Goal {    //this is the recursive part of the previous function
    return  lhs === List.empty && rhs === result ||
            rhs === List.empty && lhs === result ||
            delayed(freshn {t in
            let lhead = t ["lhead"]
            let ltail = t ["ltail"]
            let rhead = t ["rhead"]
            let rtail = t ["rtail"]
            let resthead = t ["resthead"]
            let resttail = t ["resttail"]
            let inbetween = t ["inbetween"]
            return lhs === List.cons(lhead, ltail) &&
                   rhs === List.cons(rhead, rtail) &&
                   result === List.cons(resttail, resthead) &&
                   addDigit(lhead, rhead, resttail, d0) && evalPlusRec(ltail, rtail, resthead) ||
                   addDigit(lhead, rhead, resttail, d1) && evalPlusRec(ltail, rtail, inbetween) && evalPlusRec(inbetween, toNumber(1), resthead) })
}

func evalMinus(_ lhs : Term, _ rhs : Term,_ result : Term) -> Goal {    //determines if the number 'result' is equal to the difference of the 2 numbers 'lhs' and 'rhs'
    return  delayed(freshn { t in
            let head = t ["head"]
            let tail = t ["tail"]
            let lhs_reversed = t ["lhs_reversed"]
            let rhs_reversed = t ["rhs_reversed"]
            let result_reversed = t ["result_reversed"]
            return  reverse(lhs, lhs_reversed ) &&
                    reverse(rhs, rhs_reversed ) &&
                    evalPlusRec(result_reversed, rhs_reversed, lhs_reversed) &&
                    reverse(result_reversed, result) &&
                    result === List.cons(head, tail) && notZero(head) })
}

func evalMult(_ lhs : Term, _ rhs: Term, _ result: Term) -> Goal {    //determines if the number 'result' is equal to the product of the 2 numbers 'lhs' and 'rhs'
    return (rhs === toNumber(1) && lhs === result) || //case of multiplication by 1
           delayed(freshn { t in
           let a = t ["a"]
           let b = t ["b"]
           return evalMinus(rhs, toNumber(1), a) &&
                  evalMult(lhs, a, b) &&
                  evalPlus(b, lhs, result) })
}

func evalDiv(_ lhs: Term, _ rhs: Term, _ result : Term) -> Goal {    //determines if the number 'result' is equal to the quotient of the 2 numbers 'lhs' and 'rhs'
    return evalMult(rhs, result, lhs)
}

func eq(_ lhs : Term, _ rhs : Term ) -> Goal {     //determines if the 2 digits 'lhs' and 'rhs' are equal
    var goal : Goal = (t === f)
    for i in 0...9 {
        for j in 0...9 {
            if i == j {
                goal = goal || (lhs === Value(i) && rhs === Value(j))
            }
        }
    }
    return goal
}

func evalEqual (_ lhs: Term, _ rhs : Term) -> Goal {     //determines if the 2 numbers 'lhs' and 'rhs' are equal
    return  (lhs === List.empty && rhs === List.empty) ||
            freshn {t in
            let lhead = t ["lhead"]
            let ltail = t ["ltail"]
            let rhead = t ["rhead"]
            let rtail = t ["rtail"]
            return lhs === List.cons(lhead, ltail) && rhs === List.cons(rhead, rtail) && eq(lhead, rhead) && evalEqual(ltail, rtail)
            }
}

func neq(_ lhs : Term, _ rhs : Term ) -> Goal{    //determines if the 2 digits 'lhs' and 'rhs' are not equal
    var goal : Goal = ( t === f)
    for i in 0...9 {
        for j in 0...9 {
            if i != j {
                goal = goal || (lhs === Value(i) && rhs === Value(j))
            }
        }
    }
    return goal
}

func evalNotEqual (_ lhs: Term, _ rhs: Term) -> Goal {     //determines if the 2 numbers 'lhs' and 'rhs' are not equal
    return  freshn {t in
            let lhead = t ["lhead"]
            let ltail = t ["ltail"]
            let rhead = t ["rhead"]
            let rtail = t ["rtail"]
            return (rhs === List.empty && lhs === List.cons(lhead, ltail)) ||
                   (lhs === List.empty && rhs === List.cons(lhead, ltail)) ||
                   (lhs === List.cons(lhead, ltail) && rhs === List.cons(rhead, rtail) && (neq(lhead, rtail) || evalNotEqual(ltail, rtail)))
            }
}

func gt(_ lhs : Term, _ rhs : Term ) -> Goal{    //determines if the digit 'lhs' is strictly greater than the digit 'rhs'
    var goal : Goal = ( t === f)
    for i in 0...9 {
        for j in 0...9 {
            if i > j {
                goal = goal || (lhs === Value(i) && rhs === Value(j))
            }
        }
    }
    return goal
}

func evalGreaterThan (_ lhs: Term, _ rhs: Term) -> Goal {     //determines if the number 'lhs' is strictly greater than the number 'rhs'
    return  freshn {t in
            let lhead = t ["lhead"]
            let ltail = t ["ltail"]
            let rhead = t ["rhead"]
            let rtail = t ["rtail"]
            return  (rhs === List.empty && lhs === List.cons(lhead, ltail)) || gt(lhs, rhs) ||
                    ((lhs === List.cons(lhead, ltail) && rhs === List.cons(rhead, rtail)) &&
                    ((gt(lhead, rhead) && (evalEqual(ltail, rtail) || evalGreaterThan(ltail, rtail))) ||
                    (le(lhead, rhead) && evalGreaterThan(ltail, rtail))))
            }
}

func lt(_ lhs : Term, _ rhs : Term ) -> Goal{    //determines if the digit 'lhs' is strictly lesser than the digit 'rhs'
    var goal : Goal = ( t === f)
    for i in 0...9 {
        for j in 0...9 {
            if i < j {
                goal = goal || (lhs === Value(i) && rhs === Value(j))
            }
        }
    }
    return goal
}

func evalLessThan (_ lhs: Term, _ rhs: Term) -> Goal {    //determines if the number 'lhs' is strictly lesser than the number 'rhs'
    return  freshn {t in
            let lhead = t ["lhead"]
            let ltail = t ["ltail"]
            let rhead = t ["rhead"]
            let rtail = t ["rtail"]
            return (lhs === List.empty && rhs === List.cons(lhead, ltail)) || //one is empty the other isnt basic case
                    lt(lhs, rhs) ||
                    ((lhs === List.cons(lhead, ltail) && rhs === List.cons(rhead, rtail)) && //more than one value we have to recursively check each element
                    ((lt(lhead, rhead) && (evalEqual(ltail, rtail) || evalLessThan(ltail, rtail))) ||
                    (ge(lhead, rhead) && evalLessThan(ltail, rtail))))
            }
}

func ge(_ lhs : Term , _ rhs : Term ) -> Goal{     //determines if the digit 'lhs' is greater than or equal to the digit 'rhs'
    var goal : Goal = ( t === f)
    for i in 0...9 {
        for j in 0...9 {
            if i >= j {
                goal = goal || (lhs === Value(i) && rhs === Value(j))
            }
        }
    }
    return goal
}

func evalGreaterEqual (_ lhs: Term, _ rhs: Term) -> Goal {    //determines if the number 'lhs' is greater than or equal to the number 'rhs'
    return evalGreaterThan(lhs, rhs) || evalEqual(lhs, rhs)
}

func le(_ lhs : Term, _ rhs : Term ) -> Goal{     //determines if the digit 'lhs' is lesser than or equal to the digit 'rhs'
    var goal : Goal = ( t === f)
    for i in 0...9 {
        for j in 0...9 {
            if i <= j {
                goal = goal || (lhs === Value(i) && rhs === Value(j))
            }
        }
    }
    return goal
}

func evalLessEqual (_ lhs: Term, _ rhs: Term) -> Goal {     //determines if the number 'lhs' is lesser than or equal to the number 'rhs'
    return evalLessThan(lhs, rhs) || evalEqual(lhs, rhs)
}

func evalBoolean (_ input: Term, _ output: Term) -> Goal {    //determines if the boolean corresponding of the result of the boolean expression
                                                              //given by the term 'input' is equal to the boolean 'output'
    return  (input === t && output === t) || (input === f && output === f) ||
            freshn {g in
            let l  = g ["l"]
            let r  = g ["r"]
            let lv = g ["lv"]
            let rv = g ["rv"]
            return input === and (l, r) && evalBoolean (l, lv) && evalBoolean (r, rv) &&   //case 'and'
                ((lv === t && output === rv) || (lv === f && output === f)) } ||
            freshn {g in
            let l  = g ["l"]
            let r  = g ["r"]
            let lv = g ["lv"]
            let rv = g ["rv"]
            return input === or (l, r) && evalBoolean (l, lv) && evalBoolean (r, rv) &&    //case 'or'
                ((lv === f && output === rv) || (lv === t && output === t)) } ||
            freshn {g in
            let l  = g ["l"]
            let r  = g ["r"]
            let lv = g ["lv"]
            let rv = g ["rv"]
            return input === implies (l, r) && evalBoolean (l, lv) && evalBoolean (r, rv) &&   //case 'implies'
                ((lv === t && output === rv) || (lv === f && output === t)) } ||
            freshn {g in
            let r  = g ["r"]
            let rv = g ["rv"]
            return input === not(r) && evalBoolean(r, rv) &&   //case 'not'
                ((rv === f && output === t) || (rv === t && output === f))
            }
}

func evalComparaison (_ input: Term, _ output: Term) -> Goal {    //determines if the boolean corresponding of the result of the inequality
                                                                  //given by the term 'input' is equal to the boolean 'output'
    return freshn{ t in
           let lhs = t["lhs"]
           let rhs = t["rhs"]
           let lhs_reversed = t["lhs_reversed"]
           let rhs_reversed = t["rhs_reversed"]
           return  (input === equal(lhs, rhs) && (reverse(lhs, lhs_reversed) && reverse(rhs, rhs_reversed)) &&    //case 'equal'
                   ((evalEqual(lhs_reversed, rhs_reversed) && output === Value(true)) || (evalNotEqual(lhs_reversed, rhs_reversed) && output === Value(false)))) ||

                   (input === notequal(lhs, rhs) && (reverse(lhs, lhs_reversed) && reverse(rhs, rhs_reversed)) &&     //case 'notequal'
                   ((evalNotEqual(lhs_reversed, rhs_reversed) && output === Value(true)) || (evalEqual(lhs_reversed, rhs_reversed) && output === Value(false)))) ||

                   (input === lessThan(lhs, rhs) && (reverse(lhs, lhs_reversed) && reverse(rhs, rhs_reversed)) && ((evalLessThan(lhs_reversed, rhs_reversed) &&     //case 'lessThan'
                   output === Value(true)) || (evalGreaterEqual(lhs_reversed , rhs_reversed) && output === Value(false)))) ||

                   (input === lessEqual(lhs, rhs) && (reverse(lhs, lhs_reversed) && reverse(rhs, rhs_reversed)) && ((evalLessEqual(lhs_reversed, rhs_reversed) &&    //case 'lessEqual'
                   output === Value(true)) || (evalGreaterThan(lhs_reversed, rhs_reversed) && output === Value(false)))) ||

                   (input === greaterThan(lhs, rhs) && (reverse(lhs, lhs_reversed) && reverse(rhs, rhs_reversed)) &&    //case 'greaterThan'
                   ((evalGreaterThan(lhs_reversed, rhs_reversed) && output === Value(true)) || (evalLessEqual(lhs_reversed, rhs_reversed) && output === Value(false)))) ||

                   (input === greaterEqual(lhs, rhs) && (reverse(lhs, lhs_reversed) && reverse(rhs, rhs_reversed)) &&     //case 'greaterEqual'
                   ((evalGreaterEqual(lhs_reversed, rhs_reversed) && output === Value(true)) || (evalLessThan(lhs_reversed, rhs_reversed) && output === Value(false))))
          }
}

// Main evaluation:

func eval (_ input: Term, _ output: Term) -> Goal {     //determines if the boolean corresponding of the result of the general operation (or expression)
                                                        //given by the term 'input' is equal to the boolean 'output'
    return  evalBoolean(input, output) || evalComparaison(input, output) ||
            delayed(freshn {t in
            let eval1 = t ["eval1"]
            let eval2 = t ["eval2"]
            let res1 = t ["res1"]
            let res2 = t ["res2"]
            return
            (input === implies(eval1, eval2) && eval(eval1, res1) &&     //case 'implies'
            eval(eval2, res2) && evalBoolean(implies(res1, res2), output)) ||

            (input === and(eval1, eval2) && eval(eval1, res1) &&    //case 'and'
            eval(eval2, res2) && evalBoolean(and(res1, res2), output)) ||

            (input === or(eval1, eval2) && eval(eval1, res1) &&    //case 'or'
            eval(eval2, res2) && evalBoolean(or(res1, res2), output)) ||

            (input === not(eval1) && eval(eval1, res1) &&     //case 'not'
            evalBoolean(not(res1), output)) })
}
