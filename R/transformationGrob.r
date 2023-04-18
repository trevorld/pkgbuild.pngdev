# Utilities to help use R 4.2's group affine transformation feature
# https://www.stat.auckland.ac.nz/~paul/Reports/GraphicsEngine/groups/groups.html

#' Affine transformation grob
#'
#' `transformationGrob()` is a grid grob function to facilitate
#' using the group affine transformation features introduced in R 4.2.
#' @param grob A grid grob to perform affine transformations on.
#' @param vp.define [grid::viewport()] to define grid group in.
#' @param transform An affine transformation function.
#'                  If `NULL` default to [grid::viewportTransform()].
#' @param name A character identifier (for grid)
#' @param gp A [grid::gpar()] object.
#' @param vp A [grid::viewport()] object (or `NULL`).
#' @examples
#' if (getRversion() >= '4.2.0' && require("grid")) {
#'   # Only works if active graphics device supports affine transformations
#'   # such as `png(type="cairo")` on R 4.2+ but not `ragg::agg_png()`
#'   grob <- grobTree(circleGrob(gp=gpar(fill="yellow", col="blue")),
#'                    textGrob("RSTATS", gp=gpar(fontsize=32)))
#'
#'   vp.define <- viewport(width=unit(2, "in"), height=unit(2, "in"))
#'   transformation <- transformationGrob(grob, vp.define=vp.define)
#'   grid.newpage()
#'   pushViewport(viewport(width=unit(4, "in"), height=unit(1, "in")))
#'   grid.draw(transformation)
#'   popViewport()
#' }
#'
#' print(pkgdown::fig_settings())
#' print(names(dev.cur()))
#' print(isTRUE(dev.capabilities()$transformations))
#' print(sessionInfo())
#'
#' @import grid
#' @export
transformationGrob <- function(grob,
                               vp.define = NULL,
                               transform = NULL,
                               name = NULL, gp = gpar(), vp = NULL) {
    stopifnot(getRversion() >= '4.2.0')
    if (is.null(transform))
        transform <- viewportTransform
    gTree(grob=grob, vp.define=vp.define, transform=transform,
          scale = 1,
          name = name, gp = gp, vp = vp, cl = "pp_transformation")
}

#' @export
makeContent.pp_transformation <- function(x) {
    stopifnot(isTRUE(grDevices::dev.capabilities()$transformations))
    define <- defineGrob(x$grob, vp=x$vp.define)
    use <- useGrob(define$name, transform=x$transform)
    gl <- gList(define, use)
    setChildren(x, gl)
}
