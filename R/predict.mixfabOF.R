#' Predicts ordinal response categories for new observations using a mixfabOF model fit. For unknown clusters, prediction is performed based on the fixed effects only.
#'
#' @title Predict mixfabOF
#' @param object Fitted mixfabOF model object.
#' @param newdata Dataset containing new observations to be predicted.
#' @return Predicted ordinal response category labels.
#' @author Philip Buczak
#' @export
predict.mixfabOF <- function(object, newdata, ...) {

  if(!inherits(object, "mixfabOF")) {
    stop("Error: Object must be of class mixfabOF.")
  }
  if(is.null(newdata)) {
    stop("Error: Must provide data for prediction.")
  }

  ranger.pred <- predict(object$ranger.fit, data = newdata)$predictions

  random.string <- attr(terms(object$random.formula), "term.labels")
  random.stripped <- gsub(" ", "", random.string)
  random.split <- strsplit(random.stripped, "\\|")[[1]]
  grp.var <- random.split[2]
  id <- newdata[, grp.var]
  ran.var <- strsplit(random.split[1], "\\+")[[1]]

  if("1" %in% ran.var) {
    Z <- as.matrix(cbind(1, newdata[, ran.var[ran.var != "1"]]))
  } else {
    Z <- as.matrix(newdata[, ran.var])
  }
  grps <- unique(id)
  n.grps <- length(grps)
  pred <- numeric(nrow(newdata))

  for(j in 1:n.grps) {
    id.j <- which(id == grps[j])

    if(grps[j] %in% rownames(object$random.effects)) {
      grp.id <- which(rownames(object$random.effects) == grps[j])
      pred[id.j] <- ranger.pred[id.j] + Z[id.j,, drop = FALSE] %*%
        object$random.effects[grp.id, ]

    } else {
      pred[id.j] <- ranger.pred[id.j]
    }
  }

  # Inspired by Roman Hornung's ordinalForest R package
  pred.num <- sapply(pred, function(x)
    max(which(x >= object$category.borders[1:length(object$categories)])))
  pred.cat <- factor(object$categories[pred.num], levels = object$categories)

  return(pred.cat)
}
