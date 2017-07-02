%% examplemdstruct
clc
clear
X.example.big.animals.mammals.acquatic.dolphin = 1;
X.example.big.animals.mammals.acquatic.otter = 1;
X.example.big.animals.mammals.acquatic.porpoise = 1;
X.example.big.example.fruit.banana = 1;
X.example.big.example.fruit.lemon = 1;
X.example.big.example.vehicle.car = 1;
X.example.big.example.vehicle.truck = 1;
X.example.big.pet.cat = 1;
X.example.big.pet.dog = 1;
X.example.big.letters = 1;
X.example.big.shapes = 1;
X.example.small.ants = 1;
X.example.small.mice = 1;
X.rawr = 1;
X.boo = 1;

mdstruct(X,'Struct')