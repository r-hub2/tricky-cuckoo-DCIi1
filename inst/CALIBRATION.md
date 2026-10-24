# Reference calibration

The internal nulldistrepo contains only the zero-correlation reference density
extracted without changing its values from 20261002_DCIi1CP.RData. It is a
512-row data frame with x and y columns in a named list, with rho_grid=0.
It is stored using xz compression and R serialization version 2.

The authors report generation using Gaussian noise, sample length 100, full
window 22 and 1000 simulations. Provenance is the supplied serialized research
data; the package does not claim independent regeneration of the original
density. data-raw/prepare-calibration.R records the extraction procedure in the
development source. This release exposes only the independent-noise reference.

Tail probabilities retain the original rectangular quadrature and four-decimal
rounding. Density smoothing gives a small mass below zero; the upper finite
support gives a reported zero above the largest ordinate. Probabilities are
bounded to [0,1], without extrapolation or an invented tail model.

Reference probabilities are available only for length 100, w1=22 and archeck=0.
The noise must be independent and Gaussian; other uses are statistic-only.
DCI never applies this density to selected segments. No familywise-error or
general weak-dependence guarantee is made.

Independent validation: seed 26102403, 10000 N(0,1) series of length 100;
rejection rates .0086, .0415 and .0857 at alpha .01, .05 and .10.
The density remains fixed throughout validation; these series were not used
to fit, tune or replace it. Calibration sampling uncertainty is not included
in these validation rates. Generation and validation counts are distinct.
