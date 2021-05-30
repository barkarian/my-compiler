#include "pilib.h"


/* program */ 

int N = -100;
int a, b;
int cube(int i){
return i * i * i;}
int add(int n,int k){
int j;
j = (N - n) + cube(k);
writeInt(j);
return j;}

int main() {
a = readInt();
b = readInt();
add(a, b);
} 
