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


if __name__ == '__main__':
    task1()
