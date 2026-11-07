import numpy as np
import matplotlib.pyplot as plt

class RealEllipticCurve:
    """y^2 = x^3 + ax + b"""
    def __init__(self, a, b):
        self._a = a
        self._b = b

    def lift_x(self, x_vals):
        y_squared = x_vals**3 + self._a * x_vals + self._b
        valid = y_squared >= 0
        y_pos = np.sqrt(y_squared[valid])  
        y_neg = -y_pos
        return y_pos, y_neg, valid

Curve_33 = RealEllipticCurve(-3, 3)
Curve_65 = RealEllipticCurve(-6, 5)
# 以下两个为有奇点曲线
Curve00 = RealEllipticCurve(0, 0)
Curve_32 = RealEllipticCurve(-3, 2)
Curve_158 = RealEllipticCurve(-15, 8)

# 定义 x 的范围
x = np.linspace(-5, 5, 3000)  

# 计算 y 的正负分支
y_positive, y_negative, valid = Curve_32.lift_x(x)

# 绘图
plt.figure(figsize=(8, 6))
plt.plot(x[valid], y_positive,  color='blue')
plt.plot(x[valid], y_negative, color='blue')
plt.plot(x, m * x + c, color='gray')

plt.axhline(0, color='gray', linewidth=0.5, linestyle='--')
plt.axvline(0, color='gray', linewidth=0.5, linestyle='--')
# plt.axis('off')
plt.show()
