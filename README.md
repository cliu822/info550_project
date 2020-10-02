# info550_project

For my project, I will conduct a mock-up analysis of a dataset that contains app-based geocoded locations of a subset of mobile devices recorded in the database. The restricted dataset 

To analyze the data you will need to install some R packages. The required packages can be installed using R commands.

installed_pkgs <- row.names(installed.packages())
pkgs <- c("MASS", "wesanderson")
for(p in pkgs){
	if(!(p %in% install_pkgs)){
		install.packages(p)
	}
}
Execute the analysis
To execute the analysis, from the project folder you can run

Rscript -e "rmarkdown::render('report.Rmd')"
This will create a file called report.html output in your directory that contains the results.
