# rule for installing packages
.PHONY: install
install: 
	chmod +x 1_install_packages.R &&\
	Rscript 1_install_packages.R

# rule for making report  
.PHONY: report
report: R/usa_contacts R/georgiapop.csv R/parms.csv R/intervention_scenarios.csv R/4_info550_project.Rmd
	cd R; Rscript -e "rmarkdown::render('4_info550_project.Rmd', output_file = '../output/report.html')"


# Help files for make files
.PHONY: help
help:
	@echo "install : Install packages required to execute analysis"
	@echo "report.html : Generate final analysis report"