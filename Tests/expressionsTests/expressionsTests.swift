import XCTest
import LogicKit
@testable import expressions

class expressionsTests: XCTestCase {

    func testToNumber() {
        let expected : Term = List.cons (Value (5), List.cons (Value (1), List.empty))
        XCTAssert (toNumber (51).equals (expected), "toNumber is incorrect")
    }

    static var allTests : [(String, (expressionsTests) -> () throws -> Void)] {
        return [
            ("testToNumber", testToNumber),
            ("testNot", testNot),
            ("testImplies", testImplies),
            ("testAnd", testAnd),
            ("testOr", testOr),
            ("testPlus", testPlus),
            ("testMinus", testMinus),
            ("testMult", testMult),
            ("testDiv", testDiv),
            ("testEqual", testEqual),
            ("testNotEqual", testNotEqual),
            ("testLessEqual", testLessEqual),
            ("testGreaterThan", testGreaterThan),
            ("testGreaterEqual", testGreaterEqual),
            ("testLessThan", testLessThan),
            ("testEval", testEval)
        ]
    }


    //the arithmetic operations test functions below

    func testPlus() {
        let v = Variable(named: "v")
        let n =  48
        let p =  895
        let goal = evalPlus(toNumber(n), toNumber(p), v)
        let expected = toNumber(n+p)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(expected), "can't perform addition")
            break
        }
    }

    func testMinus(){
        let v = Variable(named: "v")
        let n = 651   //n must be greater than p here because we have not defined negative numbers
        let p = 86
        let goal = evalMinus(toNumber(n), toNumber(p), v)
        let expected = toNumber(n-p)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(expected), "can't perform subtraction")
            break
        }
    }

    func testMult() {
        let v = Variable(named: "v")
        let n =  54
        let p =  18
        let goal = evalMult(toNumber(n), toNumber(p), v)
        let expected = toNumber(n*p)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(expected), "can't perform multiplication")
            break
        }
    }

    func testDiv() {
        let v = Variable(named: "v")
        let n = 77
        let p = 11
        let goal = evalDiv(toNumber(n), toNumber(p) , v)
        let expected = toNumber(n/p)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(expected), "can't perform division")
            break
        }
    }


    // the comparaison test functions below

    func testEqual() {
        let v = Variable(named: "v")
        let goal = evalComparaison(equal (toNumber(5), toNumber(5)), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "the 2 numbers are equal")
        }
    }

    func testNotEqual() {
        let v = Variable(named: "v")
        let goal = evalComparaison(notequal(toNumber(1), toNumber(5)), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "the 2 numbers are not equal")
        }
    }

    func testLessThan() {
        let v = Variable(named: "v")
        let goal = evalComparaison(lessthan(toNumber(3), toNumber(5)), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "the first number is greater than or equal to the second")
            break
        }
    }

    func testGreaterThan() {
        let v = Variable(named: "v")
        let goal = evalComparaison(greaterthan(toNumber(7), toNumber(4)), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "the first number is lesser than or equal to the second")
            break
        }
    }

    func testLessEqual() {
        let v = Variable(named: "v")
        let goal = evalComparaison(lessequal(toNumber(41), toNumber(100)), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "the first number is strictly greater than the second")
            break
        }
    }

    func testGreaterEqual() {
        let v = Variable(named: "v")
        let goal = evalComparaison(greaterequal(toNumber(65), toNumber(65)), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "the first number is strictly lesser than the second")
            break
        }
    }


    // the boolean expressions test functions below

    func testOr() {
        let v = Variable(named: "v")
        var goal = evalBoolean(or(t, t), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "True or True -> True")
        }
        goal = evalBoolean(or(t, f), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "True or False -> True")
        }
        goal = evalBoolean(or(f, f), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(f), "False or False -> False")
        }
        goal = evalBoolean(or(f, t), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "False and True -> True")
        }
    }


    func testAnd() {
        let v = Variable(named: "v")
        var goal = evalBoolean(and(t, t), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "True and True -> True")
        }
        goal = evalBoolean(and(t, f), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(f), "True and False -> False")
        }
        goal = evalBoolean(and(f, f), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(f), "False and False -> False")
        }
        goal = evalBoolean(and(f, t), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(f), "False and False -> False")
        }
    }


    func testImplies() {
        let v = Variable(named: "v")
        var goal = evalBoolean(implies(t, t), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "True -> True is True")
        }
        goal = evalBoolean(implies(t, f), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(f), "True -> False is False")
        }
        goal = evalBoolean(implies(f, t), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "False -> True is True")
        }
        goal = evalBoolean(implies(f, f), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "False -> False is True")
        }
    }


    func testNot() {
        let v = Variable(named: "v")
        var goal = evalBoolean(not(t), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(f), "not(True) -> False")
        }
        goal = evalBoolean(not(f), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "not(False) -> True")
        }
    }


    //the main evaluation test function below

    func testEval(){
        let v = Variable(named: "v")
        var goal = eval(and(t, t), v)
        for sub in solve(goal) {
            let r = sub.reified()
            XCTAssert(r[v].equals(t),"wrong result")
        }
        goal = eval(notequal(toNumber(64),toNumber(33)), v)
        for sub in solve(goal){
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "wrong comparaison")
        }
        goal = eval(not(greaterthan(toNumber(82), toNumber(141))), v)
        for sub in solve(goal){
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "wrong comparison")
        }
        goal = eval(and(lessequal(toNumber(23),toNumber(23)), lessthan(toNumber(23),toNumber(32))), v)
        for sub in solve(goal){
            let r = sub.reified()
            XCTAssert(r[v].equals(t), "wrong comparison")
        }
    }

}
