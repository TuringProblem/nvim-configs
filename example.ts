const myArray: number[] = [1, 2, 3, 4, 5, 6];
const updateArray = myArray.map(x => x * 2).filter(x => x % 2 === 0);
const [first, second, ...rest] = updateArray;

console.log(first);
console.log(second);


type MyType = {
  name: string;
  age?: number;
};

interface data {
  peoples: MyType[];
}

const something = ({ peoples }: data) => {
  const values = peoples.map(p => p.name);
  return values;
};




const myPeople: data = {
  peoples: [
    { name: "John", age: 30 },
    { name: "Jane", age: 25 },
    { name: "Bob", age: 35 },
  ],
}

console.log(something(myPeople));


