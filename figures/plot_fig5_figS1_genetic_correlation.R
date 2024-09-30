#/bin/R

## read all genetic correlation
g_corr_mat <- read.csv("GeneticCorrelationMatrix.csv")
p_mat <- read.csv("PvalueMatrix.csv")

## draw Figure S1
library(ComplexHeatmap)
col_fun <- circlize::colorRamp2(c(-1, 0, 1), hcl_palette = "RdBu")
lgd_list <- list(Legend(col_fun = col_fun, title = "Genetic Correlation", title_position = "topcenter", direction = "horizontal", 
                        legend_width = unit(12, "cm"), legend_height = unit(6, "cm")))
ht <- Heatmap(g_corr_mat, name = "mat", cluster_rows = hclust(as.dist(1 - abs(g_corr_mat)), method = "mcquitty"), 
        rect_gp = gpar(type = "none"), cluster_columns = hclust(as.dist(1 - abs(g_corr_mat)), method = "mcquitty"), 
        row_names_gp = gpar(fontsize = 8), col = col_fun, show_column_dend = F, show_row_dend = T, show_column_names = F, 
        row_dend_width = unit(6, "cm"), show_heatmap_legend = F, 
	cell_fun = function(j, i, x, y, width, height, fill){
          grid.rect(x = x, y = y, width = width, height = height, 
                    gp = gpar(col = "lightgrey", fill = NA))
          if(p_mat[i, j] < 5e-2){
            grid.circle(x = x, y = y, r = 0.4 * min(unit.c(width, height)), 
                        gp = gpar(fill = col_fun(g_corr_mat[i, j]), col = NA))
          }else{
            grid.circle(x = x, y = y, r = 0 * min(unit.c(width, height)), 
                        gp = gpar(fill = col_fun(g_corr_mat[i, j]), col = NA))
          }
        })
png("FigS1_Complexheatmap_mcquitty_dendrogram.png", width = 18, height = 12, units = "in", res = 500)
draw(ht, annotation_legend_list = lgd_list, annotation_legend_side = "left", padding = unit(c(4, 4, 4, 32), "mm"))
dev.off()


## draw Figure 5
grouptrait <- read.table("3Groups_trait.tsv", sep = "\t", header = T)$trait
sub_mat <- g_corr_mat[grouptrait, grouptrait]
sub_p_mat <- p_mat[grouptrait, grouptrait]
split_order <- c(rep("g1", 27), rep("g2", 17), rep("g3", 13))
col_fun <- circlize::colorRamp2(c(-1, 0, 1), hcl_palette = "RdBu")
lgd_list <- list(Legend(col_fun = col_fun, title = "Genetic Correlation", legend_width = unit(5, "cm"), 
                        title_position = "leftcenter-rot"))
ht <- Heatmap(sub_mat, name = "mat", cluster_rows = F, rect_gp = gpar(type = "none"), row_title = NULL,
              row_split = split_order, column_split = split_order, row_gap = unit(6, "mm"), column_gap = unit(6, "mm"),
              cluster_columns = F, row_names_gp = gpar(fontsize = 10), col = col_fun, column_title = NULL,
              show_column_names = F,  show_heatmap_legend = F,
              heatmap_legend_param = lgd_list, 
              cell_fun = function(j, i, x, y, width, height, fill){
                grid.rect(x = x, y = y, width = width, height = height, 
                          gp = gpar(col = "lightgrey", fill = NA))
                if(sub_p_mat[i, j] < 5e-2){
                  grid.circle(x = x, y = y, r = 0.4 * min(unit.c(width, height)), 
                              gp = gpar(fill = col_fun(sub_mat[i, j]), col = NA))
                }else{
                  grid.circle(x = x, y = y, r = 0 * min(unit.c(width, height)), 
                              gp = gpar(fill = col_fun(sub_mat[i, j]), col = NA))
                }
              })
png("Fig5_Complexheatmap_3groups.png", width = 16, height = 11, units = "in", res = 500)
draw(ht, annotation_legend_list = lgd_list, annotation_legend_side = "left", padding = unit(c(6, 6, 6, 50), "mm"))
dev.off()
