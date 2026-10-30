import math
import random

class Field:
    pass


class RealField(Field):
    def __init__(self, precision=1e-9)
        pass

class FiniteFieldElement:
    def __init__(self, value, modulus):
        if modulus <= 1:
            raise ValueError
        self.value = value % modulus
        self.modulus = modulus

    def __add__(self, other):
        if self.modulus != other.modulus:
            raise ValueError
        return FiniteFieldElement((self.value + other.value) % self.modulus, self.modulus)

    def __sub__(self, other):
        if self.modulus != other.modulus:
            raise ValueError
        return FiniteFieldElement((self.value - other.value) % self.modulus, self.modulus)

    def __mul__(self, other):
        if self.modulus != other.modulus:
            raise ValueError
        return FiniteFieldElement((self.value * other.value) % self.modulus, self.modulus)

    def __truediv__(self, other):
        if self.modulus != other.modulus:
            raise ValueError
        inverse = other._inverse()
        return self * inverse

    def __eq__(self, other):
        return self.value == other.value and self.modulus == other.modulus

    def __neg__(self):
        return FiniteFieldElement(-self.value % self.modulus, self.modulus)

    def _inverse(self):
        """
        求逆：计算 a 的乘法逆元
        使用扩展欧几里得算法
        """
        t, new_t = 0, 1
        r, new_r = self.modulus, self.value
        while new_r != 0:
            quotient = r // new_r
            t, new_t = new_t, t - quotient * new_t
            r, new_r = new_r, r - quotient * new_r
        if r > 1:
            raise ValueError("该元素没有逆元")
        if t < 0:
            t += self.modulus
        return FiniteFieldElement(t, self.modulus)


class FiniteField(Field):
    def __init__(self, p, n=1):
        """
        初始化有限域。
        
        :param p: 素数，表示有限域的模数。
        """
        if p <= 1 or not self.is_prime(p):
            raise ValueError("p 必须是一个大于 1 的素数")
        self.p = p

    def random_element(self):
        pass

    def is_prime(self, n) -> bool:
        pass

