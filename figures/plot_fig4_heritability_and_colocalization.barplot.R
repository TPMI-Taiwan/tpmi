### Stack barplot in Fujiplot

# phecode 
bar_info <- read.table('barplot.phecode.input',sep='\t',header=T)
bar_info$CATEGORY <- fct_rev(bar_info$CATEGORY)
bar_info$SNP <- factor(bar_info$SNP, levels = c("single", "intra_categorical", "inter_categorical"))
 
ggplot(bar_info, aes(x = CATEGORY, y = VALUE, fill = interaction(CATEGORY, SNP))) +
	scale_fill_manual(values = c("circulatory system.inter_categorical"="#F8766D","circulatory system.intra_categorical"="#FFBDBA","circulatory system.single"="#FFFFFF","dermatologic.inter_categorical"="#E58700","dermatologic.intra_categorical"="#FFC098","dermatologic.single"="#FFFFFF","digestive.inter_categorical"="#C99800","digestive.intra_categorical"="#FAC75E","digestive.single"="#FFFFFF","endocrine/metabolic.inter_categorical"="#A3A500","endocrine/metabolic.intra_categorical"="#D2D45E","endocrine/metabolic.single"="#FFFFFF","genitourinary.inter_categorical"="#6BB100","genitourinary.intra_categorical"="#9BE15E","genitourinary.single"="#FFFFFF","hematopoietic.inter_categorical"="#00BA38","hematopoietic.intra_categorical"="#5EEA72","hematopoietic.single"="#FFFFFF","infectious diseases.inter_categorical"="#00BF7D","infectious diseases.intra_categorical"="#5EEBA9","infectious diseases.single"="#FFFFFF","mental disorders.inter_categorical"="#00BCD8","mental disorders.intra_categorical"="#6EE4FF","mental disorders.single"="#FFFFFF","musculoskeletal.inter_categorical"="#00B0F6","musculoskeletal.intra_categorical"="#A7D7FF","musculoskeletal.single"="#FFFFFF","neoplasms.inter_categorical"="#619CFF","neoplasms.intra_categorical"="#B8CCFF","neoplasms.single"="#FFFFFF","neurological.inter_categorical"="#B983FF","neurological.intra_categorical"="#D9C3FF","neurological.single"="#FFFFFF","respiratory.inter_categorical"="#E76BF3","respiratory.intra_categorical"="#F7B8FF","respiratory.single"="#FFFFFF","sense organs.inter_categorical"="#FD61D1","sense organs.intra_categorical"="#FFB8E6","sense organs.single"="#FFFFFF","symptoms.inter_categorical"="#FF67A4","symptoms.intra_categorical"="#FFBAD0","symptoms.single"="#FFFFFF")) +
	geom_bar(stat = "identity", color="black", size=1) +
	scale_y_continuous(expand = c(0, 0)) +
	scale_y_reverse() +
	coord_flip() + 
	theme_minimal() +
	theme_bw() +
	theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),  axis.ticks.length = unit(0.3, "cm") )


# qt
bar_info <- read.table('barplot.qt.input',sep='\t',header=T)
bar_info$CATEGORY <- fct_rev(bar_info$CATEGORY)
bar_info$SNP <- factor(bar_info$SNP, levels = c("single", "intra_categorical", "inter_categorical"))
ggplot(bar_info, aes(x = CATEGORY, y = VALUE, fill = interaction(CATEGORY, SNP))) +
	scale_fill_manual(values = c("Anthropometric.inter_categorical"="#FF796C","Anthropometric.intra_categorical"="#FFC0BC","Anthropometric.single"="#FFFFFF","Circulation.inter_categorical"="#FF81C0","Circulation.intra_categorical"="#FFC4DE","Circulation.single"="#FFFFFF","Hematological.inter_categorical"="#FAC205","Hematological.intra_categorical"="#FFE0AD","Hematological.single"="#FFFFFF","Kidney.inter_categorical"="#15B01A","Kidney.intra_categorical"="#65E466","Kidney.single"="#FFFFFF","Liver.inter_categorical"="#06C2AC","Liver.intra_categorical"="#60EBD4","Liver.single"="#FFFFFF","Metabolic.inter_categorical"="#069AF3","Metabolic.intra_categorical"="#A4CBFF","Metabolic.single"="#FFFFFF")) +
	geom_bar(stat = "identity", color="black", size=1) +
	scale_y_continuous(expand = c(0, 0)) +
	theme_minimal() +
	theme_bw() +
	coord_flip() +
	theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), axis.ticks.length = unit(0.3, "cm") )
