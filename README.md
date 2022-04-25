# Steps script

## Abbreviations used

* Gaussian (G)
* super-Gaussian (SG)
* Poisson (P)
* the size of a side of the picture (N)

## Steps

1. create an object feature (`Ofeat`) with the following attributes:
   * a pair of values (`px`, `py`) to describe the starting position of the intensity trace,
   * a list of values (`ry[]`) to describe the intensity distribution on the y-axis,
   * an array of value (`rx[][]`) to describe the intensity distribution on the x-axis for each point/value of `ry[]`.
2. realize a function (`Frandom`) to generate a random float from a probability density function (Gaussian (G), super-Gaussian (SG), or Poisson (P), or another one to be defined), in order to define the starting position of an Ofeat object.
3. realize a function (`Finit`) to initialize an Ofeat object (i.e. `Ofeat = Finit(n)`), performing the following actions:
   1. `px = Frandom(G or SG or P);`
   2. `py = Frandom(G or SG or P);`
   3. `ry = [0,0,...,0];` of which the length is `N` (the size of a side of the picture)
   4. `rx = [0,0,...,0][0,0,...,0];` of which the length is `N*N`
4. realize a function (`FintensityY`) allowing to recover (n) points from the distribution of a Poisson log (for `ry`) to form :
   1. `ry = FintensityY(P, N);`
5. realize a function (`FintensityX`) to recover (n) points from the distribution of a Gaussian log (for `rx`) to form:
   1. `standardDeviation = ry[i]; rx[i] = FintensityX(G, standardDeviation);`
6. realize a function (`Fscale`) to project the lists of values (`rx` and `ry`) on the desired intensity scale (e.g. iMin = 230, iMax = 65536)
   * `Fscale(iMin, iMax, valueToBeScaled) = (iMax - iMin) * valueToBeScaled + iMin;`
   * example :
     * initial range `0 -> 1`
     * desired range `230 -> 65536` : `Fscale(230, 65536, 1) = 65536 ; Fscale(230, 65536, 0) = 0 ;`
7. create a list of 15 `Ofeat` objects by initializing it with `Finit` then applying `FintensityY` and then `FintensityX` to its attributes `rx` and `ry` respectively.
8. generate the plot (initialized from a matrix with a value of 0) by adding the data from `Ofeat` objects, then pass all the data of the plot into `Fscale` function to fit values at the desired scale (highlighting colors).

## Questions

1. How to determine the position of the points ? Is it from a Gaussian (G), super-Gaussian (SG), or Poisson (P) probability density function ?
2. I think it would be necessary for step 1.2 for all the positions of our Ofeat objects, and not one by one, in order to have a more homogeneous distribution and to avoid repetition bias. What do you think ?
3. About the step 5, as a Gaussian distribution is continuous in infinity, I wonder if it will add noise on the whole picture for each object. Should I truncate my data from this distribution from a certain percentile? If yes which one (+/- 1,9774) ?
4. About the step 5, I am not sure if the modification of the standard deviation only will be enough to get something smooth. It may be smoother to define the mean in addition to the standard deviation. Or maybe I should only set the mean, what do you think ?
5. What programming language do you want me to use ?