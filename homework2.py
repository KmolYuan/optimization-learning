# -*- coding: utf-8 -*-

from typing import Tuple, Callable
from math import exp, sqrt
from numpy import arange
import matplotlib.pyplot as plt


def task1():
    # exp(sqrt(x ** -1 * (1 - x ** 2)))
    plot2d(
        lambda x: exp(sqrt(x ** -1 * (1 - x * x))),
        (-10, -1),
        (0.1, 1)
    )
    # exp(x) / exp(1 / x)
    plot2d(
        lambda x: exp(x - 1 / x),
        (-5, -0.2),
        (0.1, 4.8)
    )


def plot2d(
    func: Callable[[float], float],
    *range_list: Tuple[float, float]
) -> None:
    for start, stop in range_list:
        x = []
        y = []
        for x1 in arange(start, stop, 0.01):
            x.append(x1)
            y.append(func(x1))
        plt.plot(x, y)
    plt.show()


def task4():
    c1 = 1.105
    c2 = 0.6735
    c3 = 0.0481
    k1 = 1.52
    k2 = 16.8
    k3 = 9.08
    k4 = 0.0278
    k5 = 0.0943
    k6 = 0.125
    l = 6.72
    h = 0.226
    b = 0.245
    t = 8.27

    for exp in [
        "k1 - h * l <= 0",
        "k2 - b * t * t <= 0",
        "h - b <= 0",
        "k3 - b * t * t * t <= 0",
        "(k4 * t + k5) / (b * b * b * t) - 1 <= 0",
        "k6 - h <= 0",
    ]:
        print(exp, eval(exp))


if __name__ == '__main__':
    task1()
    task4()
