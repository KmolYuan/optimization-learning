# -*- coding: utf-8 -*-

from typing import Tuple, Callable
import pylab
from numpy import arange, array, where
from scipy.optimize import minimize
from mpl_toolkits.mplot3d import Axes3D


def f(args: Tuple[float, float]) -> float:
    x1, x2 = args
    t = x2 - x1
    return t * t * t * t + t + 8 * x1 * x2 + 3


def g(args: Tuple[float, float]) -> float:
    x1, x2 = args
    x1_2 = x1 * x1
    return x1_2 * x1_2 + (1 + 2 * x2) * x1_2 + x2 * x2 - 2 * x1


def plot3d(
    func: Callable[[Tuple[float, float]], float],
    start: float,
    stop: float
) -> None:
    x = []
    y = []
    z = []
    for x1 in arange(start, stop, 0.05):
        row_x = []
        row_y = []
        row_z = []
        for x2 in arange(start, stop, 0.05):
            row_x.append(x1)
            row_y.append(x2)
            row_z.append(func((x1, x2)))
        x.append(row_x)
        y.append(row_y)
        z.append(row_z)
    x = array(x)
    y = array(y)
    z = array(z)
    min_xy = where(z == z.min())
    i = min_xy[0][0]
    j = min_xy[1][0]
    print(f"min={(x[i, j], y[i, j], z[i, j])}")

    fig = pylab.figure()
    ax = Axes3D(fig)
    ax.set_xlabel('$x1$')
    ax.set_ylabel('$x2$')
    ax.set_zlabel('$f(x)$')
    ax.plot_surface(x, y, z)
    pylab.show()


def task1() -> None:
    plot3d(f, -2, 2)
    # Optimization
    res = minimize(f, array([0.28, -0.77]), method='SLSQP', constraints={'type': 'ineq', 'fun': g})
    if res.success:
        print(f"(1) f{tuple(res.x)} => {res.fun}")
    else:
        print("(1) failed")


def task2() -> None:
    # Optimization
    res = minimize(
        lambda x: 88.9 * x[0] * x[1],
        array([0.99, 0.08]),
        method='SLSQP',
        constraints=(
            {'type': 'ineq', 'fun': lambda x: x[0] * x[1] - 0.0885},
            {'type': 'ineq', 'fun': lambda x: x[0] - 0.994},
            {'type': 'ineq', 'fun': lambda x: x[1] - 0.05},
        )
    )
    if res.success:
        print(f"(2) f{tuple(res.x)} => {res.fun}")
    else:
        print("(2) failed")


def f_x(args: Tuple[float, float]) -> float:
    x1, x2 = args
    x1_2 = x1 * x1
    x2_2 = x2 * x2
    return -x2 - 2 * x1 * x2 + x1_2 + x2_2 - 3 * x1_2 * x2 - 2 * x1_2 * x1 + 2 * x2_2 * x2_2


def task3() -> None:
    plot3d(f_x, -4, 6)
    # Optimization
    res = minimize(f_x, array([1., 1.]), method='SLSQP')
    if res.success:
        print(f"(3) f{tuple(res.x)} => {res.fun}")
    else:
        print("(3) failed")


if __name__ == '__main__':
    task1()
    task2()
    task3()
