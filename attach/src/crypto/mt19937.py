class MT:
    # constant for MT19937, change for own need
    _n = 624
    _m = 397
    _w, _r = 32, 31
    _f = 1812433253
    _a = 0x9908B0DF
    _u, _d = 11, 0xFFFFFFFF
    _s, _b = 7, 0x9D2C5680
    _t, _c = 15, 0xEFC60000 
    _l = 18
    _mask = (1<<_w) - 1

    def __init__(self, seed):
        self._init_mt(seed)

    def _init_mt(self, seed):
        self.mt = [0] * 624
        self.mt[0] = seed & self._mask # 只取32位 seed
        for i in range(1, self._n):
            prev = self.mt[i-1]
            self.mt[i] = (self._f * (prev ^ (prev >> (self._w-2))) + i) & self._mask
        self._twist()
    
    def _twist(self):
        lower_mask = (1<<self._r) - 1
        upper_mask = self._mask - lower_mask
        for i in range(self._n):
            x = (self.mt[i] & upper_mask) + (self.mt[(i+1) % self._n] & lower_mask)
            xA = x >> 1 if not x % 2 else (x >> 1) ^  self._a
            self.mt[i] = self.mt[(i + self._m) % self._n] ^ xA
        self._index = 0

    def extract_num(self):
        if self._index >= self._n:
            if self._index > self._n:
                raise ValueError("Generator was never seeded")
            self._twist()
        y = self.mt[self._index]
        y = y ^ ((y >> self._u) & self._d)
        y = y ^ ((y << self._s) & self._b)
        y = y ^ ((y << self._t) & self._c)
        y = y ^ (y >> self._l) 
        self._index += 1
        return y & self._mask

def main():
    seed = int(input())
    mt19937 = MT(seed)
    for _ in range(20):
        print(mt19937.extract_num())

if __name__ == '__main__':
    main()
