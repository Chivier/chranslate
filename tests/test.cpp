#include <iostream>
#include <cstdio>
#include <omp.h>
#include <vector>
using namespace std;

int main(int argv, char **argc) {
    int arr_length = 1000;
    vector<int> arr1, arr2, arr;
#pragma omp parallel for
    for (int index = 0; index < arr_length; ++index) {
        arr1.push_back(index);
        arr2.push_back(arr_length - index);
    }

#pragma omp parallel for
    for (int index = 0; index < arr_length; ++index) {
        arr.push_back(arr1[index] + arr2[index]);
    }

    int sum = 0;
#pragma omp parallel reduction(+:sum)
    for (int index = 0; index < arr_length; ++index) {
        sum += arr[index];
    }

    cout << sum;
    return 0;
}
