#include <bits/stdc++.h>
using namespace std;

typedef long long ll;

// Maximum possible sum of digits for numbers up to 1e8 is 8*9=72
const int MAX_SUM = 72;

// DP memoization table
ll memo_table[10][MAX_SUM + 1][2][2];
bool is_memo_computed[10][MAX_SUM + 1][2][2];

// List of prime numbers up to 72
bool is_prime_list[73];

// Initialize the list of prime numbers up to 72
void sieve_primes() {
    fill(is_prime_list, is_prime_list + 73, true);
    is_prime_list[0] = is_prime_list[1] = false;
    for(int i=2;i<=72;i++) {
        if(is_prime_list[i]) {
            for(int j=2*i; j<=72; j+=i) {
                is_prime_list[j] = false;
            }
        }
    }
}

// Convert number to digit array
void get_digits(ll num, string &s) {
    s = to_string(num);
}

// Digit DP function
ll dp(int pos, int sum, int tight, int started, const string &s) {
    if(pos == s.size()) {
        if (started && is_prime_list[sum])
            return 1;
        else
            return 0;
    }
    if(is_memo_computed[pos][sum][tight][started])
        return memo_table[pos][sum][tight][started];
    
    is_memo_computed[pos][sum][tight][started] = true;
    ll res = 0;
    int limit = tight ? (s[pos] - '0') : 9;
    for(int digit=0; digit<=limit; digit++) {
        int new_tight = tight && (digit == limit) ? 1 : 0;
        int new_started = started || (digit != 0) ? 1 : 0;
        int new_sum = sum + (new_started ? digit : 0);
        if(new_sum > MAX_SUM) continue; // Early pruning
        res += dp(pos + 1, new_sum, new_tight, new_started, s);
    }
    return memo_table[pos][sum][tight][started] = res;
}

// Wrapper for the DP
ll count_numbers_with_prime_digit_sum(ll num) {
    string s;
    get_digits(num, s);
    // Reset memoization table
    memset(is_memo_computed, 0, sizeof(is_memo_computed));
    return dp(0, 0, 1, 0, s);
}

int main(){
    ios::sync_with_stdio(false);
    cin.tie(0);
    
    // Precompute primes
    sieve_primes();
    
    ll A, B;
    cin >> A >> B;
    
    // Compute the count for B and A-1
    ll count_B = count_numbers_with_prime_digit_sum(B);
    ll count_A_minus_1 = (A > 1) ? count_numbers_with_prime_digit_sum(A-1) : 0;
    
    // The answer is the difference
    ll answer = count_B - count_A_minus_1;
    
    cout << answer;
    return 0;
}