from typing import Tuple, NewType, Iterator

Point = NewType('Point', Tuple[int, int])

class EC:
    inf: Point = (0, 0) # 无穷远点

    def __init__(self, a, b, p, G: Point=None, n=None, h=None):
        '''
        E_P: x^3 + ax + b = y^2 mod p

        point_gen: 基点, 
        n: 基点的阶, 
        para: 安全参数(点坐标比特长度), 
        h: 余因子 #E(F_p)/n
        '''
        self.a = a
        self.b = b
        self.p = p # p != size(curve)
        self.G = G # base point
        self.n = n
        self.h = h
        assert self.test_params(), "invalid params"

    def _find_inv(self, x, p):
        '''find inv mod by using Fermat's little theorem'''
        return pow(x, p - 2, p)

    def add(self, A: Point, B: Point):
        '''Elliptic Curve Addition'''
        # handle infinity
        if A == self.inf:
            # better practice may use the None to repre infinity
            # but if b!=0, the origin will not be valid point
            return B
        elif B == self.inf:
            return A

        # unpack point
        ax, ay = A
        bx, by = B

        # cal slope k
        if ax == bx and ay == by: 
	        # same point, compute tangent
            _div = self._find_inv(2 * ay, self.p) 
            k = (3 * ax * ax + self.a) * _div % self.p
        elif ax == bx:
            # same x, k not existed, return infinity
            return self.inf
        else:
            _div = self._find_inv(bx - ax, self.p) 
            k =  (by - ay) * _div % self.p

        x = (k * k - ax - bx) % self.p
        y = (k * (ax - x) - ay) % self.p
        return (x, y)

    def dbl(self, A: Point):
        '''Elliptic Curve Double'''
        return self.add(A, A)

    def smul(self, k, A: Point):
        '''Elliptic Curve Point Scalar Multiplication'''
        ans = self.inf
        base = A
        while k != 0:
            if k & 1 != 0:
                ans = self.add(base, ans) 
            base = self.add(base , base)
            k >>= 1
        return ans

	def smul2(self, k:int, A:Point):
		'''using naf to accelarate'''
        naf_k = self._naf(k)
        ans = (0, 0)
        neg_A = self.neg(A)
        for k_i in naf_k:
            ans = self.add(ans, ans)
            if k_i == -1:
                ans = self.add(ans, neg_A)
            elif k_i == 1:
                ans = self.add(ans, A)
        return ans

    def neg(self, A: Point):
        '''(x, y) -> (x, -y)'''
        return (A[0], (-A[1])%self.p)

    def test_params(self)->bool:
        # test q=p, and prime

        # test whether the curve is smooth
        if (4*(self.a**3) + 27* (self.b**2))%self.p==0:
            return False

        # test base point
        if self.G != None:
            x, y = self.G
            if not self.on_ec((x, y)):
                return False

            # test order of base point
            if self.n != None:
                if self.smul(self.n, self.G) != (0, 0):
                    return False
                # using complementary divisor
                # h = (sqrt(self.n)+1)**2 // self.n 
                # if h != self.h:
                #     return False
        return True

    def on_ec(self, A: Point)->bool:
        '''test whether point A is on this curve'''
        x, y = A
        return (y**2)%self.p == (x**3 + self.a*x + self.b)%self.p

    def _is_square(self, x: int)->bool:
        '''test whether x is the quadratic residue of p, 
        using Legendre Symbol'''
        return (x**0.5)%1 == 0
    
    def get_points(self) -> Iterator[Point]:
        '''go through all points on curve'''
        yield (0, 0)

        ## wrong method:
        # for x in range(self.p):
        #     squared_y = (x**3 + self.a*x + self.b) % self.p
        #     inv_y = self._find_inv(squared_y, self.p)
        #     if self._is_square(squared_y):
        #         y = int(squared_y ** 0.5)
        #         yield (x, y)
        #         yield (x, (-y)%self.p)
        #         continue

    def get_point_order(self, A: Point)->int:
        '''get order of point, need further optimization'''
        if not self.on_ec(A):
            raise ValueError("point is not on the curve")
        B = self.add(A, A)
        cnt = 2
        while B != self.inf:
            B = self.add(B, A)
            cnt += 1
        return cnt

    def get_ec_order(self)->int:
        '''get order of curve'''
        pass
        
    def _naf(self, k: int):
	    '''naf tool'''
        naf_k = []
        while k!=0:
            if k % 2:
                d = 2-(k%4)
                naf_k.append(d)
                k = (k-d)>>1
            else:
                naf_k.append(0)
                k >>= 1
        naf_k.reverse()
        return tuple(naf_k)    

""""""

class EllipticCurve:
    def __init__(self, a, b, field):
        """
        y^2 = x^3 + ax + b
        """
        if not field.is_valid(a) or not field.is_valid(b):
            raise ValueError
        if 4 * a * a * a + 27 * b * b == 0:
            raise ValueError
        self.a = a
        self.b = b
        self.field = field


