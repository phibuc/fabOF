% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mixfabOF.R
\name{mixfabOF}
\alias{mixfabOF}
\title{mixfabOF}
\usage{
mixfabOF(
  formula,
  data,
  random,
  delta = 0.001,
  max.iter = 100,
  scores = NULL,
  importance = FALSE,
  importance.reps = 100,
  permute.clusterwise = FALSE,
  ranger.control = NULL
)
}
\arguments{
\item{formula}{Fixed effects formula as object of class \code{formula} or \code{character}.}

\item{data}{Training data as object of class \code{data.frame} or \code{matrix}.}

\item{random}{Random effects structure as object of class \code{formula} or \code{character} . See 'Details' for syntax details.}

\item{delta}{Minimum relative change in log-likelihood for iterative estimation procedure.}

\item{max.iter}{Maximum number of iterations for iterative estimation procedure.}

\item{scores}{Numeric scores assigned to ordinal response categories.}

\item{importance}{Compute permutation variable importance based on weighted Cohen's Kappa with linear weights.}

\item{importance.reps}{Replications used for computing variable importance. High values increase stability of variable importance results but increase runtime.}

\item{permute.clusterwise}{Should permutations only occur within the same cluster?}

\item{ranger.control}{List of arguments to pass to \code{ranger} function (e.g., num.trees, mtry, etc.). See \link[ranger]{ranger} documentation for a comprehensive overview of specifiable parameters.}
}
\value{
Fitted model object of class mixfabOF containing
   \item{\code{ranger.fit}}{Forest object trained using numeric scores as target.}
   \item{\code{category.borders}}{Numeric category borders determined by frequency-based heuristic.}
   \item{\code{categories}}{Response categories of ordinal target variable.}
   \item{\code{category.scores}}{Numeric scores assigned to ordinal response categories.}
   \item{\code{category.frequencies}}{Frequencies of ordinal response categories in the training data.}
   \item{\code{variable.importance}}{Permutation variable importance values.}
   \item{\code{target}}{Target variable name.}
   \item{\code{call}}{Function call.}
   \item{\code{loglik}}{Log-likelihood value in last iteration.}
}
\description{
Fits a Mixed-effects Frequency-Adjusted Borders Ordinal Forest (mixfabOF) as described in Buczak (2024a).
Designed for ordinal prediction in hierarchical data settings, mixfabOF assigns numeric scores to the ordinal response categories and
iterates between estimating fixed and random effects. See 'Details' section below for more information on mixfabOF.
}
\details{
Extending Frequency-Adjusted Borders Ordinal Forest (\link[fabOF]{fabOF}; Buczak, 2024b) to hierarchical data, mixfabOF combines
the logic of fabOF with the iterative estimation procedure proposed in Hajjem et al. (2014) that extends regression random forest to
hierarchical data settings. To this end, mixfabOF assigns \code{scores} to the ordinal response categories and iterates between
estimating the fixed effects structure using random forest and the random effects structure using a linear mixed model.

The mixfabOF model is specified via the \code{formula} and \code{random} where \code{formula} specifies the fixed effects structure
(e.g., y ~ x1 + x2 + ...) and \code{random} specifies the random effects structure based on a grouping variable
(e.g., ~ 1|id for a random intercept model with grouping variable 'id'). The estimation procedures runs until a minimum relative
change in log-likelihood is not achieved (specified via \code{delta}) or the maximum number of iterations (\code{max.iter}) is exhausted.

By setting \code{importance = TRUE}, permutation variable importance values can be computed. For the variable importance, predictive
performance is assessed using weighted Cohen's Kappa with linear weights (see Buczak, 2024a and Buczak, 2024b for more details).

For fitting the regression RF, the \code{ranger} package (Wright & Ziegler, 2017) is used. Arguments
for \code{ranger} (e.g., \code{num.trees} or \code{mtry}) can be passed via the \code{ranger.control} argument as a list with named entries
corresponding to the respective \code{ranger} parameter. See \code{ranger} documentation for an overview
of all parameters and their description. If left unspecified in the \code{ranger.control} argument,
all parameters are initialized using their respective default from the \code{ranger} package.
}
\examples{
\dontrun{}
}
\references{
\itemize{
  \item Buczak, P. (2024a). Mixed-Effects Frequency-Adjusted Borders Ordinal Forest: A Tree Ensemble Method for Ordinal Prediction with Hierarchical Data. OSF Pre-print. \doi{10.31219/osf.io/ny6we}.
  \item Buczak, P. (2024b). fabOF: A Novel Tree Ensemble Method for Ordinal Prediction. OSF Pre-print. \doi{10.31219/osf.io/h8t4p}.
  \item Hajjem, A., Bellavance, F. & Larocque, D. (2014). Mixed-effects Random Forest for Clustered Data. JSCS. \doi{10.1080/00949655.2012.741599}
  \item Wright, M. N. & Ziegler, A. (2017). ranger: A Fast Implementation of Random Forests for High Dimensional Data in C++ and R. J Stat Softw 77:1-17. \doi{10.18637/jss.v077.i01}.
  \item Breiman, L. (2001). Random Forests. Mach Learn, 45:5-32. \doi{10.1023/A:1010933404324}.
  }
}
\author{
Philip Buczak
}
