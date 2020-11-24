installed_pkgs <- row.names(installed.packages())

pkgs <- c("ggplot2", "reshape2","kableExtra")
for(p in pkgs){
	if(!(p %in% installed_pkgs)){
		install.packages(p, repos = "http://cran.us.r-project.org")
	}
}