# -*- coding: utf-8 -*-

from typing import Tuple, Callable, Sequence, Optional
import pylab
from numpy import arange, array, where
from scipy.optimize import minimize
from mpl_toolkits.mplot3d import Axes3D


def f1(args: Tuple[float, float]) -> float:
    """(x2 - x1) ** 4 + 8 * x1 * x2 - x1 + x2 + 3"""
    x1, x2 = args
    t = x2 - x1
    return t * t * t * t + t + 8 * x1 * x2 + 3


def g1(args: Tuple[float, float]) -> float:
    """x1 ** 4 - 2 * x2 * x1 ** 2 + x2 ** 2 + x1 ** 2 - 2 * x1"""
    x1, x2 = args
    x1_2 = x1 * x1
    return x1_2 * x1_2 + (1 + 2 * x2) * x1_2 + x2 * x2 - 2 * x1


def plot3d(
    funcs: Sequence[Callable[[Tuple[float, float]], float]],
    start: float,
    stop: float,
    label1: str = "x1",
    label2: str = "x2",
    label3: str = "f(x)",
    mark: Optional[Tuple[float, float]] = None
) -> None:
    fig = pylab.figure()
    ax = Axes3D(fig)
    for f, func in enumerate(funcs):
        x = []
        y = []
        z = []
        for x1 in arange(start, stop, 0.01):
            row_x = []
            row_y = []
            row_z = []
            for x2 in arange(start, stop, 0.01):
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
        ax.set_xlabel(f"${label1}$")
        ax.set_ylabel(f"${label2}$")
        ax.set_zlabel(f"${label3}$")
        ax.plot_surface(x, y, z)
        if mark is not None:
            ax.plot(
                [mark[0]],
                [mark[1]],
                [func(mark)],
                markerfacecolor='r',
                markeredgecolor='r',
                marker='o',
                markersize=5
            )
        elif f == 0:
            ax.plot(
                [x[i, j]],
                [y[i, j]],
                [z[i, j]],
                markerfacecolor='r',
                markeredgecolor='r',
                marker='o',
                markersize=5
            )
    pylab.show()


def task1() -> None:
    plot3d((f1,), -2, 2)
    plot3d((f1, g1), -2, 2, label3="f(x), g(x)")
    # Optimization
    res = minimize(f1, array([0.28, -0.77]), method='SLSQP', constraints={'type': 'ineq', 'fun': g1})
    if res.success:
        print(f"(1) f{tuple(res.x)} => {res.fun}")
    else:
        print("(1) failed")


def f2(args: Tuple[float, float]) -> float:
    x1, x2 = args
    return 88.9 * x1 * x2


def task2() -> None:
    plot3d((f2,), -2, 2, 'd', 't')
    # Optimization
    res = minimize(
        f2,
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


def f3(args: Tuple[float, float]) -> float:
    x1, x2 = args
    x1_2 = x1 * x1
    x2_2 = x2 * x2
    return -x2 - 2 * x1 * x2 + x1_2 + x2_2 - 3 * x1_2 * x2 - 2 * x1_2 * x1 + 2 * x2_2 * x2_2


def task3() -> None:
    plot3d((f3,), -4, 6, mark=(1, 1))
    # Optimization
    res = minimize(f3, array([1., 1.]), method='SLSQP')
    if res.success:
        print(f"(3) f{tuple(res.x)} => {res.fun}")
    else:
        print("(3) failed")


if __name__ == '__main__':
    task1()
    task2()
    task3()
