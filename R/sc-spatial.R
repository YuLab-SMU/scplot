##' @title sc_spatial
##' @rdname sc-spatial
##' @param object Seurat object
##' @param features selected features to be visualized
##' @param slot if plotting a feature, which data will be used (e.g., 'data', 'counts')
##' @return ggplot object
##' @importFrom ggplot2 facet_grid
##' @importFrom ggplot2 geom_point
##' @importFrom ggplot2 scale_color_gradientn
##' @importFrom Seurat DefaultAssay
##' @export
sc_spatial <- function(object, features = NULL, slot = "data") {
    images <- SeuratObject::Images(object = object, 
                    assay = Seurat::DefaultAssay(object = object)
                )
    coord <- SeuratObject::GetTissueCoordinates(object = object[[images]])
    
    if (is.null(features)) {
        p <- ggplot(coord, aes(.data$imagecol, .data$imagerow)) + 
            geom_point() + theme_bw2()
        return(p)
    }

    d <- SeuratObject::FetchData(object = object, vars = features, slot = slot)
    
    d2 <- cbind(coord, 
                d[rownames(coord), features, 
                drop = FALSE])
    dd <- pivot_longer(d2, 3:ncol(d2), names_to = "features")

    ggplot(dd, aes(.data$imagecol, .data$imagerow, color=.data$value)) + 
        geom_point() + facet_grid(.~features) + 
        scale_color_gradientn(colours = SpatialColors(n=100)) + 
        theme_bw2()

}

##' @importFrom yulab.utils get_fun_from_pkg
SpatialColors <- yulab.utils::get_fun_from_pkg('Seurat', 'SpatialColors')
