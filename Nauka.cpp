#include <iostream>
#include <vector>

using namespace std;

vector<int> &operator*= (vector<int> &a, int b)
{
    for (auto &n: a)
        n *= b;
    return a;
}

int main() {
    vector<int> v = {1, 2, 3};
    v *= 2;

    for (auto k: v)
        cout << k << " ";
}