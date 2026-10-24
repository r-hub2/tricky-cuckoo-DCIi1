\name{covering_metric}
\alias{covering_metric}
\alias{covering_metric_unwtd}
\title{Weighted and Unweighted Segmentation Covering}
\description{Compare a true segmentation with an estimated segmentation using
best matching Jaccard overlaps, as in the manuscript's simulation criteria.}
\usage{covering_metric(Tl, actual_cps, est_cps)
covering_metric_unwtd(Tl, actual_cps, est_cps)}
\arguments{
\item{Tl}{Positive integer series length.}
\item{actual_cps}{Numeric vector of actual last-observation-before-change indices,
integers in 1 through Tl-1. Use numeric(0) for no changes.}
\item{est_cps}{Estimated indices with the same restrictions.}
}
\details{For each actual segment, find the largest intersection-over-union
score with any estimated segment. The weighted metric averages these scores
with actual segment lengths as weights. The unweighted metric assigns equal
weight to each distinct actual segment. Both functions sort and deduplicate
input locations; this corrects the original unweighted denominator for repeated
locations. Invalid indices are rejected. The metrics are directional, need not
be symmetric, and are not tests or p-values. Endpoints are computed by interval
arithmetic, without allocating observation-index sets.}
\value{A numeric value between 0 and 1; 1 means identical segmentations.}
\examples{
covering_metric(100, c(30, 60), c(32, 58))
covering_metric_unwtd(100, c(30, 60), c(32, 58))
covering_metric(100, numeric(0), numeric(0))
}
\references{
Waychal, N., Laha, A. K. and Sinha, A. (2026).
Closely spaced change-point detection with an application to geopolitical
shocks in oil and gas markets. \doi{10.48550/arXiv.2610.23476}.
}
