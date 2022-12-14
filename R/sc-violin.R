##' @title sc_violin
##' @rdname sc-violin
##' @param object Seurat object
##' @param features selected features
##' @param cells selected cells to plot (default is all cells)
##' @param slot slot to pull expression data from (e.g., 'count' or 'data')
##' @param .fun user defined function that will be applied to selected features (default is NULL and there is no data operation)
##' @param mapping aesthetic mapping
##' @param ncol number of facet columns if 'length(features) > 1'
##' @param ... additional parameters pass to 'ggplot2::geom_geom_violin()'
##' @return violin plot to visualize feature expression distribution
##' @seealso
##'  [geom_violin][ggplot2::geom_violin]; 
##' @importFrom utils modifyList
##' @importFrom ggplot2 aes_string
##' @importFrom ggplot2 ggplot
##' @importFrom ggplot2 geom_violin
##' @importFrom ggplot2 facet_wrap
##' @importFrom tidyr pivot_longer
##' @export
sc_violin <- function(object, features, 
                    cells=NULL, slot = "data", .fun = NULL, 
                    mapping = NULL, ncol=3, ...) {
    d <- get_dim_data(object, dims=NULL, features=features)
    d <- tidyr::pivot_longer(d, 2:ncol(d), names_to = "features")
    d$features <- factor(d$features, levels = features)
    if (!is.null(.fun)) {
        d <- .fun(d)
    }
    default_mapping = aes_string(fill="ident")
    if (is.null(mapping)) {
        mapping <- default_mapping
    } else {
        mapping <- modifyList(default_mapping, mapping)
    }
    p <- ggplot(d, aes_string("ident", "value")) + 
        geom_violin(mapping, ...) #+ 
        #ggforce::geom_sina(size=.1)
    
    if (length(features) > 1) {
        p <- p + facet_wrap(~features, ncol=ncol)
    }
    return(p)
}




