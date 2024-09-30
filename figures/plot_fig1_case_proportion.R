library('ggplot2')
library(ggrepel)

heri = read.csv('Fig1_data.csv', header = T, stringsAsFactors = F)
heri$Category = factor(heri$Category)
colnames(heri)[10] = c("Heritability")

figleg = read.csv('Fig1_legend.csv')

heri$CaseProp = heri$Case/486956
heri$Category = sapply(as.character(heri$Category), capitalize)
figleg$Category = capitalize(figleg$Category)
heri$Category = factor(heri$Category, levels = figleg$Category)
phecodegg =   ggplot(heri, aes(x= FinalPrevalance, y= CaseProp))+
  geom_point(aes(color = Category, shape=Category), size=3)+ 
  scale_y_log10("Case proportion in TPMI", limits=c(2*10^-3, 0.5),breaks = c(0.01, 0.1,0.5), labels = scales::comma) + 
  scale_x_log10("5-year Prevalence in NHIRD",limits = c(0.0005, 0.6), breaks = c(0.001, 0.01, 0.1,0.5), labels = scales::comma)+ 
  scale_color_manual(values = figleg$Color[-2]) +
  scale_shape_manual(values = figleg$pch[-2]) +
  annotation_logticks() + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
        axis.text=element_text(size=14), axis.title=element_text(size=16,face="bold"),
        legend.title = element_blank(), legend.text=element_text(size=12),
        legend.position="top",  legend.box="vertical", legend.margin=margin())
  
cat_color <- read.csv("qt_category_color.txt")
colnames(cat_color) <- c("Category", "Color")
quant= read.csv('Fig1_quantdata.csv', header = T)
quanpos = as.data.frame(t(sapply(unique(quant$Category), function(x) c(quangroup=x, pos=mean(quant$XPOS[which(quant$Category==x)])))))
quanpos$pos= as.numeric(quanpos$pos)
quant <- merge(quant, cat_color, by = "Category")

quantgg =  ggplot(quant, aes(x= XPOS, y= N))+
  geom_point(aes(colour = Category), size=3)+
  scale_colour_manual(values=setNames(quant$Color, quant$Category)) +
  scale_y_log10("Sample size in TPMI", limits=c(100000, 320000),  breaks = c(100000, 200000,300000), labels = scales::comma , position = "right")+
  scale_x_continuous(labels = quanpos$quangroup, breaks = quanpos$pos, limits = c(0, 25), guide = guide_axis(angle = -15))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.title.x = element_blank(),
        axis.text=element_text(size=12), axis.title=element_text(size=16,face="bold"),
        legend.title = element_blank(), legend.text=element_text(size=12),
        legend.position="top", legend.key = element_rect(colour = "transparent", fill = "white"))+
  geom_text_repel(aes(label = X), size = 5, max.overlaps=Inf, min.segment.length = 0) 

png('Fig1.png', height = 8, width = 16, units = 'in', res=300)
ggarrange(phecodegg, quantgg,
          labels = c("A", "B"),
          ncol = 2, nrow = 1, widths = c(1.75,1))
dev.off()
