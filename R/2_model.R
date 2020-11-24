### Code below is for model and model simulation

## list contact-based intervention scenarios

interventions<-  list(
  # constraints under a DO-NOTHING scenario 
  base =list(home = diag(1,16,16),
             work = diag(1,16,16),
             school = diag(1,16,16),
             others = diag(1,16,16)),
  # Georgia lockdown--assume from XX Jan to XX Feb 
  shelterinplace = list(home = diag(1,16,16),
                        work = diag(0.1,16,16),
                        school = diag(0,16,16),
                        others = diag(c(rep(0.1,4),rep(0.25,12)))),
  # constraints under school closure but 80% workplace
  relax = list(home = diag(c(rep(1,4),rep(1,12))),
               work = diag(0.5,16,16),
               school = diag(0,16,16),
               others = diag(c(rep(0.5,4),rep(0.5,12)))), 
  # constraints under household distancing and school closure known infected cases only
  relaxhomedist = list(home = diag(0.5,16,16),
                       work = diag(1,16,16),
                       school = diag(0,16,16),
                       others = diag(0.5,16,16)))


# Children as infectious and as susceptible 
SEIR = function(prop.isolate = 0, hosp.rate =0.0075,
                dateShelterInPlace = as.Date('2021-12-31') , 
                dateRelaxIntervention = as.Date('2021-12-31'),
                dateRelaxandHomedistance = as.Date('2021-12-31'),
                dateStart = as.Date('2020-02-01'),POP = georgiapop,durInf = 7,contact_ga=contacts)
{
  
  # Load population information
  pop = list()
  pop$N = sum(POP$popage)
  pop$p_age = georgiapop$propage
  N_age = pop$N*pop$p_age                                        # Population age structure (in numbers)
  
  # Specify epi info
  durLat = 5.2;   	                                             # Mean latent period (days) from Backer, et al (2020)
  gamma = 1/durInf;                                              # removal rate
  alpha = 1/durLat;                                      
  tau1 = prop.isolate
  hosp.rate = hosp.rate
  dt = 1;                                                        # Time step (days)
  tmax = 400;                                                    # Time horizon (days) 366 days in 2020 cause of leap year
  numSteps = tmax/dt;  	                                         # Total number of simulation time steps
  dateStart = as.Date(dateStart)                                 # included as a function argument 
  dateEnd = dateStart+(tmax-1)
  
  # Declare the state variables and related variables:
  S = E = Ei = I = R = H = array(0,c(numSteps,length(pop$p_age)))
  lambda = infections = infectious = incidence = isolate = newhosp = reported = cumulativeIncidence = array(0,c(numSteps,length(pop$p_age)))
  time = array(0,numSteps)
  
  # Initialise the time-dependent variables, i.e. setting the values of the variables at time 0
  E[1,] = 0
  Ei[1,]=0
  I[1,] = rep(1,16) 
  H[1,] = 0 
  R[1,] = 0 
  S[1,] = N_age-E[1,]-Ei[1,]-I[1,]-H[1,]-R[1,]
  newhosp[1,] = 0;
  incidence[1,] = 0;
  isolate[1,] = 0; 
  reported[1,] = 0;
  time[1] = 0;
  
  ## Time of interventions
  tShelterInPlace = as.vector(dateShelterInPlace - dateStart)+1
  tRelaxIntervention = as.vector(dateRelaxIntervention - dateStart)+1
  tRelaxandHomedistance = as.vector(dateRelaxandHomedistance - dateStart)+1
  
  for (stepIndex in 1: (numSteps-1))
  { 
    # load plausible intervetions 
    constraintsIntervention = interventions
    # I0: before shelter in place, use base contact rates
    if(time[stepIndex] < tShelterInPlace)  
    {
      CONSTRAINT = constraintsIntervention$base
    } else if(time[stepIndex] >= tShelterInPlace & time[stepIndex] < tRelaxIntervention) 
      # I1:  when shelter in place starts use 'shelterinplace' contact scenarios
    {
      INTERVENTION = "shelterinplace"   
      CONSTRAINT = constraintsIntervention[[INTERVENTION]] 
    } else if(time[stepIndex] >= tRelaxIntervention & time[stepIndex] < tRelaxandHomedistance)
      # I2:  When interventions relax, use 'relax' contact scenarios
    {
      INTERVENTION = "relax"   
      CONSTRAINT = constraintsIntervention[[INTERVENTION]] 
    }  else if(time[stepIndex] >= tRelaxandHomedistance)
      # I2:  If relaxing is with home distancing, then use "relaxhomedist". 
    {
      INTERVENTION = "relaxhomedist"   
      CONSTRAINT = constraintsIntervention[[INTERVENTION]] 
    } 
    
    C = CONSTRAINT[[1]]%*%contact_ga[[1]]+
      CONSTRAINT[[2]]%*%contact_ga[[2]]+
      CONSTRAINT[[3]]%*%contact_ga[[3]]+
      CONSTRAINT[[4]]%*%contact_ga[[4]]
    
    lambda[stepIndex,] = as.numeric(0.035)*(as.matrix(C)%*%as.matrix(I[stepIndex,]/N_age))
    
    tau <- ifelse(stepIndex < 90, 0,tau1)                #Date switch for proportion isolated
    
    
    numInfection = lambda[stepIndex,]*S[stepIndex,]*dt;   #S to E
    numInfectious = alpha*(1-tau)*E[stepIndex,]*dt;       #E to I
    numIsolate = alpha*tau*E[stepIndex,]*dt;              #E to Ei
    numNewHosp = hosp.rate*I[stepIndex,];                 #I to H
    numRecInfectious = gamma*I[stepIndex,]*dt;            #I to R
    numRecIsolate = gamma*Ei[stepIndex,]*dt;              #Ei to R
    numRecHosp = gamma*H[stepIndex,]*dt;                  #H to R
    
    # SEIR difference equations 
    S[stepIndex+1,] = S[stepIndex,]-numInfection;
    E[stepIndex+1,] = E[stepIndex,]+numInfection-numInfectious-numIsolate;
    Ei[stepIndex+1,] = Ei[stepIndex,]+numIsolate-numRecIsolate;
    I[stepIndex+1,] = I[stepIndex,]+numInfectious-numRecInfectious - numNewHosp;
    H[stepIndex+1,] = H[stepIndex,]+numNewHosp - numRecHosp ;
    R[stepIndex+1,] = R[stepIndex,]+numRecInfectious + numRecIsolate + numRecHosp;
    infections[stepIndex+1,] = numInfection/dt;
    infectious[stepIndex+1,] = numInfectious/dt;
    isolate[stepIndex+1,] = numIsolate/dt;
    incidence[stepIndex+1,] = (numInfectious+numIsolate)/dt;
    newhosp[stepIndex+1,] = numNewHosp/dt;
    time[stepIndex+1] = time[stepIndex]+dt;
    
  }
  output = list(S =S, E = E, Ei = Ei, I = I, R = R, time = time, lambda=lambda,
                infections = infections, infectious = infectious, incidence = incidence, isolate = isolate, newhosp=newhosp,
                N_age= N_age, 
                dateStart = dateStart, dateEnd = dateEnd, C=C,beta=beta, tShelterInPlace=tShelterInPlace, tRelaxIntervention=tRelaxIntervention)
  return(output)
}


