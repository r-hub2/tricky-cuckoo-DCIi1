# DCIi1 0.2.0

* Reference I1 p-values are restricted to n=100, w1=22 and independent Gaussian
  noise; other lengths, windows and WD mode require calibration="none".
* DCI provides descriptive candidate statistics and locations. Its pvalue
  column is always NA; significance-based acceptance is not exposed.
* change_points() extracts candidate locations without significance filtering.
* Removed development-only alpha, output, evaluation and calibration arguments
  from dcii1(), and alpha from change_points(). These calls now error instead
  of silently returning results with different inferential meaning.
* The independent-noise density is packaged; dependent calibration grids are
  excluded. The WD sigma formula is preserved for statistic-only calculations.
* Confirmed author, maintainer, copyright and GPL-3 metadata.

# DCIi1 0.1.0 (development version)

* Modularized the original code, embedded calibration data, and added tests.
* Repaired negative-terminal flag indexing and duplicate-point covering.
* Passed the localization fraction explicitly and replaced character matrices
  with streaming numeric accumulation.
