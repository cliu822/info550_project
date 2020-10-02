# Background

For my project, I use a simple SEIR-like model I previously worked on to simulate cases of severe acute respiratory syndrome coronoavirus 2 (SARS-CoV2) in Georgia. State-level shelter-in-place orders began on March 16th where schools, work places and leisure areas were closed. At the time, I was subsequently interested in the impact of different social distancing strategies on infection transmission. The goal of my model was to address the following primary research question (from early May): how will the epidemic differ if current shelter-in-place orders are relaxed with a 50% return to work and no additional intervention versus a 100% return to work and either 1) additional measures to social distance at home; 2) isolation of 20% of pre-infectious cases identified from contact tracing or 3) isolation of 50% of pre-infectious cases identified from contact tracing? 

# Methods
We adapt code from a previously published age-structured deterministic susceptible-exposed-infected-removed (S-E-I-R) model using difference equations with no births and no deaths. The figure below details the structure and transitions of the model. Briefly, our model consists of six compartments, susceptibles (S), pre-infectious (E), pre-infectious and isolated (EI), infectious (I), infectious and hospitalized (H), and recovered (R). Each compartment is further stratified into 16 five-year age groups and the model tracks the number of individuals in S, E, EI, I, H and R compartments per age group at each time step. The subscript i denotes the age-group of the stratified compartment. The age-group stratification allows for heterogeneous mixing patterns between and across age groups and an understanding of infection and disease rates per age group.

![Model structure](/modelstructure.png)

# Parameters
The table below details the parameters used to parameterized the model

Parameter|	Description|	Value|	Source
---------|----------------|-----------|----------
**beta**| Transmission prob per contact}	0.035	Estimated[1]
**alpha**|	Latent period|	5.2 days|	[6]
**gamma**|	Recovery rate|	7 days|	[5]
**delta**|	Hospitalization rate per time step|	0.0075|	Estimated[2]
**Initials**|			
**Initial infections**|	Initial infections|	1 per age group (16 total)|	Determined
**Initial population**|	Initial population|	10.5 million|	[9]
**Interventions**|			
**tau**|	Prop. isolated per time step|	20%/50%|	Determined


# Intervention scenarios
The table below details the intervention scenarios explored in our model

Scenario|	Do Nothing|	Indefinite Shelter in Place|	Relax Shelter in Place & Some return to work|	Relax Shelter in place & all return to work & home distance
--------|----------------|-----------------------------|-----------------------------------------------|---------------------------------------------------
Shelter-in-place start|	Never|	March 16th, 2020|	March 16th, 2020|	March 16th, 2020
Shelter-in-place relax|	NA|	Never|	May 1st, 2020|	May 1st, 2020
Home contacts|	0% reduction|	0% reduction|	0% reduction|	0% reduction/50%reduction
School contacts|	0% reduction|	100% reduction|	Closed (100% reduction)|	Closed (100% reduction)
Work contacts|	0% reduction|	90% reduction|	90% reduction/50% reduction|	90% reduction/0% reduction
Other contacts|	0% reduction|	90% reduction|	90% reduction/50% reduction|	90% reduction/50% reduction

# Package install

To analyze the data you will need to install some `R` packages. The required packages can be installed using `R commands`.

`installed_pkgs <- row.names(installed.packages())
pkgs <- c("ggplot2", "reshape2","gridExtra","kableExtra")
for(p in pkgs){
	if(!(p %in% install_pkgs)){
		install.packages(p)
	}
}`

# Execute the analysis
To execute the analysis, from the project folder you can run

`Rscript -e "rmarkdown::render('info550_project.Rmd')"`
This will create a file called info550_project.html output in your directory that contains the results.
