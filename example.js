var myArray = [1, 2, 3, 4, 5, 6];
var updateArray = myArray.map(function (x) { return x * 2; }).filter(function (x) { return x % 2 === 0; });
var first = updateArray[0], second = updateArray[1], rest = updateArray.slice(2);
console.log(first);
console.log(second);
var something = function (_a) {
    var peoples = _a.peoples;
    var values = peoples.map(function (p) { return p.name; });
    return values;
};
var myPeople = {
    peoples: [
        { name: "John", age: 30 },
        { name: "Jane", age: 25 },
        { name: "Bob", age: 35 },
    ],
};
console.log(something(myPeople));
