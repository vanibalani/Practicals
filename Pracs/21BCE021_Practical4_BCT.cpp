#include <bits/stdc++.h>
using namespace std;

enum Result { 
    Attack, 
    Retreat, 
    Conflict 
};

int main() {
    cout << "Enter the string: \n";
    cout << "\tL => Loyal\n";
    cout << "\tT => Traitor\n";
    
    string input = "LLLL";
    for (int i = 0; i < 4; i++) {
        cin >> input[i];
    }

    cout << "Provide an action: Attack or Retreat\n";
    string s_action;
    cin >> s_action;
    Result action = Result::Conflict;

    if (s_action == "Attack") 
        action = Result::Attack;
    else if (s_action == "Retreat") 
        action = Result::Retreat;
    else {
        cout << "ERROR: Incorrect input\n";
        exit(1);
    }

    map<int, vector<Result>> res;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            if (i == j) 
                continue;
            if (input[i] == 'T') {
                if (action == Result::Attack)
                    res[j].push_back(Result::Retreat);
                else
                    res[j].push_back(Result::Attack);
            }
            if (input[i] == 'L') {
                res[j].push_back(action);
            }
        }
    }

    int overall_attack = 0, overall_retreat = 0;
    for (int i = 0; i < 4; i++) {
        Result ans = Result::Conflict;
        int attack = 0;
        int retreat = 0;

        for (auto it : res[i]) {
            if (it == Result::Attack) {
                attack++;
                overall_attack++;
            }
            if (it == Result::Retreat) {
                retreat++;
                overall_retreat++;
            }
        }

        cout << "Lt. " << i << " ";
        cout << "Attack: " << attack << " Retreat: " << retreat << endl;
    }

    if (overall_attack > overall_retreat) {
        cout << "Overall Result: Attack\n";
    } else if (overall_attack < overall_retreat) {
        cout << "Overall Result: Retreat\n";
    } else {
        cout << "Overall Result: Conflict\n";
    }

    return 0;
}
