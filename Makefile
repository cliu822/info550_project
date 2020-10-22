# rule for installing packages
.PHONY: install
install: 
	chmod +x 1_install_packages.R &&\
	Rscript 1_install_packages.R

# rule for making report  
report.html: usa_contacts georgiapop.csv parms.csv intervention_scenarios.csv 4_info550_project.Rmd
	Rscript -e "rmarkdown::render('4_info550_project.Rmd', quiet = TRUE)"


# Help files for make files
.PHONY: help
help:
	@echo "install : Install packages required to execute analysis"
	@echo "report.html : Generate final analysis report"